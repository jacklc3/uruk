-- | Substitution machinery for inference variables.
--
-- v0 generates inference variables only for grades (the @(ℕ, +, 0)@ theory
-- is decidable so unification is trivial), but the abstraction is here for
-- v1 onwards when grade theories become more interesting and additional
-- meta-variables may appear.
--
-- Real implementation lands in Milestone 3 alongside grade-equation
-- solving.
module Inference.Substitutable where

import qualified Data.Map.Strict as Map

-- | A substitution: mapping from meta-variable identifiers to whatever they
-- stand for. The value type is left abstract for now — it will become
-- 'Types.Grade' once grades are real.
type Subst a = Map.Map String a

-- | Substitutable values. Concrete instances land in Milestone 3.
class Substitutable a where
  apply :: Subst a -> a -> a
  freeVars :: a -> [String]

-- | The empty substitution.
emptySubst :: Subst a
emptySubst = Map.empty
