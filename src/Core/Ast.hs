module Core.Ast (
  Expr (..),
  Identifier (..),
) where

import Prettyprinter (Doc, Pretty (pretty), align, nest, softline, unsafeViaShow, (<+>))

import qualified Data.Text as T

-- TODO: refine
newtype Identifier = Identifier T.Text deriving (Show)

data Expr
  = Lit Integer
  | Var Identifier
  | Let Identifier Expr
  | Sum Expr Expr
  | Prod Expr Expr
  deriving (Show)

softWrappedBinOp :: (Pretty l, Pretty r) => Doc a -> l -> r -> Doc a
softWrappedBinOp op l r = pretty l <+> op <> softline <> (align . pretty) r

instance Pretty Identifier where
  pretty (Identifier name) = pretty name

instance Pretty Expr where
  pretty (Lit i) = unsafeViaShow i
  pretty (Var name) = pretty name
  pretty (Sum el er) = softWrappedBinOp "+" el er
  pretty (Prod el er) = softWrappedBinOp "*" el er
  pretty (Let name e) = "let" <+> pretty name <+> "=" <> nest 2 (softline <> pretty e)
