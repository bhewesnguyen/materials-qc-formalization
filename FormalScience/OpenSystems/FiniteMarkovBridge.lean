import Mathlib.Data.Matrix.Basis
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Analysis.Complex.Order
import Mathlib.Basic.Complex.BigOperators
import Mathlib.Tactic.FinCases
import FormalScience.Stage0
import FormalScience.OpenSystems.Dissipator
import FormalScience.OpenSystems.TwoStateStationary

/-!
# Finite Markov generator bridge, zero Hamiltonian

A classical rate matrix on a finite state set `n` and its diagonal embedding
into the weighted matrix-unit dissipator generator. Conventions are
destination first: `q i j` is the jump rate from `j` to `i` for `i ≠ j`, the
supplied diagonal entries `q j j` are ignored everywhere (there are no
self-jumps), and

  `exitRate q j = ∑_{i ≠ j} q i j`,
  `rateMatrix q i j = q i j` for `i ≠ j`,  `rateMatrix q j j = -exitRate q j`,
  `markovGenerator q X = ∑_j ∑_{i ≠ j} q i j • D[E_ij] X`

with `D` the accepted dissipator and `E_ij = Matrix.single i j 1`. All
algebraic laws hold for arbitrary signed real rates; the physical premise
`∀ i j, i ≠ j → 0 ≤ q i j` appears only on the classical rate certificate.
The bridge is the exact identity `L_q(diag p) = diag(Q p)` on real vectors
with the coercion explicit, and its stationary consequence
`L_q(diag p) = 0 ↔ Q p = 0`; probability vectors give PSD trace-one diagonal
matrices. On `Fin 2` with `q = [[0, b], [a, 0]]` the bridge recovers the
accepted `generator a b`.

This is a generator result. It constructs no semigroup or matrix
exponential, proves no positivity of `Id + t • L_q`, and classifies only
diagonal stationary matrices. The Hamiltonian is zero; an arbitrary
Hamiltonian does not preserve the diagonal subspace.
-/

open scoped Matrix
open FormalScience.Stage0

namespace FormalScience.OpenSystems

section Classical

variable {n : Type*}

