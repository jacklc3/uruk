-- | Lower surface syntax (Parsing.SugaredSyntax) to the core AST (Syntax).
--
-- The desugarer handles purely syntactic transformations: flattening
-- multi-argument lambdas, expanding do-notation into binds, normalising
-- patterns. It does /not/ insert LNL coercions or perform any type-directed
-- elaboration — that is the elaborator's job, in "Inference.Infer".
--
-- Real implementation lands in Milestone 1.
module Parsing.Desugar where

import qualified Parsing.SugaredSyntax as S
import qualified Syntax as C

-- | Desugar a surface term to a core Ground-sort term. The interface may
-- need to become richer (e.g. returning a sort tag, or producing either a
-- 'Term' or a 'CompTerm') as the language fills out; for Milestone 0 it
-- is a stub.
desugar :: S.SugaredTerm -> C.Term
desugar _ = C.TermStub
