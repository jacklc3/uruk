-- | Token kinds produced by the lexer and consumed by the parser.
--
-- The 'Token' wrapper itself is defined in "Parsing.Lexer" so that it can
-- reference Alex's generated position type without leaking it into other
-- modules. This module owns only the abstract kinds.
module Parsing.Token where

-- | Token kinds. Milestone 1 covers the STLC surface: keywords for lambdas
-- and projections, punctuation, identifiers, and the unit literal.
data TokenKind
  -- Keywords
  = TokFun
  | TokFst
  | TokSnd
  -- Type names
  | TokTUnit
  -- Punctuation
  | TokLParen
  | TokRParen
  | TokComma
  | TokColon
  | TokArrow      -- ^ @->@
  | TokStar       -- ^ @*@
  -- Literals
  | TokUnit       -- ^ @()@
  -- Identifiers
  | TokIdent String
  deriving (Eq, Show)
