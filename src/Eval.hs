-- | Call-by-value evaluator for Uruk core terms.
--
-- Grades are static information; the evaluator erases them and runs the
-- underlying term. For v0 the only side effect is the @tick@ counter,
-- threaded through evaluation as part of the result.
--
-- Real implementation lands in Milestone 1 (Ground STLC evaluation),
-- Milestone 2 (linear values), and Milestone 3 (@tick@ counter threading).
module Eval where

import Environment (Env, Value)
import Syntax (Term)

-- | Evaluation result.
--
-- In later milestones this will carry the final value together with the
-- accumulated grade information (e.g. the tick count); for Milestone 0
-- it is a stub.
data Result = ResultStub
  deriving (Eq, Show)

-- | Evaluate a Ground-sort term in the given environment.
eval :: Env -> Term -> Result
eval _ _ = ResultStub
