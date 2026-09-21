# API guide

A map from the accepted mathematics to fully qualified Lean names, with the
assumptions each declaration actually carries. Every name listed here is in
`exports.json` and depends only on `propext`, `Classical.choice`, and
`Quot.sound`. Each public theorem has a direct consumer contract in
`Audit/Contracts.lean` that restates it with spelled-out formulas; public
definitions are anchored there by consumers of their formula theorems
rather than by a contract of their own. The three compiled examples in
`examples/Usage.lean` are the canonical usage snippets; this guide links to
them rather than duplicating them.

## Imports and setup

```lean
import FormalScience            -- the umbrella: all eight release modules
open FormalScience.Stage0 FormalScience.OpenSystems FormalScience.Quantum
open scoped Topology            -- for the `𝓝` notation in limit statements
```

The eight modules can be imported individually:

| Import | Declaration namespace |
| --- | --- |
| `import FormalScience.Stage0` | `FormalScience.Stage0` |
| `import FormalScience.OpenSystems.Dissipator` | `FormalScience.OpenSystems` |
| `import FormalScience.OpenSystems.TwoStateStationary` | `FormalScience.OpenSystems` |
| `import FormalScience.OpenSystems.TwoStateEvolution` | `FormalScience.OpenSystems` |
| `import FormalScience.Quantum.FiniteKraus` | `FormalScience.Quantum` |
| `import FormalScience.OpenSystems.TwoStateKraus` | `FormalScience.OpenSystems` |
| `import FormalScience.OpenSystems.TwoStateConvergence` | `FormalScience.OpenSystems` |
| `import FormalScience.OpenSystems.FiniteMarkovBridge` | `FormalScience.OpenSystems` |

Module names are not declaration namespaces: `dissipator_trace` is
`FormalScience.OpenSystems.dissipator_trace`, not a name under
`Dissipator`. Setup is the README's pinned toolchain (Lean 4.34.0, Mathlib
`5ed29652`) and cache command.

## Conventions that every statement follows

- Basis `0, 1` on `FormalScience.Stage0.QubitMatrix := Matrix (Fin 2) (Fin 2) ℂ`.
  `a` is the rate of the jump `0 → 1` carried by
  `FormalScience.OpenSystems.jumpZeroToOne = Matrix.single 1 0 1` (`E_10`);
  `b` is the rate of `1 → 0` carried by
  `FormalScience.OpenSystems.jumpOneToZero` (`E_01`).
- Zero Hamiltonian everywhere, including the Markov bridge.
- Densities: `FormalScience.Stage0.IsDensity ρ := ρ.PosSemidef ∧ Matrix.trace ρ = 1`,
  qubit specific. Generic results state `PosSemidef ∧ trace = 1` directly.
- Signed versus physical hypotheses. Algebraic identities (entries, trace,
  Hermiticity, semigroup, derivative, generator formulas, the Markov
  bridge) hold for arbitrary real rates and times. Positivity and density
  preservation of the two-state flow need `0 ≤ a`, `0 ≤ b`, `0 ≤ t`.
  Attraction to the stationary state needs `0 < a + b`; at `a = b = 0` the
  flow is the identity and no matrix attracts every density.
- Norms. The convergence estimate is in the Frobenius norm, centered in a
  trace fiber: the target is `Matrix.trace X • rhoStar a b`, not `rhoStar`
  alone, unless `Matrix.trace X = 1`. It is not a trace-norm or
  diamond-norm statement and not an uncentered Frobenius contraction.
- Complete positivity is stated in explicit finite-matrix form: PSD
  preservation after blockwise amplification by every finite ancilla
  dimension `m`, on every PSD input, entangled or not.
- Markov bridge: destination first, `q i j` is the rate from `j` to `i`;
  the supplied diagonal entries `q j j` are ignored by definition; the
  results are generator identities, not a transition semigroup.

In the tables, `e = exp(-(a+b) t)`, `c = exp(-(a+b) t / 2)`, and `↑x` is the
cast of a real into `ℂ`.

