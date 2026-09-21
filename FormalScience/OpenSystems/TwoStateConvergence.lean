import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.SpecialFunctions.Exp
import FormalScience.Stage0
import FormalScience.OpenSystems.Dissipator
import FormalScience.OpenSystems.TwoStateStationary
import FormalScience.OpenSystems.TwoStateEvolution
import FormalScience.Quantum.FiniteKraus
import FormalScience.OpenSystems.TwoStateKraus

/-!
# Quantitative two-state convergence

The Frobenius error estimate and long-time limits for the accepted flow
`evolution a b t`, with `gamma = a + b`. The named norm is

  `qubitFrobeniusNorm X = sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)`,

bridged to Mathlib's scoped Frobenius instance. For an arbitrary complex matrix
`X` write `tau = trace X` and `Y = X - tau • rhoStar a b`, the deviation of `X`
from the stationary projection in its own trace fiber. Under `gamma ≠ 0` the
centered flow has entries `e Y_00`, `e Y_11`, `c Y_01`, `c Y_10` with
`e = exp(-gamma t)`, `c = exp(-(gamma t)/2)`, so

  `F(Phi_t X - tau • rhoStar)^2 = e^2 (|Y_00|^2 + |Y_11|^2) + c^2 (|Y_01|^2 + |Y_10|^2)`,

and for `gamma > 0`, `t ≥ 0` the estimate `F(Phi_t X - tau • rhoStar) ≤ c F(Y)`
holds for every complex `X`. As `t → ∞` the scalar error `F(Phi_t X - tau • rhoStar)`
tends to `0`, and the matrix `Phi_t X` tends to `tau • rhoStar` in the canonical
matrix topology. Physical consumers combine this with the accepted density
preservation, and the rate boundaries reuse the accepted stationary identities.
At both rates zero the flow is the identity and no single matrix attracts every
density.

The `tau` factor is essential: the estimate is centered in a trace fiber and
asserts no unconditional uncentered Frobenius contraction `F(Phi_t X) ≤ F(X)`,
which is false in general. Nothing here concerns trace or diamond norms,
spectral gaps, or generic Perron-Frobenius theory.
-/

open scoped Matrix Topology
open FormalScience.Stage0 Filter

namespace FormalScience.OpenSystems

section Norm

/-- The Frobenius norm of a qubit matrix as an explicit real finite sum of squared complex
entry norms. -/
noncomputable def qubitFrobeniusNorm (X : QubitMatrix) : ℝ :=
  Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)

/-- The explicit finite-sum formula. -/
theorem qubitFrobeniusNorm_def (X : QubitMatrix) :
    qubitFrobeniusNorm X = Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2) := rfl

open scoped Matrix.Norms.Frobenius in
/-- Bridge to Mathlib's scoped Frobenius norm instance on matrices. -/
theorem qubitFrobeniusNorm_eq_norm (X : QubitMatrix) : qubitFrobeniusNorm X = ‖X‖ := by
  rw [Matrix.frobenius_norm_def, ← Real.sqrt_eq_rpow]
  simp only [Real.rpow_two, qubitFrobeniusNorm]

theorem qubitFrobeniusNorm_nonneg (X : QubitMatrix) : 0 ≤ qubitFrobeniusNorm X :=
  Real.sqrt_nonneg _

/-- Four-entry expansion of the squared norm. -/
theorem qubitFrobeniusNorm_sq (X : QubitMatrix) :
    qubitFrobeniusNorm X ^ 2 = ‖X 0 0‖ ^ 2 + ‖X 0 1‖ ^ 2 + ‖X 1 0‖ ^ 2 + ‖X 1 1‖ ^ 2 := by
  unfold qubitFrobeniusNorm
  rw [Real.sq_sqrt (by positivity)]
  simp only [Fin.sum_univ_two]
  ring

/-- Norm of a nonnegative real scalar times a complex number, squared. -/
private theorem norm_ofReal_mul_sq {r : ℝ} (hr : 0 ≤ r) (z : ℂ) :
    ‖(r : ℂ) * z‖ ^ 2 = r ^ 2 * ‖z‖ ^ 2 := by
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hr, mul_pow]

end Norm

section Scalars

theorem expFactor_pos (γ t : ℝ) : 0 < expFactor γ t := Real.exp_pos _

