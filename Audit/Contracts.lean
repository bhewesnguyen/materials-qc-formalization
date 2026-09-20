import FormalScience

/-!
Independent consumer signatures. Density conclusions are spelled out in terms
of Mathlib's PSD predicate and trace, rather than only through our local alias.
No proof-search tactic fills gaps in these checks: every example is a direct
use of the public declaration at the required type.
-/

open scoped BigOperators ComplexOrder Matrix
open FormalScience.Stage0

example (i : Fin 2) :
    basisProjector i = Matrix.single i i (1 : ℂ) :=
  FormalScience.Stage0.basisProjector_eq_single i

example (i : Fin 2) :
    (basisProjector i).PosSemidef ∧ Matrix.trace (basisProjector i) = 1 :=
  FormalScience.Stage0.basisProjector_isDensity i

example (q : ℝ) (h0 : 0 ≤ q) (h1 : q ≤ 1) :
    (Matrix.diagonal ![((1-q : ℝ) : ℂ), (q : ℂ)]).PosSemidef ∧
      Matrix.trace (Matrix.diagonal ![((1-q : ℝ) : ℂ), (q : ℂ)]) = 1 :=
  FormalScience.Stage0.diagonalState_isDensity q h0 h1

example : diagonalState 0 = basisProjector 0 := FormalScience.Stage0.diagonalState_zero
example : diagonalState 1 = basisProjector 1 := FormalScience.Stage0.diagonalState_one
example : basisProjector 0 ≠ basisProjector 1 := FormalScience.Stage0.basisProjector_zero_ne_one

example {α β κ : Type*} [Fintype α] [Fintype β] [Fintype κ]
    (K : κ → Matrix β α ℂ) (X : Matrix α α ℂ) :
    Matrix.trace (∑ j, K j * X * (K j)ᴴ) =
      Matrix.trace ((∑ j, (K j)ᴴ * K j) * X) :=
  FormalScience.Stage0.krausMap_trace K X

example {α β κ : Type*} [Fintype α] [Fintype β] [Fintype κ]
    [DecidableEq α]
    (K : κ → Matrix β α ℂ) (hK : ∑ j, (K j)ᴴ * K j = 1)
    (X : Matrix α α ℂ) :
    Matrix.trace (∑ j, K j * X * (K j)ᴴ) = Matrix.trace X :=
  FormalScience.Stage0.krausMap_trace_preserving K hK X

example : (∑ _j : Fin 1, ((1 : QubitMatrix)ᴴ * 1)) = 1 :=
  FormalScience.Stage0.identityKraus_complete

example (X : QubitMatrix) :
    (∑ _j : Fin 1, (1 : QubitMatrix) * X * (1 : QubitMatrix)ᴴ) = X :=
  FormalScience.Stage0.identityKraus_apply X
