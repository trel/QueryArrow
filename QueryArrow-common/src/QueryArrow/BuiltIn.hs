module QueryArrow.BuiltIn where

import System.IO (FilePath, readFile)
import Text.Read (readMaybe)
import QueryArrow.FO.Data

standardBuiltInPreds = [
        Pred (UQPredName "le") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType]),
        Pred (UQPredName "lt") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType]),
        Pred (UQPredName "eq") (PredType ObjectPred [ParamType True True False (TypeVar "a"), ParamType False True True (TypeVar "a")]),
        Pred (UQPredName "ge") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType]),
        Pred (UQPredName "gt") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType]),
        Pred (UQPredName "ne") (PredType ObjectPred [ParamType True True False (TypeVar "a"), ParamType True True False (TypeVar "a")]),
        Pred (UQPredName "like") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType]),
        Pred (UQPredName "not_like") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType]),
        Pred (UQPredName "like_regex") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType]),
        Pred (UQPredName "not_like_regex") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType]),
        Pred (UQPredName "in") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType]),
        Pred (UQPredName "add") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "sub") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "mul") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "div") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "mod") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "exp") (PredType ObjectPred [ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True NumberType]),
        Pred (UQPredName "concat") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType, ParamType False False True TextType]),
        Pred (UQPredName "substr") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False NumberType, ParamType True True False NumberType, ParamType False False True TextType]),
        Pred (UQPredName "regex_replace") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType, ParamType True True False TextType, ParamType False False True TextType]),
        Pred (UQPredName "replace") (PredType ObjectPred [ParamType True True False TextType, ParamType True True False TextType, ParamType True True False TextType, ParamType False False True TextType]),
        Pred (UQPredName "strlen") (PredType ObjectPred [ParamType True True False TextType, ParamType False False True NumberType])
        ]


standardBuiltInPredsMap = constructPredMap standardBuiltInPreds

qStandardBuiltInPreds :: String -> [Pred]
qStandardBuiltInPreds ns = map (setPredNamespace ns) standardBuiltInPreds

qStandardBuiltInPredsMap ns = constructPredMap (qStandardBuiltInPreds ns)