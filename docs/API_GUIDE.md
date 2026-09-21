# API guide

A short map from the accepted mathematics to Lean names, with the
assumptions each theorem actually carries. Every declaration listed here is
in `exports.json`, has a fully spelled-out consumer in
`Audit/Contracts.lean`, and depends only on `propext`, `Classical.choice`,
and `Quot.sound`. The three compiled examples in `examples/Usage.lean` are
the canonical usage snippets; this guide links to them rather than
duplicating them.

## Imports and setup

```lean
import FormalScience            -- the umbrella: all eight release modules
open FormalScience.Stage0 FormalScience.OpenSystems
open scoped Topology            -- for the `𝓝` notation in limit statements
```

Individual modules can be imported directly (`FormalScience.Stage0`,
`FormalScience.OpenSystems.Dissipator`, `.TwoStateStationary`,
`.TwoStateEvolution`, `FormalScience.Quantum.FiniteKraus`,
`FormalScience.OpenSystems.TwoStateKraus`, `.TwoStateConvergence`,
`.FiniteMarkovBridge`). Setup is the README's pinned toolchain (Lean
4.34.0, Mathlib `5ed29652`) and cache command.

## Conventions that every statement follows

- Basis `0, 1` on `QubitMatrix := Matrix (Fin 2) (Fin 2) ℂ`. `a` is the
  rate of the jump `0 → 1` carried by `jumpZeroToOne = Matrix.single 1 0 1`
  (`E_10`); `b` is the rate of `1 → 0` carried by `jumpOneToZero = E_01`.
- Zero Hamiltonian everywhere, including the Markov bridge.
- Densities: `IsDensity ρ := ρ.PosSemidef ∧ Matrix.trace ρ = 1`, qubit
  specific. Generic results state `PosSemidef ∧ trace = 1` directly.
- Signed versus physical hypotheses. Algebraic identities (entries, trace,
  Hermiticity, semigroup, derivative, generator formulas, the Markov
  bridge) hold for arbitrary real rates and times. Positivity and density
  preservation of the two-state flow need `0 ≤ a`, `0 ≤ b`, `0 ≤ t`.
  Attraction to the stationary state needs `0 < a + b`; at `a = b = 0` the
  flow is the identity and no matrix attracts every density.
- Norms. The convergence estimate is in the Frobenius norm, centered in a
  trace fiber: the target is `Matrix.trace X • rhoStar a b`, not `rhoStar`
  alone, unless `trace X = 1`. It is not a trace-norm or diamond-norm
  statement and not an uncentered Frobenius contraction.
- Complete positivity is stated in explicit finite-matrix form: PSD
  preservation after blockwise amplification by every finite ancilla
  dimension `m`, on every PSD input, entangled or not.
- Markov bridge: destination first, `q i j` is the rate from `j` to `i`;
  the supplied diagonal entries `q j j` are ignored by definition; the
  results are generator identities, not a transition semigroup.

## States and finite Kraus sums (`FormalScience.Stage0`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `basisProjector i`, `basisProjector_isDensity` | the two basis densities | none |
| `diagonalState p`, `diagonalState_isDensity` | `diag(1 - p, p)` is a density | `0 ≤ p ≤ 1` |
| `krausMap K X` | `∑ j, K j * X * (K j)ᴴ` on rectangular `K j : Matrix β α ℂ` | none |
| `krausMap_trace_preserving` | `trace (krausMap K X) = trace X` | `∑ j, (K j)ᴴ * K j = 1` |

## Dissipators (`FormalScience.OpenSystems.Dissipator`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `dissipator V X` | `V * X * Vᴴ - (1/2) • (Vᴴ * V * X + X * Vᴴ * V)`, any finite index type | none |
| `dissipatorLinearMap V` | the same as a `ℂ`-linear map | none |
| `dissipator_trace` | `trace (dissipator V X) = 0` | none (every `V`, every `X`) |
| `dissipator_isHermitian` | `X.IsHermitian → (dissipator V X).IsHermitian` | Hermitian input |
| `dissipator_jumpZeroToOne_eq`, `dissipator_jumpOneToZero_eq` | closed forms at `E_10`, `E_01` | none |

