module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure)

-- | Entry point. v0 milestone-0 behaviour: accept a single filename argument
-- and print @ok@. The full pipeline (parse → desugar → infer → eval) is
-- wired up in subsequent milestones as each component comes online.
main :: IO ()
main = do
  args <- getArgs
  case args of
    [_filename] -> putStrLn "ok"
    _           -> do
      putStrLn "Usage: uruk <filename>"
      exitFailure