/-- The exit rate from state `j`: the total destination-first rate `q i j` out of `j` over
`i ≠ j`. The diagonal entry `q j j` is ignored. -/
def exitRate [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (j : n) : ℝ :=
  ∑ i, if i = j then 0 else q i j

/-- The defining finite sum of the exit rate, with the self-jump exclusion visible. -/
theorem exitRate_def [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (j : n) :
    exitRate q j = ∑ i, if i = j then 0 else q i j := rfl

/-- The classical rate matrix: `q i j` off the diagonal and `-exitRate q j` on it. Column `j`
carries the rates out of `j`. -/
def rateMatrix [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) : Matrix n n ℝ :=
  Matrix.of fun i j => if i = j then -exitRate q j else q i j

theorem rateMatrix_apply_of_ne [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) {i j : n}
    (h : i ≠ j) : rateMatrix q i j = q i j := by
  simp [rateMatrix, h]

theorem rateMatrix_apply_diag [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (j : n) :
    rateMatrix q j j = -exitRate q j := by
  simp [rateMatrix]

/-- Every column of the rate matrix sums to zero. -/
theorem rateMatrix_sum_col [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (j : n) :
    ∑ i, rateMatrix q i j = 0 := by
  have h : ∀ i, rateMatrix q i j =
      (if i = j then -exitRate q j else 0) + (if i = j then 0 else q i j) := by
    intro i
    simp only [rateMatrix, Matrix.of_apply]
    split_ifs <;> simp
  simp only [h, Finset.sum_add_distrib, Finset.sum_ite_eq', Finset.mem_univ, ite_true]
  rw [← exitRate_def]
  ring

/-- The classical action: inflow from the other states minus outflow. -/
theorem rateMatrix_mulVec_apply [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (p : n → ℝ)
    (i : n) :
    (rateMatrix q).mulVec p i = (∑ j, if i = j then 0 else q i j * p j) - exitRate q i * p i := by
  rw [Matrix.mulVec_apply_eq_sum]
  have h : ∀ j, rateMatrix q i j * p j =
      (if i = j then 0 else q i j * p j) + (if i = j then -(exitRate q j * p j) else 0) := by
    intro j
    simp only [rateMatrix, Matrix.of_apply]
    split_ifs <;> ring
  simp only [h, Finset.sum_add_distrib, Finset.sum_ite_eq, Finset.mem_univ, ite_true]
  ring

/-- Mass conservation for the infinitesimal action: the entries of `Q p` sum to zero. -/
theorem sum_rateMatrix_mulVec [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (p : n → ℝ) :
    ∑ i, (rateMatrix q).mulVec p i = 0 := by
  simp only [Matrix.mulVec_apply_eq_sum]
  rw [Finset.sum_comm]
  simp only [← Finset.sum_mul, rateMatrix_sum_col, zero_mul, Finset.sum_const_zero]

/-- Physical rates give nonnegative exit rates. -/
theorem exitRate_nonneg [Fintype n] [DecidableEq n] {q : Matrix n n ℝ}
    (hq : ∀ i j, i ≠ j → 0 ≤ q i j) (j : n) : 0 ≤ exitRate q j := by
  refine Finset.sum_nonneg fun i _ => ?_
  split_ifs with h
  · exact le_rfl
  · exact hq i j h

/-- Physical rates give nonnegative off-diagonal rate-matrix entries. -/
theorem rateMatrix_nonneg_of_ne [Fintype n] [DecidableEq n] {q : Matrix n n ℝ}
    (hq : ∀ i j, i ≠ j → 0 ≤ q i j) {i j : n} (h : i ≠ j) : 0 ≤ rateMatrix q i j := by
  rw [rateMatrix_apply_of_ne q h]
  exact hq i j h

end Classical

section MatrixUnit

variable {n : Type*}

/-- The dissipator of a matrix unit: `D[E_ij] X = X_jj E_ii - (1/2)(E_jj X + X E_jj)`. -/
theorem dissipator_single [Fintype n] [DecidableEq n] (i j : n) (X : Matrix n n ℂ) :
    dissipator (Matrix.single i j (1 : ℂ)) X =
      Matrix.single i i (X j j) -
        (1 / 2 : ℂ) • (Matrix.single j j 1 * X + X * Matrix.single j j 1) := by
  unfold dissipator
  rw [Matrix.conjTranspose_single, star_one, Matrix.single_mul_mul_single,
    Matrix.single_mul_single_same, Matrix.mul_assoc X, Matrix.single_mul_single_same]
  simp only [one_mul, mul_one]

/-- Entrywise form of `dissipator_single`. -/
private theorem dissipator_single_apply [Fintype n] [DecidableEq n] (i j k l : n)
    (X : Matrix n n ℂ) :
    dissipator (Matrix.single i j (1 : ℂ)) X k l =
      (if i = k ∧ i = l then X j j else 0) -
        (1 / 2 : ℂ) * ((if j = k then X k l else 0) + (if j = l then X k l else 0)) := by
  have h1 : (Matrix.single j j (1 : ℂ) * X) k l = if j = k then X k l else 0 := by
    by_cases hjk : j = k
    · subst hjk
      simp [Matrix.single_mul_apply_same]
    · simp [Ne.symm hjk, hjk]
  have h2 : (X * Matrix.single j j (1 : ℂ)) k l = if j = l then X k l else 0 := by
    by_cases hjl : j = l
    · subst hjl
      simp [Matrix.mul_single_apply_same]
    · simp [Ne.symm hjl, hjl]
  rw [dissipator_single]
  simp only [Matrix.sub_apply, Matrix.smul_apply, Matrix.add_apply, Matrix.single_apply,
    smul_eq_mul, h1, h2]

end MatrixUnit

section Quantum

variable {n : Type*}

/-- The zero-Hamiltonian Markov generator: the complex-linear sum over `j` and `i ≠ j` of
`q i j` times the accepted dissipator at the matrix unit `E_ij`. -/
noncomputable def markovGenerator [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) :
    Matrix n n ℂ →ₗ[ℂ] Matrix n n ℂ :=
  ∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipatorLinearMap (Matrix.single i j 1)

/-- The defining dissipator sum of the generator. -/
theorem markovGenerator_apply [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (X : Matrix n n ℂ) :
    markovGenerator q X =
      ∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipator (Matrix.single i j 1) X := by
  simp only [markovGenerator, LinearMap.sum_apply, LinearMap.smul_apply, dissipatorLinearMap_apply]

/-- Population entry: inflow from the other states minus outflow, for every complex `X` and every
signed real rate matrix. -/
theorem markovGenerator_apply_diag [Fintype n] [DecidableEq n] (q : Matrix n n ℝ)
    (X : Matrix n n ℂ) (i : n) :
    markovGenerator q X i i =
      (∑ j, if i = j then 0 else (q i j : ℂ) * X j j) - (exitRate q i : ℂ) * X i i := by
  rw [markovGenerator_apply, Matrix.sum_apply]
  simp only [Matrix.sum_apply, Matrix.smul_apply, dissipator_single_apply, smul_eq_mul, and_self]
  have h : ∀ j i', ((if i' = j then 0 else q i' j : ℝ) : ℂ) *
      ((if i' = i then X j j else 0) -
        (1 / 2 : ℂ) * ((if j = i then X i i else 0) + (if j = i then X i i else 0))) =
      (if i' = i then ((if i' = j then 0 else q i' j : ℝ) : ℂ) * X j j else 0) -
        (if j = i then ((if i' = j then 0 else q i' j : ℝ) : ℂ) * X i i else 0) := by
    intro j i'
    split_ifs <;> ring
  simp only [h, Finset.sum_sub_distrib, Finset.sum_ite_eq', Finset.mem_univ, ite_true,
    Finset.sum_ite_irrel, Finset.sum_const_zero]
  rw [exitRate_def, Complex.ofReal_sum, Finset.sum_mul]
  congr 1
  refine Finset.sum_congr rfl fun j _ => ?_
  split_ifs <;> simp

/-- Coherence entry: each off-diagonal entry is scaled by minus the average of the two exit rates.
This is a generator coefficient, not a trajectory. -/
theorem markovGenerator_apply_of_ne [Fintype n] [DecidableEq n] (q : Matrix n n ℝ)
    (X : Matrix n n ℂ) {i j : n} (hij : i ≠ j) :
    markovGenerator q X i j = -(((exitRate q i + exitRate q j) / 2 : ℝ) : ℂ) * X i j := by
  rw [markovGenerator_apply, Matrix.sum_apply]
  simp only [Matrix.sum_apply, Matrix.smul_apply, dissipator_single_apply, smul_eq_mul]
  have hne : ∀ i', ¬(i' = i ∧ i' = j) := fun i' ⟨h1, h2⟩ => hij (h1.symm.trans h2)
  simp only [hne, ite_false, zero_sub]
  have h : ∀ j' i', ((if i' = j' then 0 else q i' j' : ℝ) : ℂ) *
      -((1 / 2 : ℂ) * ((if j' = i then X i j else 0) + (if j' = j then X i j else 0))) =
      (if j' = i then -(1 / 2 : ℂ) * (((if i' = j' then 0 else q i' j' : ℝ) : ℂ) * X i j) else 0) +
        (if j' = j then -(1 / 2 : ℂ) * (((if i' = j' then 0 else q i' j' : ℝ) : ℂ) * X i j)
          else 0) := by
    intro j' i'
    split_ifs <;> ring
  simp only [h, Finset.sum_add_distrib, Finset.sum_ite_irrel, Finset.sum_const_zero,
    Finset.sum_ite_eq', Finset.mem_univ, ite_true]
  have hr : ∀ k, ((exitRate q k : ℝ) : ℂ) = ∑ i', ((if i' = k then 0 else q i' k : ℝ) : ℂ) := by
    intro k
    rw [exitRate_def, Complex.ofReal_sum]
  rw [Complex.ofReal_div, Complex.ofReal_add, hr i, hr j, Complex.ofReal_ofNat]
  simp only [← Finset.mul_sum, ← Finset.sum_mul]
  ring

/-- The generator annihilates the trace of every complex matrix, by the accepted dissipator law. -/
theorem markovGenerator_trace [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (X : Matrix n n ℂ) :
    Matrix.trace (markovGenerator q X) = 0 := by
  rw [markovGenerator_apply]
  simp only [Matrix.trace_sum, Matrix.trace_smul, dissipator_trace, smul_zero,
    Finset.sum_const_zero]

/-- The generator preserves Hermiticity for every signed real rate matrix, by the accepted
dissipator law and the self-adjointness of real scalars. -/
theorem markovGenerator_isHermitian [Fintype n] [DecidableEq n] (q : Matrix n n ℝ)
    {X : Matrix n n ℂ} (hX : X.IsHermitian) : (markovGenerator q X).IsHermitian := by
  rw [markovGenerator_apply]
  unfold Matrix.IsHermitian
  simp only [Matrix.conjTranspose_sum, Matrix.conjTranspose_smul, Complex.star_def,
    Complex.conj_ofReal, (dissipator_isHermitian _ hX).eq]

end Quantum

section Bridge

open scoped ComplexOrder

variable {n : Type*}

/-- The diagonal bridge: the quantum generator on a real diagonal matrix is the diagonal matrix
of the classical action, with the coercion explicit. -/
theorem markovGenerator_diagonal [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (p : n → ℝ) :
    markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) =
      Matrix.diagonal fun i => ((rateMatrix q).mulVec p i : ℂ) := by
  ext k l
  by_cases hkl : k = l
  · subst hkl
    rw [markovGenerator_apply_diag, Matrix.diagonal_apply_eq, Matrix.diagonal_apply_eq,
      rateMatrix_mulVec_apply]
    push_cast
    congr 1
    refine Finset.sum_congr rfl fun j _ => ?_
    split_ifs <;> simp
  · rw [markovGenerator_apply_of_ne q _ hkl, Matrix.diagonal_apply_ne _ hkl,
      Matrix.diagonal_apply_ne _ hkl, mul_zero]

/-- Diagonal stationarity is exactly the classical stationary equation. -/
theorem markovGenerator_diagonal_eq_zero_iff [Fintype n] [DecidableEq n] (q : Matrix n n ℝ)
    (p : n → ℝ) :
    markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) = 0 ↔ (rateMatrix q).mulVec p = 0 := by
  rw [markovGenerator_diagonal, Matrix.diagonal_eq_zero]
  constructor
  · intro h
    funext i
    have := congrFun h i
    simpa using this
  · intro h
    funext i
    simp [h]

/-- A probability vector embeds as a positive semidefinite diagonal matrix of complex trace one.
Stated directly for a generic finite index type; the accepted qubit `IsDensity` is unchanged. -/
theorem diagonal_ofReal_posSemidef_trace_one [Fintype n] [DecidableEq n] (p : n → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1) :
    (Matrix.diagonal fun i => (p i : ℂ)).PosSemidef ∧
      Matrix.trace (Matrix.diagonal fun i => (p i : ℂ)) = 1 := by
  refine ⟨Matrix.PosSemidef.diagonal ?_, ?_⟩
  · intro i
    exact Complex.zero_le_real.mpr (hp i)
  · rw [Matrix.trace_diagonal, ← Complex.ofReal_sum, hs, Complex.ofReal_one]

/-- A stationary probability vector gives a stationary density: positive semidefinite, trace one,
and annihilated by the generator. Rate nonnegativity is not needed for this implication. -/
theorem stationary_diagonal_density [Fintype n] [DecidableEq n] (q : Matrix n n ℝ) (p : n → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1) (hQ : (rateMatrix q).mulVec p = 0) :
    (Matrix.diagonal fun i => (p i : ℂ)).PosSemidef ∧
      Matrix.trace (Matrix.diagonal fun i => (p i : ℂ)) = 1 ∧
        markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) = 0 :=
  ⟨(diagonal_ofReal_posSemidef_trace_one p hp hs).1,
    (diagonal_ofReal_posSemidef_trace_one p hp hs).2,
    (markovGenerator_diagonal_eq_zero_iff q p).mpr hQ⟩

end Bridge

section Boundaries

variable {n : Type*}

theorem exitRate_zero [Fintype n] [DecidableEq n] (j : n) : exitRate (0 : Matrix n n ℝ) j = 0 := by
  simp [exitRate]

theorem rateMatrix_zero [Fintype n] [DecidableEq n] : rateMatrix (0 : Matrix n n ℝ) = 0 := by
  ext i j
  simp [rateMatrix, exitRate]

/-- Zero rates give the zero generator, as bundled linear maps. -/
theorem markovGenerator_zero [Fintype n] [DecidableEq n] :
    markovGenerator (0 : Matrix n n ℝ) = 0 := by
  ext X : 1
  simp [markovGenerator_apply]

/-- Diagonal rate entries are ignored: a diagonal rate matrix has zero exit rates. -/
theorem exitRate_diagonal [Fintype n] [DecidableEq n] (d : n → ℝ) (j : n) :
    exitRate (Matrix.diagonal d) j = 0 := by
  refine Finset.sum_eq_zero fun i _ => ?_
  split_ifs with h
  · rfl
  · exact Matrix.diagonal_apply_ne d h

theorem rateMatrix_diagonal [Fintype n] [DecidableEq n] (d : n → ℝ) :
    rateMatrix (Matrix.diagonal d) = 0 := by
  ext i j
  by_cases h : i = j
  · subst h
    rw [rateMatrix_apply_diag, exitRate_diagonal, neg_zero, Matrix.zero_apply]
  · rw [rateMatrix_apply_of_ne _ h, Matrix.diagonal_apply_ne d h, Matrix.zero_apply]

theorem markovGenerator_diagonal_rates [Fintype n] [DecidableEq n] (d : n → ℝ) :
    markovGenerator (Matrix.diagonal d) = 0 := by
  ext X : 1
  rw [markovGenerator_apply, LinearMap.zero_apply]
  refine Finset.sum_eq_zero fun j _ => Finset.sum_eq_zero fun i _ => ?_
  split_ifs with h
  · simp
  · rw [Matrix.diagonal_apply_ne d h, Complex.ofReal_zero, zero_smul]

end Boundaries

section TwoState

/-- The two-state rate matrix `[[0, b], [a, 0]]`: `a` is the `0 → 1` rate (`q 1 0`) and `b` the
`1 → 0` rate (`q 0 1`). -/
theorem rateMatrix_two (a b : ℝ) :
    rateMatrix (Matrix.of ![![0, b], ![a, 0]]) = Matrix.of ![![-a, b], ![a, -b]] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [rateMatrix, exitRate, Fin.sum_univ_two]

/-- The finite bridge specializes to the accepted two-state generator, as bundled linear maps. -/
theorem markovGenerator_two (a b : ℝ) :
    markovGenerator (Matrix.of ![![0, b], ![a, 0]]) = generator a b := by
  have h0 : exitRate (Matrix.of ![![0, b], ![a, 0]]) 0 = a := by
    simp [exitRate, Fin.sum_univ_two]
  have h1 : exitRate (Matrix.of ![![0, b], ![a, 0]]) 1 = b := by
    simp [exitRate, Fin.sum_univ_two]
  ext X : 1
  have hs0 : (∑ j : Fin 2, if (0 : Fin 2) = j then 0 else
      ((Matrix.of ![![0, b], ![a, 0]] : Matrix (Fin 2) (Fin 2) ℝ) 0 j : ℂ) * X j j) =
      (b : ℂ) * X 1 1 := by
    simp [Fin.sum_univ_two]
  have hs1 : (∑ j : Fin 2, if (1 : Fin 2) = j then 0 else
      ((Matrix.of ![![0, b], ![a, 0]] : Matrix (Fin 2) (Fin 2) ℝ) 1 j : ℂ) * X j j) =
      (a : ℂ) * X 0 0 := by
    simp [Fin.sum_univ_two]
  apply qubitMatrix_ext
  · rw [markovGenerator_apply_diag, generator_apply_zero_zero, hs0, h0]
    ring
  · rw [markovGenerator_apply_of_ne _ _ (by decide), generator_apply_zero_one, h0, h1]
    push_cast
    ring
  · rw [markovGenerator_apply_of_ne _ _ (by decide), generator_apply_one_zero, h0, h1]
    push_cast
    ring
  · rw [markovGenerator_apply_diag, generator_apply_one_one, hs1, h1]

end TwoState

end FormalScience.OpenSystems
