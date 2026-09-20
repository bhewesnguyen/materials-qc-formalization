import Mathlib.Data.Matrix.Basis
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Trace
import FormalScience.Stage0

/-!
# Finite dissipator algebra

This module defines the dissipator component of a GKSL generator for one
jump matrix `V` acting on finite complex matrices,

  `D[V](X) = V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)`,

and proves its three elementary algebraic laws: complex linearity in `X`,
trace annihilation, and preservation of Hermiticity. The jump matrix `V` is
arbitrary. It is not assumed Hermitian, unitary, or normalized, and `X` is
not assumed to be a density matrix. The results are then specialized to the
qubit basis jumps `E_10` and `E_01` of the two-state pilot.

The dissipator is a generator component. Nothing here claims that `D[V]` is
a positive or completely positive map, that it generates a semigroup, or
anything about stationary states or dynamics.
-/

open scoped Matrix

namespace FormalScience.OpenSystems

section General

variable {n : Type*} [Fintype n]

/-- The dissipator of jump matrix `V`, with the one-half factor as an explicit
complex scalar. Marked `noncomputable` only because complex division has no
executable implementation; this attribute does not affect the proofs. -/
noncomputable def dissipator (V X : Matrix n n ℂ) : Matrix n n ℂ :=
  V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)

/-- The dissipator is additive in its matrix argument. -/
theorem dissipator_add (V X Y : Matrix n n ℂ) :
    dissipator V (X + Y) = dissipator V X + dissipator V Y := by
  simp only [dissipator, mul_add, add_mul, smul_add]
  abel

/-- The dissipator is complex-homogeneous in its matrix argument. -/
theorem dissipator_smul (V : Matrix n n ℂ) (c : ℂ) (X : Matrix n n ℂ) :
    dissipator V (c • X) = c • dissipator V X := by
  simp only [dissipator, Matrix.mul_smul, Matrix.smul_mul, smul_add, smul_sub,
    smul_comm c (1 / 2 : ℂ)]

/-- The dissipator bundled as a complex-linear map on matrices. Its underlying
function is `dissipator V` itself, so the defining formula is available by `rfl`. -/
noncomputable def dissipatorLinearMap (V : Matrix n n ℂ) : Matrix n n ℂ →ₗ[ℂ] Matrix n n ℂ where
  toFun := dissipator V
  map_add' := dissipator_add V
  map_smul' := dissipator_smul V

@[simp]
theorem dissipatorLinearMap_apply (V X : Matrix n n ℂ) :
    dissipatorLinearMap V X = dissipator V X := rfl

/-- Every dissipator output is traceless, for every jump matrix and every input
matrix. No density, positivity, or normalization hypothesis is used. -/
theorem dissipator_trace (V X : Matrix n n ℂ) : Matrix.trace (dissipator V X) = 0 := by
  unfold dissipator
  rw [Matrix.trace_sub, Matrix.trace_smul, Matrix.trace_add, Matrix.trace_mul_cycle V X Vᴴ,
    Matrix.mul_assoc X Vᴴ V, Matrix.trace_mul_comm X (Vᴴ * V), smul_eq_mul]
  ring

/-- The anticommutator of two Hermitian matrices is Hermitian. -/
theorem isHermitian_anticommutator {A X : Matrix n n ℂ} (hA : A.IsHermitian)
    (hX : X.IsHermitian) : (A * X + X * A).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_add, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, hA.eq,
    hX.eq, add_comm]

/-- The scalar one half is real, hence self-adjoint in `ℂ`. -/
theorem isSelfAdjoint_half : IsSelfAdjoint (1 / 2 : ℂ) := by
  rw [IsSelfAdjoint, star_div₀, star_one, star_ofNat]

