import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import FormalScience.Stage0
import FormalScience.OpenSystems.Dissipator

/-!
# Two-state stationary pilot

The weighted two-jump generator with zero Hamiltonian on the qubit basis
`0, 1`, with real rates `a` (jump `E_10`, population `0 -> 1`) and `b`
(jump `E_01`, population `1 -> 0`):

  `L[a,b](X) = (a : ℂ) • D[E_10](X) + (b : ℂ) • D[E_01](X)`.

This module proves the four entry equations, trace annihilation, and
Hermiticity preservation for arbitrary real rates and arbitrary complex `X`;
defines the candidate `rhoStar a b = diagonalState (a / (a + b))`; proves,
under only `a + b ≠ 0`, its diagonal presentation, stationarity, and the
algebraic uniqueness statement `trace X = 1 → (L X = 0 ↔ X = rhoStar)` for
every complex matrix `X` (no Hermiticity or positivity assumed); proves
density validity and unique existence of a stationary density under
`0 ≤ a`, `0 ≤ b`, `0 < a + b`; and covers the one-zero-rate, both-zero-rate,
and equal-positive-rate boundary cases.

Nothing here concerns dynamics, semigroups, convergence, positivity of maps,
complete positivity, or generic GKSL theory. Lean division is total, so
`rhoStar a b` has a value when `a + b = 0`; the theorems that need
`a + b ≠ 0` state it explicitly.
-/

open scoped Matrix
open FormalScience.Stage0

namespace FormalScience.OpenSystems

/-- A real number cast into `ℂ` is self-adjoint. -/
theorem isSelfAdjoint_ofReal (r : ℝ) : IsSelfAdjoint (r : ℂ) := by
  rw [IsSelfAdjoint, Complex.star_def, Complex.conj_ofReal]

/-- Two qubit matrices agree when their four entries agree. -/
theorem qubitMatrix_ext {A B : QubitMatrix} (h00 : A 0 0 = B 0 0) (h01 : A 0 1 = B 0 1)
    (h10 : A 1 0 = B 1 0) (h11 : A 1 1 = B 1 1) : A = B := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact h00
  · exact h01
  · exact h10
  · exact h11

section Generator

/-- The weighted two-jump generator with zero Hamiltonian. Rate `a` weights
the jump `E_10` (population `0 -> 1`) and rate `b` weights `E_01`. -/
noncomputable def generator (a b : ℝ) : QubitMatrix →ₗ[ℂ] QubitMatrix :=
  (a : ℂ) • dissipatorLinearMap jumpZeroToOne + (b : ℂ) • dissipatorLinearMap jumpOneToZero

/-- The defining weighted formula of the generator. -/
theorem generator_apply (a b : ℝ) (X : QubitMatrix) :
    generator a b X =
      (a : ℂ) • dissipator jumpZeroToOne X + (b : ℂ) • dissipator jumpOneToZero X := rfl

