{-# LANGUAGE ScopedTypeVariables #-}
-- | Test harness for Uruk.
--
-- Walks @test/cases/@ for @.uk@ files and runs each through the full
-- pipeline (parse → desugar → infer → eval). Each case declares its
-- expectations as directive comments, modelled on Cambria's harness:
--
--   -- \@expect-type:  \<type\>     inferred type must match this string
--   -- \@expect-value: \<value\>    evaluation must produce this result
--   -- \@expect-error: \<substring\> type checking must fail with this substring
--
-- A case with no directives is reported as a failure: every case must
-- assert something.
module Main where

import Control.Exception      (SomeException, evaluate, try)
import Control.Monad          (filterM, unless)
import Data.Function          (on)
import Data.List              (groupBy, intercalate, isInfixOf, sort, stripPrefix)
import Data.Maybe             (mapMaybe)
import System.Directory       (doesDirectoryExist, listDirectory)
import System.Exit            (exitFailure, exitSuccess)
import System.FilePath        ((</>), dropExtension, makeRelative, takeDirectory, takeExtension)

import Environment            (initialEnv)
import Eval                   (eval)
import Inference.Infer        (infer)
import Parsing.Desugar        (desugar)
import Parsing.Parser         (parse)

casesDir :: FilePath
casesDir = "test/cases"

data Expectation
  = ExpectType  String
  | ExpectValue String
  | ExpectError String

data Outcome = Pass | Fail String

-- | The triple a successful run produces: rendered type, rendered value.
-- A failed run produces an error message.
type Run = Either String (String, String)

-- | Run a source string through the full pipeline. Evaluation errors
-- (out-of-bounds projections, applied non-functions, etc.) should be
-- unreachable on well-typed inputs but are caught here for robust
-- reporting.
runProgram :: String -> IO Run
runProgram src =
  case parse src of
    Left err -> pure (Left err)
    Right sugared ->
      let term = desugar sugared in
      case infer term of
        Left err -> pure (Left err)
        Right ty -> do
          r <- try (evaluate (eval initialEnv term))
          case r of
            Right v        -> pure (Right (show v, show ty))
            Left (e :: SomeException) -> pure (Left ("runtime: " ++ show e))

findCases :: FilePath -> IO [FilePath]
findCases root = do
  entries <- sort . map (root </>) <$> listDirectory root
  dirs    <- filterM doesDirectoryExist entries
  nested  <- concat <$> mapM findCases dirs
  pure $ filter ((== ".uk") . takeExtension) entries ++ nested

directives :: [(String, String -> Expectation)]
directives =
  [ ("-- @expect-type: ",  ExpectType)
  , ("-- @expect-value: ", ExpectValue)
  , ("-- @expect-error: ", ExpectError)
  ]

parseDirectives :: String -> [Expectation]
parseDirectives src = do
  line           <- lines src
  (prefix, ctor) <- directives
  Just val       <- [stripPrefix prefix line]
  pure $ ctor val

check :: Run -> Expectation -> Maybe String
check (Right (_, t')) (ExpectType t)
  | t == t'                          = Nothing
  | otherwise                        = Just $ mismatch "Expected type" t "Actual" t'
check (Left err)      (ExpectType t) = Just $ mismatch "Expected type" t "Got error" err
check (Left err)      (ExpectError s)
  | s `isInfixOf` err                = Nothing
  | otherwise                        = Just $ mismatch "Expected error containing" s "Actual error" err
check (Right (_, t))  (ExpectError s) = Just $ mismatch "Expected error containing" s "Got type" t
check (Right (v', _)) (ExpectValue v)
  | v == v'                          = Nothing
  | otherwise                        = Just $ mismatch "Expected value" v "Actual" v'
check (Left err)      (ExpectValue v) = Just $ mismatch "Expected value" v "Got error" err

mismatch :: String -> String -> String -> String -> String
mismatch lLabel l rLabel r = lLabel ++ ": " ++ l ++ "\n  " ++ rLabel ++ ": " ++ r

testName, testGroup :: FilePath -> String
testName  = dropExtension . makeRelative casesDir
testGroup = takeDirectory . makeRelative casesDir

renderOutcome :: FilePath -> Outcome -> String
renderOutcome p Pass        = "PASS: " ++ testName p
renderOutcome p (Fail msg)  = "FAIL: " ++ testName p ++ "\n  " ++ msg

printGroup :: [(FilePath, Outcome)] -> IO ()
printGroup []                  = pure ()
printGroup grp@((p, _) : _)    = do
  putStrLn $ "── " ++ testGroup p ++ " ──"
  mapM_ (putStrLn . uncurry renderOutcome) grp
  putStrLn ""

judge :: String -> Run -> Outcome
judge src run = case parseDirectives src of
  []  -> Fail "no expectation directives found"
  exs -> case mapMaybe (check run) exs of
    []    -> Pass
    fails -> Fail (intercalate "\n  " fails)

main :: IO ()
main = do
  hasDir <- doesDirectoryExist casesDir
  unless hasDir $ do
    putStrLn $ "ERROR: " ++ casesDir ++ " not found."
    exitFailure
  files <- findCases casesDir
  results <- mapM (\f -> do
                      src <- readFile f
                      run <- runProgram src
                      pure (f, judge src run)) files
  mapM_ printGroup (groupBy ((==) `on` testGroup . fst) results)
  let passed = length [() | (_, Pass) <- results]
      total  = length results
  putStrLn $ show passed ++ "/" ++ show total ++ " tests passed."
  if passed == total then exitSuccess else exitFailure
