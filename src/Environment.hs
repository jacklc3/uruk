-- | Runtime environment and built-in primitives for Uruk.
--
-- For v0 the only built-in is @tick@: a graded primitive of type
-- @T<1> Unit@ that increments a runtime counter. The environment also holds
-- the bindings introduced by user terms during evaluation.
--
-- Real definitions land in Milestone 3 once the term and value
-- representations stabilise; for Milestone 0 this module is a stub.
module Environment where

-- | Runtime values.
data Value = ValueStub
  deriving (Eq, Show)

-- | Evaluation environment: bindings from identifiers to values.
data Env = Env
  deriving (Eq, Show)

-- | The initial environment, populated with built-in primitives such as
-- @tick@. Empty for now.
initialEnv :: Env
initialEnv = Env
