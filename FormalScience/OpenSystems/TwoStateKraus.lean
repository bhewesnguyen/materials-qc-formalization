import Mathlib.Analysis.Real.Sqrt
import FormalScience.Stage0
import FormalScience.OpenSystems.Dissipator
import FormalScience.OpenSystems.TwoStateStationary
import FormalScience.OpenSystems.TwoStateEvolution
import FormalScience.Quantum.FiniteKraus

/-!
# Four-Kraus certification of the two-state evolution

For nonnegative rates `a`, `b` and nonnegative time `t`, the accepted flow
`evolution a b t` is a trace-preserving finite Kraus map with four operators.
With `gamma = a + b`, `p = b / gamma` (total division, so `p = 0` at zero total
rate), `c = halfExpFactor gamma t = exp(-(gamma t)/2)`, and `d = sqrt(1 - c^2)`:

  `K0 = sqrt p • diag(1, c)`,        `K1 = (sqrt p * d) • E_01`,
  `K2 = sqrt (1 - p) • diag(c, 1)`,  `K3 = (sqrt (1 - p) * d) • E_10`.

Proved under `0 ≤ a`, `0 ≤ b`, `0 ≤ t`: completeness `∑ Kjᴴ Kj = 1`; the exact
representation `evolution a b t X = krausMap (evolutionKraus a b t) X` for every
complex matrix `X`; trace preservation through the Stage 0 Kraus theorem;
positivity and density preservation; the blockwise amplification identity with
the lifted operators `1 ⊗ₖ Kj`; positive semidefiniteness after every finite
ancilla extension (the complete-positivity endpoint); the tensor-action check;
and the boundary identities at both-zero rates, time zero, and each one-zero-rate
direction.

The certification domain is exactly `a, b, t ≥ 0`. Signed rates and negative
times remain valid inputs of the earlier linear flow and are not covered here.
No convergence, Choi or Stinespring equivalence, or generic GKSL claim is made.
-/

open scoped Matrix Kronecker ComplexOrder
open FormalScience.Stage0 FormalScience.Quantum

namespace FormalScience.OpenSystems

section Scalars

/-- Equilibrium population of basis state `0`: `p = b / (a + b)`, with total division. This is
not the population-one parameter of `diagonalState`. -/
noncomputable def equilibriumZero (a b : ℝ) : ℝ := b / (a + b)

/-- The jump amplitude `d = sqrt(1 - c^2)`, with `c = halfExpFactor γ t`. -/
noncomputable def jumpAmplitude (γ t : ℝ) : ℝ := Real.sqrt (1 - halfExpFactor γ t ^ 2)

theorem halfExpFactor_sq (γ t : ℝ) : halfExpFactor γ t ^ 2 = expFactor γ t := by
  unfold halfExpFactor expFactor
  rw [sq, ← Real.exp_add]
  congr 1
  ring

theorem halfExpFactor_pos (γ t : ℝ) : 0 < halfExpFactor γ t := Real.exp_pos _

theorem halfExpFactor_le_one {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) : halfExpFactor γ t ≤ 1 := by
  unfold halfExpFactor
  rw [Real.exp_le_one_iff]
  have := mul_nonneg hγ ht
  linarith

theorem one_sub_halfExpFactor_sq_nonneg {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) :
    0 ≤ 1 - halfExpFactor γ t ^ 2 :=
  sub_nonneg.mpr (pow_le_one₀ (halfExpFactor_pos γ t).le (halfExpFactor_le_one hγ ht))

theorem jumpAmplitude_sq {γ t : ℝ} (hγ : 0 ≤ γ) (ht : 0 ≤ t) :
    jumpAmplitude γ t ^ 2 = 1 - halfExpFactor γ t ^ 2 :=
  Real.sq_sqrt (one_sub_halfExpFactor_sq_nonneg hγ ht)

