-- | Surface (pre-elaboration) AST for Uruk.
--
-- The parser produces 'SugaredTerm' values; the desugarer in
-- "Parsing.Desugar" lowers them to "Syntax". The two are very close in
-- Milestone 1 — they differ only in that surface types are 'SugaredType'
-- rather than 'Types.GroundType', because v1+ will let the surface mention
-- type constructs (graded types, linear connectives) that the core elaborator
-- has to resolve.
module Parsing.SugaredSyntax where

import Types (Ident)

-- | Surface terms.
data SugaredTerm
  = SVar Ident
  | SUnit
  | SPair SugaredTerm SugaredTerm
  | SFst SugaredTerm
  | SSnd SugaredTerm
  | SLam Ident (Maybe SugaredType) SugaredTerm
  | SApp SugaredTerm SugaredTerm
  deriving (Eq, Show)

-- | Surface types. Mirrors Milestone 1's 'GroundType' fragment; will grow
-- with linear connectives and grades in later milestones.
data SugaredType
  = STUnit
  | STProd SugaredType SugaredType
  | STArr  SugaredType SugaredType
  deriving (Eq, Show)