## States and finite Kraus sums (`FormalScience.Stage0`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.Stage0.basisProjector i` (definition) | `Matrix.diagonal fun j => if j = i then 1 else 0` | none |
| `FormalScience.Stage0.basisProjector_isDensity` | `IsDensity (basisProjector i)` | none |
| `FormalScience.Stage0.diagonalState p` (definition) | `Matrix.diagonal ![((1 - p : ℝ) : ℂ), (p : ℂ)]` | none |
| `FormalScience.Stage0.diagonalState_isDensity` | `IsDensity (diagonalState p)` | `0 ≤ p`, `p ≤ 1` |
| `FormalScience.Stage0.krausMap K X` (definition) | `∑ j, K j * X * (K j)ᴴ` on rectangular `K j : Matrix β α ℂ` | none |
| `FormalScience.Stage0.krausMap_trace_preserving` | `Matrix.trace (krausMap K X) = Matrix.trace X` | `∑ j, (K j)ᴴ * K j = 1` |

## Dissipators (`FormalScience.OpenSystems`, module `Dissipator`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.OpenSystems.dissipator V X` (definition) | `V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)`, any finite index type | none |
| `FormalScience.OpenSystems.dissipatorLinearMap V` (definition) | the same as a `ℂ`-linear map | none |
| `FormalScience.OpenSystems.dissipator_trace` | `Matrix.trace (dissipator V X) = 0` | none (every `V`, every `X`) |
| `FormalScience.OpenSystems.dissipator_isHermitian` | `X.IsHermitian → (dissipator V X).IsHermitian` | Hermitian input |
| `FormalScience.OpenSystems.dissipator_jumpZeroToOne_eq` | closed form of `dissipator jumpZeroToOne X` | none |
| `FormalScience.OpenSystems.dissipator_jumpOneToZero_eq` | closed form of `dissipator jumpOneToZero X` | none |

## Two-state generator and stationary state (module `TwoStateStationary`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.OpenSystems.generator a b` (definition) | `(a : ℂ) • dissipatorLinearMap jumpZeroToOne + (b : ℂ) • dissipatorLinearMap jumpOneToZero` | none |
| `FormalScience.OpenSystems.generator_apply_zero_zero` | `generator a b X 0 0 = -↑a * X 0 0 + ↑b * X 1 1` | none |
| `FormalScience.OpenSystems.generator_apply_one_one` | `generator a b X 1 1 = ↑a * X 0 0 - ↑b * X 1 1` | none |
| `FormalScience.OpenSystems.generator_apply_zero_one` | `generator a b X 0 1 = -(↑(a + b) / 2) * X 0 1` | none |
| `FormalScience.OpenSystems.generator_apply_one_zero` | `generator a b X 1 0 = -(↑(a + b) / 2) * X 1 0` | none |
| `FormalScience.OpenSystems.generator_trace` | `Matrix.trace (generator a b X) = 0` | none |
| `FormalScience.OpenSystems.generator_isHermitian` | `X.IsHermitian → (generator a b X).IsHermitian` | Hermitian input |
| `FormalScience.OpenSystems.rhoStar a b` (definition) | `diagonalState (a / (a + b))` | none |
| `FormalScience.OpenSystems.rhoStar_eq_diagonal` | `rhoStar a b = Matrix.diagonal ![↑(b / (a + b)), ↑(a / (a + b))]` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.generator_rhoStar` | `generator a b (rhoStar a b) = 0` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.rhoStar_isDensity` | `IsDensity (rhoStar a b)` | `0 ≤ a`, `0 ≤ b`, `0 < a + b` |
| `FormalScience.OpenSystems.isDensity_generator_eq_zero_iff` | `generator a b ρ = 0 ↔ ρ = rhoStar a b` | `a + b ≠ 0`, `IsDensity ρ` |
| `FormalScience.OpenSystems.existsUnique_stationary_density` | `∃! ρ, IsDensity ρ ∧ generator a b ρ = 0` | `0 ≤ a`, `0 ≤ b`, `0 < a + b` |
| `FormalScience.OpenSystems.rhoStar_zero_left` | `rhoStar 0 b = basisProjector 0` | none (holds for every real `b`, including `b = 0`) |
| `FormalScience.OpenSystems.rhoStar_zero_right` | `rhoStar a 0 = basisProjector 1` | `a ≠ 0` |
| `FormalScience.OpenSystems.rhoStar_same` | `rhoStar r r = diagonalState (1 / 2)` | `r ≠ 0` |
| `FormalScience.OpenSystems.not_existsUnique_stationary_density_zero_zero` | no unique stationary density at both rates zero | none |

