-- | Core term AST for Uruk.
--
-- This module holds the post-elaboration syntax: terms with explicit @J@/@R@
-- coercions, explicit @derelict@ at grade-elimination sites, and a clear
-- separation between Ground-sort and Computation-sort terms.
--
-- The surface (pre-elaboration) AST lives in "Parsing.SugaredSyntax". The
-- desugarer in "Parsing.Desugar" produces something close to this AST, and
-- the elaborator in "Inference.Infer" inserts the LNL coercions.
module Syntax where

import Types (Ident)

-- | Ground-sort terms (paper: 𝒜-judgement @Γ ⊢_𝒜 u : A@).
--
-- Constructors will be added in Milestone 1 (STLC) and Milestone 2
-- (lifting computations via @R@).
data Term = TermStub
  deriving (Eq, Show)

-- | Computation-sort terms (paper: mixed judgement @Γ; Δ ⊢_C t : X@).
--
-- Constructors will be added in Milestone 2 (linear core) and Milestone 3
-- (graded @return@/@do@ and @tick@).
data CompTerm = CompTermStub
  deriving (Eq, Show)
