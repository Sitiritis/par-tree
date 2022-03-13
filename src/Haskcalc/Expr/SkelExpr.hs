-- Haskell module generated by the BNF converter

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module Haskcalc.Expr.SkelExpr where

import Prelude (($), Either(..), String, (++), Show, show)
import qualified Haskcalc.Expr.AbsExpr

type Err = Either String
type Result = Err String

failure :: Show a => a -> Result
failure x = Left $ "Undefined case: " ++ show x

transIdent :: Haskcalc.Expr.AbsExpr.Ident -> Result
transIdent x = case x of
  Haskcalc.Expr.AbsExpr.Ident string -> failure x

transDecl :: Haskcalc.Expr.AbsExpr.Decl -> Result
transDecl x = case x of
  Haskcalc.Expr.AbsExpr.FunDecl ident idents decls -> failure x
  Haskcalc.Expr.AbsExpr.LetDecl ident expr -> failure x
  Haskcalc.Expr.AbsExpr.ExprDecl expr -> failure x

transExpr :: Haskcalc.Expr.AbsExpr.Expr -> Result
transExpr x = case x of
  Haskcalc.Expr.AbsExpr.Add expr1 expr2 -> failure x
  Haskcalc.Expr.AbsExpr.Mult expr1 expr2 -> failure x
  Haskcalc.Expr.AbsExpr.App ident exprs -> failure x
  Haskcalc.Expr.AbsExpr.Val ident -> failure x
  Haskcalc.Expr.AbsExpr.Lit integer -> failure x
