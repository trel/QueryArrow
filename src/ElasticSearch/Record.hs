{-# LANGUAGE DeriveGeneric #-}

module ElasticSearch.Record where

import QueryPlan

import Data.Aeson (parseJSON, toJSON, Object, FromJSON, ToJSON, Value)
import Data.Map.Strict (Map, union, delete)
import Data.Text (Text)
import Control.Applicative ((<$>))

newtype ESRecord = ESRecord (Map Text Value) deriving Show

instance FromJSON ESRecord where
    parseJSON a = ESRecord <$> parseJSON a

instance ToJSON ESRecord where
    toJSON (ESRecord a) = toJSON a

updateProps :: ESRecord -> ESRecord -> ESRecord
updateProps (ESRecord diff) (ESRecord orig) = ESRecord (diff `union` orig)

deleteProps :: [Text] -> ESRecord -> ESRecord
deleteProps diff (ESRecord orig) = ESRecord (foldr (\prop map1 -> delete prop map1) orig diff)
