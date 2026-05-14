-- | Typing contexts for Uruk's two-sort type system.
--
-- The elaborator maintains two contexts simultaneously:
--
-- * Γ ('groundCtx') — the non-linear context, mapping identifiers to
--   'GroundType'. Variables in Γ may be used freely.
--
-- * Δ ('compCtx') — the linear computation context, mapping identifiers
--   to 'CompType'. Variables in Δ must be used exactly once across binary
--   typing rules; 'splitLinear' (Milestone 2) will partition Δ at those
--   rules.
--
-- Milestone 1 uses only Γ; Δ stays in the record so that Milestone 2 can
-- extend the elaborator without churning the type of 'Env' everywhere.
module Inference.Context
  ( Env (..)
  , emptyEnv
  , extendGround
  , lookupGround
  ) where

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

-- | Extend Γ with a fresh binding. Shadowing is permitted: a later
-- binding for the same identifier hides the earlier one.
extendGround :: Ident -> GroundType -> Env -> Env
extendGround x t env =
  env { groundCtx = Map.insert x t (groundCtx env) }

-- | Look up an identifier in Γ.
lookupGround :: Ident -> Env -> Maybe GroundType
lookupGround x env = Map.lookup x (groundCtx env)
