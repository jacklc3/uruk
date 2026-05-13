-- | Unification of types.
--
-- For v0 the type language is fully concrete (no type variables beyond
-- grade meta-variables) so unification reduces to structural equality.
-- The module exists to mirror Cambria's layout and to give v1 a place to
-- expand once grade polymorphism arrives.
--
-- Real implementation lands in Milestone 1.
module Inference.Unify where

import Inference.Monad (Infer, TypeError)
import Inference.Substitutable (Subst, emptySubst)

-- | Unify two values, producing a substitution that makes them equal.
-- For Milestone 0 a stub specialised to plain structural equality, with the
-- substitution component carrying nothing useful yet.
unify :: (Eq a, Show a) => a -> a -> Infer (Subst ())
unify a b
  | a == b    = Right emptySubst
  | otherwise = Left (mismatch a b)

mismatch :: (Show a) => a -> a -> TypeError
mismatch a b = "cannot unify " ++ show a ++ " with " ++ show b
