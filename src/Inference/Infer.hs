-- | Bidirectional type elaborator for Uruk.
--
-- Milestone 1 implements 'inferG' / 'checkG' on the Ground-sort fragment:
-- variables, unit, products, projections, lambdas, and application. The
-- elaborator is bidirectional in the Pierce–Turner style: 'inferG' returns
-- a synthesised type, while 'checkG' verifies a term against an expected
-- one and is used wherever the rule provides a target.
--
-- Annotation rules used here:
--
-- * Variables, unit, projections, and applications synthesise.
-- * Pair literals synthesise (from inferring both components).
-- * Lambdas synthesise iff the parameter is annotated, otherwise check
--   against an arrow type.
--
-- Coercion to the Computation sort, grades, and operations are deferred to
-- Milestones 2 and 3.
module Inference.Infer
  ( infer
  , inferG
  , checkG
  ) where

import Control.Monad        (when)
import Control.Monad.Reader (asks, local)

import Inference.Context (extendGround, lookupGround)
import Inference.Monad   (Infer, runInfer, typeError)
import Syntax            (Term (..))
import Types             (GroundType (..))

-- | Top-level entry point used by 'Main' and the test harness. Runs the
-- bidirectional elaborator under the empty context and returns the
-- synthesised type or the first error encountered.
infer :: Term -> Either String GroundType
infer = runInfer . inferG

-- | Synthesise the Ground type of a term.
inferG :: Term -> Infer GroundType

inferG (Var x) = do
  mt <- asks (lookupGround x)
  case mt of
    Just t  -> pure t
    Nothing -> typeError $ "unbound variable: " ++ x

inferG Unit = pure GUnit

inferG (Pair l r) = do
  tl <- inferG l
  tr <- inferG r
  pure (GProd tl tr)

inferG (Fst t) = do
  tt <- inferG t
  case tt of
    GProd a _ -> pure a
    _ -> typeError $
      "fst expects a product, got " ++ show tt

inferG (Snd t) = do
  tt <- inferG t
  case tt of
    GProd _ b -> pure b
    _ -> typeError $
      "snd expects a product, got " ++ show tt

inferG (Lam x (Just paramTy) body) = do
  retTy <- local (extendGround x paramTy) (inferG body)
  pure (GArr paramTy retTy)

inferG (Lam _ Nothing _) =
  typeError
    "cannot infer the type of an unannotated lambda \
    \(write `fun (x : T) -> ...` or supply an expected arrow type)"

inferG (App f a) = do
  ft <- inferG f
  case ft of
    GArr argTy retTy -> do
      checkG a argTy
      pure retTy
    _ -> typeError $
      "applied non-function of type " ++ show ft

-- | Check a term against an expected Ground type. Falls back to 'inferG'
-- followed by an equality check for forms that don't have a dedicated
-- checking rule.
checkG :: Term -> GroundType -> Infer ()

checkG (Lam x mParam body) expected =
  case expected of
    GArr paramTy retTy -> do
      case mParam of
        Just t
          | t /= paramTy ->
              typeError $
                "lambda parameter annotated " ++ show t
                  ++ " but expected " ++ show paramTy
        _ -> pure ()
      local (extendGround x paramTy) (checkG body retTy)
    _ -> typeError $
      "lambda used where a non-function type " ++ show expected ++ " was expected"

checkG (Pair l r) expected =
  case expected of
    GProd a b -> do
      checkG l a
      checkG r b
    _ -> typeError $
      "pair used where a non-product type " ++ show expected ++ " was expected"

checkG t expected = do
  got <- inferG t
  when (got /= expected) $
    typeError $
      "type mismatch: expected " ++ show expected ++ ", got " ++ show got
