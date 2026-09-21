import FormalScience

/-!
# Usage examples

Three anonymous consumers of the accepted public API, compiled with
`lake env lean examples/Usage.lean`. They are documentation, not part of the
216-export release inventory in `exports.json`, and they add no theorem. Each
example states its premises in full and closes by direct application of one
accepted theorem. See `docs/API_GUIDE.md` for the theorem map.
-/

open FormalScience.Stage0 FormalScience.OpenSystems
open scoped Topology

/-! ## 1. The physical two-state flow preserves densities

For nonnegative rates `a` (jump `0 → 1`) and `b` (jump `1 → 0`) and nonnegative
time `t`, the accepted evolution maps every density (positive semidefinite,
complex trace one) to a density. Both rates may be zero. -/

example (a b t : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : 0 ≤ t) (ρ : QubitMatrix)
    (hρ : IsDensity ρ) : IsDensity (evolution a b t ρ) :=
  evolution_isDensity ha hb ht hρ

/-! ## 2. Every density converges to the stationary density

Under nonnegative rates with positive total rate `0 < a + b`, the stationary
state `rhoStar a b` is itself a density and every density tends to it as
`t → ∞`, in the canonical topology on `Matrix (Fin 2) (Fin 2) ℂ`. The positive
total rate is essential: at `a = b = 0` the flow is the identity and no single
matrix attracts every density (`not_exists_common_limit_zero_zero`). -/

example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hγ : 0 < a + b) (ρ : QubitMatrix)
    (hρ : IsDensity ρ) :
    IsDensity (rhoStar a b) ∧
      Filter.Tendsto (fun t : ℝ => evolution a b t ρ) Filter.atTop (𝓝 (rhoStar a b)) :=
  tendsto_evolution_of_isDensity ha hb hγ hρ

/-! ## 3. The diagonal Markov bridge on three states

For an arbitrary signed real rate matrix `q` on `Fin 3` (destination first:
`q i j` is the rate from `j` to `i`, and the diagonal entries of `q` are
ignored) and an arbitrary real vector `p`, the zero-Hamiltonian generator acts
on the complex diagonal embedding of `p` as the diagonal embedding of the
classical action `(rateMatrix q).mulVec p`. No nonnegativity is assumed. -/

example (q : Matrix (Fin 3) (Fin 3) ℝ) (p : Fin 3 → ℝ) :
    markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) =
      Matrix.diagonal fun i => (((rateMatrix q).mulVec p i : ℝ) : ℂ) :=
  markovGenerator_diagonal q p