/-- Hermiticity is preserved: for every `V`, if `X` is Hermitian then so is
`D[V](X)`. The jump matrix `V` is not assumed Hermitian or unitary. -/
theorem dissipator_isHermitian (V : Matrix n n ℂ) {X : Matrix n n ℂ} (hX : X.IsHermitian) :
    (dissipator V X).IsHermitian := by
  have hVV : (Vᴴ * V).IsHermitian := Matrix.isHermitian_conjTranspose_mul_self V
  have hAnti : (Vᴴ * V * X + X * Vᴴ * V).IsHermitian := by
    have h := isHermitian_anticommutator hVV hX
    rwa [← Matrix.mul_assoc X Vᴴ V] at h
  exact (Matrix.isHermitian_mul_mul_conjTranspose V hX).sub (hAnti.smul isSelfAdjoint_half)

end General

section Qubit

open FormalScience.Stage0

/-- The jump matrix `E_10 = |1><0|`, moving population from basis state `0` to
basis state `1`. In the planned pilot it carries the rate `a`. -/
def jumpZeroToOne : QubitMatrix := Matrix.single 1 0 (1 : ℂ)

/-- The jump matrix `E_01 = |0><1|`, moving population from basis state `1` to
basis state `0`. In the planned pilot it carries the rate `b`. -/
def jumpOneToZero : QubitMatrix := Matrix.single 0 1 (1 : ℂ)

/-- The two basis jumps are adjoint to each other. -/
theorem jumpZeroToOne_conjTranspose : jumpZeroToOneᴴ = jumpOneToZero := by
  simp [jumpZeroToOne, jumpOneToZero, Matrix.conjTranspose_single]

/-- The two basis jumps are adjoint to each other. -/
theorem jumpOneToZero_conjTranspose : jumpOneToZeroᴴ = jumpZeroToOne := by
  simp [jumpZeroToOne, jumpOneToZero, Matrix.conjTranspose_single]

/-- `E_10ᴴ E_10 = E_00`: the normalization matrix of the upward jump is the
projector onto basis state `0`. -/
theorem jumpZeroToOne_conjTranspose_mul_self :
    jumpZeroToOneᴴ * jumpZeroToOne = basisProjector 0 := by
  rw [jumpZeroToOne_conjTranspose, jumpOneToZero, jumpZeroToOne, Matrix.single_mul_single_same,
    basisProjector_eq_single, mul_one]

/-- `E_01ᴴ E_01 = E_11`: the normalization matrix of the downward jump is the
projector onto basis state `1`. -/
theorem jumpOneToZero_conjTranspose_mul_self :
    jumpOneToZeroᴴ * jumpOneToZero = basisProjector 1 := by
  rw [jumpOneToZero_conjTranspose, jumpZeroToOne, jumpOneToZero, Matrix.single_mul_single_same,
    basisProjector_eq_single, mul_one]

/-- `E_10 X E_10ᴴ = X_00 E_11`: the upward jump transfers the `0` population to `1`. -/
theorem jumpZeroToOne_mul_mul_conjTranspose (X : QubitMatrix) :
    jumpZeroToOne * X * jumpZeroToOneᴴ = X 0 0 • basisProjector 1 := by
  rw [jumpZeroToOne_conjTranspose, jumpZeroToOne, jumpOneToZero, Matrix.single_mul_mul_single,
    basisProjector_eq_single, Matrix.smul_single, one_mul, mul_one, smul_eq_mul, mul_one]

/-- `E_01 X E_01ᴴ = X_11 E_00`: the downward jump transfers the `1` population to `0`. -/
theorem jumpOneToZero_mul_mul_conjTranspose (X : QubitMatrix) :
    jumpOneToZero * X * jumpOneToZeroᴴ = X 1 1 • basisProjector 0 := by
  rw [jumpOneToZero_conjTranspose, jumpOneToZero, jumpZeroToOne, Matrix.single_mul_mul_single,
    basisProjector_eq_single, Matrix.smul_single, one_mul, mul_one, smul_eq_mul, mul_one]

