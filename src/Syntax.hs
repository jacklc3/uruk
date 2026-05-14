-- | Core term AST for Uruk.
--
-- This module holds the post-elaboration syntax: terms with explicit
-- type annotations on binders where they were supplied by the user, and
-- (in later milestones) explicit @J@/@R@ coercions and @derelict@ at
-- grade-elimination sites.
--
-- Milestone 1 covers the STLC fragment of the Ground sort.
module Syntax where

import Types (Ident, GroundType)

-- | Ground-sort terms (paper: 𝒜-judgement @Γ ⊢_𝒜 u : A@).
data Term
  = Var Ident
    -- ^ Variable reference.
  | Unit
    -- ^ The unit value, @()@.
  | Pair Term Term
    -- ^ Pair constructor, @(t, u)@.
  | Fst Term
    -- ^ First projection.
  | Snd Term
    -- ^ Second projection.
  | Lam Ident (Maybe GroundType) Term
    -- ^ Lambda abstraction. The optional annotation @'Just' t@ records the
    -- parameter type when the user wrote @fun (x : t) -> e@; @'Nothing'@
    -- means the elaborator must determine it by checking against an arrow
    -- type.
  | App Term Term
    -- ^ Application.
  deriving (Eq, Show)

-- | Computation-sort terms (paper: mixed judgement @Γ; Δ ⊢_C t : X@). Stub
-- until Milestone 2.
data CompTerm = CompTermStub
  deriving (Eq, Show)
