module Haskcalc.Interpreter () where

import Haskcalc.Core.Ast (Expr (..), Identifier)

import Data.HashMap.Strict (HashMap)
import Data.Sequence (Seq)
import Relude (Integer)

data SingleEvaluation = SingleEvaluation
  { evaluatedExpr :: Expr
  , evaluationResult :: Integer
  }

data EvaluationResult = EvaluationResult
  { definitions :: HashMap Identifier Expr
  , evaluations :: Seq Integer
  }

-- TODO: return Map of names -> definition (varible or function) and vector of pairs (expression and corresponding evaludation result)
runHaskcalc :: [Expr] -> EvaluationResult
runHaskcalc _ = _
