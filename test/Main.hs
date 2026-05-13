-- | Test harness for Uruk.
--
-- For Milestone 0 this is a placeholder that succeeds without running any
-- cases. From Milestone 1 onward it will pick up @.uk@ files under
-- @test/cases/@ and check them against directive comments, following
-- Cambria's pattern:
--
--   -- @expect-type:  <type>      inferred type must match this string
--   -- @expect-value: <value>     evaluation must produce this result
--   -- @expect-error: <substring> type checking must fail with this substring
module Main where

import System.Exit (exitSuccess)

main :: IO ()
main = do
  putStrLn "0/0 tests passed."
  exitSuccess
