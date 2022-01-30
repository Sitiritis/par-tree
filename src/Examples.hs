module Examples where

import Core.Ast (Expr (..), Identifier (..))

import Prettyprinter (Pretty (pretty))
import Prettyprinter.Util (putDocW)

two :: Expr
two = Lit 2

simpleSum :: Expr
simpleSum = Add two three
 where
  three = Lit 3

simpleProd :: Expr
simpleProd = Mult two seven
 where
  seven = Lit 7

letExample :: Expr
letExample = Let (Identifier "x") simpleProd

exprppW :: Int -> Expr -> IO ()
exprppW w e = putDocW w (pretty e) *> putStrLn ""

exprpp :: Expr -> IO ()
exprpp = exprppW 80
