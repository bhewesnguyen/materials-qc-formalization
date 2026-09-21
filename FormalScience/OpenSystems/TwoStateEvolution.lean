import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Complex.RealDeriv
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Matrix.Normed
import FormalScience.Stage0
import FormalScience.OpenSystems.Dissipator
import FormalScience.OpenSystems.TwoStateStationary

/-!
# Explicit two-state evolution

An explicit complex-linear flow `evolution a b t` on every complex qubit
matrix, for arbitrary real rates `a` (jump `E_10`, population `0 -> 1`),
`b` (jump `E_01`, population `1 -> 0`), and arbitrary real time `t`, with
`gamma = a + b` and zero Hamiltonian. With

  `e(gamma,t) = exp(-gamma t)`, `f(gamma,t) = exp(-(gamma t)/2)`,
  `k(gamma,t) = t` if `gamma = 0`, else `(1 - exp(-gamma t)) / gamma`,

the entries are

  `Phi(X)_00 = X_00 + k * (-a X_00 + b X_11)`,  `Phi(X)_11 = X_11 + k * (a X_00 - b X_11)`,
  `Phi(X)_01 = f * X_01`,                         `Phi(X)_10 = f * X_10`.

Proved here: the four entry formulas, `Phi_0 = Id`, the semigroup law
`Phi_(t+u) = Phi_t ∘ Phi_u` for all real rates and times, trace
preservation, Hermiticity preservation for Hermitian input, the
matrix-valued derivative `HasDerivAt (fun s => Phi_s X) (L (Phi_t X)) t`,
the fixed point `rhoStar` at nonzero total rate, the trace-linear diagonal
formulas at nonzero total rate, the zero-total-rate identity
`Phi_t = Id + t L`, and the signed-rate witness `Phi_t(E_00) = diagonalState t`
at `a = 1`, `b = -1`.

The real-line extension is a mathematical convenience giving an ordinary
two-sided derivative. Nothing here claims that any `Phi_t` is a quantum
channel, positive, completely positive, or density preserving, nor anything
about convergence.
-/

open scoped Matrix
open FormalScience.Stage0

namespace FormalScience.OpenSystems

section Scalars

/-- `e(gamma, t) = exp(-gamma t)`. -/
noncomputable def expFactor (γ t : ℝ) : ℝ := Real.exp (-(γ * t))

/-- `f(gamma, t) = exp(-(gamma t) / 2)`, the coherence coefficient. -/
noncomputable def halfExpFactor (γ t : ℝ) : ℝ := Real.exp (-(γ * t) / 2)

/-- `k(gamma, t)`: `t` when `gamma = 0`, otherwise `(1 - exp(-gamma t)) / gamma`. The
zero branch is essential: signed cancellation `a = -b ≠ 0` does not make the generator
vanish, so `k` must still equal `t` there. -/
noncomputable def integratedExpFactor (γ t : ℝ) : ℝ :=
  if γ = 0 then t else (1 - Real.exp (-(γ * t))) / γ

theorem expFactor_zero (γ : ℝ) : expFactor γ 0 = 1 := by
  simp [expFactor]

theorem halfExpFactor_zero (γ : ℝ) : halfExpFactor γ 0 = 1 := by
  simp [halfExpFactor]

theorem integratedExpFactor_zero (γ : ℝ) : integratedExpFactor γ 0 = 0 := by
  unfold integratedExpFactor
  split_ifs <;> simp

theorem integratedExpFactor_of_eq_zero {γ : ℝ} (h : γ = 0) (t : ℝ) :
    integratedExpFactor γ t = t := by
  simp [integratedExpFactor, h]

theorem integratedExpFactor_of_ne_zero {γ : ℝ} (h : γ ≠ 0) (t : ℝ) :
    integratedExpFactor γ t = (1 - expFactor γ t) / γ := by
  simp [integratedExpFactor, expFactor, h]

