module Examples where

import Core.Ast (Expr (..), Identifier (..))
import Prettyprinter (Pretty (pretty))
import Prettyprinter.Util (putDocW)
import Relude (IO, Int, NonEmpty ((:|)), putStrLn, (*>))

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

addFunc :: Expr
addFunc =
  Func
    (Identifier "add")
    ( Identifier "x"
        :| [Identifier "y"]
    )
    (Add (Val (Identifier "x")) (Val (Identifier "y")) :| [])

functionExample :: Expr
functionExample =
  Func
    (Identifier "func")
    ( Identifier "first"
        :| [ Identifier "second"
           , Identifier "third"
           ]
    )
    ( addFunc
        :| [ Let
              (Identifier "y")
              ( App
                  (Identifier "add")
                  ( Mult (Val (Identifier "first")) (Val (Identifier "second"))
                      :| [Lit 4]
                  )
              )
           , Let
              (Identifier "z")
              (Mult (Val (Identifier "y")) (Lit 4))
           , Add (Add (Val (Identifier "z")) (Val (Identifier "third"))) (Lit 1)
           ]
    )

exprppW :: Int -> Expr -> IO ()
exprppW w e = putDocW w (pretty e) *> putStrLn ""

exprpp :: Expr -> IO ()
exprpp = exprppW 80
