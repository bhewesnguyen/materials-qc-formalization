import FormalScience.Stage0
import Mathlib.LinearAlgebra.Matrix.Kronecker

open scoped Matrix Kronecker ComplexOrder
open FormalScience.Stage0

namespace AuditProbe

def amplify {α β : Type*} (m : ℕ)
    (Φ : Matrix α α ℂ → Matrix β β ℂ)
    (Y : Matrix (Fin m × α) (Fin m × α) ℂ) :
    Matrix (Fin m × β) (Fin m × β) ℂ :=
  Matrix.of fun r s => Φ (Matrix.of fun i j => Y (r.1, i) (s.1, j)) r.2 s.2

theorem krausMap_posSemidef {α β κ : Type*} [Fintype α] [Fintype β] [Fintype κ]
    (K : κ → Matrix β α ℂ) {X : Matrix α α ℂ} (hX : X.PosSemidef) :
    (krausMap K X).PosSemidef := by
  exact Matrix.posSemidef_sum Finset.univ (fun j _ => hX.mul_mul_conjTranspose_same (K j))

theorem amplify_krausMap {α β κ : Type*} [Fintype α] [Fintype β] [Fintype κ]
    (m : ℕ) (K : κ → Matrix β α ℂ)
    (Y : Matrix (Fin m × α) (Fin m × α) ℂ) :
    amplify m (krausMap K) Y =
      krausMap (fun j => (1 : Matrix (Fin m) (Fin m) ℂ) ⊗ₖ K j) Y := by
  ext ⟨r,i⟩ ⟨s,j⟩
  simp only [amplify, krausMap, Matrix.sum_apply]
  apply Finset.sum_congr rfl
  intro c _
  simp_rw [Matrix.mul_apply, Matrix.conjTranspose_apply]
  simp only [Matrix.kroneckerMap, Matrix.of_apply, Fintype.sum_prod_type, Matrix.one_apply]
  simp only [ite_mul, one_mul, zero_mul, Finset.sum_ite_irrel, Finset.sum_const_zero,
    Finset.sum_ite_eq, Finset.mem_univ, ↓reduceIte, apply_ite]
  simp

theorem krausMap_allAncilla_posSemidef {α β κ : Type*}
    [Fintype α] [Fintype β] [Fintype κ]
    (m : ℕ) (K : κ → Matrix β α ℂ)
    {Y : Matrix (Fin m × α) (Fin m × α) ℂ} (hY : Y.PosSemidef) :
    (amplify m (krausMap K) Y).PosSemidef := by
  rw [amplify_krausMap]
  exact krausMap_posSemidef _ hY

end AuditProbe

#print axioms AuditProbe.amplify
#print axioms AuditProbe.krausMap_posSemidef
#print axioms AuditProbe.amplify_krausMap
#print axioms AuditProbe.krausMap_allAncilla_posSemidef
