import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Stage 0: finite-state and trace probes

This module fixes only the finite matrix representation needed by the first
open-systems milestone. It does not assert complete positivity, a Lindblad
semigroup, stationarity, or convergence.
-/

open scoped BigOperators ComplexOrder Matrix

namespace FormalScience.Stage0

/-- Complex matrices on the ordered basis `0, 1`. -/
abbrev QubitMatrix := Matrix (Fin 2) (Fin 2) ℂ

/-- The ordinary positive-semidefinite, trace-one density predicate. -/
def IsDensity (ρ : QubitMatrix) : Prop :=
  ρ.PosSemidef ∧ Matrix.trace ρ = 1

/-- The projector onto computational basis vector `i`. -/
def basisProjector (i : Fin 2) : QubitMatrix :=
  Matrix.diagonal fun j => if j = i then 1 else 0

/-- The chosen diagonal presentation is exactly the usual matrix unit. -/
theorem basisProjector_eq_single (i : Fin 2) :
    basisProjector i = Matrix.single i i (1 : ℂ) := by
  ext j k
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    norm_num [basisProjector, Matrix.single]

/-- Each computational basis projector is a density. -/
theorem basisProjector_isDensity (i : Fin 2) : IsDensity (basisProjector i) := by
  constructor
  · apply Matrix.PosSemidef.diagonal
    intro j
    change (0 : ℂ) ≤ (if j = i then 1 else 0)
    split_ifs <;> norm_num
  · simp [basisProjector]

/-- A diagonal state whose population of basis state `1` is `populationOne`. -/
def diagonalState (populationOne : ℝ) : QubitMatrix :=
  Matrix.diagonal ![((1 - populationOne : ℝ) : ℂ), (populationOne : ℂ)]

/-- All real diagonal mixtures in the closed probability interval are densities. -/
theorem diagonalState_isDensity (populationOne : ℝ)
    (h0 : 0 ≤ populationOne) (h1 : populationOne ≤ 1) :
    IsDensity (diagonalState populationOne) := by
  constructor
  · apply Matrix.PosSemidef.diagonal
    intro i
    fin_cases i
    · exact Complex.zero_le_real.mpr (sub_nonneg.mpr h1)
    · exact Complex.zero_le_real.mpr h0
  · simp [diagonalState, Matrix.trace, Fin.sum_univ_two]

/-- The zero-population endpoint is basis state `0`. -/
theorem diagonalState_zero : diagonalState 0 = basisProjector 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [diagonalState, basisProjector]

/-- The unit-population endpoint is basis state `1`. -/
theorem diagonalState_one : diagonalState 1 = basisProjector 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [diagonalState, basisProjector]

/-- A concrete nonvacuity witness: the density space has distinct elements. -/
theorem basisProjector_zero_ne_one : basisProjector 0 ≠ basisProjector 1 := by
  intro h
  have h00 := congrArg (fun M : QubitMatrix => M 0 0) h
  norm_num [basisProjector] at h00

section KrausTrace

variable {α β κ : Type*} [Fintype α] [Fintype β] [Fintype κ]

/-- The finite rectangular Kraus sum. No normalization is built into the definition. -/
def krausMap (K : κ → Matrix β α ℂ) (X : Matrix α α ℂ) : Matrix β β ℂ :=
  ∑ j, K j * X * (K j)ᴴ

/-- Cyclicity exposes the normalization matrix for an arbitrary finite Kraus sum. -/
theorem krausMap_trace (K : κ → Matrix β α ℂ) (X : Matrix α α ℂ) :
    Matrix.trace (krausMap K X) = Matrix.trace ((∑ j, (K j)ᴴ * K j) * X) := by
  unfold krausMap
  calc
    Matrix.trace (∑ j, K j * X * (K j)ᴴ) =
        ∑ j, Matrix.trace (K j * X * (K j)ᴴ) := Matrix.trace_sum _ _
    _ = ∑ j, Matrix.trace ((K j)ᴴ * K j * X) := by
      apply Finset.sum_congr rfl
      intro j _
      exact Matrix.trace_mul_cycle _ _ _
    _ = Matrix.trace (∑ j, (K j)ᴴ * K j * X) := (Matrix.trace_sum _ _).symm
    _ = Matrix.trace ((∑ j, (K j)ᴴ * K j) * X) := by rw [Finset.sum_mul]

/-- Kraus completeness implies trace preservation on all matrices, not only densities. -/
theorem krausMap_trace_preserving [DecidableEq α] (K : κ → Matrix β α ℂ)
    (hK : ∑ j, (K j)ᴴ * K j = 1) (X : Matrix α α ℂ) :
    Matrix.trace (krausMap K X) = Matrix.trace X := by
  rw [krausMap_trace, hK, Matrix.one_mul]

end KrausTrace

/-- A singleton identity Kraus family witnesses that the completeness premise is satisfiable. -/
theorem identityKraus_complete :
    (∑ _j : Fin 1, ((1 : QubitMatrix)ᴴ * 1)) = 1 := by
  simp

/-- The singleton identity Kraus family acts as the identity on every qubit matrix. -/
theorem identityKraus_apply (X : QubitMatrix) :
    krausMap (fun _ : Fin 1 => (1 : QubitMatrix)) X = X := by
  simp [krausMap]

end FormalScience.Stage0
