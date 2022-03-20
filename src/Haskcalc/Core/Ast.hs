module Haskcalc.Core.Ast (
  Expr (..),
  Identifier (..),
) where

import qualified Data.Text as T
import Prettyprinter (
  Doc,
  Pretty (pretty),
  align,
  hardline,
  nest,
  parens,
  sep,
  softline,
  unsafeViaShow,
  vsep,
  (<+>),
 )
import Relude (
  Foldable (toList),
  Integer,
  NonEmpty ((:|)),
  Show,
  toList,
  (.),
  (<$>),
  (<>),
 )

-- TODO: refine
newtype Identifier = Identifier T.Text deriving (Show)

data Expr
  = Lit Integer
  | Val Identifier
  | Let Identifier Expr
  | Add Expr Expr
  | Mult Expr Expr
  | Func Identifier (NonEmpty Identifier) (NonEmpty Expr)
  | App Identifier (NonEmpty Expr)
  deriving (Show)

prettyWithParens :: Expr -> Doc ann
prettyWithParens (Lit i) = pretty i
prettyWithParens (Val i) = pretty i
prettyWithParens e = parens (pretty e)

softWrappedBinOp :: Doc a -> Doc a -> Doc a -> Doc a
softWrappedBinOp op l r = l <+> op <> softline <> align r

instance Pretty Identifier where
  pretty (Identifier name) = pretty name

instance Pretty Expr where
  pretty (Lit i) = unsafeViaShow i
  pretty (Val name) = pretty name
  pretty (Let name e) = "let" <+> pretty name <+> "=" <> nest 2 (softline <> pretty e)
  pretty (Add el er) = softWrappedBinOp "+" (prettyWithParens el) (prettyWithParens er)
  pretty (Mult el er) = softWrappedBinOp "*" (prettyWithParens el) (prettyWithParens er)
  pretty (Func name args (expr :| [])) =
    pretty name <+> prettyArgs <+> "="
      <> nest 2 (softline <> prettyBody)
   where
    argDocs = pretty <$> args
    prettyArgs = (align . sep . toList) argDocs
    prettyBody = pretty expr
  pretty (Func name args body) =
    pretty name <+> prettyArgs <+> "="
      <> nest 2 (hardline <> prettyBody)
   where
    argDocs = pretty <$> args
    prettyArgs = (align . sep . toList) argDocs
    bodyDocs = pretty <$> body
    prettyBody = (vsep . toList) bodyDocs
  pretty (App name args) = sep prettyAppWithArgs
   where
    argDocs = prettyWithParens <$> args
    prettyAppWithArgs = pretty name : toList argDocs