## Two-state generator and stationary state (`TwoStateStationary`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `generator a b` | `(a : ℂ) • D[E_10] + (b : ℂ) • D[E_01]`, bundled linear map | none |
| `generator_apply_zero_zero` and the three other entries | `-a X_00 + b X_11`, `a X_00 - b X_11`, `-(a+b)/2 · X_ij` | none |
| `generator_trace`, `generator_isHermitian` | trace zero; Hermitian in, Hermitian out | none; Hermitian input |
| `rhoStar a b` | `diagonalState (a / (a + b))`, equal to `diag(b/(a+b), a/(a+b))` (`rhoStar_eq_diagonal`) | `a + b ≠ 0` for the diagonal form |
| `generator_rhoStar` | `generator a b (rhoStar a b) = 0` | `a + b ≠ 0` |
| `rhoStar_isDensity` | `IsDensity (rhoStar a b)` | `0 ≤ a`, `0 ≤ b`, `0 < a + b` |
| `isDensity_generator_eq_zero_iff` | a density is stationary iff it is `rhoStar` | `a + b ≠ 0`, `IsDensity ρ` |
| `existsUnique_stationary_density` | unique stationary density | `0 ≤ a`, `0 ≤ b`, `0 < a + b` |
| `rhoStar_zero_left`, `rhoStar_zero_right`, `rhoStar_same` | boundaries: `basisProjector 0` at `a = 0`, `basisProjector 1` at `b = 0`, `diagonalState (1/2)` at `a = b` | `b ≠ 0`, `a ≠ 0`, `r ≠ 0` respectively |
| `not_existsUnique_stationary_density_zero_zero` | no unique stationary density at both rates zero | none |

## Two-state evolution (`TwoStateEvolution`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `evolution a b t` | the explicit flow, bundled `ℂ`-linear map | none (all real rates and times) |
| `evolution_zero`, `evolution_add` | `Phi_0 = id`, `Phi_(t+u) = Phi_t ∘ Phi_u` | none |
| `evolution_trace`, `evolution_isHermitian` | trace preserved; Hermitian preserved | none; Hermitian input |
| `hasDerivAt_evolution` | `HasDerivAt (fun s => Phi_s X) (generator a b (Phi_t X)) t` | none |
| `evolution_rhoStar` | `Phi_t (rhoStar a b) = rhoStar a b` | `a + b ≠ 0` |
| `evolution_apply_zero_zero_of_ne_zero`, `_one_one_of_ne_zero` | populations `e X_ii + (1 - e)(rate/(a+b)) trace X` with `e = exp(-(a+b) t)` | `a + b ≠ 0` |
| `evolution_zero_zero` | `evolution 0 0 t = id` | none |

## Kraus certification and complete positivity (`FiniteKraus`, `TwoStateKraus`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `krausMap_posSemidef` | `X.PosSemidef → (krausMap K X).PosSemidef` | PSD input |
| `amplify m Φ Y` | blockwise application on `Fin m × α` (ancilla index first) | none |
| `amplify_krausMap`, `amplify_kronecker` | `amplify m (krausMap K) = krausMap (1 ⊗ₖ K ·)`; `amplify m Φ (A ⊗ₖ X) = A ⊗ₖ Φ X` | none; `Φ` linear |
| `evolutionKraus a b t` | the four operators (see `evolutionKraus_apply_zero` to `_three`) | none |
| `evolutionKraus_complete` | `∑ j, (K j)ᴴ * K j = 1` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `evolution_eq_krausMap` | `evolution a b t X = krausMap (evolutionKraus a b t) X` for every complex `X` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |
| `evolution_posSemidef`, `evolution_isDensity` | PSD and density preservation | `0 ≤ a`, `0 ≤ b`, `0 ≤ t`; PSD or density input |
| `amplify_evolution_posSemidef` | `(amplify m (evolution a b t) Y).PosSemidef` for every `m` and PSD `Y` | `0 ≤ a`, `0 ≤ b`, `0 ≤ t` |

Usage: example 1 in `examples/Usage.lean` applies `evolution_isDensity`.

## Quantitative convergence (`TwoStateConvergence`)

