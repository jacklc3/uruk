-- | The elaboration monad.
--
-- The stack reads the typing context from a 'Reader', threads a small
-- elaboration state through 'StateT' (for fresh names and grade
-- constraints — neither used yet in Milestone 1, but the field exists so
-- that later milestones can extend it without changing the monad shape),
-- and surfaces type errors via 'Except'.
module Inference.Monad
  ( TypeError
  , InferState (..)
  , initialState
  , Infer
  , runInfer
  , typeError
  ) where

import Control.Monad.Except  (ExceptT, runExceptT, throwError)
import Control.Monad.Reader  (ReaderT, runReaderT)
import Control.Monad.State   (StateT, evalStateT)
import Data.Functor.Identity (Identity, runIdentity)

import Inference.Context (Env, emptyEnv)

-- | Type errors produced by the elaborator. Milestone 1 surfaces these as
-- plain strings; later milestones may refine the representation to carry
-- source positions and structured expected/actual information.
type TypeError = String

-- | Mutable elaboration state.
--
-- For Milestone 1 the only field is a fresh-name counter, which is unused
-- by the current rules but kept so that adding grade meta-variables in
-- Milestone 3 doesn't ripple through every signature.
data InferState = InferState
  { freshCounter :: !Int
  }
  deriving (Eq, Show)

-- | Initial elaboration state.
initialState :: InferState
initialState = InferState { freshCounter = 0 }

-- | The elaboration monad.
type Infer a = ReaderT Env (StateT InferState (ExceptT TypeError Identity)) a

-- | Run an elaboration computation under the empty context.
runInfer :: Infer a -> Either TypeError a
runInfer m =
  runIdentity $
    runExceptT $
      evalStateT (runReaderT m emptyEnv) initialState

-- | Abort elaboration with a type error.
typeError :: TypeError -> Infer a
typeError = throwError
