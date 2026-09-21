import FormalScience

/-!
Independent consumer signatures. Density conclusions are spelled out in terms
of Mathlib's PSD predicate and trace, rather than only through our local alias.
No proof-search tactic fills gaps in these checks: every example is a direct
use of the public declaration at the required type.
-/

open scoped BigOperators ComplexOrder Matrix Kronecker
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

/-!
## Explicit two-state evolution

The scalar coefficients are spelled out with `Real.exp` and an explicit `if`
for the zero-total-rate branch (`Ek`, `Ef`, `Ee` below), the four entries of
the map are restated, and the derivative contract has the exact matrix-valued
type with the generator expanded to its weighted formula. Rates and times are
arbitrary reals unless a hypothesis is displayed.
-/

/- `k(gamma, t)`: `t` at zero total rate, else `(1 - exp(-gamma t)) / gamma`. The
`quotPrecheck` option only disables an eager syntax check that cannot see through the
`if`; the notation still elaborates to exactly this term. -/
set_option quotPrecheck false in
local notation "Ek" => fun (γ t : ℝ) => (if γ = 0 then t else (1 - Real.exp (-(γ * t))) / γ)
/-- `f(gamma, t) = exp(-(gamma t)/2)`. -/
local notation "Ef" => fun (γ t : ℝ) => Real.exp (-(γ * t) / 2)
/-- `e(gamma, t) = exp(-gamma t)`. -/
local notation "Ee" => fun (γ t : ℝ) => Real.exp (-(γ * t))
/-- The evolution map, by its project name; its entries are pinned down below. -/
local notation "Ev" => FormalScience.OpenSystems.evolution

example (γ : ℝ) : Ee γ 0 = 1 := FormalScience.OpenSystems.expFactor_zero γ
example (γ : ℝ) : Ef γ 0 = 1 := FormalScience.OpenSystems.halfExpFactor_zero γ
example (γ : ℝ) : Ek γ 0 = 0 := FormalScience.OpenSystems.integratedExpFactor_zero γ
example {γ : ℝ} (h : γ = 0) (t : ℝ) : Ek γ t = t :=
  FormalScience.OpenSystems.integratedExpFactor_of_eq_zero h t
example {γ : ℝ} (h : γ ≠ 0) (t : ℝ) : Ek γ t = (1 - Ee γ t) / γ :=
  FormalScience.OpenSystems.integratedExpFactor_of_ne_zero h t
example {γ : ℝ} (h : γ = 0) (t : ℝ) : Ef γ t = 1 :=
  FormalScience.OpenSystems.halfExpFactor_of_eq_zero h t
example {γ : ℝ} (h : γ = 0) (t : ℝ) : Ee γ t = 1 :=
  FormalScience.OpenSystems.expFactor_of_eq_zero h t
example (γ t : ℝ) : γ * Ek γ t = 1 - Ee γ t :=
  FormalScience.OpenSystems.mul_integratedExpFactor γ t
example (γ t u : ℝ) : Ek γ (t + u) = Ek γ t + Ee γ t * Ek γ u :=
  FormalScience.OpenSystems.integratedExpFactor_add γ t u
example (γ t u : ℝ) : Ef γ (t + u) = Ef γ t * Ef γ u :=
  FormalScience.OpenSystems.halfExpFactor_add γ t u
example (γ t : ℝ) : HasDerivAt (fun s => Ee γ s) (-γ * Ee γ t) t :=
  FormalScience.OpenSystems.hasDerivAt_expFactor γ t
example (γ t : ℝ) : HasDerivAt (fun s => Ef γ s) (-(γ / 2) * Ef γ t) t :=
  FormalScience.OpenSystems.hasDerivAt_halfExpFactor γ t
example (γ t : ℝ) : HasDerivAt (fun s => Ek γ s) (Ee γ t) t :=
  FormalScience.OpenSystems.hasDerivAt_integratedExpFactor γ t

example (a b t : ℝ) (X : QubitMatrix) (i : Fin 2) :
    Ev a b t X i i = X i i + (Ek (a + b) t : ℂ) * Lw a b X i i :=
  FormalScience.OpenSystems.evolution_apply_diag a b t X i