/-- Closed form of the upward-jump dissipator in terms of the basis projectors. -/
theorem dissipator_jumpZeroToOne_eq (X : QubitMatrix) :
    dissipator jumpZeroToOne X =
      X 0 0 • basisProjector 1 - (1 / 2 : ℂ) • (basisProjector 0 * X + X * basisProjector 0) := by
  unfold dissipator
  rw [jumpZeroToOne_mul_mul_conjTranspose, Matrix.mul_assoc X, jumpZeroToOne_conjTranspose_mul_self]

/-- Closed form of the downward-jump dissipator in terms of the basis projectors. -/
theorem dissipator_jumpOneToZero_eq (X : QubitMatrix) :
    dissipator jumpOneToZero X =
      X 1 1 • basisProjector 0 - (1 / 2 : ℂ) • (basisProjector 1 * X + X * basisProjector 1) := by
  unfold dissipator
  rw [jumpOneToZero_mul_mul_conjTranspose, Matrix.mul_assoc X, jumpOneToZero_conjTranspose_mul_self]

/-- The general trace law consumed at `V = E_10`. -/
theorem dissipator_jumpZeroToOne_trace (X : QubitMatrix) :
    Matrix.trace (dissipator jumpZeroToOne X) = 0 :=
  dissipator_trace jumpZeroToOne X

/-- The general trace law consumed at `V = E_01`. -/
theorem dissipator_jumpOneToZero_trace (X : QubitMatrix) :
    Matrix.trace (dissipator jumpOneToZero X) = 0 :=
  dissipator_trace jumpOneToZero X

/-- The general Hermiticity law consumed at `V = E_10`. -/
theorem dissipator_jumpZeroToOne_isHermitian {X : QubitMatrix} (hX : X.IsHermitian) :
    (dissipator jumpZeroToOne X).IsHermitian :=
  dissipator_isHermitian jumpZeroToOne hX

/-- The general Hermiticity law consumed at `V = E_01`. -/
theorem dissipator_jumpOneToZero_isHermitian {X : QubitMatrix} (hX : X.IsHermitian) :
    (dissipator jumpOneToZero X).IsHermitian :=
  dissipator_isHermitian jumpOneToZero hX

/-- Boundary witness: the upward jump is not Hermitian, so the general laws above
are used outside the Hermitian case. -/
theorem jumpZeroToOne_not_isHermitian : ¬ jumpZeroToOne.IsHermitian := by
  intro h
  have h10 := congrArg (fun M : QubitMatrix => M 1 0) h.eq
  simp [jumpZeroToOne, Matrix.single, Matrix.conjTranspose_apply] at h10

/-- Boundary witness: the downward jump is not Hermitian either. -/
theorem jumpOneToZero_not_isHermitian : ¬ jumpOneToZero.IsHermitian := by
  intro h
  have h01 := congrArg (fun M : QubitMatrix => M 0 1) h.eq
  simp [jumpOneToZero, Matrix.single, Matrix.conjTranspose_apply] at h01

/-- Convention witness: the upward jump moves the pure state `0` toward the pure
state `1`, with the expected signs. -/
theorem dissipator_jumpZeroToOne_basisProjector_zero :
    dissipator jumpZeroToOne (basisProjector 0) = basisProjector 1 - basisProjector 0 := by
  rw [dissipator_jumpZeroToOne_eq, basisProjector_eq_single 0, basisProjector_eq_single 1,
    Matrix.single_apply_same, Matrix.single_mul_single_same, one_smul, one_mul, ← two_smul ℂ,
    smul_smul]
  norm_num

/-- Convention witness: the downward jump moves the pure state `1` toward the pure
state `0`, with the expected signs. -/
theorem dissipator_jumpOneToZero_basisProjector_one :
    dissipator jumpOneToZero (basisProjector 1) = basisProjector 0 - basisProjector 1 := by
  rw [dissipator_jumpOneToZero_eq, basisProjector_eq_single 0, basisProjector_eq_single 1,
    Matrix.single_apply_same, Matrix.single_mul_single_same, one_smul, one_mul, ← two_smul ℂ,
    smul_smul]
  norm_num

end Qubit

end FormalScience.OpenSystems
