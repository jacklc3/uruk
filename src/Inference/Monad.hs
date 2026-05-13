-- | The elaboration monad: reader for the context, state for fresh names
-- and grade constraints, except for type errors.
--
-- Real definitions land in Milestone 1; the shape is sketched below for
-- reference.
module Inference.Monad where

-- | Type errors produced by the elaborator. For Milestone 0 a plain string,
-- as in Cambria; later milestones will refine this into structured errors
-- (with source positions, expected/actual types, grade equations).
type TypeError = String

-- | The elaboration monad. Will become
-- @ReaderT 'Inference.Context.Env' (StateT FreshAndConstraints (Except TypeError))@
-- in Milestone 1; for Milestone 0 it is just 'Either'.
type Infer a = Either TypeError a

-- | Run an elaboration computation.
runInfer :: Infer a -> Either TypeError a
runInfer = id
