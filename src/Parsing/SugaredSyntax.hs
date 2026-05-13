-- | Surface (pre-elaboration) AST for Uruk.
--
-- The parser in "Parsing.Parser" produces values of this type. The desugarer
-- in "Parsing.Desugar" lowers them to the core AST in "Syntax", and then the
-- elaborator in "Inference.Infer" inserts the LNL coercions @J@/@R@ and
-- grade machinery.
--
-- Surface syntax keeps things humans write: multi-argument lambdas, do-blocks,
-- pattern shorthands, implicit promotion. Real constructors land in
-- Milestone 1 onwards.
module Parsing.SugaredSyntax where

-- | Surface terms. Stub for Milestone 0; will be expanded per milestone.
data SugaredTerm = SugaredStub
  deriving (Eq, Show)