theorem equilibriumZero_nonneg {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ equilibriumZero a b :=
  div_nonneg hb (add_nonneg ha hb)

theorem equilibriumZero_le_one {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) : equilibriumZero a b ≤ 1 := by
  unfold equilibriumZero
  rcases (add_nonneg ha hb).lt_or_eq with h | h
  · exact (div_le_one h).mpr (by linarith)
  · rw [← h, div_zero]
    exact zero_le_one

theorem one_sub_equilibriumZero {a b : ℝ} (h : a + b ≠ 0) :
    1 - equilibriumZero a b = a / (a + b) := by
  unfold equilibriumZero
  field_simp
  ring

theorem equilibriumZero_of_add_eq_zero {a b : ℝ} (h : a + b = 0) : equilibriumZero a b = 0 := by
  simp [equilibriumZero, h]

/-- With nonnegative rates, zero total rate forces both rates to vanish. -/
theorem eq_zero_of_add_eq_zero {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (h : a + b = 0) :
    a = 0 ∧ b = 0 :=
  ⟨by linarith, by linarith⟩

end Scalars

section Family

/-- The four Kraus operators of the two-state evolution. -/
noncomputable def evolutionKraus (a b t : ℝ) : Fin 4 → QubitMatrix :=
  ![(Real.sqrt (equilibriumZero a b) : ℂ) • Matrix.diagonal ![1, (halfExpFactor (a + b) t : ℂ)],
    (Real.sqrt (equilibriumZero a b) * jumpAmplitude (a + b) t : ℂ) • jumpOneToZero,
    (Real.sqrt (1 - equilibriumZero a b) : ℂ) •
      Matrix.diagonal ![(halfExpFactor (a + b) t : ℂ), 1],
    (Real.sqrt (1 - equilibriumZero a b) * jumpAmplitude (a + b) t : ℂ) • jumpZeroToOne]

theorem evolutionKraus_apply_zero (a b t : ℝ) :
    evolutionKraus a b t 0 =
      (Real.sqrt (equilibriumZero a b) : ℂ) •
        Matrix.diagonal ![1, (halfExpFactor (a + b) t : ℂ)] := rfl

theorem evolutionKraus_apply_one (a b t : ℝ) :
    evolutionKraus a b t 1 =
      (Real.sqrt (equilibriumZero a b) * jumpAmplitude (a + b) t : ℂ) • jumpOneToZero := rfl

theorem evolutionKraus_apply_two (a b t : ℝ) :
    evolutionKraus a b t 2 =
      (Real.sqrt (1 - equilibriumZero a b) : ℂ) •
        Matrix.diagonal ![(halfExpFactor (a + b) t : ℂ), 1] := rfl

theorem evolutionKraus_apply_three (a b t : ℝ) :
    evolutionKraus a b t 3 =
      (Real.sqrt (1 - equilibriumZero a b) * jumpAmplitude (a + b) t : ℂ) • jumpZeroToOne := rfl

end Family

section Certificate

variable {a b t : ℝ}

/-- The three square-root identities in complex form, packaged for the entry calculations. -/
private theorem sqrt_facts (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) :
    ((Real.sqrt (equilibriumZero a b) : ℝ) : ℂ) * (Real.sqrt (equilibriumZero a b) : ℂ) =
        (equilibriumZero a b : ℂ) ∧
      ((Real.sqrt (1 - equilibriumZero a b) : ℝ) : ℂ) *
          (Real.sqrt (1 - equilibriumZero a b) : ℂ) = 1 - (equilibriumZero a b : ℂ) ∧
      ((jumpAmplitude (a + b) t : ℝ) : ℂ) * (jumpAmplitude (a + b) t : ℂ) =
        1 - (halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) t : ℂ) := by
  refine ⟨?_, ?_, ?_⟩
  · rw [← Complex.ofReal_mul, Real.mul_self_sqrt (equilibriumZero_nonneg ha hb)]
  · rw [← Complex.ofReal_mul, Real.mul_self_sqrt (sub_nonneg.mpr (equilibriumZero_le_one ha hb))]
    push_cast
    rfl
  · rw [← Complex.ofReal_mul, ← sq, jumpAmplitude_sq (add_nonneg ha hb) ht]
    push_cast
    ring

/-- Completeness of the family: `∑ Kjᴴ Kj = 1`, including at zero total rate. -/
theorem evolutionKraus_complete (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) :
    ∑ j, (evolutionKraus a b t j)ᴴ * evolutionKraus a b t j = 1 := by
  obtain ⟨hsp, hsq, hd⟩ := sqrt_facts ha hb ht
  apply qubitMatrix_ext
  · simp [Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero, jumpZeroToOne,
      Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
    linear_combination hsp +
      ((halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) t : ℂ) +
        (jumpAmplitude (a + b) t : ℂ) * (jumpAmplitude (a + b) t : ℂ)) * hsq +
      (1 - (equilibriumZero a b : ℂ)) * hd
  · simp [Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero, jumpZeroToOne,
      Matrix.single, Matrix.diagonal]
  · simp [Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero, jumpZeroToOne,
      Matrix.single, Matrix.diagonal]
  · simp [Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero, jumpZeroToOne,
      Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
    linear_combination
      ((halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) t : ℂ) +
        (jumpAmplitude (a + b) t : ℂ) * (jumpAmplitude (a + b) t : ℂ)) * hsp +
      hsq + (equilibriumZero a b : ℂ) * hd

/-- Entry `(0,0)` of the Kraus sum: `(p + (1-p) c^2) X_00 + p (1 - c^2) X_11`. -/
theorem krausMap_evolutionKraus_apply_zero_zero (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t)
    (X : QubitMatrix) :
    krausMap (evolutionKraus a b t) X 0 0 =
      ((equilibriumZero a b + (1 - equilibriumZero a b) * halfExpFactor (a + b) t ^ 2 : ℝ) : ℂ) *
          X 0 0 +
        ((equilibriumZero a b * (1 - halfExpFactor (a + b) t ^ 2) : ℝ) : ℂ) * X 1 1 := by
  obtain ⟨hsp, hsq, hd⟩ := sqrt_facts ha hb ht
  simp [krausMap, Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero,
    jumpZeroToOne, Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
  linear_combination
    (X 0 0 + (jumpAmplitude (a + b) t : ℂ) * (jumpAmplitude (a + b) t : ℂ) * X 1 1) * hsp +
      ((halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) t : ℂ) * X 0 0) * hsq +
      ((equilibriumZero a b : ℂ) * X 1 1) * hd

/-- Entry `(1,1)` of the Kraus sum: `(1-p)(1 - c^2) X_00 + ((1-p) + p c^2) X_11`. -/
theorem krausMap_evolutionKraus_apply_one_one (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t)
    (X : QubitMatrix) :
    krausMap (evolutionKraus a b t) X 1 1 =
      (((1 - equilibriumZero a b) * (1 - halfExpFactor (a + b) t ^ 2) : ℝ) : ℂ) * X 0 0 +
        (((1 - equilibriumZero a b) + equilibriumZero a b * halfExpFactor (a + b) t ^ 2 : ℝ) : ℂ) *
          X 1 1 := by
  obtain ⟨hsp, hsq, hd⟩ := sqrt_facts ha hb ht
  simp [krausMap, Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero,
    jumpZeroToOne, Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
  linear_combination
    ((jumpAmplitude (a + b) t : ℂ) * (jumpAmplitude (a + b) t : ℂ) * X 0 0 + X 1 1) * hsq +
      ((1 - (equilibriumZero a b : ℂ)) * X 0 0) * hd +
      ((halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) t : ℂ) * X 1 1) * hsp

/-- Entry `(0,1)` of the Kraus sum: `c X_01`. -/
theorem krausMap_evolutionKraus_apply_zero_one (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t)
    (X : QubitMatrix) :
    krausMap (evolutionKraus a b t) X 0 1 = (halfExpFactor (a + b) t : ℂ) * X 0 1 := by
  obtain ⟨hsp, hsq, -⟩ := sqrt_facts ha hb ht
  simp [krausMap, Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero,
    jumpZeroToOne, Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
  linear_combination ((halfExpFactor (a + b) t : ℂ) * X 0 1) * hsp +
    ((halfExpFactor (a + b) t : ℂ) * X 0 1) * hsq

/-- Entry `(1,0)` of the Kraus sum: `c X_10`. -/
theorem krausMap_evolutionKraus_apply_one_zero (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t)
    (X : QubitMatrix) :
    krausMap (evolutionKraus a b t) X 1 0 = (halfExpFactor (a + b) t : ℂ) * X 1 0 := by
  obtain ⟨hsp, hsq, -⟩ := sqrt_facts ha hb ht
  simp [krausMap, Fin.sum_univ_four, evolutionKraus, Matrix.mul_apply, jumpOneToZero,
    jumpZeroToOne, Matrix.single, Matrix.diagonal, Complex.conj_ofReal]
  linear_combination ((halfExpFactor (a + b) t : ℂ) * X 1 0) * hsp +
    ((halfExpFactor (a + b) t : ℂ) * X 1 0) * hsq

/-- The exact representation: on every complex qubit matrix, the accepted flow equals the
Kraus sum of the family, for nonnegative rates and time. No density, trace, Hermiticity, or
positivity premise on `X`. -/
theorem evolution_eq_krausMap (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    evolution a b t X = krausMap (evolutionKraus a b t) X := by
  by_cases hγ : a + b = 0
  · obtain ⟨rfl, rfl⟩ := eq_zero_of_add_eq_zero ha hb hγ
    rw [evolution_zero_zero, LinearMap.id_apply]
    have hp : equilibriumZero 0 0 = 0 := equilibriumZero_of_add_eq_zero (by norm_num)
    have hc : halfExpFactor (0 + 0) t = 1 := halfExpFactor_of_eq_zero (by norm_num) t
    apply qubitMatrix_ext
    · rw [krausMap_evolutionKraus_apply_zero_zero ha hb ht, hp, hc]; push_cast; ring
    · rw [krausMap_evolutionKraus_apply_zero_one ha hb ht, hc]; push_cast; ring
    · rw [krausMap_evolutionKraus_apply_one_zero ha hb ht, hc]; push_cast; ring
    · rw [krausMap_evolutionKraus_apply_one_one ha hb ht, hp, hc]; push_cast; ring
  · have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast hγ
    apply qubitMatrix_ext
    · rw [evolution_apply_zero_zero_of_ne_zero a b t hγ, krausMap_evolutionKraus_apply_zero_zero
        ha hb ht, ← halfExpFactor_sq, Matrix.trace_fin_two]
      unfold equilibriumZero
      push_cast
      field_simp
      ring
    · rw [evolution_apply_zero_one, krausMap_evolutionKraus_apply_zero_one ha hb ht]
    · rw [evolution_apply_one_zero, krausMap_evolutionKraus_apply_one_zero ha hb ht]
    · rw [evolution_apply_one_one_of_ne_zero a b t hγ, krausMap_evolutionKraus_apply_one_one
        ha hb ht, ← halfExpFactor_sq, Matrix.trace_fin_two]
      unfold equilibriumZero
      push_cast
      field_simp
      ring

/-- Trace preservation of the Kraus sum, as a direct consumer of completeness through the Stage 0
theorem. -/
theorem krausMap_evolutionKraus_trace (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (X : QubitMatrix) :
    Matrix.trace (krausMap (evolutionKraus a b t) X) = Matrix.trace X :=
  krausMap_trace_preserving (evolutionKraus a b t) (evolutionKraus_complete ha hb ht) X

/-- Positivity of the physical flow on positive semidefinite input. -/
theorem evolution_posSemidef (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : X.PosSemidef) : (evolution a b t X).PosSemidef := by
  rw [evolution_eq_krausMap ha hb ht]
  exact krausMap_posSemidef _ hX

/-- Density preservation of the physical flow. -/
theorem evolution_isDensity (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : IsDensity X) : IsDensity (evolution a b t X) :=
  ⟨evolution_posSemidef ha hb ht hX.1, by rw [evolution_trace]; exact hX.2⟩

end Certificate

section CompletePositivity

variable {a b t : ℝ}

/-- The amplified flow equals the Kraus sum of the lifted operators `1 ⊗ₖ Kj`, for every ancilla
dimension and every input, entangled or not. -/
theorem amplify_evolution_eq_krausMap (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (m : ℕ)
    (Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) ℂ) :
    amplify m (evolution a b t) Y =
      krausMap (fun j => (1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ evolutionKraus a b t j) Y := by
  have h : (⇑(evolution a b t) : QubitMatrix → QubitMatrix) = krausMap (evolutionKraus a b t) :=
    funext (evolution_eq_krausMap ha hb ht)
  rw [h, amplify_krausMap]

/-- Complete positivity in explicit finite-matrix form: after every finite ancilla extension the
physical flow maps positive semidefinite matrices to positive semidefinite matrices. -/
theorem amplify_evolution_posSemidef (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (m : ℕ)
    {Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) ℂ} (hY : Y.PosSemidef) :
    (amplify m (evolution a b t) Y).PosSemidef := by
  rw [amplify_evolution_eq_krausMap ha hb ht]
  exact krausMap_posSemidef _ hY

/-- Tensor-action check: the amplified flow acts as the identity on the ancilla factor. Valid for
arbitrary real rates and times, by linearity alone. -/
theorem amplify_evolution_kronecker (a b t : ℝ) (m : ℕ) (A : Matrix (Fin m) (Fin m) ℂ)
    (X : QubitMatrix) :
    amplify m (evolution a b t) (A ⊗ₖ X) = A ⊗ₖ evolution a b t X :=
  amplify_kronecker m (evolution a b t) A X

end CompletePositivity

section Boundaries

/-- The diagonal matrix `diag(1, 1)` is the identity. -/
private theorem diagonal_one_one : (Matrix.diagonal ![1, 1] : QubitMatrix) = 1 := by
  rw [← Matrix.diagonal_one]
  congr 1
  funext j
  fin_cases j <;> rfl

/-- The vector `![1, 1]` is the constant one function. -/
private theorem vec_one_one : (![1, 1] : Fin 2 → ℂ) = 1 := by
  funext j
  fin_cases j <;> rfl

/-- Both rates zero: `K2 = 1` and the other three operators vanish, for every real `t`. -/
theorem evolutionKraus_zero_zero (t : ℝ) : evolutionKraus 0 0 t = ![0, 0, 1, 0] := by
  have hp : equilibriumZero 0 0 = 0 := equilibriumZero_of_add_eq_zero (by norm_num)
  have hc : halfExpFactor 0 t = 1 := halfExpFactor_of_eq_zero rfl t
  have hd : jumpAmplitude 0 t = 0 := by
    unfold jumpAmplitude
    rw [hc]
    simp
  funext j
  fin_cases j
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp, hc, vec_one_one]
  · simp [evolutionKraus, hd]

/-- Both rates zero: the represented map is the identity, for nonnegative `t`. -/
theorem krausMap_evolutionKraus_zero_zero {t : ℝ} (ht : 0 ≤ t) (X : QubitMatrix) :
    krausMap (evolutionKraus 0 0 t) X = X := by
  rw [← evolution_eq_krausMap le_rfl le_rfl ht, evolution_zero_zero, LinearMap.id_apply]

/-- Time zero: `K0 = sqrt p • 1`, `K2 = sqrt (1-p) • 1`, `K1 = K3 = 0`, for every real rate pair. -/
theorem evolutionKraus_time_zero (a b : ℝ) :
    evolutionKraus a b 0 =
      ![(Real.sqrt (equilibriumZero a b) : ℂ) • 1, 0,
        (Real.sqrt (1 - equilibriumZero a b) : ℂ) • 1, 0] := by
  have hc : halfExpFactor (a + b) 0 = 1 := halfExpFactor_zero (a + b)
  have hd : jumpAmplitude (a + b) 0 = 0 := by
    unfold jumpAmplitude
    rw [hc]
    simp
  funext j
  fin_cases j
  · simp [evolutionKraus, hc, diagonal_one_one]
  · simp [evolutionKraus, hd]
  · simp [evolutionKraus, hc, diagonal_one_one]
  · simp [evolutionKraus, hd]

/-- Time zero with physical rates: the represented map is the identity. -/
theorem krausMap_evolutionKraus_time_zero {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (X : QubitMatrix) :
    krausMap (evolutionKraus a b 0) X = X := by
  rw [← evolution_eq_krausMap ha hb le_rfl, evolution_zero, LinearMap.id_apply]

/-- Rate `a = 0`, `b > 0`: `K0 = diag(1, c)`, `K1 = d • E_01`, `K2 = K3 = 0`. -/
theorem evolutionKraus_zero_left {b : ℝ} (hb : 0 < b) (t : ℝ) :
    evolutionKraus 0 b t =
      ![Matrix.diagonal ![1, (halfExpFactor (0 + b) t : ℂ)],
        (jumpAmplitude (0 + b) t : ℂ) • jumpOneToZero, 0, 0] := by
  have hp : equilibriumZero 0 b = 1 := by
    unfold equilibriumZero
    rw [zero_add, div_self hb.ne']
  funext j
  fin_cases j
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]

/-- Rate `b = 0`, any real `a`: `K0 = K1 = 0`, `K2 = diag(c, 1)`, `K3 = d • E_10`. This includes
`a = 0`, where total division gives `p = 0` consistently. -/
theorem evolutionKraus_zero_right (a t : ℝ) :
    evolutionKraus a 0 t =
      ![0, 0, Matrix.diagonal ![(halfExpFactor (a + 0) t : ℂ), 1],
        (jumpAmplitude (a + 0) t : ℂ) • jumpZeroToOne] := by
  have hp : equilibriumZero a 0 = 0 := by
    unfold equilibriumZero
    rw [zero_div]
  funext j
  fin_cases j
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]
  · simp [evolutionKraus, hp]

/-- Density preservation in the `a = 0` direction, for every nonnegative `b` and `t`. -/
theorem evolution_isDensity_zero_left {b t : ℝ} (hb : 0 ≤ b) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : IsDensity X) : IsDensity (evolution 0 b t X) :=
  evolution_isDensity le_rfl hb ht hX

/-- Density preservation in the `b = 0` direction, for every nonnegative `a` and `t`. -/
theorem evolution_isDensity_zero_right {a t : ℝ} (ha : 0 ≤ a) (ht : 0 ≤ t) {X : QubitMatrix}
    (hX : IsDensity X) : IsDensity (evolution a 0 t X) :=
  evolution_isDensity ha le_rfl ht hX

end Boundaries

end FormalScience.OpenSystems
