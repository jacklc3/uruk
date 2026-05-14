{
module Parsing.Lexer where

import Parsing.Token
}

%wrapper "posn"

$digit  = 0-9
$alpha  = [a-zA-Z]
$lower  = [a-z]
$upper  = [A-Z]
$white_ = [\ \t\n\r]

@ident  = [$alpha \_] [$alpha $digit \_ \']*

tokens :-
  $white_+                   ;
  "--".*                     ;

  -- Keywords
  fun                        { \p _ -> Token p "fun" TokFun }
  fst                        { \p _ -> Token p "fst" TokFst }
  snd                        { \p _ -> Token p "snd" TokSnd }

  -- Type names
  Unit                       { \p _ -> Token p "Unit" TokTUnit }

  -- Multi-character punctuation must come before single-character rules.
  "()"                       { \p _ -> Token p "()" TokUnit }
  "->"                       { \p _ -> Token p "->" TokArrow }

  -- Single-character punctuation
  "("                        { \p _ -> Token p "(" TokLParen }
  ")"                        { \p _ -> Token p ")" TokRParen }
  ","                        { \p _ -> Token p "," TokComma }
  ":"                        { \p _ -> Token p ":" TokColon }
  "*"                        { \p _ -> Token p "*" TokStar }

  -- Identifiers come last so that the keyword rules above take priority.
  @ident                     { \p s -> Token p s (TokIdent s) }

{
-- | Lexed token: position, raw lexeme, and abstract token kind.
data Token = Token AlexPosn String TokenKind
  deriving (Eq, Show)

-- | Extract the position information from a token.
tokenPosn :: Token -> AlexPosn
tokenPosn (Token p _ _) = p

-- | Render a position as @line:col@ for error messages.
showPosn :: AlexPosn -> String
showPosn (AlexPn _ l c) = show l ++ ":" ++ show c
}
