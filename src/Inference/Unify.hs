-- | Unification of types.
--
-- For v0 the type language is fully concrete (no type variables beyond
-- grade meta-variables, which only appear from Milestone 3 onwards) so
-- unification reduces to structural equality. The module exists to mirror
-- Cambria's layout and to give later milestones a place to expand once
-- meta-variables arrive.
module Inference.Unify (unify) where

import Inference.Monad (Infer, typeError)
import Inference.Substitutable (Subst, emptySubst)

-- | Unify two values, producing a substitution that makes them equal.
-- For Milestone 1 this is just an equality check; the returned
-- substitution is empty.
unify :: (Eq a, Show a) => a -> a -> Infer (Subst ())
unify a b
  | a == b    = pure emptySubst
  | otherwise = typeError $ "cannot unify " ++ show a ++ " with " ++ show b
