import FormalScience

open FormalScience.Stage0 FormalScience.OpenSystems
open scoped Topology

-- The guide's setup does not open the Quantum namespace.
/-- error: Unknown identifier `krausMap_posSemidef` -/
#guard_msgs in
#check krausMap_posSemidef

-- These fully qualified names resolve and use the accepted source.
#check FormalScience.Quantum.krausMap_posSemidef
#check FormalScience.Quantum.amplify
#check FormalScience.Quantum.amplify_krausMap

-- The accepted zero-left identity needs no hypothesis, even at b = 0.
example (b : ℝ) : rhoStar 0 b = basisProjector 0 := rhoStar_zero_left b
example : rhoStar 0 0 = basisProjector 0 := rhoStar_zero_left 0
