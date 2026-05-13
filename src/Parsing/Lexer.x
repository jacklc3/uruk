{
module Parsing.Lexer where

import Parsing.Token
}

%wrapper "posn"

$white = [\ \t\n\r]

tokens :-
  $white+         ;
  "--".*          ;
  .               { \p s -> Token p s TokStub }

{
-- | Lexed token: position, raw lexeme, and abstract token kind.
data Token = Token AlexPosn String TokenKind
  deriving (Eq, Show)
}
