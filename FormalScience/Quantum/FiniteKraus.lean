import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.LinearAlgebra.Matrix.PosDef
import FormalScience.Stage0

/-!
# Finite Kraus maps: positivity and ancilla amplification

Generic facts about the Stage 0 finite Kraus sum `krausMap K X = ∑ j, K j * X * (K j)ᴴ`
for rectangular `K j : Matrix β α ℂ`:

* positive semidefiniteness is preserved, with no normalization hypothesis;
* `amplify m Φ` applies a matrix map `Φ` blockwise to a matrix on `Fin m × α`, the
  ancilla index first, and for a Kraus map this equals the Kraus map with the lifted
  operators `1 ⊗ₖ K j`;
* consequently a Kraus map stays positive after every finite ancilla extension;
* for a complex-linear `Φ`, amplification acts as the identity on the ancilla factor
  of a Kronecker product.

The positivity lemma, the amplifier, the lifting identity, and the all-ancilla
positivity theorem are adapted from the auditor's feasibility probe returned with the
evolution audit (`audits/evolution/v1/reference/KrausProbe.lean`); see D014. Nothing
here mentions a specific model or claims trace preservation.
-/

open scoped Matrix Kronecker ComplexOrder
open FormalScience.Stage0

namespace FormalScience.Quantum

variable {α β κ : Type*}

/-- Finite Kraus sums preserve positive semidefiniteness. No normalization is needed. -/
theorem krausMap_posSemidef [Fintype α] [Fintype β] [Fintype κ] (K : κ → Matrix β α ℂ)
    {X : Matrix α α ℂ} (hX : X.PosSemidef) : (krausMap K X).PosSemidef :=
  Matrix.posSemidef_sum Finset.univ fun j _ => hX.mul_mul_conjTranspose_same (K j)

/-- Blockwise amplification by an `m`-dimensional ancilla, ancilla index first: the block
`(r, s)` of the output is `Φ` applied to the block `(r, s)` of the input. -/
def amplify (m : ℕ) (Φ : Matrix α α ℂ → Matrix β β ℂ) (Y : Matrix (Fin m × α) (Fin m × α) ℂ) :
    Matrix (Fin m × β) (Fin m × β) ℂ :=
  Matrix.of fun r s => Φ (Matrix.of fun i j => Y (r.1, i) (s.1, j)) r.2 s.2

/-- The exact blockwise formula of the amplifier. -/
theorem amplify_apply (m : ℕ) (Φ : Matrix α α ℂ → Matrix β β ℂ)
    (Y : Matrix (Fin m × α) (Fin m × α) ℂ) (r s : Fin m) (i j : β) :
    amplify m Φ Y (r, i) (s, j) = Φ (Matrix.of fun u v => Y (r, u) (s, v)) i j := rfl

/-- Amplifying a Kraus map is the Kraus map of the lifted operators `1 ⊗ₖ K j`. This holds for
every input `Y`, entangled or not, with no positivity or normalization hypothesis. -/
theorem amplify_krausMap [Fintype α] [Fintype κ] (m : ℕ) (K : κ → Matrix β α ℂ)
    (Y : Matrix (Fin m × α) (Fin m × α) ℂ) :
    amplify m (krausMap K) Y = krausMap (fun j => (1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ K j) Y := by
  ext ⟨r, i⟩ ⟨s, j⟩
  simp only [amplify, krausMap, Matrix.sum_apply]
  apply Finset.sum_congr rfl
  intro c _
  simp_rw [Matrix.mul_apply, Matrix.conjTranspose_apply]
  simp only [Matrix.kroneckerMap, Matrix.of_apply, Fintype.sum_prod_type, Matrix.one_apply]
  simp only [ite_mul, one_mul, zero_mul, Finset.sum_ite_irrel, Finset.sum_const_zero,
    Finset.sum_ite_eq, Finset.mem_univ, ↓reduceIte, apply_ite]
  simp

/-- A finite Kraus map stays positive semidefinite after every finite ancilla extension. -/
theorem amplify_krausMap_posSemidef [Fintype α] [Fintype β] [Fintype κ] (m : ℕ)
    (K : κ → Matrix β α ℂ) {Y : Matrix (Fin m × α) (Fin m × α) ℂ} (hY : Y.PosSemidef) :
    (amplify m (krausMap K) Y).PosSemidef := by
  rw [amplify_krausMap]
  exact krausMap_posSemidef _ hY

/-- For a complex-linear `Φ`, amplification acts on a Kronecker product as the identity on the
ancilla factor. This checks the product ordering; it does not replace the all-input lifting
identity. -/
theorem amplify_kronecker (m : ℕ) (Φ : Matrix α α ℂ →ₗ[ℂ] Matrix β β ℂ)
    (A : Matrix (Fin m) (Fin m) ℂ) (X : Matrix α α ℂ) :
    amplify m Φ (A ⊗ₖ X) = A ⊗ₖ Φ X := by
  ext ⟨r, i⟩ ⟨s, j⟩
  have hblock : (Matrix.of fun u v => (A ⊗ₖ X) (r, u) (s, v)) = A r s • X := by
    ext u v
    simp [Matrix.kroneckerMap_apply]
  rw [amplify_apply, hblock, map_smul, Matrix.smul_apply, Matrix.kroneckerMap_apply, smul_eq_mul]

end FormalScience.Quantum
