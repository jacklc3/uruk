-- | Runtime environment and built-in primitives for Uruk.
--
-- For Milestone 1 the runtime is a plain call-by-value evaluator: values
-- are unit, pairs, and closures. The 'tick' built-in lands in Milestone 3
-- alongside grade tracking.
module Environment
  ( Value (..)
  , Env
  , initialEnv
  , extend
  , lookupVar
  ) where

import qualified Data.Map.Strict as Map

import Syntax (Term)
import Types  (Ident)

-- | Runtime values.
data Value
  = VUnit
  | VPair Value Value
  | VClosure Ident Term Env
  deriving Eq

-- | Evaluation environment: bindings from identifiers to values.
type Env = Map.Map Ident Value

-- | The initial environment. Empty for Milestone 1; will be populated
-- with the @tick@ primitive in Milestone 3.
initialEnv :: Env
initialEnv = Map.empty

-- | Extend an environment with a fresh binding.
extend :: Ident -> Value -> Env -> Env
extend = Map.insert

-- | Look up a runtime binding.
lookupVar :: Ident -> Env -> Maybe Value
lookupVar = Map.lookup

-- | Human-readable rendering used by 'Main' and the test harness.
-- Closures print uniformly as @<fun>@ so that test expectations don't
-- depend on captured environment contents.
instance Show Value where
  show VUnit          = "()"
  show (VPair l r)    = "(" ++ show l ++ ", " ++ show r ++ ")"
  show (VClosure {})  = "<fun>"
