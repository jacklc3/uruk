-- | Call-by-value evaluator for Uruk core terms.
--
-- For Milestone 1 evaluation operates on the Ground-sort fragment only.
-- The evaluator assumes its input has type-checked: it does not re-check
-- structural assumptions and falls back to 'error' for ill-typed inputs,
-- which should be unreachable on well-typed programs.
--
-- Grades, the @tick@ primitive, and the linear runtime arrive in
-- Milestones 2 and 3; the evaluator's shape (a function from environment
-- and term to value) does not change.
module Eval
  ( eval
  ) where

import Environment (Env, Value (..), extend, lookupVar)
import Syntax      (Term (..))

-- | Evaluate a Ground-sort term in the given environment.
eval :: Env -> Term -> Value
eval env t = case t of
  Var x ->
    case lookupVar x env of
      Just v  -> v
      Nothing -> error $ "uruk: unbound variable at runtime: " ++ x
        -- Unreachable on well-typed input.

  Unit ->
    VUnit

  Pair l r ->
    VPair (eval env l) (eval env r)

  Fst p ->
    case eval env p of
      VPair l _ -> l
      v -> error $ "uruk: fst on non-pair runtime value: " ++ show v

  Snd p ->
    case eval env p of
      VPair _ r -> r
      v -> error $ "uruk: snd on non-pair runtime value: " ++ show v

  Lam x _ body ->
    VClosure x body env

  App f a ->
    case eval env f of
      VClosure x body fenv ->
        let v = eval env a
         in eval (extend x v fenv) body
      v -> error $ "uruk: applied non-function runtime value: " ++ show v