example (a b t : ℝ) (X : QubitMatrix) {i j : Fin 2} (h : i ≠ j) :
    Ev a b t X i j = (Ef (a + b) t : ℂ) * X i j :=
  FormalScience.OpenSystems.evolution_apply_offDiag a b t X h
example (a b t : ℝ) (X : QubitMatrix) :
    Ev a b t X 0 0 = X 0 0 + (Ek (a + b) t : ℂ) * (-(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1) :=
  FormalScience.OpenSystems.evolution_apply_zero_zero a b t X
example (a b t : ℝ) (X : QubitMatrix) :
    Ev a b t X 1 1 = X 1 1 + (Ek (a + b) t : ℂ) * ((a : ℂ) * X 0 0 - (b : ℂ) * X 1 1) :=
  FormalScience.OpenSystems.evolution_apply_one_one a b t X
example (a b t : ℝ) (X : QubitMatrix) : Ev a b t X 0 1 = (Ef (a + b) t : ℂ) * X 0 1 :=
  FormalScience.OpenSystems.evolution_apply_zero_one a b t X
example (a b t : ℝ) (X : QubitMatrix) : Ev a b t X 1 0 = (Ef (a + b) t : ℂ) * X 1 0 :=
  FormalScience.OpenSystems.evolution_apply_one_zero a b t X

example (a b : ℝ) : Ev a b 0 = LinearMap.id := FormalScience.OpenSystems.evolution_zero a b
example (a b t u : ℝ) : Ev a b (t + u) = (Ev a b t).comp (Ev a b u) :=
  FormalScience.OpenSystems.evolution_add a b t u
example (a b t : ℝ) (X : QubitMatrix) : Matrix.trace (Ev a b t X) = Matrix.trace X :=
  FormalScience.OpenSystems.evolution_trace a b t X
example {A : QubitMatrix} (h00 : star (A 0 0) = A 0 0) (h11 : star (A 1 1) = A 1 1)
    (h10 : star (A 1 0) = A 0 1) : Aᴴ = A :=
  FormalScience.OpenSystems.qubitMatrix_isHermitian_of_entries h00 h11 h10
example (a b t : ℝ) {X : QubitMatrix} (hX : Xᴴ = X) : (Ev a b t X)ᴴ = Ev a b t X :=
  FormalScience.OpenSystems.evolution_isHermitian a b t hX

section DerivativeContracts

attribute [local instance] Matrix.normedAddCommGroup Matrix.normedSpace

example {φ : ℝ → QubitMatrix} {φ' : QubitMatrix} {t : ℝ}
    (h00 : HasDerivAt (fun s => φ s 0 0) (φ' 0 0) t)
    (h01 : HasDerivAt (fun s => φ s 0 1) (φ' 0 1) t)
    (h10 : HasDerivAt (fun s => φ s 1 0) (φ' 1 0) t)
    (h11 : HasDerivAt (fun s => φ s 1 1) (φ' 1 1) t) : HasDerivAt φ φ' t :=
  FormalScience.OpenSystems.hasDerivAt_qubitMatrix h00 h01 h10 h11

/- The matrix-valued derivative endpoint: the derivative of `s ↦ Phi_s X` at every real
`t` is the generator, written as its weighted dissipator formula, applied to `Phi_t X`. -/
example (a b t : ℝ) (X : QubitMatrix) :
    HasDerivAt (fun s : ℝ => Ev a b s X) (Lw a b (Ev a b t X)) t :=
  FormalScience.OpenSystems.hasDerivAt_evolution a b t X

end DerivativeContracts

example (a b t : ℝ) {X : QubitMatrix} (h : Lw a b X = 0) : Ev a b t X = X :=
  FormalScience.OpenSystems.evolution_apply_of_generator_eq_zero a b t h
example (a b t : ℝ) (h : a + b ≠ 0) : Ev a b t (Rho a b) = Rho a b :=
  FormalScience.OpenSystems.evolution_rhoStar a b t h

/- Trace-linear population formulas on all matrices at nonzero total rate. -/
example (a b t : ℝ) (h : a + b ≠ 0) (X : QubitMatrix) :
    Ev a b t X 0 0 =
      (Ee (a + b) t : ℂ) * X 0 0 +
        (((1 - Ee (a + b) t) * (b / (a + b)) : ℝ) : ℂ) * Matrix.trace X :=
  FormalScience.OpenSystems.evolution_apply_zero_zero_of_ne_zero a b t h X
example (a b t : ℝ) (h : a + b ≠ 0) (X : QubitMatrix) :
    Ev a b t X 1 1 =
      (Ee (a + b) t : ℂ) * X 1 1 +
        (((1 - Ee (a + b) t) * (a / (a + b)) : ℝ) : ℂ) * Matrix.trace X :=
  FormalScience.OpenSystems.evolution_apply_one_one_of_ne_zero a b t h X

/- Zero total rate: `Phi_t = Id + t L` as bundled maps, the both-zero identity, and the
signed witness that rules out an identity shortcut. -/
example (a b t : ℝ) (h : a + b = 0) :
    Ev a b t = LinearMap.id + (t : ℂ) • FormalScience.OpenSystems.generator a b :=
  FormalScience.OpenSystems.evolution_eq_id_add_smul_generator a b t h
example (t : ℝ) : Ev 0 0 t = LinearMap.id := FormalScience.OpenSystems.evolution_zero_zero t
example (t : ℝ) : Ev 1 (-1) t (basisProjector 0) = diagonalState t :=
  FormalScience.OpenSystems.evolution_one_neg_one_basisProjector_zero t

example (b : ℝ) : Lw 0 b (basisProjector 0) = 0 :=
  FormalScience.OpenSystems.generator_zero_left_basisProjector_zero b
example (a : ℝ) : Lw a 0 (basisProjector 1) = 0 :=
  FormalScience.OpenSystems.generator_zero_right_basisProjector_one a
example (r : ℝ) : Lw r r (diagonalState (1 / 2)) = 0 :=
  FormalScience.OpenSystems.generator_same_diagonalState_half r
example (b t : ℝ) : Ev 0 b t (basisProjector 0) = basisProjector 0 :=
  FormalScience.OpenSystems.evolution_zero_left_basisProjector_zero b t
example (a t : ℝ) : Ev a 0 t (basisProjector 1) = basisProjector 1 :=
  FormalScience.OpenSystems.evolution_zero_right_basisProjector_one a t
example (r t : ℝ) : Ev r r t (diagonalState (1 / 2)) = diagonalState (1 / 2) :=
  FormalScience.OpenSystems.evolution_same_diagonalState_half r t

/-!
## Finite Kraus maps and the four-Kraus certificate

Generic layer: the Kraus sum is written as `∑ j, K j * X * (K j)ᴴ`, the amplifier's
block formula is exposed through `amplify_apply`, and the lifted operators are
`1 ⊗ₖ K j`. Two-state layer: `Ep` and `Ed` are spelled out with real division,
`Real.exp`, and `Real.sqrt`; the family `Kev` is referred to by name and its four
members are pinned individually with those scalars and the matrix units `E₀₁`, `E₁₀`; the
physical hypotheses `0 ≤ a`, `0 ≤ b`, `0 ≤ t` appear exactly where the theorems
require them, and the both-zero and time-zero cases are covered explicitly.
-/

section GenericKrausContracts

variable {α β κ : Type*}

example [Fintype α] [Fintype β] [Fintype κ] (K : κ → Matrix β α ℂ) {X : Matrix α α ℂ}
    (hX : X.PosSemidef) : (∑ j, K j * X * (K j)ᴴ).PosSemidef :=
  FormalScience.Quantum.krausMap_posSemidef K hX

example (m : ℕ) (Φ : Matrix α α ℂ → Matrix β β ℂ) (Y : Matrix (Fin m × α) (Fin m × α) ℂ)
    (r s : Fin m) (i j : β) :
    FormalScience.Quantum.amplify m Φ Y (r, i) (s, j) =
      Φ (Matrix.of fun u v => Y (r, u) (s, v)) i j :=
  FormalScience.Quantum.amplify_apply m Φ Y r s i j

example [Fintype α] [Fintype κ] (m : ℕ) (K : κ → Matrix β α ℂ)
    (Y : Matrix (Fin m × α) (Fin m × α) ℂ) :
    FormalScience.Quantum.amplify m (fun X => ∑ j, K j * X * (K j)ᴴ) Y =
      ∑ j, ((1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ K j) * Y * ((1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ K j)ᴴ :=
  FormalScience.Quantum.amplify_krausMap m K Y

example [Fintype α] [Fintype β] [Fintype κ] (m : ℕ) (K : κ → Matrix β α ℂ)
    {Y : Matrix (Fin m × α) (Fin m × α) ℂ} (hY : Y.PosSemidef) :
    (FormalScience.Quantum.amplify m (fun X => ∑ j, K j * X * (K j)ᴴ) Y).PosSemidef :=
  FormalScience.Quantum.amplify_krausMap_posSemidef m K hY

example (m : ℕ) (Φ : Matrix α α ℂ →ₗ[ℂ] Matrix β β ℂ) (A : Matrix (Fin m) (Fin m) ℂ)
    (X : Matrix α α ℂ) :
    FormalScience.Quantum.amplify m Φ (A ⊗ₖ X) = A ⊗ₖ Φ X :=
  FormalScience.Quantum.amplify_kronecker m Φ A X

end GenericKrausContracts

section TwoStateKrausContracts

/-- `p = b / (a + b)`, with total division. -/
local notation "Ep" => fun (a b : ℝ) => b / (a + b)
/-- `d = sqrt(1 - c^2)` with `c = exp(-(gamma t)/2)`. -/
local notation "Ed" => fun (γ t : ℝ) => Real.sqrt (1 - Real.exp (-(γ * t) / 2) ^ 2)
/-- The Kraus family by its project name; its four members are pinned down below with real
square roots and matrix units, and every later contract refers to this same family. -/
local notation "Kev" => FormalScience.OpenSystems.evolutionKraus
/-- The amplifier of the generic layer, by name; its block formula is checked above. -/
local notation "Amp" => FormalScience.Quantum.amplify

example (γ t : ℝ) : Ef γ t ^ 2 = Ee γ t := FormalScience.OpenSystems.halfExpFactor_sq γ t
example (γ t : ℝ) : 0 < Ef γ t := FormalScience.OpenSystems.halfExpFactor_pos γ t
example {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) : Ef γ t ≤ 1 :=
  FormalScience.OpenSystems.halfExpFactor_le_one hγ ht
example {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) : 0 ≤ 1 - Ef γ t ^ 2 :=
  FormalScience.OpenSystems.one_sub_halfExpFactor_sq_nonneg hγ ht
example {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) : Ed γ t ^ 2 = 1 - Ef γ t ^ 2 :=
  FormalScience.OpenSystems.jumpAmplitude_sq hγ ht
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ Ep a b :=
  FormalScience.OpenSystems.equilibriumZero_nonneg ha hb
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) : Ep a b ≤ 1 :=
  FormalScience.OpenSystems.equilibriumZero_le_one ha hb
example {a b : ℝ} (h : a + b ≠ 0) : 1 - Ep a b = a / (a + b) :=
  FormalScience.OpenSystems.one_sub_equilibriumZero h
example {a b : ℝ} (h : a + b = 0) : Ep a b = 0 :=
  FormalScience.OpenSystems.equilibriumZero_of_add_eq_zero h
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (h : a + b = 0) : a = 0 ∧ b = 0 :=
  FormalScience.OpenSystems.eq_zero_of_add_eq_zero ha hb h

/- The four operators with real square roots and the matrix units: `K0 = sqrt p • diag(1, c)`,
`K1 = (sqrt p * d) • E_01`, `K2 = sqrt (1-p) • diag(c, 1)`, `K3 = (sqrt (1-p) * d) • E_10`. -/
example (a b t : ℝ) :
    Kev a b t 0 = ((Real.sqrt (Ep a b) : ℝ) : ℂ) • Matrix.diagonal ![1, (Ef (a + b) t : ℂ)] :=
  FormalScience.OpenSystems.evolutionKraus_apply_zero a b t
example (a b t : ℝ) :
    Kev a b t 1 = (((Real.sqrt (Ep a b) : ℝ) : ℂ) * (Ed (a + b) t : ℂ)) • E₀₁ :=
  FormalScience.OpenSystems.evolutionKraus_apply_one a b t
example (a b t : ℝ) :
    Kev a b t 2 =
      ((Real.sqrt (1 - Ep a b) : ℝ) : ℂ) • Matrix.diagonal ![(Ef (a + b) t : ℂ), 1] :=
  FormalScience.OpenSystems.evolutionKraus_apply_two a b t
example (a b t : ℝ) :
    Kev a b t 3 = (((Real.sqrt (1 - Ep a b) : ℝ) : ℂ) * (Ed (a + b) t : ℂ)) • E₁₀ :=
  FormalScience.OpenSystems.evolutionKraus_apply_three a b t

/- Completeness, entries, and the all-matrix representation under the physical hypotheses. -/
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) :
    ∑ j, (Kev a b t j)ᴴ * Kev a b t j = 1 :=
  FormalScience.OpenSystems.evolutionKraus_complete ha hb ht
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    (∑ j, Kev a b t j * X * (Kev a b t j)ᴴ) 0 0 =
      ((Ep a b + (1 - Ep a b) * Ef (a + b) t ^ 2 : ℝ) : ℂ) * X 0 0 +
        ((Ep a b * (1 - Ef (a + b) t ^ 2) : ℝ) : ℂ) * X 1 1 :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_apply_zero_zero ha hb ht X
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    (∑ j, Kev a b t j * X * (Kev a b t j)ᴴ) 1 1 =
      (((1 - Ep a b) * (1 - Ef (a + b) t ^ 2) : ℝ) : ℂ) * X 0 0 +
        (((1 - Ep a b) + Ep a b * Ef (a + b) t ^ 2 : ℝ) : ℂ) * X 1 1 :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_apply_one_one ha hb ht X
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    (∑ j, Kev a b t j * X * (Kev a b t j)ᴴ) 0 1 = (Ef (a + b) t : ℂ) * X 0 1 :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_apply_zero_one ha hb ht X
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    (∑ j, Kev a b t j * X * (Kev a b t j)ᴴ) 1 0 = (Ef (a + b) t : ℂ) * X 1 0 :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_apply_one_zero ha hb ht X
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    Ev a b t X = ∑ j, Kev a b t j * X * (Kev a b t j)ᴴ :=
  FormalScience.OpenSystems.evolution_eq_krausMap ha hb ht X
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    Matrix.trace (∑ j, Kev a b t j * X * (Kev a b t j)ᴴ) = Matrix.trace X :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_trace ha hb ht X

/- Positivity and density preservation of the physical flow. -/
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : X.PosSemidef) : (Ev a b t X).PosSemidef :=
  FormalScience.OpenSystems.evolution_posSemidef ha hb ht hX
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : X.PosSemidef ∧ Matrix.trace X = 1) :
    (Ev a b t X).PosSemidef ∧ Matrix.trace (Ev a b t X) = 1 :=
  FormalScience.OpenSystems.evolution_isDensity ha hb ht hX

/- Complete positivity: the lifted-Kraus identity on every input, the all-`m` PSD conclusion,
and the tensor-action convention (ancilla first). -/
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (m : ℕ)
    (Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) ℂ) :
    Amp m (Ev a b t) Y =
      ∑ j, ((1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ Kev a b t j) * Y *
        ((1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ Kev a b t j)ᴴ :=
  FormalScience.OpenSystems.amplify_evolution_eq_krausMap ha hb ht m Y
example {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (m : ℕ)
    {Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) ℂ} (hY : Y.PosSemidef) :
    (Amp m (Ev a b t) Y).PosSemidef :=
  FormalScience.OpenSystems.amplify_evolution_posSemidef ha hb ht m hY
example (a b t : ℝ) (m : ℕ) (A : Matrix (Fin m) (Fin m) ℂ) (X : QubitMatrix) :
    Amp m (Ev a b t) (A ⊗ₖ X) = A ⊗ₖ Ev a b t X :=
  FormalScience.OpenSystems.amplify_evolution_kronecker a b t m A X

/- Boundaries: both rates zero, time zero, and each one-zero-rate direction. -/
example (t : ℝ) : Kev 0 0 t = ![0, 0, 1, 0] := FormalScience.OpenSystems.evolutionKraus_zero_zero t
example {t : ℝ} (ht : 0 ≤ t) (X : QubitMatrix) :
    ∑ j, Kev 0 0 t j * X * (Kev 0 0 t j)ᴴ = X :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_zero_zero ht X
example (a b : ℝ) :
    Kev a b 0 =
      ![((Real.sqrt (Ep a b) : ℝ) : ℂ) • 1, 0, ((Real.sqrt (1 - Ep a b) : ℝ) : ℂ) • 1, 0] :=
  FormalScience.OpenSystems.evolutionKraus_time_zero a b
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (X : QubitMatrix) :
    ∑ j, Kev a b 0 j * X * (Kev a b 0 j)ᴴ = X :=
  FormalScience.OpenSystems.krausMap_evolutionKraus_time_zero ha hb X
example {b : ℝ} (hb : 0 < b) (t : ℝ) :
    Kev 0 b t = ![Matrix.diagonal ![1, (Ef (0 + b) t : ℂ)], (Ed (0 + b) t : ℂ) • E₀₁, 0, 0] :=
  FormalScience.OpenSystems.evolutionKraus_zero_left hb t
example (a t : ℝ) :
    Kev a 0 t = ![0, 0, Matrix.diagonal ![(Ef (a + 0) t : ℂ), 1], (Ed (a + 0) t : ℂ) • E₁₀] :=
  FormalScience.OpenSystems.evolutionKraus_zero_right a t
example {b t : ℝ} (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : X.PosSemidef ∧ Matrix.trace X = 1) :
    (Ev 0 b t X).PosSemidef ∧ Matrix.trace (Ev 0 b t X) = 1 :=
  FormalScience.OpenSystems.evolution_isDensity_zero_left hb ht hX
example {a t : ℝ} (ha : 0 ≤ a) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : X.PosSemidef ∧ Matrix.trace X = 1) :
    (Ev a 0 t X).PosSemidef ∧ Matrix.trace (Ev a 0 t X) = 1 :=
  FormalScience.OpenSystems.evolution_isDensity_zero_right ha ht hX

end TwoStateKrausContracts

/-!
## Quantitative convergence

`Fn X` is the Frobenius norm written as the explicit real square root of the finite
sum of squared complex entry norms; the bridge to Mathlib's scoped Frobenius instance
is checked with the scope selected explicitly. The stationary projection of `X` is
`Matrix.trace X • Rho a b` with the `trace X` factor visible. Exponentials are
`Real.exp`; the total-rate hypotheses are `a + b ≠ 0` for the exact identities and
`0 < a + b` for the estimate and the limits; `0 ≤ t` appears only where required.
Limits are stated as `Filter.Tendsto` along `Filter.atTop` into `nhds`.
-/

section ConvergenceContracts

/-- The Frobenius norm as an explicit finite sum. -/
local notation "Fn" => fun (X : QubitMatrix) => Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)

example (X : QubitMatrix) :
    FormalScience.OpenSystems.qubitFrobeniusNorm X = Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_def X

open scoped Matrix.Norms.Frobenius in
example (X : QubitMatrix) : Fn X = ‖X‖ := FormalScience.OpenSystems.qubitFrobeniusNorm_eq_norm X

example (X : QubitMatrix) : 0 ≤ Fn X := FormalScience.OpenSystems.qubitFrobeniusNorm_nonneg X
example (X : QubitMatrix) :
    Fn X ^ 2 = ‖X 0 0‖ ^ 2 + ‖X 0 1‖ ^ 2 + ‖X 1 0‖ ^ 2 + ‖X 1 1‖ ^ 2 :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_sq X

example (γ t : ℝ) : 0 < Ee γ t := FormalScience.OpenSystems.expFactor_pos γ t
example {γ : ℝ} (hγ : 0 < γ) : Filter.Tendsto (fun t => Ee γ t) Filter.atTop (nhds 0) :=
  FormalScience.OpenSystems.expFactor_tendsto hγ
example {γ : ℝ} (hγ : 0 < γ) : Filter.Tendsto (fun t => Ef γ t) Filter.atTop (nhds 0) :=
  FormalScience.OpenSystems.halfExpFactor_tendsto hγ

/- Centered entries: the deviation from the stationary projection in the trace fiber. -/
example {a b : ℝ} (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    (Ev a b t X - Matrix.trace X • Rho a b) 0 0 =
      (Real.exp (-((a + b) * t)) : ℂ) * (X - Matrix.trace X • Rho a b) 0 0 :=
  FormalScience.OpenSystems.evolution_sub_smul_rhoStar_apply_zero_zero h t X
example {a b : ℝ} (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    (Ev a b t X - Matrix.trace X • Rho a b) 1 1 =
      (Real.exp (-((a + b) * t)) : ℂ) * (X - Matrix.trace X • Rho a b) 1 1 :=
  FormalScience.OpenSystems.evolution_sub_smul_rhoStar_apply_one_one h t X
example (a b t : ℝ) (X : QubitMatrix) :
    (Ev a b t X - Matrix.trace X • Rho a b) 0 1 =
      (Real.exp (-((a + b) * t) / 2) : ℂ) * (X - Matrix.trace X • Rho a b) 0 1 :=
  FormalScience.OpenSystems.evolution_sub_smul_rhoStar_apply_zero_one a b t X
example (a b t : ℝ) (X : QubitMatrix) :
    (Ev a b t X - Matrix.trace X • Rho a b) 1 0 =
      (Real.exp (-((a + b) * t) / 2) : ℂ) * (X - Matrix.trace X • Rho a b) 1 0 :=
  FormalScience.OpenSystems.evolution_sub_smul_rhoStar_apply_one_zero a b t X

/- Exact squared error split: diagonal energy at rate `2 gamma`, coherence energy at `gamma`. -/
example {a b : ℝ} (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    Fn (Ev a b t X - Matrix.trace X • Rho a b) ^ 2 =
      Real.exp (-((a + b) * t)) ^ 2 *
          (‖(X - Matrix.trace X • Rho a b) 0 0‖ ^ 2 + ‖(X - Matrix.trace X • Rho a b) 1 1‖ ^ 2) +
        Real.exp (-((a + b) * t) / 2) ^ 2 *
          (‖(X - Matrix.trace X • Rho a b) 0 1‖ ^ 2 + ‖(X - Matrix.trace X • Rho a b) 1 0‖ ^ 2) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_sq_evolution_sub h t X

/- The all-matrix estimate, its trace-one specialization, and the equal-trace pair bound. -/
example {a b : ℝ} (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t) (X : QubitMatrix) :
    Fn (Ev a b t X - Matrix.trace X • Rho a b) ≤
      Real.exp (-((a + b) * t) / 2) * Fn (X - Matrix.trace X • Rho a b) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_le hγ t ht X
example {a b : ℝ} (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : Matrix.trace X = 1) :
    Fn (Ev a b t X - Rho a b) ≤ Real.exp (-((a + b) * t) / 2) * Fn (X - Rho a b) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_rhoStar_le hγ t ht hX
example {a b : ℝ} (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t) {X Z : QubitMatrix}
    (hXZ : Matrix.trace X = Matrix.trace Z) :
    Fn (Ev a b t X - Ev a b t Z) ≤ Real.exp (-((a + b) * t) / 2) * Fn (X - Z) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_evolution_le hγ t ht hXZ

/- Long-time limits: the scalar error and the matrix itself, in the canonical matrix topology. -/
example {a b : ℝ} (hγ : 0 < a + b) (X : QubitMatrix) :
    Filter.Tendsto (fun t : ℝ => Fn (Ev a b t X - Matrix.trace X • Rho a b))
      Filter.atTop (nhds 0) :=
  FormalScience.OpenSystems.tendsto_qubitFrobeniusNorm_evolution_sub hγ X
example {φ : ℝ → QubitMatrix} {M : QubitMatrix} {l : Filter ℝ}
    (h00 : Filter.Tendsto (fun t => φ t 0 0) l (nhds (M 0 0)))
    (h01 : Filter.Tendsto (fun t => φ t 0 1) l (nhds (M 0 1)))
    (h10 : Filter.Tendsto (fun t => φ t 1 0) l (nhds (M 1 0)))
    (h11 : Filter.Tendsto (fun t => φ t 1 1) l (nhds (M 1 1))) : Filter.Tendsto φ l (nhds M) :=
  FormalScience.OpenSystems.tendsto_qubitMatrix h00 h01 h10 h11
example {a b : ℝ} (hγ : 0 < a + b) (X : QubitMatrix) :
    Filter.Tendsto (fun t : ℝ => Ev a b t X) Filter.atTop (nhds (Matrix.trace X • Rho a b)) :=
  FormalScience.OpenSystems.tendsto_evolution hγ X
example {a b : ℝ} (hγ : 0 < a + b) {X : QubitMatrix} (hX : Matrix.trace X = 1) :
    Filter.Tendsto (fun t : ℝ => Ev a b t X) Filter.atTop (nhds (Rho a b)) :=
  FormalScience.OpenSystems.tendsto_evolution_of_trace_eq_one hγ hX

/- Physical consumers: density preservation with the contraction, and the density limit. -/
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t)
    {ρ : QubitMatrix} (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    ((Ev a b t ρ).PosSemidef ∧ Matrix.trace (Ev a b t ρ) = 1) ∧
      Fn (Ev a b t ρ - Rho a b) ≤ Real.exp (-((a + b) * t) / 2) * Fn (ρ - Rho a b) :=
  FormalScience.OpenSystems.evolution_isDensity_and_qubitFrobeniusNorm_le ha hb hγ t ht hρ
example {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (hγ : 0 < a + b) {ρ : QubitMatrix}
    (hρ : ρ.PosSemidef ∧ Matrix.trace ρ = 1) :
    ((Rho a b).PosSemidef ∧ Matrix.trace (Rho a b) = 1) ∧
      Filter.Tendsto (fun t : ℝ => Ev a b t ρ) Filter.atTop (nhds (Rho a b)) :=
  FormalScience.OpenSystems.tendsto_evolution_of_isDensity ha hb hγ hρ

/- Rate boundaries: the three positive-total-rate limits and the both-zero non-attractor. -/
example {b : ℝ} (hb : 0 < b) {X : QubitMatrix} (hX : Matrix.trace X = 1) :
    Filter.Tendsto (fun t : ℝ => Ev 0 b t X) Filter.atTop (nhds (basisProjector 0)) :=
  FormalScience.OpenSystems.tendsto_evolution_zero_left hb hX
example {a : ℝ} (ha : 0 < a) {X : QubitMatrix} (hX : Matrix.trace X = 1) :
    Filter.Tendsto (fun t : ℝ => Ev a 0 t X) Filter.atTop (nhds (basisProjector 1)) :=
  FormalScience.OpenSystems.tendsto_evolution_zero_right ha hX
example {r : ℝ} (hr : 0 < r) {X : QubitMatrix} (hX : Matrix.trace X = 1) :
    Filter.Tendsto (fun t : ℝ => Ev r r t X) Filter.atTop (nhds (diagonalState (1 / 2))) :=
  FormalScience.OpenSystems.tendsto_evolution_same hr hX
example : ¬ ∃ σ : QubitMatrix, ∀ ρ : QubitMatrix, (ρ.PosSemidef ∧ Matrix.trace ρ = 1) →
    Filter.Tendsto (fun t : ℝ => Ev 0 0 t ρ) Filter.atTop (nhds σ) :=
  FormalScience.OpenSystems.not_exists_common_limit_zero_zero

/- Optional witness: `E_01` is an eigenvector of the flow saturating the coherence exponent. -/
example (a b t : ℝ) : Ev a b t E₀₁ = (Real.exp (-((a + b) * t) / 2) : ℂ) • E₀₁ :=
  FormalScience.OpenSystems.evolution_jumpOneToZero a b t
example : Fn E₀₁ = 1 := FormalScience.OpenSystems.qubitFrobeniusNorm_jumpOneToZero
example (a b t : ℝ) : Fn (Ev a b t E₀₁) = Real.exp (-((a + b) * t) / 2) :=
  FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_jumpOneToZero a b t

end ConvergenceContracts

end JumpContracts
