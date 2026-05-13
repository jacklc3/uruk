-- | Types of the Uruk language.
--
-- Uruk has two sorts of types, following the LNL-RMM calculus:
--
-- * 'GroundType' — non-linear types (the 𝒜 sort in the paper). These behave
--   like ordinary STLC types: values can be duplicated and discarded freely.
--
-- * 'CompType' — linear computation types (the C sort in the paper). These
--   live under a symmetric monoidal discipline; variables in the computation
--   context must be used exactly once.
--
-- The two sorts are connected by the lifts @J : Ground → Comp@ and
-- @R : Comp → Ground@, and grades are themselves first-class types in the
-- computation sort.
--
-- v0 ships only with the @(ℕ, +, 0)@ grade theory and a single built-in
-- graded primitive (@tick@); the surface syntax for everything else is
-- present but the implementations are stubs.
module Types where

-- | Identifiers (variable names, eventually operation names).
type Ident = String

-- | Non-linear, Cartesian closed type sort (paper: 𝒜).
--
-- Real constructors (@GUnit@, @GProd@, @GArr@, @GR@, @GComp@) will be added in
-- Milestone 1 and Milestone 2. For Milestone 0 a single stub keeps the module
-- well-formed without forcing premature design choices.
data GroundType = GroundTypeStub
  deriving (Eq, Show)

-- | Linear, symmetric-monoidal-closed type sort (paper: C).
data CompType = CompTypeStub
  deriving (Eq, Show)

-- | First-class grades, inhabiting the computation sort as types.
--
-- v0 instantiates the grade theory to @(ℕ, +, 0)@; later milestones make
-- this pluggable.
data Grade = GradeStub
  deriving (Eq, Show)
