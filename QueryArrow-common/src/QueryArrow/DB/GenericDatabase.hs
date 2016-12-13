{-# LANGUAGE TypeFamilies #-}

module QueryArrow.DB.GenericDatabase where

import QueryArrow.FO.Data
import QueryArrow.DB.DB
import QueryArrow.FO.Types

import Data.Set

data GenericDatabase db a = GenericDatabase db a String [Pred]

class IGenericDatabase01 db where
  type GDBQueryType db
  type GDBFormulaType db
  gSupported :: db -> Set Var -> GDBFormulaType db -> Set Var -> Bool
  gCheckQuery :: db ->  VarTypeMap -> GDBFormulaType db ->  VarTypeMap -> IO (Either String ())
  gTranslateQuery :: db ->  Set Var -> GDBFormulaType db ->  Set Var -> IO (GDBQueryType db)

instance (IGenericDatabase01 db) => IDatabase0 (GenericDatabase db a) where
  type DBFormulaType (GenericDatabase db a) = GDBFormulaType db
  getName (GenericDatabase _ _ name _) = name
  getPreds (GenericDatabase _ _ _ preds) = preds
  supported (GenericDatabase db _ _ _) = gSupported db
  checkQuery (GenericDatabase db _ _ _) = gCheckQuery db
instance (IGenericDatabase01 db) => IDatabase1 (GenericDatabase db a) where
  type DBQueryType (GenericDatabase db a) = GDBQueryType db
  translateQuery (GenericDatabase db _ _ _) = gTranslateQuery db
