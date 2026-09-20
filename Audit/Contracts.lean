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

/-!
## Finite dissipator algebra

The dissipator conclusions are spelled out with the defining formula
`V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)` rather than through the
project name `dissipator`, Hermiticity is written as `Mᴴ = M`, and the basis
jumps are written as Mathlib matrix units. The jump matrix `V` carries no
hypothesis anywhere below.
-/

section DissipatorContracts

variable {n : Type*} [Fintype n]

example (V X Y : Matrix n n ℂ) :
    V * (X + Y) * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * (X + Y) + (X + Y) * Vᴴ * V) =
      (V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)) +
        (V * Y * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * Y + Y * Vᴴ * V)) :=
  FormalScience.OpenSystems.dissipator_add V X Y

example (V : Matrix n n ℂ) (c : ℂ) (X : Matrix n n ℂ) :
    V * (c • X) * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * (c • X) + (c • X) * Vᴴ * V) =
      c • (V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)) :=
  FormalScience.OpenSystems.dissipator_smul V c X

example (V X : Matrix n n ℂ) :
    FormalScience.OpenSystems.dissipatorLinearMap V X =
      V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V) :=
  FormalScience.OpenSystems.dissipatorLinearMap_apply V X

example (V X : Matrix n n ℂ) :
    Matrix.trace (V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)) = 0 :=
  FormalScience.OpenSystems.dissipator_trace V X

example {A X : Matrix n n ℂ} (hA : Aᴴ = A) (hX : Xᴴ = X) :
    (A * X + X * A)ᴴ = A * X + X * A :=
  FormalScience.OpenSystems.isHermitian_anticommutator hA hX

example : star (1 / 2 : ℂ) = 1 / 2 :=
  FormalScience.OpenSystems.isSelfAdjoint_half

example (V : Matrix n n ℂ) {X : Matrix n n ℂ} (hX : Xᴴ = X) :
    (V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V))ᴴ =
      V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V) :=
  FormalScience.OpenSystems.dissipator_isHermitian V hX

end DissipatorContracts

section JumpContracts

/-- `E_10 = |1><0|` as a Mathlib matrix unit on the ordered qubit basis. -/
local notation "E₁₀" => (Matrix.single 1 0 (1 : ℂ) : QubitMatrix)

/-- `E_01 = |0><1|` as a Mathlib matrix unit on the ordered qubit basis. -/
local notation "E₀₁" => (Matrix.single 0 1 (1 : ℂ) : QubitMatrix)

example : E₁₀ᴴ = E₀₁ := FormalScience.OpenSystems.jumpZeroToOne_conjTranspose
example : E₀₁ᴴ = E₁₀ := FormalScience.OpenSystems.jumpOneToZero_conjTranspose

example : E₁₀ᴴ * E₁₀ = basisProjector 0 :=
  FormalScience.OpenSystems.jumpZeroToOne_conjTranspose_mul_self
example : E₀₁ᴴ * E₀₁ = basisProjector 1 :=
  FormalScience.OpenSystems.jumpOneToZero_conjTranspose_mul_self

example (X : QubitMatrix) : E₁₀ * X * E₁₀ᴴ = X 0 0 • basisProjector 1 :=
  FormalScience.OpenSystems.jumpZeroToOne_mul_mul_conjTranspose X
example (X : QubitMatrix) : E₀₁ * X * E₀₁ᴴ = X 1 1 • basisProjector 0 :=
  FormalScience.OpenSystems.jumpOneToZero_mul_mul_conjTranspose X

example (X : QubitMatrix) :
    E₁₀ * X * E₁₀ᴴ - (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * X + X * E₁₀ᴴ * E₁₀) =
      X 0 0 • basisProjector 1 - (1 / 2 : ℂ) • (basisProjector 0 * X + X * basisProjector 0) :=
  FormalScience.OpenSystems.dissipator_jumpZeroToOne_eq X
example (X : QubitMatrix) :
    E₀₁ * X * E₀₁ᴴ - (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * X + X * E₀₁ᴴ * E₀₁) =
      X 1 1 • basisProjector 0 - (1 / 2 : ℂ) • (basisProjector 1 * X + X * basisProjector 1) :=
  FormalScience.OpenSystems.dissipator_jumpOneToZero_eq X

example (X : QubitMatrix) :
    Matrix.trace (E₁₀ * X * E₁₀ᴴ - (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * X + X * E₁₀ᴴ * E₁₀)) = 0 :=
  FormalScience.OpenSystems.dissipator_jumpZeroToOne_trace X
example (X : QubitMatrix) :
    Matrix.trace (E₀₁ * X * E₀₁ᴴ - (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * X + X * E₀₁ᴴ * E₀₁)) = 0 :=
  FormalScience.OpenSystems.dissipator_jumpOneToZero_trace X

example {X : QubitMatrix} (hX : Xᴴ = X) :
    (E₁₀ * X * E₁₀ᴴ - (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * X + X * E₁₀ᴴ * E₁₀))ᴴ =
      E₁₀ * X * E₁₀ᴴ - (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * X + X * E₁₀ᴴ * E₁₀) :=
  FormalScience.OpenSystems.dissipator_jumpZeroToOne_isHermitian hX
example {X : QubitMatrix} (hX : Xᴴ = X) :
    (E₀₁ * X * E₀₁ᴴ - (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * X + X * E₀₁ᴴ * E₀₁))ᴴ =
      E₀₁ * X * E₀₁ᴴ - (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * X + X * E₀₁ᴴ * E₀₁) :=
  FormalScience.OpenSystems.dissipator_jumpOneToZero_isHermitian hX

example : ¬ (E₁₀ᴴ = E₁₀) := FormalScience.OpenSystems.jumpZeroToOne_not_isHermitian
example : ¬ (E₀₁ᴴ = E₀₁) := FormalScience.OpenSystems.jumpOneToZero_not_isHermitian

example :
    E₁₀ * basisProjector 0 * E₁₀ᴴ -
        (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * basisProjector 0 + basisProjector 0 * E₁₀ᴴ * E₁₀) =
      basisProjector 1 - basisProjector 0 :=
  FormalScience.OpenSystems.dissipator_jumpZeroToOne_basisProjector_zero
example :
    E₀₁ * basisProjector 1 * E₀₁ᴴ -
        (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * basisProjector 1 + basisProjector 1 * E₀₁ᴴ * E₀₁) =
      basisProjector 0 - basisProjector 1 :=
  FormalScience.OpenSystems.dissipator_jumpOneToZero_basisProjector_one

end JumpContracts
