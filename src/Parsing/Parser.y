{
module Parsing.Parser (parse) where

import Control.Monad.Except

import Parsing.Token
import Parsing.Lexer
import Parsing.SugaredSyntax
}

%name parseProgram Program
%tokentype { Token }
%monad { Except String } { (>>=) } { return }
%error { parseError }

%token
  STUB    { Token _ _ TokStub }

%%

-- Milestone 0 grammar: the empty program. Productions for real terms land
-- in Milestone 1 onwards.
Program :: { SugaredTerm }
Program : {- empty -}   { SugaredStub }

{
parseError :: [Token] -> Except String a
parseError _ = throwError "parse error"

-- | Parse a Uruk source string into a surface term.
parse :: String -> Either String SugaredTerm
parse s =
  case runExcept (parseProgram (alexScanTokens s)) of
    Left err -> Left err
    Right t  -> Right t
}
