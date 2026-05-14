module Main where

import System.Environment (getArgs)
import System.Exit        (exitFailure)

import Environment        (initialEnv)
import Eval               (eval)
import Inference.Infer    (infer)
import Parsing.Desugar    (desugar)
import Parsing.Parser     (parse)

-- | Entry point. Runs the full pipeline for Milestone 1:
--
--   1. read the file given on the command line,
--   2. parse it into the surface syntax,
--   3. desugar to the core AST,
--   4. type-check via the bidirectional elaborator, and
--   5. evaluate, printing @value : type@.
main :: IO ()
main = do
  args <- getArgs
  case args of
    [filename] -> do
      src <- readFile filename
      case parse src of
        Left err -> do
          putStrLn err
          exitFailure
        Right sugared ->
          let term = desugar sugared in
          case infer term of
            Left err -> do
              putStrLn err
              exitFailure
            Right ty ->
              putStrLn $ show (eval initialEnv term) ++ " : " ++ show ty
    _ -> do
      putStrLn "Usage: uruk <filename>"
      exitFailure