| Name | Statement | Assumptions |
| --- | --- | --- |
| `qubitFrobeniusNorm X` | `Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)` | none |
| `qubitFrobeniusNorm_eq_norm` | equals `‖X‖` under `open scoped Matrix.Norms.Frobenius` | none |
| `qubitFrobeniusNorm_sq_evolution_sub` | exact split `e^2 (|Y_00|^2 + |Y_11|^2) + c^2 (|Y_01|^2 + |Y_10|^2)` with `Y = X - trace X • rhoStar` | `a + b ≠ 0` |
| `qubitFrobeniusNorm_evolution_sub_le` | `F(Phi_t X - trace X • rhoStar) ≤ halfExpFactor (a+b) t * F(X - trace X • rhoStar)`, `halfExpFactor γ t = exp(-(γ t)/2)` | `0 < a + b`, `0 ≤ t`; every complex `X` |
| `qubitFrobeniusNorm_evolution_sub_rhoStar_le` | the same with `rhoStar` as target | `0 < a + b`, `0 ≤ t`, `trace X = 1` |
| `qubitFrobeniusNorm_evolution_sub_evolution_le` | pairwise bound on equal-trace inputs | `0 < a + b`, `0 ≤ t`, `trace X = trace Z` |
| `tendsto_evolution` | `Tendsto (fun t => Phi_t X) atTop (𝓝 (trace X • rhoStar a b))` | `0 < a + b` |
| `tendsto_evolution_of_isDensity` | `IsDensity (rhoStar a b) ∧ Tendsto (fun t => Phi_t ρ) atTop (𝓝 (rhoStar a b))` | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `IsDensity ρ` |
| `evolution_isDensity_and_qubitFrobeniusNorm_le` | density preserved and distance to `rhoStar` contracted | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `0 ≤ t`, `IsDensity ρ` |
| `tendsto_evolution_zero_left`, `_zero_right`, `_same` | limits `basisProjector 0`, `basisProjector 1`, `diagonalState (1/2)` | `0 < b`, `0 < a`, `0 < r` with `trace X = 1` |
| `not_exists_common_limit_zero_zero` | at `a = b = 0` no matrix attracts every density | none |

Usage: example 2 in `examples/Usage.lean` applies
`tendsto_evolution_of_isDensity`; the both-zero exception is
`not_exists_common_limit_zero_zero`.

## Finite Markov generator bridge (`FiniteMarkovBridge`)

All statements are over an arbitrary `{n : Type*} [Fintype n] [DecidableEq n]`
with `q : Matrix n n ℝ`, destination first, diagonal entries ignored.

| Name | Statement | Assumptions |
| --- | --- | --- |
| `exitRate q j` | `∑ i, if i = j then 0 else q i j` | none |
| `rateMatrix q` | `q i j` off the diagonal, `-exitRate q j` on it | none |
| `rateMatrix_sum_col`, `sum_rateMatrix_mulVec` | zero column sums; `∑ i, (Q p) i = 0` | none |
| `rateMatrix_mulVec_apply` | `(Q p) i = ∑_{j ≠ i} q i j * p j - exitRate q i * p i` | none |
| `exitRate_nonneg`, `rateMatrix_nonneg_of_ne` | nonnegative exit rates and off-diagonal entries | `∀ i j, i ≠ j → 0 ≤ q i j` |
| `markovGenerator q` | `∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipatorLinearMap (Matrix.single i j 1)` | none |
| `markovGenerator_apply_diag`, `markovGenerator_apply_of_ne` | populations `∑_{j ≠ i} q i j X_jj - r_i X_ii`; coherences `-(r_i + r_j)/2 · X_ij` | none (every complex `X`, signed rates) |
| `markovGenerator_trace`, `markovGenerator_isHermitian` | trace zero; Hermitian preserved | none; Hermitian input |
| `markovGenerator_diagonal` | `L_q (diagonal fun i => (p i : ℂ)) = diagonal fun i => ((Q p) i : ℂ)` | none |
| `markovGenerator_diagonal_eq_zero_iff` | `L_q (diag ↑p) = 0 ↔ Q p = 0` | none |
| `diagonal_ofReal_posSemidef_trace_one` | `(diag ↑p).PosSemidef ∧ trace = 1` | `∀ i, 0 ≤ p i`, `∑ i, p i = 1` |
| `stationary_diagonal_density` | PSD, trace one, and `L_q (diag ↑p) = 0` | the two above and `Q p = 0` |
| `markovGenerator_zero`, `markovGenerator_diagonal_rates` | zero and diagonal-only rates give the zero map | none |
| `rateMatrix_two`, `markovGenerator_two` | `q = [[0, b], [a, 0]]` gives `Q = [[-a, b], [a, -b]]` and `markovGenerator q = generator a b` | none |

Usage: example 3 in `examples/Usage.lean` applies `markovGenerator_diagonal`
on `Fin 3`.

## What is not here

No matrix exponential or transition semigroup for the Markov generator, no
positivity of `Id + t • L_q`, no generic GKSL characterization, no generic
Perron-Frobenius or mixing theory, no Choi or Stinespring equivalence, no
partial trace or purification, no trace-norm or diamond-norm results, and no
Hamiltonian term. No broad portfolio row is declared complete, and no
mathematical novelty is claimed.
