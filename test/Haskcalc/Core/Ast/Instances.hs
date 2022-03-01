{-# OPTIONS_GHC -Wno-orphans #-}

module Haskcalc.Core.Ast.Instances where

import Generic.Random (genericArbitraryRec, uniform)
import Haskcalc.Core.Ast (Expr (Add, App, Func, Let, Lit, Mult, Val), Identifier (Identifier))
import Relude (Generic)
import Test.QuickCheck (Arbitrary (arbitrary))
import Test.QuickCheck.Instances ()

deriving instance Arbitrary Identifier

deriving instance Generic Expr

instance Arbitrary Expr where
  arbitrary = genericArbitraryRec uniform