## Two-state evolution (module `TwoStateEvolution`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.OpenSystems.evolution a b t` (definition) | the explicit flow, bundled `ℂ`-linear map | none (all real rates and times) |
| `FormalScience.OpenSystems.evolution_zero` | `evolution a b 0 = LinearMap.id` | none |
| `FormalScience.OpenSystems.evolution_add` | `evolution a b (t + u) = (evolution a b t).comp (evolution a b u)` | none |
| `FormalScience.OpenSystems.evolution_trace` | `Matrix.trace (evolution a b t X) = Matrix.trace X` | none |
| `FormalScience.OpenSystems.evolution_isHermitian` | `X.IsHermitian → (evolution a b t X).IsHermitian` | Hermitian input |
| `FormalScience.OpenSystems.hasDerivAt_evolution` | `HasDerivAt (fun s => evolution a b s X) (generator a b (evolution a b t X)) t` | none |
| `FormalScience.OpenSystems.evolution_rhoStar` | `evolution a b t (rhoStar a b) = rhoStar a b` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.evolution_apply_zero_zero_of_ne_zero` | `evolution a b t X 0 0 = ↑e * X 0 0 + ↑((1 - e) * (b / (a + b))) * Matrix.trace X` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.evolution_apply_one_one_of_ne_zero` | `evolution a b t X 1 1 = ↑e * X 1 1 + ↑((1 - e) * (a / (a + b))) * Matrix.trace X` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.evolution_zero_zero` | `evolution 0 0 t = LinearMap.id` | none |

## Kraus certification and complete positivity (modules `FiniteKraus` and `TwoStateKraus`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.Quantum.krausMap_posSemidef` | `X.PosSemidef → (krausMap K X).PosSemidef` | PSD input |
| `FormalScience.Quantum.amplify m Φ Y` (definition) | blockwise application of `Φ` on `Fin m × α` (ancilla index first) | none |
| `FormalScience.Quantum.amplify_krausMap` | `amplify m (krausMap K) Y = krausMap (fun j => 1 ⊗ₖ K j) Y` | none |
| `FormalScience.Quantum.amplify_kronecker` | `amplify m Φ (A ⊗ₖ X) = A ⊗ₖ Φ X` | `Φ` a `ℂ`-linear map |
| `FormalScience.OpenSystems.evolutionKraus a b t` (definition) | the four operators, given by `evolutionKraus_apply_zero`, `evolutionKraus_apply_one`, `evolutionKraus_apply_two`, `evolutionKraus_apply_three` | none |
| `FormalScience.OpenSystems.evolutionKraus_complete` | `∑ j, (evolutionKraus a b t j)ᴴ * evolutionKraus a b t j = 1` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `FormalScience.OpenSystems.evolution_eq_krausMap` | `evolution a b t X = krausMap (evolutionKraus a b t) X` for every complex `X` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `FormalScience.OpenSystems.evolution_posSemidef` | `X.PosSemidef → (evolution a b t X).PosSemidef` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `FormalScience.OpenSystems.evolution_isDensity` | `IsDensity X → IsDensity (evolution a b t X)` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `FormalScience.OpenSystems.amplify_evolution_posSemidef` | `Y.PosSemidef → (amplify m (evolution a b t) Y).PosSemidef`, every `m` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |

Usage: example 1 in `examples/Usage.lean` applies
`FormalScience.OpenSystems.evolution_isDensity`.

