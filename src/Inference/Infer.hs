-- | Bidirectional type elaborator for Uruk.
--
-- Provides @inferG@/@checkG@ for the Ground sort and @inferC@/@checkC@ for
-- the Computation sort; the sort tracked by which function the caller
-- invokes. Coercions between sorts (@J@, @R@, @derelict@) are inserted by
-- this module when the user's surface term mentions them, and (later)
-- elaborated implicitly where unambiguous.
--
-- Real rules land in Milestone 1 (Ground STLC), Milestone 2 (LNL boundary),
-- and Milestone 3 (graded constructs and @tick@).
module Inference.Infer where

import Inference.Monad (Infer)
import Syntax (Term)
import Types (GroundType (..))

-- | Entry point used by 'Main' and the test harness.
--
-- For Milestone 0 this always succeeds and returns the placeholder Ground
-- type. Real implementation lands in Milestone 1.
infer :: Term -> Infer GroundType
infer _ = Right GroundTypeStub
