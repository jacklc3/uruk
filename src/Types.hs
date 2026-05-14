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
-- Milestone 1 implements only 'GroundType'. 'CompType' and 'Grade' remain
-- stubs until Milestones 2 and 3 respectively.
module Types where

-- | Identifiers (variable names, eventually operation names).
type Ident = String

-- | Non-linear, Cartesian closed type sort (paper: 𝒜).
data GroundType
  = GUnit
    -- ^ The unit type, @Unit@.
  | GProd GroundType GroundType
    -- ^ Cartesian product, @A * B@.
  | GArr GroundType GroundType
    -- ^ Non-linear function type, @A -> B@.
  deriving Eq

-- | Linear, symmetric-monoidal-closed type sort (paper: C). Stub until
-- Milestone 2.
data CompType = CompTypeStub
  deriving (Eq, Show)

-- | First-class grades, inhabiting the computation sort as types. Stub until
-- Milestone 3.
data Grade = GradeStub
  deriving (Eq, Show)

-- | Custom 'Show' for 'GroundType' so error messages and test expectations
-- read naturally. Parenthesises to keep the printed form unambiguous.
--
-- Precedence levels used by 'showsPrecGT':
--
--   * 0 — top-level
--   * 1 — left of @->@ (since @->@ is right-associative)
--   * 2 — left of @*@   (since @*@  is right-associative)
--   * 3 — atomic
instance Show GroundType where
  showsPrec p t = showsPrecGT p t

showsPrecGT :: Int -> GroundType -> ShowS
showsPrecGT _ GUnit        = showString "Unit"
showsPrecGT p (GProd a b)  =
  showParen (p > 2) $
    showsPrecGT 3 a . showString " * " . showsPrecGT 2 b
showsPrecGT p (GArr a b)   =
  showParen (p > 1) $
    showsPrecGT 2 a . showString " -> " . showsPrecGT 1 b