## Quantitative convergence (module `TwoStateConvergence`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.OpenSystems.qubitFrobeniusNorm X` (definition) | `Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)` | none |
| `FormalScience.OpenSystems.qubitFrobeniusNorm_eq_norm` | `qubitFrobeniusNorm X = ‖X‖` under `open scoped Matrix.Norms.Frobenius` | none |
| `FormalScience.OpenSystems.qubitFrobeniusNorm_sq_evolution_sub` | exact split `e ^ 2 * (‖Y 0 0‖ ^ 2 + ‖Y 1 1‖ ^ 2) + c ^ 2 * (‖Y 0 1‖ ^ 2 + ‖Y 1 0‖ ^ 2)` with `Y = X - Matrix.trace X • rhoStar a b` | `a + b ≠ 0` |
| `FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_le` | `qubitFrobeniusNorm (evolution a b t X - Matrix.trace X • rhoStar a b) ≤ halfExpFactor (a + b) t * qubitFrobeniusNorm (X - Matrix.trace X • rhoStar a b)`, where `halfExpFactor γ t = Real.exp (-(γ * t) / 2)` | `0 < a + b`, `0 ≤ t`; every complex `X` |
| `FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_rhoStar_le` | the same with `rhoStar a b` as target | `0 < a + b`, `0 ≤ t`, `Matrix.trace X = 1` |
| `FormalScience.OpenSystems.qubitFrobeniusNorm_evolution_sub_evolution_le` | `qubitFrobeniusNorm (evolution a b t X - evolution a b t Z) ≤ halfExpFactor (a + b) t * qubitFrobeniusNorm (X - Z)` | `0 < a + b`, `0 ≤ t`, `Matrix.trace X = Matrix.trace Z` |
| `FormalScience.OpenSystems.tendsto_evolution` | `Filter.Tendsto (fun t => evolution a b t X) Filter.atTop (𝓝 (Matrix.trace X • rhoStar a b))` | `0 < a + b` |
| `FormalScience.OpenSystems.tendsto_evolution_of_isDensity` | `IsDensity (rhoStar a b) ∧ Filter.Tendsto (fun t => evolution a b t ρ) Filter.atTop (𝓝 (rhoStar a b))` | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `IsDensity ρ` |
| `FormalScience.OpenSystems.evolution_isDensity_and_qubitFrobeniusNorm_le` | density preserved and distance to `rhoStar a b` contracted by `halfExpFactor (a + b) t` | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `0 ≤ t`, `IsDensity ρ` |
| `FormalScience.OpenSystems.tendsto_evolution_zero_left` | limit `basisProjector 0` for `evolution 0 b t X` | `0 < b`, `Matrix.trace X = 1` |
| `FormalScience.OpenSystems.tendsto_evolution_zero_right` | limit `basisProjector 1` for `evolution a 0 t X` | `0 < a`, `Matrix.trace X = 1` |
| `FormalScience.OpenSystems.tendsto_evolution_same` | limit `diagonalState (1 / 2)` for `evolution r r t X` | `0 < r`, `Matrix.trace X = 1` |
| `FormalScience.OpenSystems.not_exists_common_limit_zero_zero` | `¬ ∃ σ, ∀ ρ, IsDensity ρ → Filter.Tendsto (fun t => evolution 0 0 t ρ) Filter.atTop (𝓝 σ)` | none |

Usage: example 2 in `examples/Usage.lean` applies
`FormalScience.OpenSystems.tendsto_evolution_of_isDensity`; the both-zero
exception is `FormalScience.OpenSystems.not_exists_common_limit_zero_zero`.

## Finite Markov generator bridge (module `FiniteMarkovBridge`)

All statements are over an arbitrary `{n : Type*} [Fintype n] [DecidableEq n]`
with `q : Matrix n n ℝ`, destination first, diagonal entries ignored. Write
`r_i = exitRate q i` and `Q = rateMatrix q`.