theorem expFactor_tendsto {γ : ℝ} (hγ : 0 < γ) : Tendsto (fun t => expFactor γ t) atTop (𝓝 0) := by
  simpa only [expFactor, neg_mul, Function.comp_def, id_eq] using
    Real.tendsto_exp_atBot.comp (tendsto_id.const_mul_atTop_of_neg (neg_lt_zero.mpr hγ))

theorem halfExpFactor_tendsto {γ : ℝ} (hγ : 0 < γ) :
    Tendsto (fun t => halfExpFactor γ t) atTop (𝓝 0) := by
  have h : -(γ / 2) < 0 := by linarith
  convert Real.tendsto_exp_atBot.comp (tendsto_id.const_mul_atTop_of_neg h) using 1
  ext t
  simp only [halfExpFactor, Function.comp_def, id_eq]
  congr 1
  ring

end Scalars

section Centered

variable {a b : ℝ}

/-- Centered entry `(0,0)`: the deviation from the stationary projection decays with `e`. -/
theorem evolution_sub_smul_rhoStar_apply_zero_zero (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    (evolution a b t X - Matrix.trace X • rhoStar a b) 0 0 =
      (expFactor (a + b) t : ℂ) * (X - Matrix.trace X • rhoStar a b) 0 0 := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul]
  rw [evolution_apply_zero_zero_of_ne_zero a b t h, rhoStar_apply_zero_zero a b h,
    Matrix.trace_fin_two]
  push_cast
  field_simp
  ring

/-- Centered entry `(1,1)`. -/
theorem evolution_sub_smul_rhoStar_apply_one_one (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    (evolution a b t X - Matrix.trace X • rhoStar a b) 1 1 =
      (expFactor (a + b) t : ℂ) * (X - Matrix.trace X • rhoStar a b) 1 1 := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul]
  rw [evolution_apply_one_one_of_ne_zero a b t h, rhoStar_apply_one_one, Matrix.trace_fin_two]
  push_cast
  field_simp
  ring

/-- Centered entry `(0,1)`: the coherence decays with `c`. The stationary projection has no
coherence, so this holds for every real rate pair. -/
theorem evolution_sub_smul_rhoStar_apply_zero_one (a b t : ℝ) (X : QubitMatrix) :
    (evolution a b t X - Matrix.trace X • rhoStar a b) 0 1 =
      (halfExpFactor (a + b) t : ℂ) * (X - Matrix.trace X • rhoStar a b) 0 1 := by
  simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul]
  rw [evolution_apply_zero_one, rhoStar_apply_zero_one, mul_zero, sub_zero, sub_zero]

/-- Centered entry `(1,0)`. -/
theorem evolution_sub_smul_rhoStar_apply_one_zero (a b t : ℝ) (X : QubitMatrix) :
    (evolution a b t X - Matrix.trace X • rhoStar a b) 1 0 =
      (halfExpFactor (a + b) t : ℂ) * (X - Matrix.trace X • rhoStar a b) 1 0 := by
  simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul]
  rw [evolution_apply_one_zero, rhoStar_apply_one_zero, mul_zero, sub_zero, sub_zero]

/-- The exact squared Frobenius error: diagonal energy decays at rate `2 gamma`, coherence
energy at rate `gamma`. Valid for every real `t` and every nonzero total rate. -/
theorem qubitFrobeniusNorm_sq_evolution_sub (h : a + b ≠ 0) (t : ℝ) (X : QubitMatrix) :
    qubitFrobeniusNorm (evolution a b t X - Matrix.trace X • rhoStar a b) ^ 2 =
      expFactor (a + b) t ^ 2 *
          (‖(X - Matrix.trace X • rhoStar a b) 0 0‖ ^ 2 +
            ‖(X - Matrix.trace X • rhoStar a b) 1 1‖ ^ 2) +
        halfExpFactor (a + b) t ^ 2 *
          (‖(X - Matrix.trace X • rhoStar a b) 0 1‖ ^ 2 +
            ‖(X - Matrix.trace X • rhoStar a b) 1 0‖ ^ 2) := by
  rw [qubitFrobeniusNorm_sq, evolution_sub_smul_rhoStar_apply_zero_zero h,
    evolution_sub_smul_rhoStar_apply_zero_one, evolution_sub_smul_rhoStar_apply_one_zero,
    evolution_sub_smul_rhoStar_apply_one_one h,
    norm_ofReal_mul_sq (expFactor_pos _ _).le, norm_ofReal_mul_sq (expFactor_pos _ _).le,
    norm_ofReal_mul_sq (halfExpFactor_pos _ _).le, norm_ofReal_mul_sq (halfExpFactor_pos _ _).le]
  ring

