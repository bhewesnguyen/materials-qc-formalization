import FormalScience.OpenSystems.TwoStateKraus

/-!
Optional auditor API feasibility probe for the convergence assignment.
This is outside the accepted release and proves neither the main error
estimate nor convergence of the evolution.
-/
open FormalScience.Stage0 FormalScience.OpenSystems Filter
open scoped Topology

namespace ConvergenceApiProbe

noncomputable def probeFrobenius (X : QubitMatrix) : ℝ :=
  Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)

open scoped Matrix.Norms.Frobenius in
theorem frobenius_bridge (X : QubitMatrix) : probeFrobenius X = ‖X‖ := by
  rw [Matrix.frobenius_norm_def, ← Real.sqrt_eq_rpow]
  simp only [Real.rpow_two, probeFrobenius]

theorem expFactor_tendsto {γ : ℝ} (hγ : 0 < γ) :
    Tendsto (fun t => expFactor γ t) atTop (𝓝 0) := by
  simpa only [expFactor, neg_mul, Function.comp_def, id_eq] using
    Real.tendsto_exp_atBot.comp
      (tendsto_id.const_mul_atTop_of_neg (neg_lt_zero.mpr hγ))

theorem halfExpFactor_tendsto {γ : ℝ} (hγ : 0 < γ) :
    Tendsto (fun t => halfExpFactor γ t) atTop (𝓝 0) := by
  have h : -(γ / 2) < 0 := by linarith
  convert Real.tendsto_exp_atBot.comp
    (tendsto_id.const_mul_atTop_of_neg h) using 1
  ext t
  simp only [halfExpFactor, Function.comp_def, id_eq]
  congr 1
  ring

#print axioms probeFrobenius
#print axioms frobenius_bridge
#print axioms expFactor_tendsto
#print axioms halfExpFactor_tendsto

end ConvergenceApiProbe
