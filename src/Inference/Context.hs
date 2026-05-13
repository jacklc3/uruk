-- | Typing contexts for Uruk's two-sort type system.
--
-- The elaborator maintains two contexts simultaneously:
--
-- * Γ ('groundCtx') — the non-linear context, mapping identifiers to
--   'GroundType'. Variables in Γ may be used freely.
--
-- * Δ ('compCtx')   — the linear computation context, mapping identifiers
--   to 'CompType'. Variables in Δ must be used exactly once across binary
--   typing rules; 'splitLinear' partitions Δ at those rules.
--
-- This split is the syntactic embodiment of the LNL discipline. Real
-- implementations land in Milestone 1 (Γ alone, for STLC) and Milestone 2
-- (the full Γ; Δ split with linear partitioning).
module Inference.Context where

import qualified Data.Map.Strict as Map

import Types (Ident, GroundType, CompType)

-- | The elaborator's typing context, pairing Γ and Δ.
data Env = Env
  { groundCtx :: Map.Map Ident GroundType  -- ^ Γ — non-linear, freely duplicated
  , compCtx   :: Map.Map Ident CompType    -- ^ Δ — linear, partitioned at binary rules
  }
  deriving (Eq, Show)

-- | Empty context.
emptyEnv :: Env
emptyEnv = Env { groundCtx = Map.empty, compCtx = Map.empty }
