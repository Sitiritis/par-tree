{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
#if __GLASGOW_HASKELL__ <= 708
{-# LANGUAGE OverlappingInstances #-}
#endif

{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}

-- | Pretty-printer for Haskcalc.
--   Generated by the BNF converter.

module Haskcalc.Expr.PrintExpr where

import Prelude
  ( ($), (.)
  , Bool(..), (==), (<)
  , Int, Integer, Double, (+), (-), (*)
  , String, (++)
  , ShowS, showChar, showString
  , all, dropWhile, elem, foldr, id, map, null, replicate, shows, span
  )
import Data.Char ( Char, isSpace )
import qualified Haskcalc.Expr.AbsExpr

-- | The top-level printing method.

printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i = \case
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    [";"]        -> showChar ';'
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : ts@(p:_) | closingOrPunctuation p -> showString t . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i     = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t s =
    case (all isSpace t', null spc, null rest) of
      (True , _   , True ) -> []              -- remove trailing space
      (False, _   , True ) -> t'              -- remove trailing space
      (False, True, False) -> t' ++ ' ' : s   -- add space if none
      _                    -> t' ++ s
    where
      t'          = showString t []
      (spc, rest) = span isSpace s

  closingOrPunctuation :: String -> Bool
  closingOrPunctuation [c] = c `elem` closerOrPunct
  closingOrPunctuation _   = False

  closerOrPunct :: String
  closerOrPunct = ")],;"

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- | The printer class does the job.

class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance {-# OVERLAPPABLE #-} Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt     _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q = \case
  s | s == q -> showChar '\\' . showChar s
  '\\' -> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  s -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j < i then parenth else id

instance Print Integer where
  prt _ x = doc (shows x)

instance Print Double where
  prt _ x = doc (shows x)

instance Print Haskcalc.Expr.AbsExpr.Ident where
  prt _ (Haskcalc.Expr.AbsExpr.Ident i) = doc $ showString i
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print Haskcalc.Expr.AbsExpr.Decl where
  prt i = \case
    Haskcalc.Expr.AbsExpr.FunDecl id_ ids decls -> prPrec i 0 (concatD [prt 0 id_, prt 0 ids, doc (showString "="), doc (showString "{"), prt 0 decls, doc (showString "}")])
    Haskcalc.Expr.AbsExpr.LetDecl id_ expr -> prPrec i 0 (concatD [doc (showString "let"), prt 0 id_, doc (showString "="), prt 0 expr])
    Haskcalc.Expr.AbsExpr.ExprDecl expr -> prPrec i 0 (concatD [prt 0 expr])
  prtList _ [] = concatD []
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ";"), prt 0 xs]

instance Print [Haskcalc.Expr.AbsExpr.Ident] where
  prt = prtList

instance Print [Haskcalc.Expr.AbsExpr.Decl] where
  prt = prtList

instance Print Haskcalc.Expr.AbsExpr.Expr where
  prt i = \case
    Haskcalc.Expr.AbsExpr.Add expr1 expr2 -> prPrec i 0 (concatD [prt 1 expr1, doc (showString "+"), prt 0 expr2])
    Haskcalc.Expr.AbsExpr.Mult expr1 expr2 -> prPrec i 1 (concatD [prt 2 expr1, doc (showString "*"), prt 1 expr2])
    Haskcalc.Expr.AbsExpr.App id_ exprs -> prPrec i 2 (concatD [prt 0 id_, prt 0 exprs])
    Haskcalc.Expr.AbsExpr.Val id_ -> prPrec i 3 (concatD [prt 0 id_])
    Haskcalc.Expr.AbsExpr.Lit n -> prPrec i 3 (concatD [prt 0 n])
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print [Haskcalc.Expr.AbsExpr.Expr] where
  prt = prtList

