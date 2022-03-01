module Haskcalc.ConstantPropagation.Internal where

import Haskcalc.Core.Ast (
  Expr (Add, App, Let, Lit, Mult, Val),
  Identifier,
 )
import Relude (Integer, otherwise, ($), (*), (+), (<$>), (==))

foldConst :: Expr -> Expr
foldConst (Let ident e) = Let ident (foldConst e)
foldConst (Add (Lit cl) (Lit cr)) = Lit (cl + cr)
foldConst (Add e (Lit 0)) = e
foldConst (Add (Lit 0) e) = e
foldConst (Mult (Lit cl) (Lit cr)) = Lit (cl * cr)
foldConst (Mult e (Lit 1)) = e
foldConst (Mult (Lit 1) e) = e
foldConst (Mult _ z@(Lit 0)) = z
foldConst (Mult z@(Lit 0) _) = z
foldConst (Mult (Lit l) (Add el er)) =
  case (oel, oer) of
    (Lit cl, Lit cr) -> Lit $ l * (cl + cr)
    (Lit cl, e) -> Add (Lit (cl * l)) e
    (e, Lit cr) -> Add e (Lit (cr * l))
    _ -> Add oel oer
 where
  oel = foldConst el
  oer = foldConst er
foldConst (Mult (Add el er) (Lit l)) =
  case (oel, oer) of
    (Lit cl, Lit cr) -> Lit $ l * (cl + cr)
    (Lit cl, e) -> Add (Lit (cl * l)) e
    (e, Lit cr) -> Add e (Lit (cr * l))
    _ -> Add oel oer
 where
  oel = foldConst el
  oer = foldConst er
foldConst (App ident es) = App ident (foldConst <$> es)
foldConst e = e

sub :: Identifier -> Integer -> Expr -> Expr
sub sid sc val@(Val v)
  | sid == v = Lit sc
  | otherwise = val
sub sid sc (Let li e) = Let li oe
 where
  oe = sub sid sc e
sub sid sc (Add el er) = Add oel oer
 where
  oel = sub sid sc el
  oer = sub sid sc er
sub sid sc (Mult el er) = Mult oel oer
 where
  oel = sub sid sc el
  oer = sub sid sc er
sub sid sc (App fid args) = App fid oargs
 where
  oargs = sub sid sc <$> args
sub _ _ e = e
