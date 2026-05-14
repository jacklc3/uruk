{
{-# OPTIONS_GHC -Wno-unused-imports #-}
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
  fun         { Token _ _ TokFun }
  fst         { Token _ _ TokFst }
  snd         { Token _ _ TokSnd }
  'Unit'      { Token _ _ TokTUnit }
  '('         { Token _ _ TokLParen }
  ')'         { Token _ _ TokRParen }
  '()'        { Token _ _ TokUnit }
  ','         { Token _ _ TokComma }
  ':'         { Token _ _ TokColon }
  '->'        { Token _ _ TokArrow }
  '*'         { Token _ _ TokStar }
  ident       { Token _ _ (TokIdent $$) }

%%

-- A program is a single expression.
Program :: { SugaredTerm }
        : Expr                                   { $1 }

-- The expression layer is split so that lambda bodies extend as far right
-- as possible, application is left-associative, and projections/atoms sit
-- below application.

Expr :: { SugaredTerm }
     : Lam                                       { $1 }

Lam :: { SugaredTerm }
    : fun '(' ident ':' Type ')' '->' Expr       { SLam $3 (Just $5) $8 }
    | fun ident '->' Expr                        { SLam $2 Nothing $4 }
    | AppExpr                                    { $1 }

AppExpr :: { SugaredTerm }
        : AppExpr Atom                           { SApp $1 $2 }
        | fst Atom                               { SFst $2 }
        | snd Atom                               { SSnd $2 }
        | Atom                                   { $1 }

Atom :: { SugaredTerm }
     : ident                                     { SVar $1 }
     | '()'                                      { SUnit }
     | '(' Expr ')'                              { $2 }
     | '(' Expr ',' Expr ')'                     { SPair $2 $4 }

-- Types: '->' is right-associative and binds least tightly; '*' is
-- right-associative and binds tighter than '->'.

Type :: { SugaredType }
     : Type1 '->' Type                           { STArr  $1 $3 }
     | Type1                                     { $1 }

Type1 :: { SugaredType }
      : AtomT '*' Type1                          { STProd $1 $3 }
      | AtomT                                    { $1 }

AtomT :: { SugaredType }
      : 'Unit'                                   { STUnit }
      | '(' Type ')'                             { $2 }

{
parseError :: [Token] -> Except String a
parseError []                          = throwError "parse error at end of input"
parseError (Token p s _ : _) =
  throwError $ "parse error at " ++ showPosn p ++ " near '" ++ s ++ "'"

-- | Parse a Uruk source string into a surface term.
parse :: String -> Either String SugaredTerm
parse s =
  case runExcept (parseProgram (alexScanTokens s)) of
    Left err -> Left err
    Right t  -> Right t
}