theorem halfExpFactor_of_eq_zero {γ : ℝ} (h : γ = 0) (t : ℝ) : halfExpFactor γ t = 1 := by
  simp [halfExpFactor, h]

theorem expFactor_of_eq_zero {γ : ℝ} (h : γ = 0) (t : ℝ) : expFactor γ t = 1 := by
  simp [expFactor, h]

/-- `gamma * k = 1 - e`, in both branches. -/
theorem mul_integratedExpFactor (γ t : ℝ) :
    γ * integratedExpFactor γ t = 1 - expFactor γ t := by
  unfold integratedExpFactor expFactor
  split_ifs with h
  · simp [h]
  · field_simp

/-- The composition law of `k`. -/
theorem integratedExpFactor_add (γ t u : ℝ) :
    integratedExpFactor γ (t + u) =
      integratedExpFactor γ t + expFactor γ t * integratedExpFactor γ u := by
  unfold integratedExpFactor expFactor
  split_ifs with h
  · simp [h]
  · rw [mul_add, neg_add, Real.exp_add]
    field_simp
    ring

theorem halfExpFactor_add (γ t u : ℝ) :
    halfExpFactor γ (t + u) = halfExpFactor γ t * halfExpFactor γ u := by
  unfold halfExpFactor
  rw [← Real.exp_add]
  congr 1
  ring

