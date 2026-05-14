-- | Lower surface syntax to the core AST.
--
-- For Milestone 1 the surface and core are structurally identical and the
-- desugarer is a near-trivial structural recursion. The only real
-- difference is that surface types ('SugaredType') translate to ground
-- types ('GroundType').
--
-- This will grow with do-notation, multi-argument lambdas, and other sugars
-- in later milestones.
module Parsing.Desugar (desugar, desugarType) where

import qualified Parsing.SugaredSyntax as S
import qualified Syntax as C
import qualified Types as T

-- | Desugar a surface term to a core Ground-sort term.
desugar :: S.SugaredTerm -> C.Term
desugar (S.SVar x)        = C.Var x
desugar  S.SUnit          = C.Unit
desugar (S.SPair l r)     = C.Pair (desugar l) (desugar r)
desugar (S.SFst t)        = C.Fst  (desugar t)
desugar (S.SSnd t)        = C.Snd  (desugar t)
desugar (S.SLam x mt b)   = C.Lam  x (fmap desugarType mt) (desugar b)
desugar (S.SApp f a)      = C.App  (desugar f) (desugar a)

-- | Desugar a surface type to a 'GroundType'.
desugarType :: S.SugaredType -> T.GroundType
desugarType  S.STUnit       = T.GUnit
desugarType (S.STProd a b)  = T.GProd (desugarType a) (desugarType b)
desugarType (S.STArr  a b)  = T.GArr  (desugarType a) (desugarType b)
