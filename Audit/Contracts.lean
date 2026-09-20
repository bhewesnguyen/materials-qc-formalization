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

/-!
## Two-state stationary pilot

`Lw a b X` below is the weighted generator written out with matrix units and
the dissipator formula, so the entry, trace, Hermiticity, and stationarity
contracts do not depend on the project name `generator`. The candidate
`rhoStar a b` is written as the explicit diagonal `diag(1 - a/(a+b), a/(a+b))`
and `IsDensity` as Mathlib positive semidefiniteness plus trace one. Rate
hypotheses appear exactly where the theorems require them.
-/

/-- The weighted generator spelled out: `a` weights `D[E_10]`, `b` weights `D[E_01]`. -/
local notation "Lw" => fun (a b : ℝ) (X : QubitMatrix) =>
  ((a : ℂ) • (E₁₀ * X * E₁₀ᴴ - (1 / 2 : ℂ) • (E₁₀ᴴ * E₁₀ * X + X * E₁₀ᴴ * E₁₀)) +
    (b : ℂ) • (E₀₁ * X * E₀₁ᴴ - (1 / 2 : ℂ) • (E₀₁ᴴ * E₀₁ * X + X * E₀₁ᴴ * E₀₁)) : QubitMatrix)

/-- The candidate `diag(1 - a/(a+b), a/(a+b))` spelled out. -/
local notation "Rho" => fun (a b : ℝ) =>
  (Matrix.diagonal ![((1 - a / (a + b) : ℝ) : ℂ), ((a / (a + b) : ℝ) : ℂ)] : QubitMatrix)

example (r : ℝ) : star (r : ℂ) = r := FormalScience.OpenSystems.isSelfAdjoint_ofReal r

example {A B : QubitMatrix} (h00 : A 0 0 = B 0 0) (h01 : A 0 1 = B 0 1) (h10 : A 1 0 = B 1 0)
    (h11 : A 1 1 = B 1 1) : A = B :=
  FormalScience.OpenSystems.qubitMatrix_ext h00 h01 h10 h11

example (a b : ℝ) (X : QubitMatrix) : FormalScience.OpenSystems.generator a b X = Lw a b X :=
  FormalScience.OpenSystems.generator_apply a b X

example (a b : ℝ) (X : QubitMatrix) : Lw a b X 0 0 = -(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1 :=
  FormalScience.OpenSystems.generator_apply_zero_zero a b X
example (a b : ℝ) (X : QubitMatrix) : Lw a b X 1 1 = (a : ℂ) * X 0 0 - (b : ℂ) * X 1 1 :=
  FormalScience.OpenSystems.generator_apply_one_one a b X
example (a b : ℝ) (X : QubitMatrix) : Lw a b X 0 1 = -(((a + b : ℝ) : ℂ) / 2) * X 0 1 :=
  FormalScience.OpenSystems.generator_apply_zero_one a b X
example (a b : ℝ) (X : QubitMatrix) : Lw a b X 1 0 = -(((a + b : ℝ) : ℂ) / 2) * X 1 0 :=
  FormalScience.OpenSystems.generator_apply_one_zero a b X

example (a b : ℝ) (X : QubitMatrix) : Matrix.trace (Lw a b X) = 0 :=
  FormalScience.OpenSystems.generator_trace a b X
example (a b : ℝ) {X : QubitMatrix} (hX : Xᴴ = X) : (Lw a b X)ᴴ = Lw a b X :=
  FormalScience.OpenSystems.generator_isHermitian a b hX

example (a b : ℝ) (h : a + b ≠ 0) :
    Rho a b = Matrix.diagonal ![((b / (a + b) : ℝ) : ℂ), ((a / (a + b) : ℝ) : ℂ)] :=
  FormalScience.OpenSystems.rhoStar_eq_diagonal a b h
example (a b : ℝ) (h : a + b ≠ 0) : Rho a b 0 0 = ((b / (a + b) : ℝ) : ℂ) :=
  FormalScience.OpenSystems.rhoStar_apply_zero_zero a b h
example (a b : ℝ) : Rho a b 1 1 = ((a / (a + b) : ℝ) : ℂ) :=
  FormalScience.OpenSystems.rhoStar_apply_one_one a b
example (a b : ℝ) : Rho a b 0 1 = 0 := FormalScience.OpenSystems.rhoStar_apply_zero_one a b
example (a b : ℝ) : Rho a b 1 0 = 0 := FormalScience.OpenSystems.rhoStar_apply_one_zero a b

example (a b : ℝ) (h : a + b ≠ 0) : Lw a b (Rho a b) = 0 :=
  FormalScience.OpenSystems.generator_rhoStar a b h

/- Algebraic uniqueness applied to an arbitrary trace-one complex matrix: no
Hermiticity, positivity, or diagonal shape is assumed of `X`. -/
example (a b : ℝ) (h : a + b ≠ 0) (X : QubitMatrix) (hX : Matrix.trace X = 1) :
    Lw a b X = 0 ↔ X = Rho a b :=
  FormalScience.OpenSystems.generator_eq_zero_iff_of_trace_eq_one a b h X hX

example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a + b) :
    (Rho a b).PosSemidef ∧ Matrix.trace (Rho a b) = 1 :=
  FormalScience.OpenSystems.rhoStar_isDensity a b ha hb hab

example (a b : ℝ) (h : a + b ≠ 0) {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    Lw a b ρ = 0 ↔ ρ = Rho a b :=
  FormalScience.OpenSystems.isDensity_generator_eq_zero_iff a b h hρ

example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a + b) :
    ∃! ρ : QubitMatrix, (ρ.PosSemidef ∧ Matrix.trace ρ = 1) ∧ Lw a b ρ = 0 :=
  FormalScience.OpenSystems.existsUnique_stationary_density a b ha hb hab

example (b : ℝ) : Rho 0 b = basisProjector 0 := FormalScience.OpenSystems.rhoStar_zero_left b
example (b : ℝ) (hb : 0 < b) {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    Lw 0 b ρ = 0 ↔ ρ = basisProjector 0 :=
  FormalScience.OpenSystems.isDensity_generator_zero_left_eq_zero_iff b hb hρ

example (a : ℝ) (ha : a ≠ 0) : Rho a 0 = basisProjector 1 :=
  FormalScience.OpenSystems.rhoStar_zero_right a ha
example (a : ℝ) (ha : 0 < a) {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    Lw a 0 ρ = 0 ↔ ρ = basisProjector 1 :=
  FormalScience.OpenSystems.isDensity_generator_zero_right_eq_zero_iff a ha hρ

example (X : QubitMatrix) : Lw 0 0 X = 0 := FormalScience.OpenSystems.generator_zero_zero X
example {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) : Lw 0 0 ρ = 0 :=
  FormalScience.OpenSystems.generator_zero_zero_of_isDensity hρ
example : ¬ ∃! ρ : QubitMatrix, (ρ.PosSemidef ∧ Matrix.trace ρ = 1) ∧ Lw 0 0 ρ = 0 :=
  FormalScience.OpenSystems.not_existsUnique_stationary_density_zero_zero

example (r : ℝ) (hr : r ≠ 0) : Rho r r = diagonalState (1 / 2) :=
  FormalScience.OpenSystems.rhoStar_same r hr
example (r : ℝ) (hr : 0 < r) {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    Lw r r ρ = 0 ↔ ρ = diagonalState (1 / 2) :=
  FormalScience.OpenSystems.isDensity_generator_same_eq_zero_iff r hr hρ

end JumpContracts