theorem hasDerivAt_expFactor (γ t : ℝ) :
    HasDerivAt (fun s => expFactor γ s) (-γ * expFactor γ t) t := by
  have h1 : HasDerivAt (fun s : ℝ => -γ * s) (-γ) t := by
    simpa using (hasDerivAt_id' (x := t)).const_mul (-γ)
  have h2 := h1.exp
  simp only [expFactor, ← neg_mul]
  convert h2 using 1
  ring

theorem hasDerivAt_halfExpFactor (γ t : ℝ) :
    HasDerivAt (fun s => halfExpFactor γ s) (-(γ / 2) * halfExpFactor γ t) t := by
  have h1 : HasDerivAt (fun s : ℝ => -(γ / 2) * s) (-(γ / 2)) t := by
    simpa using (hasDerivAt_id' (x := t)).const_mul (-(γ / 2))
  have h2 := h1.exp
  have e : (fun s => halfExpFactor γ s) = fun s => Real.exp (-(γ / 2) * s) := by
    funext s
    simp only [halfExpFactor]
    ring_nf
  rw [e]
  convert h2 using 1
  simp only [halfExpFactor]
  ring_nf

theorem hasDerivAt_integratedExpFactor (γ t : ℝ) :
    HasDerivAt (fun s => integratedExpFactor γ s) (expFactor γ t) t := by
  by_cases h : γ = 0
  · subst h
    simp only [integratedExpFactor_of_eq_zero rfl, expFactor_of_eq_zero rfl]
    exact hasDerivAt_id' (x := t)
  · simp only [integratedExpFactor_of_ne_zero h]
    have := ((hasDerivAt_expFactor γ t).const_sub 1).div_const γ
    convert this using 1
    field_simp

end Scalars

section Map

/-- The underlying entry formula: `X_ii + k * L(X)_ii` on the diagonal and `f * X_ij` off
it. Public entry theorems below restate it with the generator entries expanded. -/
private noncomputable def evolutionFun (a b t : ℝ) (X : QubitMatrix) : QubitMatrix :=
  Matrix.of fun i j =>
    if i = j then X i j + (integratedExpFactor (a + b) t : ℂ) * generator a b X i j
    else (halfExpFactor (a + b) t : ℂ) * X i j

/-- The explicit evolution as a complex-linear map on all qubit matrices. -/
noncomputable def evolution (a b t : ℝ) : QubitMatrix →ₗ[ℂ] QubitMatrix where
  toFun := evolutionFun a b t
  map_add' X Y := by
    ext i j
    simp only [evolutionFun, Matrix.of_apply, Matrix.add_apply, map_add]
    split_ifs <;> ring
  map_smul' c X := by
    ext i j
    simp only [evolutionFun, Matrix.of_apply, Matrix.smul_apply, map_smul, smul_eq_mul,
      RingHom.id_apply]
    split_ifs <;> ring

/-- Diagonal entries: the input entry plus `k` times the generator's entry. -/
theorem evolution_apply_diag (a b t : ℝ) (X : QubitMatrix) (i : Fin 2) :
    evolution a b t X i i = X i i + (integratedExpFactor (a + b) t : ℂ) * generator a b X i i := by
  show evolutionFun a b t X i i = _
  simp [evolutionFun]

/-- Off-diagonal entries: `f` times the input entry. -/
theorem evolution_apply_offDiag (a b t : ℝ) (X : QubitMatrix) {i j : Fin 2} (h : i ≠ j) :
    evolution a b t X i j = (halfExpFactor (a + b) t : ℂ) * X i j := by
  show evolutionFun a b t X i j = _
  simp [evolutionFun, h]

theorem evolution_apply_zero_zero (a b t : ℝ) (X : QubitMatrix) :
    evolution a b t X 0 0 =
      X 0 0 + (integratedExpFactor (a + b) t : ℂ) * (-(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1) := by
  rw [evolution_apply_diag, generator_apply_zero_zero]

theorem evolution_apply_one_one (a b t : ℝ) (X : QubitMatrix) :
    evolution a b t X 1 1 =
      X 1 1 + (integratedExpFactor (a + b) t : ℂ) * ((a : ℂ) * X 0 0 - (b : ℂ) * X 1 1) := by
  rw [evolution_apply_diag, generator_apply_one_one]

theorem evolution_apply_zero_one (a b t : ℝ) (X : QubitMatrix) :
    evolution a b t X 0 1 = (halfExpFactor (a + b) t : ℂ) * X 0 1 :=
  evolution_apply_offDiag a b t X (by decide)

theorem evolution_apply_one_zero (a b t : ℝ) (X : QubitMatrix) :
    evolution a b t X 1 0 = (halfExpFactor (a + b) t : ℂ) * X 1 0 :=
  evolution_apply_offDiag a b t X (by decide)

end Map

section Laws

/-- Initial condition: `Phi_0 = Id`. -/
theorem evolution_zero (a b : ℝ) : evolution a b 0 = LinearMap.id := by
  apply LinearMap.ext
  intro X
  rw [LinearMap.id_apply]
  apply qubitMatrix_ext
  · rw [evolution_apply_zero_zero, integratedExpFactor_zero]; simp
  · rw [evolution_apply_zero_one, halfExpFactor_zero]; simp
  · rw [evolution_apply_one_zero, halfExpFactor_zero]; simp
  · rw [evolution_apply_one_one, integratedExpFactor_zero]; simp

/-- Semigroup law for all real rates and times: `Phi_(t+u) = Phi_t ∘ Phi_u`. -/
theorem evolution_add (a b t u : ℝ) :
    evolution a b (t + u) = (evolution a b t).comp (evolution a b u) := by
  apply LinearMap.ext
  intro X
  rw [LinearMap.comp_apply]
  have hk : ((integratedExpFactor (a + b) (t + u) : ℝ) : ℂ) =
      (integratedExpFactor (a + b) t : ℂ) +
        (expFactor (a + b) t : ℂ) * (integratedExpFactor (a + b) u : ℂ) := by
    rw [integratedExpFactor_add]; push_cast; ring
  have hf : ((halfExpFactor (a + b) (t + u) : ℝ) : ℂ) =
      (halfExpFactor (a + b) t : ℂ) * (halfExpFactor (a + b) u : ℂ) := by
    rw [halfExpFactor_add]; push_cast; ring
  have hγk : ((a + b : ℝ) : ℂ) * (integratedExpFactor (a + b) t : ℂ) =
      1 - (expFactor (a + b) t : ℂ) := by
    exact_mod_cast mul_integratedExpFactor (a + b) t
  push_cast at hγk
  apply qubitMatrix_ext
  · rw [evolution_apply_zero_zero, evolution_apply_zero_zero, evolution_apply_zero_zero,
      evolution_apply_one_one, hk]
    linear_combination
      (integratedExpFactor (a + b) u : ℂ) * (-(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1) * hγk
  · rw [evolution_apply_zero_one, evolution_apply_zero_one, evolution_apply_zero_one, hf]
    ring
  · rw [evolution_apply_one_zero, evolution_apply_one_zero, evolution_apply_one_zero, hf]
    ring
  · rw [evolution_apply_one_one, evolution_apply_one_one, evolution_apply_one_one,
      evolution_apply_zero_zero, hk]
    linear_combination
      (integratedExpFactor (a + b) u : ℂ) * ((a : ℂ) * X 0 0 - (b : ℂ) * X 1 1) * hγk

/-- Trace preservation for every matrix, every rate pair, and every time. -/
theorem evolution_trace (a b t : ℝ) (X : QubitMatrix) :
    Matrix.trace (evolution a b t X) = Matrix.trace X := by
  rw [Matrix.trace_fin_two, Matrix.trace_fin_two, evolution_apply_zero_zero,
    evolution_apply_one_one]
  ring

/-- Two qubit matrices are Hermitian when the diagonal is self-conjugate and the
off-diagonal entries are conjugate to each other. -/
theorem qubitMatrix_isHermitian_of_entries {A : QubitMatrix} (h00 : star (A 0 0) = A 0 0)
    (h11 : star (A 1 1) = A 1 1) (h10 : star (A 1 0) = A 0 1) : A.IsHermitian := by
  have h01 : star (A 0 1) = A 1 0 := by
    have := congrArg star h10
    rw [star_star] at this
    exact this.symm
  apply Matrix.IsHermitian.ext
  intro i j
  fin_cases i <;> fin_cases j
  · exact h00
  · exact h10
  · exact h01
  · exact h11

/-- Hermiticity preservation, for Hermitian input, at every real rate pair and time. -/
theorem evolution_isHermitian (a b t : ℝ) {X : QubitMatrix} (hX : X.IsHermitian) :
    (evolution a b t X).IsHermitian := by
  have h00 := hX.apply 0 0
  have h11 := hX.apply 1 1
  have h10 := hX.apply 0 1
  apply qubitMatrix_isHermitian_of_entries
  · rw [evolution_apply_zero_zero]
    simp only [star_add, star_mul', star_neg, Complex.star_def, Complex.conj_ofReal] at h00 h11 ⊢
    rw [h00, h11]
  · rw [evolution_apply_one_one]
    simp only [star_add, star_sub, star_mul', Complex.star_def, Complex.conj_ofReal] at h00 h11 ⊢
    rw [h00, h11]
  · rw [evolution_apply_one_zero, evolution_apply_zero_one]
    simp only [star_mul', Complex.star_def, Complex.conj_ofReal] at h10 ⊢
    rw [h10]

end Laws

section Derivative

attribute [local instance] Matrix.normedAddCommGroup Matrix.normedSpace

/-- Entrywise derivatives assemble into a matrix-valued derivative on `Fin 2`. The norm on
`QubitMatrix` is the entrywise supremum norm from Mathlib's `Matrix.normedAddCommGroup`;
in finite dimension the derivative does not depend on this choice. -/
theorem hasDerivAt_qubitMatrix {φ : ℝ → QubitMatrix} {φ' : QubitMatrix} {t : ℝ}
    (h00 : HasDerivAt (fun s => φ s 0 0) (φ' 0 0) t)
    (h01 : HasDerivAt (fun s => φ s 0 1) (φ' 0 1) t)
    (h10 : HasDerivAt (fun s => φ s 1 0) (φ' 1 0) t)
    (h11 : HasDerivAt (fun s => φ s 1 1) (φ' 1 1) t) : HasDerivAt φ φ' t := by
  refine hasDerivAt_pi.mpr fun i => hasDerivAt_pi.mpr fun j => ?_
  fin_cases i <;> fin_cases j
  · exact h00
  · exact h01
  · exact h10
  · exact h11

/-- The matrix-valued derivative: `d/ds Phi_s X = L (Phi_t X)` at every real time. -/
theorem hasDerivAt_evolution (a b t : ℝ) (X : QubitMatrix) :
    HasDerivAt (fun s => evolution a b s X) (generator a b (evolution a b t X)) t := by
  have hk : HasDerivAt (fun s => ((integratedExpFactor (a + b) s : ℝ) : ℂ))
      ((expFactor (a + b) t : ℝ) : ℂ) t :=
    (hasDerivAt_integratedExpFactor (a + b) t).ofReal_comp
  have hf : HasDerivAt (fun s => ((halfExpFactor (a + b) s : ℝ) : ℂ))
      ((-((a + b) / 2) * halfExpFactor (a + b) t : ℝ) : ℂ) t :=
    (hasDerivAt_halfExpFactor (a + b) t).ofReal_comp
  have hγk : ((a + b : ℝ) : ℂ) * (integratedExpFactor (a + b) t : ℂ) =
      1 - (expFactor (a + b) t : ℂ) := by
    exact_mod_cast mul_integratedExpFactor (a + b) t
  push_cast at hγk
  apply hasDerivAt_qubitMatrix
  · simp only [evolution_apply_zero_zero]
    rw [generator_apply_zero_zero, evolution_apply_zero_zero, evolution_apply_one_one]
    convert (hk.mul_const (-(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1)).const_add (X 0 0) using 1
    linear_combination (-(-(a : ℂ) * X 0 0 + (b : ℂ) * X 1 1)) * hγk
  · simp only [evolution_apply_zero_one]
    rw [generator_apply_zero_one, evolution_apply_zero_one]
    convert hf.mul_const (X 0 1) using 1
    push_cast
    ring
  · simp only [evolution_apply_one_zero]
    rw [generator_apply_one_zero, evolution_apply_one_zero]
    convert hf.mul_const (X 1 0) using 1
    push_cast
    ring
  · simp only [evolution_apply_one_one]
    rw [generator_apply_one_one, evolution_apply_zero_zero, evolution_apply_one_one]
    convert (hk.mul_const ((a : ℂ) * X 0 0 - (b : ℂ) * X 1 1)).const_add (X 1 1) using 1
    linear_combination (-((a : ℂ) * X 0 0 - (b : ℂ) * X 1 1)) * hγk

end Derivative

section FixedPoints

/-- Stationary matrices are fixed by the flow at every time, for every rate pair. -/
theorem evolution_apply_of_generator_eq_zero (a b t : ℝ) {X : QubitMatrix}
    (h : generator a b X = 0) : evolution a b t X = X := by
  have h01 : -(((a + b : ℝ) : ℂ) / 2) * X 0 1 = 0 := by
    rw [← generator_apply_zero_one, h]; rfl
  have h10 : -(((a + b : ℝ) : ℂ) / 2) * X 1 0 = 0 := by
    rw [← generator_apply_one_zero, h]; rfl
  have hoff : ∀ i j : Fin 2, i ≠ j → (halfExpFactor (a + b) t : ℂ) * X i j = X i j := by
    intro i j hij
    by_cases hγ : a + b = 0
    · rw [halfExpFactor_of_eq_zero hγ]; simp
    · have hc : -(((a + b : ℝ) : ℂ) / 2) ≠ 0 := by
        rw [neg_ne_zero]
        exact div_ne_zero (Complex.ofReal_ne_zero.mpr hγ) two_ne_zero
      have : X i j = 0 := by
        fin_cases i <;> fin_cases j
        · exact absurd rfl hij
        · exact (mul_eq_zero.mp h01).resolve_left hc
        · exact (mul_eq_zero.mp h10).resolve_left hc
        · exact absurd rfl hij
      rw [this, mul_zero]
  apply qubitMatrix_ext
  · rw [evolution_apply_diag, h, Matrix.zero_apply, mul_zero, add_zero]
  · rw [evolution_apply_offDiag a b t X (by decide), hoff 0 1 (by decide)]
  · rw [evolution_apply_offDiag a b t X (by decide), hoff 1 0 (by decide)]
  · rw [evolution_apply_diag, h, Matrix.zero_apply, mul_zero, add_zero]

/-- The stationary candidate is a fixed point at nonzero total rate. -/
theorem evolution_rhoStar (a b t : ℝ) (h : a + b ≠ 0) :
    evolution a b t (rhoStar a b) = rhoStar a b :=
  evolution_apply_of_generator_eq_zero a b t (generator_rhoStar a b h)

/-- Trace-linear population formula at nonzero total rate, entry `(0,0)`. The `trace X`
factor is what makes this a linear identity on all matrices. -/
theorem evolution_apply_zero_zero_of_ne_zero (a b t : ℝ) (h : a + b ≠ 0) (X : QubitMatrix) :
    evolution a b t X 0 0 =
      (expFactor (a + b) t : ℂ) * X 0 0 +
        (((1 - expFactor (a + b) t) * (b / (a + b)) : ℝ) : ℂ) * Matrix.trace X := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  rw [evolution_apply_zero_zero, integratedExpFactor_of_ne_zero h, Matrix.trace_fin_two]
  push_cast
  field_simp
  ring

/-- Trace-linear population formula at nonzero total rate, entry `(1,1)`. -/
theorem evolution_apply_one_one_of_ne_zero (a b t : ℝ) (h : a + b ≠ 0) (X : QubitMatrix) :
    evolution a b t X 1 1 =
      (expFactor (a + b) t : ℂ) * X 1 1 +
        (((1 - expFactor (a + b) t) * (a / (a + b)) : ℝ) : ℂ) * Matrix.trace X := by
  have hc : ((a : ℂ) + (b : ℂ)) ≠ 0 := by exact_mod_cast h
  rw [evolution_apply_one_one, integratedExpFactor_of_ne_zero h, Matrix.trace_fin_two]
  push_cast
  field_simp
  ring

end FixedPoints

section ZeroTotalRate

/-- At zero total rate the flow is exactly `Id + t L`, as bundled linear maps. This includes
signed cancellation, where `L` is not zero. -/
theorem evolution_eq_id_add_smul_generator (a b t : ℝ) (h : a + b = 0) :
    evolution a b t = LinearMap.id + (t : ℂ) • generator a b := by
  apply LinearMap.ext
  intro X
  rw [LinearMap.add_apply, LinearMap.smul_apply, LinearMap.id_apply]
  have hk : ((integratedExpFactor (a + b) t : ℝ) : ℂ) = (t : ℂ) := by
    rw [integratedExpFactor_of_eq_zero h]
  have hf : ((halfExpFactor (a + b) t : ℝ) : ℂ) = 1 := by
    rw [halfExpFactor_of_eq_zero h]; push_cast; rfl
  have hab : ((a + b : ℝ) : ℂ) = 0 := by rw [h]; push_cast; rfl
  apply qubitMatrix_ext
  · rw [evolution_apply_diag, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, hk]
  · rw [evolution_apply_zero_one, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul,
      generator_apply_zero_one, hf, hab]
    ring
  · rw [evolution_apply_one_zero, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul,
      generator_apply_one_zero, hf, hab]
    ring
  · rw [evolution_apply_diag, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, hk]

/-- With both rates zero the flow is the identity at every time. -/
theorem evolution_zero_zero (t : ℝ) : evolution 0 0 t = LinearMap.id := by
  rw [evolution_eq_id_add_smul_generator 0 0 t (by norm_num)]
  have hL : generator 0 0 = 0 := LinearMap.ext generator_zero_zero
  rw [hL, smul_zero, add_zero]

/-- Signed-rate witness: with `a = 1`, `b = -1` the total rate vanishes but the flow moves
`E_00` along `diagonalState t`. This is an algebraic identity for every real `t`, not a
density claim. -/
theorem evolution_one_neg_one_basisProjector_zero (t : ℝ) :
    evolution 1 (-1) t (basisProjector 0) = diagonalState t := by
  rw [evolution_eq_id_add_smul_generator 1 (-1) t (by norm_num), LinearMap.add_apply,
    LinearMap.smul_apply, LinearMap.id_apply]
  apply qubitMatrix_ext
  · rw [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, generator_apply_zero_zero]
    simp [basisProjector, diagonalState]
    ring
  · rw [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, generator_apply_zero_one]
    simp [basisProjector, diagonalState]
  · rw [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, generator_apply_one_zero]
    simp [basisProjector, diagonalState]
  · rw [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul, generator_apply_one_one]
    simp [basisProjector, diagonalState]

end ZeroTotalRate

section BoundaryFixedPoints

/-- `E_00` is stationary for `a = 0` and every real `b`. -/
theorem generator_zero_left_basisProjector_zero (b : ℝ) :
    generator 0 b (basisProjector 0) = 0 := by
  apply qubitMatrix_ext
  · rw [generator_apply_zero_zero]; simp [basisProjector]
  · rw [generator_apply_zero_one]; simp [basisProjector]
  · rw [generator_apply_one_zero]; simp [basisProjector]
  · rw [generator_apply_one_one]; simp [basisProjector]

/-- `E_11` is stationary for `b = 0` and every real `a`. -/
theorem generator_zero_right_basisProjector_one (a : ℝ) :
    generator a 0 (basisProjector 1) = 0 := by
  apply qubitMatrix_ext
  · rw [generator_apply_zero_zero]; simp [basisProjector]
  · rw [generator_apply_zero_one]; simp [basisProjector]
  · rw [generator_apply_one_zero]; simp [basisProjector]
  · rw [generator_apply_one_one]; simp [basisProjector]

/-- The maximally mixed state is stationary for equal rates, every real `r`. -/
theorem generator_same_diagonalState_half (r : ℝ) :
    generator r r (diagonalState (1 / 2)) = 0 := by
  apply qubitMatrix_ext
  · rw [generator_apply_zero_zero]; simp [diagonalState]; ring
  · rw [generator_apply_zero_one]; simp [diagonalState]
  · rw [generator_apply_one_zero]; simp [diagonalState]
  · rw [generator_apply_one_one]; simp [diagonalState]; ring

/-- One-zero-rate fixed state: `a = 0`, any real `b`, any real `t`. -/
theorem evolution_zero_left_basisProjector_zero (b t : ℝ) :
    evolution 0 b t (basisProjector 0) = basisProjector 0 :=
  evolution_apply_of_generator_eq_zero 0 b t (generator_zero_left_basisProjector_zero b)

/-- One-zero-rate fixed state: `b = 0`, any real `a`, any real `t`. -/
theorem evolution_zero_right_basisProjector_one (a t : ℝ) :
    evolution a 0 t (basisProjector 1) = basisProjector 1 :=
  evolution_apply_of_generator_eq_zero a 0 t (generator_zero_right_basisProjector_one a)

/-- Equal-rate fixed state: any real `r`, any real `t`. -/
theorem evolution_same_diagonalState_half (r t : ℝ) :
    evolution r r t (diagonalState (1 / 2)) = diagonalState (1 / 2) :=
  evolution_apply_of_generator_eq_zero r r t (generator_same_diagonalState_half r)

end BoundaryFixedPoints

end FormalScience.OpenSystems
