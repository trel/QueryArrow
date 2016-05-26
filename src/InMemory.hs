{-# LANGUAGE TypeFamilies, MultiParamTypeClasses, FunctionalDependencies, ExistentialQuantification, FlexibleInstances, OverloadedStrings,
   RankNTypes, FlexibleContexts, GADTs, DeriveGeneric #-}
module InMemory where

import ResultStream
import FO.Data
import FO.Domain
import QueryPlan
import Rewriting
import Config
import Parser
import DBQuery
import Utils

import Prelude  hiding (lookup)
import Data.Map.Strict (Map, (!), empty, member, insert, foldrWithKey, foldlWithKey, alter, lookup, fromList, toList, unionWith, unionsWith, intersectionWith, elems, delete, singleton, keys, filterWithKey)
import qualified Data.Map.Strict
import Data.List ((\\), intercalate, union)
import Control.Monad.Trans.State.Strict (StateT, evalStateT,evalState, get, put, State, runState   )
import Control.Applicative ((<$>), liftA2)
import Data.Convertible.Base
import Control.Monad.Logic
import Control.Monad.Except
import Data.Maybe
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as B8
import Text.ParserCombinators.Parsec hiding (State)
import Debug.Trace




-- example MapDB


limitvarsInRow :: [Var] -> MapResultRow -> MapResultRow
limitvarsInRow vars row = transform (keys row) vars row

data MapDB (m :: * -> * )= MapDB String String [(ResultValue, ResultValue)] deriving Show

data MapDBStmt m = MapDBStmt (MapDB m) Query
instance (Functor m, Monad m) => Database_ (MapDB m) m MapResultRow (MapDBStmt m) where
    dbBegin _ = return ()
    dbCommit _ = return True
    dbPrepare _ = return True
    dbRollback _ = return ()
    getName (MapDB name _ _) = name
    getPreds (MapDB _ predname _) = [ Pred predname (PredType ObjectPred [Key "String", Key "String"]) ]
    domainSize db varDomainSize  (Atom thepred args)
        | thepred `elem` getPreds db = return (case db of
                MapDB _ _ rows ->
                    mmins (map (exprDomainSizeMap varDomainSize (Bounded (length rows))) args))
             -- this just look up each var from the varDomainSize
    domainSize _ _ _ = return empty
    prepareQuery db qu _ = return (MapDBStmt db qu)
    supported (MapDB _ predname _) (FAtomic (Atom (Pred p _) _)) _ | p == predname = True
    supported _ _ _ = False
    supported' (MapDB _ predname _) (Atomic (Atom (Pred p _) _)) _ | p == predname = True
    supported' _ _ _ = False
    translateQuery _ qu vars = (show qu, vars)

instance (Monad m) => DBStatementClose m (MapDBStmt m) where
    dbStmtClose _ = return ()

instance (Monad m) => DBStatementExec m MapResultRow (MapDBStmt m) where
    dbStmtExec  (MapDBStmt (MapDB _ _ rows) (Query vars form@(FAtomic _))) _ stream  = do
        row2 <- mapDBFilterResults rows stream form
        return (limitvarsInRow vars row2)


-- update mapdb

data StateMapDB (m :: * -> * )= StateMapDB String String deriving Show

data StateMapDBStmt m = StateMapDBStmt (StateMapDB m) Query

instance (Monad m) => Database_ (StateMapDB m) (StateT (Map String [(ResultValue, ResultValue)]) m) MapResultRow (StateMapDBStmt m) where
    dbBegin _ = return ()
    dbPrepare _ = return True
    dbCommit _ = return True
    dbRollback _ = return ()
    getName (StateMapDB name _) = name
    getPreds (StateMapDB _ predname) = [ Pred predname (PredType ObjectPred [Key "String", Key "String"]) ]
    domainSize db varDomainSize  (Atom thepred args)
        | thepred `elem` getPreds db = do
                rows <- get
                return (mmins (map (exprDomainSizeMap varDomainSize (Bounded (length rows))) args))
            -- this just look up each var from the varDomainSize
    domainSize _ _ _ = return empty
    prepareQuery db qu _ = return (StateMapDBStmt db qu)
    supported _ (FAtomic _) _ = True
    supported _ (FInsert _) _ = True
    supported _ _ _ = False
    supported' _ (Atomic _) _ = True
    supported' _ _ _ = False
    translateQuery _ qu vars = (show qu, vars)

instance (Monad m) => DBStatementClose (StateT (Map String [(ResultValue, ResultValue)]) m) (StateMapDBStmt m) where
    dbStmtClose _ = return ()

instance (Monad m) => DBStatementExec (StateT (Map String [(ResultValue, ResultValue)]) m) MapResultRow (StateMapDBStmt m) where
    dbStmtExec (StateMapDBStmt (StateMapDB name _) (Query vars form@(FAtomic _))) _ stream  = do
        rowsmap <- lift get
        let rows = rowsmap ! name
        row2 <- mapDBFilterResults rows stream form
        return (limitvarsInRow vars row2)
    dbStmtExec (StateMapDBStmt (StateMapDB name _) (Query vars (FInsert lit@(Lit thesign _))))  rsvars stream = do
        rowsmap <- lift get
        let rows = rowsmap ! name
        let freevars = freeVars lit
        let add rows1 row = rows1 `union` [row]
        let remove rows1 row = rows1 \\ [row]
        let arg12 (Lit _ (Atom _ [a,b])) = (convert a, convert b)
            arg12 _ = error "wrong number of args"
        row1 <- stream
        let rows2 = (case thesign of
                        Pos -> add
                        Neg -> remove) rows (arg12 (substResultValue row1 lit))
        lift $ put (insert name rows2 rowsmap)
        return row1



mapDBFilterResults :: (Functor m, Monad m) => [(ResultValue, ResultValue)] -> ResultStream m MapResultRow -> Formula -> ResultStream m MapResultRow
mapDBFilterResults rows  results (FAtomic (Atom thepred args)) = do
    resrow <- results
    trace (show resrow) $ case args of
        VarExpr var1 : (VarExpr var2 : _)
            | var1 `member` resrow ->
                if var2 `member` resrow then do
                    guard ((resrow ! var1, resrow ! var2) `elem` rows)
                    return mempty
                else
                    listResultStream [singleton var2 (snd x) | x <- rows, fst x == resrow ! var1]

            | var2 `member` resrow ->
                listResultStream [singleton var1 (fst x) | x <- rows, snd x == resrow ! var2]
            | otherwise ->
                listResultStream [fromList [(var1, fst x), (var2, snd x)] | x <- rows]
        VarExpr var1 : StringExpr str2 : _ ->
            if var1 `member` resrow then do
                guard ((resrow ! var1, StringValue str2) `elem` rows)
                return mempty
            else
                listResultStream [singleton var1 (fst x) | x <- rows, snd x == StringValue str2]
        StringExpr str1 : VarExpr var2 : _ ->
            if var2 `member` resrow then do
                guard ((StringValue str1, resrow ! var2) `elem` rows)
                return mempty
            else
                listResultStream [singleton var2 (snd x) | x <- rows, snd x == StringValue str1]
        StringExpr str1 : StringExpr str2 : _ -> do
                guard ((StringValue str1, StringValue str2) `elem` rows)
                return mempty
        _ -> do
            guard False
            return mempty


-- example EqDB

data EqDB (m :: * -> *) = EqDB String

data EqDBStmt = EqDBStmt Query
instance (Monad m) => Database_ (EqDB m) m MapResultRow EqDBStmt where
    dbBegin _ = return ()
    dbPrepare _ = return True
    dbCommit _ = return True
    dbRollback _ = return ()
    getName (EqDB name) = name
    getPreds _ = [ Pred "eq" (PredType ObjectPred [Key "Any", Key "Any"]) ]
    domainSize _ _ _ = return empty
    prepareQuery _ qu _ = return (EqDBStmt qu)
    translateQuery _ qu vars = (show qu, vars)

    supported _ (FAtomic (Atom (Pred "eq" _) _)) _ = True
    supported _ _ _ = False
    supported' _ (Atomic (Atom (Pred "eq" _) _)) _ = True
    supported' _ (Not (Atomic (Atom (Pred "eq" _) _))) _ = True
    supported' _ _ _ = False

instance (Monad m) => DBStatementClose m (EqDBStmt) where
    dbStmtClose _ = return ()

evalExpr :: MapResultRow -> Expr -> ResultValue
evalExpr row (StringExpr s) = StringValue s
evalExpr row (IntExpr s) = IntValue s
evalExpr row (VarExpr v) = case lookup v row of
    Nothing -> Null
    Just r -> r

instance (Monad m) => DBStatementExec m MapResultRow (EqDBStmt) where
    dbStmtExec (EqDBStmt (Query _ (FAtomic (Atom _ [a, b])))) rsvars stream = do
        row <- stream
        if evalExpr row a == evalExpr row b
            then return mempty
            else emptyResultStream

    dbStmtExec (EqDBStmt (Query _ (FClassical (Atomic (Atom _ [a, b]))))) rsvars stream = do
        row <- stream
        if evalExpr row a == evalExpr row b
            then return mempty
            else emptyResultStream

    dbStmtExec (EqDBStmt (Query _ (FClassical (Not (Atomic (Atom _ [a, b])))))) rsvars stream = do
        row <- stream
        if evalExpr row a /= evalExpr row b
            then return mempty
            else emptyResultStream

    dbStmtExec (EqDBStmt qu) rsvars stream = error ("dqdb: unsupported query " ++ show qu)
