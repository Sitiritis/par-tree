{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Redundant $" #-}
module Haskcalc.ConstantPropagation.InternalSpec (spec) where

import Haskcalc.ConstantPropagation.Internal (foldConst)
import Haskcalc.Core.Ast (Expr (Func), Identifier)
import Haskcalc.Core.Ast.Instances ()
import Relude (NonEmpty, const, return, ($))
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck

spec :: Spec
spec = do
  foldConstSpec
  subSpec

foldConstSpec :: Spec
foldConstSpec =
  describe "foldConst" $ do
    modifyArgs (const (stdArgs {maxSize = 5, maxSuccess = 5})) $
      prop "does not change function definition" $
        forAll anyFunctionGenerator $
          (\f -> foldConst f `shouldBe` f)

-- TODO: test distributivity
-- TODO: implement more tests for foldConst

subSpec :: Spec
subSpec =
  xdescribe "sub" $ do
    xit "" $ pendingWith "Not implemented, yet"

-- TODO: implement more tests for sub

anyFunctionGenerator :: Gen Expr
anyFunctionGenerator = do
  ident <- arbitrary :: Gen Identifier
  params <- arbitrary :: Gen (NonEmpty Identifier)
  body <- arbitrary :: Gen (NonEmpty Expr)
  let func = Func ident params body
  return func