end Centered

section Estimate

variable {a b : ℝ}

/-- The quantitative estimate on every complex matrix: the Frobenius distance to the stationary
projection in the trace fiber contracts by `exp(-(gamma t)/2)`. Only `gamma > 0` and `t ≥ 0`
are assumed. -/
theorem qubitFrobeniusNorm_evolution_sub_le (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t)
    (X : QubitMatrix) :
    qubitFrobeniusNorm (evolution a b t X - Matrix.trace X • rhoStar a b) ≤
      halfExpFactor (a + b) t * qubitFrobeniusNorm (X - Matrix.trace X • rhoStar a b) := by
  have hc0 : 0 < halfExpFactor (a + b) t := halfExpFactor_pos _ _
  have hc1 : halfExpFactor (a + b) t ≤ 1 := halfExpFactor_le_one hγ.le ht
  have he : expFactor (a + b) t = halfExpFactor (a + b) t ^ 2 := (halfExpFactor_sq _ _).symm
  have hD : 0 ≤ ‖(X - Matrix.trace X • rhoStar a b) 0 0‖ ^ 2 +
      ‖(X - Matrix.trace X • rhoStar a b) 1 1‖ ^ 2 := by positivity
  have h4 : (halfExpFactor (a + b) t ^ 2) ^ 2 ≤ halfExpFactor (a + b) t ^ 2 := by
    rw [← pow_mul]
    exact pow_le_pow_of_le_one hc0.le hc1 (by norm_num)
  have hsq : qubitFrobeniusNorm (evolution a b t X - Matrix.trace X • rhoStar a b) ^ 2 ≤
      (halfExpFactor (a + b) t * qubitFrobeniusNorm (X - Matrix.trace X • rhoStar a b)) ^ 2 := by
    rw [qubitFrobeniusNorm_sq_evolution_sub hγ.ne' t X, he, mul_pow, qubitFrobeniusNorm_sq]
    have := mul_le_mul_of_nonneg_right h4 hD
    nlinarith [this]
  have h1 := Real.sqrt_le_sqrt hsq
  rwa [Real.sqrt_sq (qubitFrobeniusNorm_nonneg _),
    Real.sqrt_sq (mul_nonneg hc0.le (qubitFrobeniusNorm_nonneg _))] at h1

/-- Trace-one specialization: the distance to `rhoStar` itself contracts. -/
theorem qubitFrobeniusNorm_evolution_sub_rhoStar_le (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t)
    {X : QubitMatrix} (hX : Matrix.trace X = 1) :
    qubitFrobeniusNorm (evolution a b t X - rhoStar a b) ≤
      halfExpFactor (a + b) t * qubitFrobeniusNorm (X - rhoStar a b) := by
  have := qubitFrobeniusNorm_evolution_sub_le hγ t ht X
  rwa [hX, one_smul] at this

/-- Pairwise contraction on equal-trace inputs, by linearity. -/
theorem qubitFrobeniusNorm_evolution_sub_evolution_le (hγ : 0 < a + b) (t : ℝ) (ht : 0 ≤ t)
    {X Z : QubitMatrix} (hXZ : Matrix.trace X = Matrix.trace Z) :
    qubitFrobeniusNorm (evolution a b t X - evolution a b t Z) ≤
      halfExpFactor (a + b) t * qubitFrobeniusNorm (X - Z) := by
  have h0 : Matrix.trace (X - Z) = 0 := by rw [Matrix.trace_sub, hXZ, sub_self]
  have := qubitFrobeniusNorm_evolution_sub_le hγ t ht (X - Z)
  rwa [h0, zero_smul, sub_zero, sub_zero, map_sub] at this

end Estimate

section Limits

variable {a b : ℝ}

/-- The scalar Frobenius error tends to zero. -/
theorem tendsto_qubitFrobeniusNorm_evolution_sub (hγ : 0 < a + b) (X : QubitMatrix) :
    Tendsto (fun t : ℝ => qubitFrobeniusNorm (evolution a b t X - Matrix.trace X • rhoStar a b))
      atTop (𝓝 0) := by
  have hlim : Tendsto (fun t : ℝ => halfExpFactor (a + b) t *
      qubitFrobeniusNorm (X - Matrix.trace X • rhoStar a b)) atTop (𝓝 0) := by
    simpa using (halfExpFactor_tendsto hγ).mul_const
      (qubitFrobeniusNorm (X - Matrix.trace X • rhoStar a b))
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hlim ?_ ?_
  · exact Eventually.of_forall fun t => qubitFrobeniusNorm_nonneg _
  · filter_upwards [eventually_ge_atTop (0 : ℝ)] with t ht
    exact qubitFrobeniusNorm_evolution_sub_le hγ t ht X

/-- Entrywise limits assemble into a matrix limit on `Fin 2`, in the canonical matrix
topology. -/
theorem tendsto_qubitMatrix {φ : ℝ → QubitMatrix} {M : QubitMatrix} {l : Filter ℝ}
    (h00 : Tendsto (fun t => φ t 0 0) l (𝓝 (M 0 0)))
    (h01 : Tendsto (fun t => φ t 0 1) l (𝓝 (M 0 1)))
    (h10 : Tendsto (fun t => φ t 1 0) l (𝓝 (M 1 0)))
    (h11 : Tendsto (fun t => φ t 1 1) l (𝓝 (M 1 1))) : Tendsto φ l (𝓝 M) := by
  refine tendsto_pi_nhds.mpr fun i => tendsto_pi_nhds.mpr fun j => ?_
  fin_cases i <;> fin_cases j
  · exact h00
  · exact h01
  · exact h10
  · exact h11

/-- The matrix-valued limit: `Phi_t X` tends to `trace X • rhoStar` in the canonical matrix
topology, for every complex matrix `X`. -/
theorem tendsto_evolution (hγ : 0 < a + b) (X : QubitMatrix) :
    Tendsto (fun t : ℝ => evolution a b t X) atTop (𝓝 (Matrix.trace X • rhoStar a b)) := by
  have hE : Tendsto (fun t : ℝ => ((expFactor (a + b) t : ℝ) : ℂ)) atTop (𝓝 0) := by
    have := (Complex.continuous_ofReal.tendsto 0).comp (expFactor_tendsto hγ)
    simpa [Function.comp_def] using this
  have hF : Tendsto (fun t : ℝ => ((halfExpFactor (a + b) t : ℝ) : ℂ)) atTop (𝓝 0) := by
    have := (Complex.continuous_ofReal.tendsto 0).comp (halfExpFactor_tendsto hγ)
    simpa [Function.comp_def] using this
  apply tendsto_qubitMatrix
  · have e : (fun t : ℝ => evolution a b t X 0 0) = fun t =>
        (expFactor (a + b) t : ℂ) * X 0 0 +
          (1 - (expFactor (a + b) t : ℂ)) * ((b / (a + b) : ℝ) : ℂ) * Matrix.trace X := by
      funext t
      rw [evolution_apply_zero_zero_of_ne_zero a b t hγ.ne' X]
      push_cast
      ring
    rw [e, Matrix.smul_apply, smul_eq_mul, rhoStar_apply_zero_zero a b hγ.ne']
    have hlim : Tendsto (fun t : ℝ => (expFactor (a + b) t : ℂ) * X 0 0 +
        (1 - (expFactor (a + b) t : ℂ)) * ((b / (a + b) : ℝ) : ℂ) * Matrix.trace X) atTop
        (𝓝 ((0 : ℂ) * X 0 0 + (1 - 0) * ((b / (a + b) : ℝ) : ℂ) * Matrix.trace X)) :=
      (hE.mul_const (X 0 0)).add (((tendsto_const_nhds.sub hE).mul_const
        (((b / (a + b) : ℝ) : ℂ))).mul_const (Matrix.trace X))
    have hpt : (0 : ℂ) * X 0 0 + (1 - 0) * ((b / (a + b) : ℝ) : ℂ) * Matrix.trace X =
        Matrix.trace X * ((b / (a + b) : ℝ) : ℂ) := by ring
    rwa [hpt] at hlim
  · have e : (fun t : ℝ => evolution a b t X 0 1) = fun t =>
        (halfExpFactor (a + b) t : ℂ) * X 0 1 := funext fun t => evolution_apply_zero_one a b t X
    rw [e, Matrix.smul_apply, smul_eq_mul, rhoStar_apply_zero_one, mul_zero]
    simpa using hF.mul_const (X 0 1)
  · have e : (fun t : ℝ => evolution a b t X 1 0) = fun t =>
        (halfExpFactor (a + b) t : ℂ) * X 1 0 := funext fun t => evolution_apply_one_zero a b t X
    rw [e, Matrix.smul_apply, smul_eq_mul, rhoStar_apply_one_zero, mul_zero]
    simpa using hF.mul_const (X 1 0)
  · have e : (fun t : ℝ => evolution a b t X 1 1) = fun t =>
        (expFactor (a + b) t : ℂ) * X 1 1 +
          (1 - (expFactor (a + b) t : ℂ)) * ((a / (a + b) : ℝ) : ℂ) * Matrix.trace X := by
      funext t
      rw [evolution_apply_one_one_of_ne_zero a b t hγ.ne' X]
      push_cast
      ring
    rw [e, Matrix.smul_apply, smul_eq_mul, rhoStar_apply_one_one]
    have hlim : Tendsto (fun t : ℝ => (expFactor (a + b) t : ℂ) * X 1 1 +
        (1 - (expFactor (a + b) t : ℂ)) * ((a / (a + b) : ℝ) : ℂ) * Matrix.trace X) atTop
        (𝓝 ((0 : ℂ) * X 1 1 + (1 - 0) * ((a / (a + b) : ℝ) : ℂ) * Matrix.trace X)) :=
      (hE.mul_const (X 1 1)).add (((tendsto_const_nhds.sub hE).mul_const
        (((a / (a + b) : ℝ) : ℂ))).mul_const (Matrix.trace X))
    have hpt : (0 : ℂ) * X 1 1 + (1 - 0) * ((a / (a + b) : ℝ) : ℂ) * Matrix.trace X =
        Matrix.trace X * ((a / (a + b) : ℝ) : ℂ) := by ring
    rwa [hpt] at hlim

/-- Trace-one specialization of the matrix limit: the target is `rhoStar` itself. -/
theorem tendsto_evolution_of_trace_eq_one (hγ : 0 < a + b) {X : QubitMatrix}
    (hX : Matrix.trace X = 1) :
    Tendsto (fun t : ℝ => evolution a b t X) atTop (𝓝 (rhoStar a b)) := by
  have := tendsto_evolution hγ X
  rwa [hX, one_smul] at this

end Limits

section Physical

variable {a b : ℝ}

/-- Physical consumer: for a density input and physical rates, the evolved matrix is a density
and its Frobenius distance to `rhoStar` contracts by `exp(-(gamma t)/2)`. -/
theorem evolution_isDensity_and_qubitFrobeniusNorm_le (ha : 0 ≤ a) (hb : 0 ≤ b) (hγ : 0 < a + b)
    (t : ℝ) (ht : 0 ≤ t) {ρ : QubitMatrix} (hρ : IsDensity ρ) :
    IsDensity (evolution a b t ρ) ∧
      qubitFrobeniusNorm (evolution a b t ρ - rhoStar a b) ≤
        halfExpFactor (a + b) t * qubitFrobeniusNorm (ρ - rhoStar a b) :=
  ⟨evolution_isDensity ha hb ht hρ, qubitFrobeniusNorm_evolution_sub_rhoStar_le hγ t ht hρ.2⟩

/-- Physical limit: every density tends to the stationary density `rhoStar`, which is itself a
density by the accepted stationary milestone. -/
theorem tendsto_evolution_of_isDensity (ha : 0 ≤ a) (hb : 0 ≤ b) (hγ : 0 < a + b)
    {ρ : QubitMatrix} (hρ : IsDensity ρ) :
    IsDensity (rhoStar a b) ∧ Tendsto (fun t : ℝ => evolution a b t ρ) atTop (𝓝 (rhoStar a b)) :=
  ⟨rhoStar_isDensity a b ha hb hγ, tendsto_evolution_of_trace_eq_one hγ hρ.2⟩

end Physical

section Boundaries

/-- `a = 0`, `b > 0`: every trace-one matrix tends to `basisProjector 0`. -/
theorem tendsto_evolution_zero_left {b : ℝ} (hb : 0 < b) {X : QubitMatrix}
    (hX : Matrix.trace X = 1) :
    Tendsto (fun t : ℝ => evolution 0 b t X) atTop (𝓝 (basisProjector 0)) := by
  have := tendsto_evolution_of_trace_eq_one (a := 0) (b := b) (by linarith) hX
  rwa [rhoStar_zero_left] at this

/-- `a > 0`, `b = 0`: every trace-one matrix tends to `basisProjector 1`. -/
theorem tendsto_evolution_zero_right {a : ℝ} (ha : 0 < a) {X : QubitMatrix}
    (hX : Matrix.trace X = 1) :
    Tendsto (fun t : ℝ => evolution a 0 t X) atTop (𝓝 (basisProjector 1)) := by
  have := tendsto_evolution_of_trace_eq_one (a := a) (b := 0) (by linarith) hX
  rwa [rhoStar_zero_right a ha.ne'] at this

/-- `a = b = r > 0`: every trace-one matrix tends to the maximally mixed state. -/
theorem tendsto_evolution_same {r : ℝ} (hr : 0 < r) {X : QubitMatrix}
    (hX : Matrix.trace X = 1) :
    Tendsto (fun t : ℝ => evolution r r t X) atTop (𝓝 (diagonalState (1 / 2))) := by
  have := tendsto_evolution_of_trace_eq_one (a := r) (b := r) (by linarith) hX
  rwa [rhoStar_same r hr.ne'] at this

/-- `a = b = 0`: the flow is the identity, so no single matrix attracts every density. The two
distinct basis densities and uniqueness of limits give the contradiction. -/
theorem not_exists_common_limit_zero_zero :
    ¬ ∃ σ : QubitMatrix, ∀ ρ : QubitMatrix,
      IsDensity ρ → Tendsto (fun t : ℝ => evolution 0 0 t ρ) atTop (𝓝 σ) := by
  rintro ⟨σ, hσ⟩
  have hconst : ∀ ρ : QubitMatrix, (fun t : ℝ => evolution 0 0 t ρ) = fun _ => ρ := fun ρ =>
    funext fun t => by rw [evolution_zero_zero, LinearMap.id_apply]
  have h0 := hσ (basisProjector 0) (basisProjector_isDensity 0)
  have h1 := hσ (basisProjector 1) (basisProjector_isDensity 1)
  rw [hconst] at h0 h1
  have e0 : basisProjector 0 = σ := tendsto_nhds_unique tendsto_const_nhds h0
  have e1 : basisProjector 1 = σ := tendsto_nhds_unique tendsto_const_nhds h1
  exact basisProjector_zero_ne_one (e0.trans e1.symm)

end Boundaries

section Witness

/-- The coherence matrix unit `E_01` is an eigenvector of the flow with eigenvalue `c`, for all
real rates and times. -/
theorem evolution_jumpOneToZero (a b t : ℝ) :
    evolution a b t jumpOneToZero = (halfExpFactor (a + b) t : ℂ) • jumpOneToZero := by
  apply qubitMatrix_ext
  · rw [evolution_apply_zero_zero]; simp [jumpOneToZero, Matrix.single]
  · rw [evolution_apply_zero_one]; simp [jumpOneToZero, Matrix.single]
  · rw [evolution_apply_one_zero]; simp [jumpOneToZero, Matrix.single]
  · rw [evolution_apply_one_one]; simp [jumpOneToZero, Matrix.single]

theorem qubitFrobeniusNorm_jumpOneToZero : qubitFrobeniusNorm jumpOneToZero = 1 := by
  unfold qubitFrobeniusNorm
  simp [Fin.sum_univ_two, jumpOneToZero, Matrix.single]

/-- The witness saturates the coherence exponent: `F(Phi_t E_01) = exp(-(gamma t)/2)`. `E_01` is
not a density; this checks the prefactor and exponent, not density sharpness. -/
theorem qubitFrobeniusNorm_evolution_jumpOneToZero (a b t : ℝ) :
    qubitFrobeniusNorm (evolution a b t jumpOneToZero) = halfExpFactor (a + b) t := by
  rw [evolution_jumpOneToZero]
  unfold qubitFrobeniusNorm
  simp [Fin.sum_univ_two, jumpOneToZero, Matrix.single, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (halfExpFactor_pos (a + b) t), Real.sqrt_sq (halfExpFactor_pos (a + b) t).le]

end Witness

end FormalScience.OpenSystems
