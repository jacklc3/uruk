-- | Token kinds produced by the lexer and consumed by the parser.
--
-- The 'Token' wrapper itself is defined in "Parsing.Lexer" so that it can
-- reference Alex's generated position type without leaking it elsewhere.
-- This module owns only the abstract kinds.
--
-- Real constructors are added in Milestone 1 (STLC tokens), Milestone 2
-- (LNL connectives), and Milestone 3 (grade syntax, @tick@).
module Parsing.Token where

-- | Token kinds. Stub for Milestone 0; real cases are added per milestone.
data TokenKind = TokStub
  deriving (Eq, Show)