| Name | Statement | Assumptions |
| --- | --- | --- |
| `FormalScience.OpenSystems.exitRate q j` (definition) | `∑ i, if i = j then 0 else q i j` | none |
| `FormalScience.OpenSystems.rateMatrix q` (definition) | `Matrix.of fun i j => if i = j then -exitRate q j else q i j` | none |
| `FormalScience.OpenSystems.rateMatrix_sum_col` | `∑ i, rateMatrix q i j = 0` | none |
| `FormalScience.OpenSystems.rateMatrix_mulVec_apply` | `(rateMatrix q).mulVec p i = (∑ j, if i = j then 0 else q i j * p j) - exitRate q i * p i` | none |
| `FormalScience.OpenSystems.sum_rateMatrix_mulVec` | `∑ i, (rateMatrix q).mulVec p i = 0` | none |
| `FormalScience.OpenSystems.exitRate_nonneg` | `0 ≤ exitRate q j` | `∀ i j, i ≠ j → 0 ≤ q i j` |
| `FormalScience.OpenSystems.rateMatrix_nonneg_of_ne` | `0 ≤ rateMatrix q i j` | `∀ i j, i ≠ j → 0 ≤ q i j`, and `i ≠ j` |
| `FormalScience.OpenSystems.markovGenerator q` (definition) | `∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipatorLinearMap (Matrix.single i j 1)` | none |
| `FormalScience.OpenSystems.markovGenerator_apply_diag` | `markovGenerator q X i i = (∑ j, if i = j then 0 else ↑(q i j) * X j j) - ↑(exitRate q i) * X i i` | none (every complex `X`, signed rates) |
| `FormalScience.OpenSystems.markovGenerator_apply_of_ne` | `markovGenerator q X i j = -↑((exitRate q i + exitRate q j) / 2) * X i j` | `i ≠ j` (every complex `X`, signed rates) |
| `FormalScience.OpenSystems.markovGenerator_trace` | `Matrix.trace (markovGenerator q X) = 0` | none |
| `FormalScience.OpenSystems.markovGenerator_isHermitian` | `X.IsHermitian → (markovGenerator q X).IsHermitian` | Hermitian input |
| `FormalScience.OpenSystems.markovGenerator_diagonal` | `markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) = Matrix.diagonal fun i => (((rateMatrix q).mulVec p i : ℝ) : ℂ)` | none |
| `FormalScience.OpenSystems.markovGenerator_diagonal_eq_zero_iff` | `markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) = 0 ↔ (rateMatrix q).mulVec p = 0` | none |
| `FormalScience.OpenSystems.diagonal_ofReal_posSemidef_trace_one` | `(Matrix.diagonal fun i => (p i : ℂ)).PosSemidef ∧ Matrix.trace (Matrix.diagonal fun i => (p i : ℂ)) = 1` | `∀ i, 0 ≤ p i`, `∑ i, p i = 1` |
| `FormalScience.OpenSystems.stationary_diagonal_density` | PSD, trace one, and `markovGenerator q (Matrix.diagonal fun i => (p i : ℂ)) = 0` | `∀ i, 0 ≤ p i`, `∑ i, p i = 1`, `(rateMatrix q).mulVec p = 0` |
| `FormalScience.OpenSystems.markovGenerator_zero` | `markovGenerator 0 = 0` | none |
| `FormalScience.OpenSystems.markovGenerator_diagonal_rates` | `markovGenerator (Matrix.diagonal d) = 0` | none |
| `FormalScience.OpenSystems.rateMatrix_two` | `rateMatrix (Matrix.of ![![0, b], ![a, 0]]) = Matrix.of ![![-a, b], ![a, -b]]` | none |
| `FormalScience.OpenSystems.markovGenerator_two` | `markovGenerator (Matrix.of ![![0, b], ![a, 0]]) = generator a b` | none |

Usage: example 3 in `examples/Usage.lean` applies
`FormalScience.OpenSystems.markovGenerator_diagonal` on `Fin 3`.

## What is not here

No matrix exponential or transition semigroup for the Markov generator, no
positivity of `Id + t • L_q`, no generic GKSL characterization, no generic
Perron-Frobenius or mixing theory, no Choi or Stinespring equivalence, no
partial trace or purification, no trace-norm or diamond-norm results, and no
Hamiltonian term. No broad portfolio row is declared complete, and no
mathematical novelty is claimed.