/-- Entry `(0,0)`: population balance into basis state `0`. -/
theorem generator_apply_zero_zero (a b : ℝ) (X : QubitMatrix) :
    generator a b X 0 0 = -(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1 := by
  rw [generator_apply, dissipator_jumpZeroToOne_eq, dissipator_jumpOneToZero_eq]
  simp [basisProjector, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- Entry `(1,1)`: population balance into basis state `1`. -/
theorem generator_apply_one_one (a b : ℝ) (X : QubitMatrix) :
    generator a b X 1 1 = (a : ℂ) * X 0 0 - (b : ℂ) * X 1 1 := by
  rw [generator_apply, dissipator_jumpZeroToOne_eq, dissipator_jumpOneToZero_eq]
  simp [basisProjector, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- Entry `(0,1)`: the coherence is multiplied by `-(a + b) / 2`. This is an
algebraic identity for arbitrary real rates; decay is its physical reading for
nonnegative rates once time evolution is introduced. -/
theorem generator_apply_zero_one (a b : ℝ) (X : QubitMatrix) :
    generator a b X 0 1 = -(((a + b : ℝ) : ℂ) / 2) * X 0 1 := by
  rw [generator_apply, dissipator_jumpZeroToOne_eq, dissipator_jumpOneToZero_eq]
  simp [basisProjector, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- Entry `(1,0)`: the coherence is multiplied by `-(a + b) / 2`, for arbitrary
real rates, as in the `(0,1)` entry. -/
theorem generator_apply_one_zero (a b : ℝ) (X : QubitMatrix) :
    generator a b X 1 0 = -(((a + b : ℝ) : ℂ) / 2) * X 1 0 := by
  rw [generator_apply, dissipator_jumpZeroToOne_eq, dissipator_jumpOneToZero_eq]
  simp [basisProjector, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- The generator annihilates the trace for every rate pair and every matrix. -/
theorem generator_trace (a b : ℝ) (X : QubitMatrix) : Matrix.trace (generator a b X) = 0 := by
  rw [generator_apply, Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul, dissipator_trace,
    dissipator_trace, smul_zero, smul_zero, add_zero]

/-- The generator preserves Hermiticity for every real rate pair. -/
theorem generator_isHermitian (a b : ℝ) {X : QubitMatrix} (hX : X.IsHermitian) :
    (generator a b X).IsHermitian := by
  rw [generator_apply]
  exact ((dissipator_isHermitian jumpZeroToOne hX).smul (isSelfAdjoint_ofReal a)).add
    ((dissipator_isHermitian jumpOneToZero hX).smul (isSelfAdjoint_ofReal b))

end Generator

section Stationary

/-- The stationary candidate `diagonalState (a / (a + b))`, that is
`diag(1 - a/(a+b), a/(a+b))`. Division is total, so this has a value even when
`a + b = 0`; the theorems below carry the hypotheses they need. -/
noncomputable def rhoStar (a b : ℝ) : QubitMatrix := diagonalState (a / (a + b))

private theorem one_sub_div_add (a b : ℝ) (h : a + b ≠ 0) : 1 - a / (a + b) = b / (a + b) := by
  field_simp
  ring

/-- Under a nonzero total rate the candidate is `diag(b/(a+b), a/(a+b))`. -/
theorem rhoStar_eq_diagonal (a b : ℝ) (h : a + b ≠ 0) :
    rhoStar a b = Matrix.diagonal ![((b / (a + b) : ℝ) : ℂ), ((a / (a + b) : ℝ) : ℂ)] := by
  rw [rhoStar, diagonalState, one_sub_div_add a b h]

theorem rhoStar_apply_zero_zero (a b : ℝ) (h : a + b ≠ 0) :
    rhoStar a b 0 0 = ((b / (a + b) : ℝ) : ℂ) := by
  rw [rhoStar_eq_diagonal a b h]
  simp

theorem rhoStar_apply_one_one (a b : ℝ) : rhoStar a b 1 1 = ((a / (a + b) : ℝ) : ℂ) := by
  simp only [rhoStar, diagonalState, Matrix.diagonal_apply_eq]
  rfl

theorem rhoStar_apply_zero_one (a b : ℝ) : rhoStar a b 0 1 = 0 := by
  simp [rhoStar, diagonalState]

theorem rhoStar_apply_one_zero (a b : ℝ) : rhoStar a b 1 0 = 0 := by
  simp [rhoStar, diagonalState]

/-- Stationarity of the candidate under a nonzero total rate. -/
theorem generator_rhoStar (a b : ℝ) (h : a + b ≠ 0) : generator a b (rhoStar a b) = 0 := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  apply qubitMatrix_ext
  · rw [generator_apply_zero_zero, rhoStar_apply_zero_zero a b h, rhoStar_apply_one_one,
      Matrix.zero_apply]
    push_cast
    field_simp
    ring
  · rw [generator_apply_zero_one, rhoStar_apply_zero_one, Matrix.zero_apply, mul_zero]
  · rw [generator_apply_one_zero, rhoStar_apply_one_zero, Matrix.zero_apply, mul_zero]
  · rw [generator_apply_one_one, rhoStar_apply_zero_zero a b h, rhoStar_apply_one_one,
      Matrix.zero_apply]
    push_cast
    field_simp
    ring

/-- Algebraic uniqueness: among all complex matrices of trace one, the candidate
is the only stationary one. Neither Hermiticity nor positivity of `X` is assumed. -/
theorem generator_eq_zero_iff_of_trace_eq_one (a b : ℝ) (h : a + b ≠ 0) (X : QubitMatrix)
    (hX : Matrix.trace X = 1) : generator a b X = 0 ↔ X = rhoStar a b := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  have hhalf : (((a + b : ℝ) : ℂ) / 2) ≠ 0 := by
    push_cast
    exact div_ne_zero hc two_ne_zero
  rw [Matrix.trace_fin_two] at hX
  constructor
  · intro hL
    have e00 : generator a b X 0 0 = 0 := by rw [hL]; rfl
    have e01 : generator a b X 0 1 = 0 := by rw [hL]; rfl
    have e10 : generator a b X 1 0 = 0 := by rw [hL]; rfl
    rw [generator_apply_zero_zero] at e00
    rw [generator_apply_zero_one, neg_mul, neg_eq_zero, mul_eq_zero] at e01
    rw [generator_apply_one_zero, neg_mul, neg_eq_zero, mul_eq_zero] at e10
    have h01 : X 0 1 = 0 := e01.resolve_left hhalf
    have h10 : X 1 0 = 0 := e10.resolve_left hhalf
    have h11 : X 1 1 = (a : ℂ) / ((a : ℂ) + (b : ℂ)) := by
      rw [eq_div_iff hc]
      linear_combination (a : ℂ) * hX + e00
    have h00 : X 0 0 = (b : ℂ) / ((a : ℂ) + (b : ℂ)) := by
      rw [eq_div_iff hc]
      linear_combination (b : ℂ) * hX - e00
    apply qubitMatrix_ext
    · rw [h00, rhoStar_apply_zero_zero a b h]
      push_cast
      ring
    · rw [h01, rhoStar_apply_zero_one]
    · rw [h10, rhoStar_apply_one_zero]
    · rw [h11, rhoStar_apply_one_one]
      push_cast
      ring
  · rintro rfl
    exact generator_rhoStar a b h

/-- With nonnegative rates and positive total rate the candidate is a density. -/
theorem rhoStar_isDensity (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a + b) :
    IsDensity (rhoStar a b) :=
  diagonalState_isDensity (a / (a + b)) (div_nonneg ha hab.le)
    ((div_le_one₀ hab).mpr (by linarith))

/-- For a density, stationarity is equivalent to being the candidate. Only a nonzero
total rate is needed; the density hypothesis supplies trace one. -/
theorem isDensity_generator_eq_zero_iff (a b : ℝ) (h : a + b ≠ 0) {ρ : QubitMatrix}
    (hρ : IsDensity ρ) : generator a b ρ = 0 ↔ ρ = rhoStar a b :=
  generator_eq_zero_iff_of_trace_eq_one a b h ρ hρ.2

/-- Unique existence of a stationary density under the physical rate hypotheses. -/
theorem existsUnique_stationary_density (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a + b) :
    ∃! ρ : QubitMatrix, IsDensity ρ ∧ generator a b ρ = 0 := by
  refine ⟨rhoStar a b, ⟨rhoStar_isDensity a b ha hb hab, generator_rhoStar a b hab.ne'⟩, ?_⟩
  rintro ρ ⟨hρ, hL⟩
  exact (isDensity_generator_eq_zero_iff a b hab.ne' hρ).mp hL

end Stationary

section Boundary

/-- Boundary case `a = 0`: the candidate is the projector onto basis state `0`. No
hypothesis on `b` is needed for this identity. -/
theorem rhoStar_zero_left (b : ℝ) : rhoStar 0 b = basisProjector 0 := by
  rw [rhoStar, zero_div, diagonalState_zero]

/-- Boundary case `a = 0`, `b > 0`: the unique stationary density is `basisProjector 0`. -/
theorem isDensity_generator_zero_left_eq_zero_iff (b : ℝ) (hb : 0 < b) {ρ : QubitMatrix}
    (hρ : IsDensity ρ) : generator 0 b ρ = 0 ↔ ρ = basisProjector 0 := by
  rw [← rhoStar_zero_left b]
  exact isDensity_generator_eq_zero_iff 0 b (by rw [zero_add]; exact hb.ne') hρ

/-- Boundary case `b = 0`, `a ≠ 0`: the candidate is the projector onto basis state `1`. -/
theorem rhoStar_zero_right (a : ℝ) (ha : a ≠ 0) : rhoStar a 0 = basisProjector 1 := by
  rw [rhoStar, add_zero, div_self ha, diagonalState_one]

/-- Boundary case `a > 0`, `b = 0`: the unique stationary density is `basisProjector 1`. -/
theorem isDensity_generator_zero_right_eq_zero_iff (a : ℝ) (ha : 0 < a) {ρ : QubitMatrix}
    (hρ : IsDensity ρ) : generator a 0 ρ = 0 ↔ ρ = basisProjector 1 := by
  rw [← rhoStar_zero_right a ha.ne']
  exact isDensity_generator_eq_zero_iff a 0 (by rw [add_zero]; exact ha.ne') hρ

/-- Boundary case `a = b = 0`: the generator vanishes on every matrix. -/
theorem generator_zero_zero (X : QubitMatrix) : generator 0 0 X = 0 := by
  rw [generator_apply]
  simp

/-- Boundary case `a = b = 0`: every density is stationary. -/
theorem generator_zero_zero_of_isDensity {ρ : QubitMatrix} (_hρ : IsDensity ρ) :
    generator 0 0 ρ = 0 :=
  generator_zero_zero ρ

/-- Boundary case `a = b = 0`: unique existence fails, witnessed by the two distinct
basis densities. -/
theorem not_existsUnique_stationary_density_zero_zero :
    ¬ ∃! ρ : QubitMatrix, IsDensity ρ ∧ generator 0 0 ρ = 0 := by
  rintro ⟨ρ, -, huniq⟩
  have h0 := huniq (basisProjector 0) ⟨basisProjector_isDensity 0, generator_zero_zero _⟩
  have h1 := huniq (basisProjector 1) ⟨basisProjector_isDensity 1, generator_zero_zero _⟩
  exact basisProjector_zero_ne_one (h0.trans h1.symm)

/-- Boundary case `a = b = r ≠ 0`: the candidate is the maximally mixed state. -/
theorem rhoStar_same (r : ℝ) (hr : r ≠ 0) : rhoStar r r = diagonalState (1 / 2) := by
  have h2 : r + r ≠ 0 := by
    intro h
    apply hr
    linarith
  unfold rhoStar
  congr 1
  field_simp
  ring

/-- Boundary case `a = b = r > 0`: the unique stationary density is the maximally mixed
state. No unequal-rate premise appears. -/
theorem isDensity_generator_same_eq_zero_iff (r : ℝ) (hr : 0 < r) {ρ : QubitMatrix}
    (hρ : IsDensity ρ) : generator r r ρ = 0 ↔ ρ = diagonalState (1 / 2) := by
  rw [← rhoStar_same r hr.ne']
  exact isDensity_generator_eq_zero_iff r r (by linarith) hρ

end Boundary

end FormalScience.OpenSystems
