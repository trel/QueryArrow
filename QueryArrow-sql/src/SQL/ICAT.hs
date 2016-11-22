{-# LANGUAGE FlexibleContexts #-}
module SQL.ICAT where

import Prelude hiding (lookup)
import DB.GenericDatabase
import FO.Data
import SQL.SQL
import ICAT
import Data.Namespace.Namespace

import Data.Text (unpack)
import Data.Map.Strict (fromList)
import Text.Read


makeICATSQLDBAdapter :: String -> [String] -> Maybe String -> a -> IO (GenericDatabase  SQLTrans a)
makeICATSQLDBAdapter ns [predsPath, mappingsPath] nextid conninfo = do
    preds0 <- loadPreds predsPath
    let preds =
          case nextid of
            Nothing -> preds0
            Just nextid -> Pred (UQPredName nextid) (PredType ObjectPred [Key "Text"]) : preds0
    mappings <- loadMappings mappingsPath
    return (GenericDatabase (sqlStandardTrans ns preds mappings nextid) conninfo ns (qStandardPreds ns preds ++ qStandardBuiltInPreds ns))

loadMappings :: FilePath -> IO [(String, (Table, [SQLQualifiedCol]))]
loadMappings path = do
    content <- readFile path
    case readMaybe content of
        Just mappings -> return mappings
        Nothing -> error ("loadMappings: cannot parse file " ++ path)

sqlMapping :: String -> [Pred] -> [(String, (Table, [SQLQualifiedCol]))] -> PredTableMap
sqlMapping ns preds mappings =
    let sqlStandardPredsMap = qStandardPredsMap ns preds
        lookupPred n = case lookupObject (QPredName ns [] n) sqlStandardPredsMap of
                Nothing -> error ("sqlMapping: cannot find predicate " ++ n)
                Just pred1 -> pred1 in
        fromList (map (\(n, m) -> (lookupPred n, m)) mappings)

sqlStandardTrans :: String -> [Pred] -> [(String, (Table, [SQLQualifiedCol]))] -> Maybe String -> SQLTrans
sqlStandardTrans ns preds mappings nextid =
    let sqlStandardBuiltInPredsMap = qStandardBuiltInPredsMap ns
        lookupPred n = case lookupObject (QPredName ns [] n) sqlStandardBuiltInPredsMap of
                Nothing -> error ("sqlStandardTrans: cannot find predicate " ++ n)
                Just pred1 -> pred1 in

        (SQLTrans
            (BuiltIn ( fromList [
                (lookupPred "le", simpleBuildIn "le" (\thesign args ->
                    return (swhere (SQLCompCond (case thesign of
                        Pos -> "<="
                        Neg -> ">") (head args) (args !! 1))))),
                (lookupPred "lt", simpleBuildIn "lt" (\thesign args ->
                    return (swhere (SQLCompCond (case thesign of
                        Pos -> "<"
                        Neg -> ">=") (head args) (args !! 1))))),
                (lookupPred "eq", \thesign args -> do
                        sqlExprs <- mapM sqlExprFromArg args
                        case sqlExprs of
                            [Left a, Left b] ->
                                return (swhere (SQLCompCond (case thesign of
                                    Pos -> "="
                                    Neg -> "<>") a b))
                            [Left a, Right v] -> case thesign of
                                Pos -> do
                                    addVarRep v a
                                    return mempty
                                Neg ->
                                    return sqlfalse
                            _ -> error "eq: unsupported arguments, only the second argument can be unbounded"),
                (lookupPred "like", simpleBuildIn "like" (\thesign args ->
                    return (swhere (SQLCompCond (case thesign of
                        Pos -> "LIKE"
                        Neg -> "NOT LIKE") (head args) (args !! 1))))),
                (lookupPred "like_regex", simpleBuildIn "like_regex" (\thesign args ->
                    return (swhere (SQLCompCond (case thesign of
                        Pos -> "~"
                        Neg -> "!~") (head args) (args !! 1))))),
                (lookupPred "in", simpleBuildIn "in" (\thesign args ->
                    let sql = swhere (SQLCompCond "in" (head args) (SQLExprText ("(" ++ (case args !! 1 of
                                                                                              SQLStringConstExpr str -> unpack str
                                                                                              _ -> error "the second argument of in is not a string") ++ ")"))) in
                        case thesign of
                            Pos -> return sql
                            Neg -> return (snot sql))),
                (lookupPred "add", repBuildIn (\ [Left a, Left b, Right v] -> [(v, SQLInfixFuncExpr "+" (SQLCastExpr a "integer") (SQLCastExpr b "integer"))]
                    )),
                (lookupPred "concat", repBuildIn (\ [Left a, Left b, Right v] -> [(v, SQLFuncExpr "concat" [SQLCastExpr a "text", SQLCastExpr b "text"])]
                    )),
                (lookupPred "substr", repBuildIn (\ [Left a, Left b, Left c, Right v] -> [(v, SQLFuncExpr "substr" [SQLCastExpr a "text", SQLCastExpr b "text", SQLCastExpr c "text"])]
                    )),
                (lookupPred "replace", repBuildIn (\ [Left a, Left b, Left c, Right v] -> [(v, SQLFuncExpr "replace" [SQLCastExpr a "text", SQLCastExpr b "text", SQLCastExpr c "text"])]
                    )),
                (lookupPred "regex_replace", repBuildIn (\ [Left a, Left b, Left c, Right v] -> [(v, SQLFuncExpr "regexp_replace" [SQLCastExpr a "text", SQLCastExpr b "text", SQLCastExpr c "text"])]
                    )),
                (lookupPred "cast_int", repBuildIn (\ [Left a, Right v] -> [(v, SQLCastExpr a "integer")]
                    )),
                (lookupPred "strlen", repBuildIn (\ [Left a, Right v] -> [(v, SQLFuncExpr "length" [SQLCastExpr a "text"])]
                    ))
            ]))
            (sqlMapping ns preds mappings) nextid)
