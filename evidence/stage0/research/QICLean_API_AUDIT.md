# QICLean API and dependency reconnaissance for Stage 0

Status: source inspection only. No QICLean build, exported-type printout, or transitive-axiom audit was executed for this note. The parent task performs the separate Mathlib pilot build. Repository source-token inspection is not an axiom audit.

Post-build correction: the final Mathlib-only probe compiled successfully with an explicit `Mathlib.Analysis.Complex.Basic` import. At the selected pin, use `Complex.zero_le_real.mpr` for the scalar inequalities below. The suggested name `Complex.ofReal_nonneg` in the original reconnaissance is not the correct namespace for that alias. The built source and final Stage 0 report supersede those provisional suggestions. This correction does not change QICLean's source-only audit status.

## Examined revisions

- QICLean: `https://github.com/LionSR/QICLean`, commit `af5430a1bb7050b86e7520035eccfa7e1e3249d6`, local snapshot `research_quantum/repo1`.
- Its `lean-toolchain`: `leanprover/lean4:v4.35.0-rc1`.
- Its manifest pins Mathlib to `c32e1ec0d1eb5237ba344eee50162f45d5b0fc76`, input revision `v4.35.0-rc1`.
- Its Lake package additionally requires `Gametheory` from `LionSR/Brouwer` at `ec93e4daed4ad8b4784a9d760e492832e7711433`, and `checkdecls`, manifest-pinned to `3d425859e73fcfbef85b9638c2a91708ef4a22d4`.
- Proposed pilot Mathlib source: `5ed2965256430c3649e86755f9576b54eca72435`, version `v4.34.0`, local snapshot `stage0/mathlib`.

## Recommendation

Use Mathlib alone for C00 and the small Kraus trace-preservation probe. The required PSD, diagonal, outer-product, trace, adjoint, finite-sum, and matrix multiplication APIs already exist. A local namespaced predicate `IsDensity rho := rho.PosSemidef ∧ Matrix.trace rho = 1` is a thin domain adapter, not a competing matrix ecosystem. Take matrices on `Fin 2` for the pilot, which supplies explicit nonempty basis labels.

QICLean remains a useful source reference and potential later dependency. Importing it now would couple a small elementary probe to its Lean 4.35 release-candidate snapshot, its downstream package resolution, and APIs beyond this milestone. This is an engineering scope decision, not a conclusion that QICLean is untrustworthy. The inspected selected modules do not themselves import Brouwer or checkdecls.

If later importing QICLean, pin its exact revision and compatible Mathlib revision, rebuild the selected import closure, and audit the actual exports. Do not assume current QICLean compiles against the proposed 4.34 baseline. Do not copy proof bodies without retaining Apache 2.0 notices and authorship/provenance.

## QICLean definitions and minimal candidate modules

| Purpose | Module and declaration | Mathematical content / limitation |
| --- | --- | --- |
| Density predicate | `QICLean.Channel.Basic`: global `densityMatrices`, `mem_densityMatrices` | Exactly PSD and complex trace equal to one, matrices indexed by `Fin D`. |
| Nonemptiness | Same: global `densityMatrices_nonempty (hD : 0 < D)` | Explicit maximally mixed witness `(D : ℂ)⁻¹ • 1`; positivity of dimension is required. |
| Mixtures | Same: global `densityMatrices_isConvex` | Real convexity. No direct `diag(1-p,p)` declaration found in this selected module. Direct Mathlib diagonal PSD is shorter. |
| Vector outer product | `QICLean.Analysis.TraceNormContractionCoefficient`: `Matrix.pureStateProj` | `vecMulVec ψ (fun p => star (ψ p))`, defined for all vectors. It is a normalized rank-one density only with the unit-vector hypothesis. |
| Unit normalization | Same: `Matrix.IsUnitVector` | Hermitian self-dot-product equals complex one. |
| Pure-state density | Same: `Matrix.pureStateProj_posSemidef`, `Matrix.trace_pureStateProj`, `Matrix.pureStateProj_mem_densityMatrices` | The final result takes `IsUnitVector ψ`. Its proof is elementary, but its module imports trace-norm theory. |
| Rank-one status | `QICLean.Channel.FixedPoint.ExtremeDensityStates`: `Matrix.IsUnitVector.isRankOneOrthogonalProjection_pureStateProj` | Useful if actual rank-one status is required; unnecessary for C00 validity and distinct basis witnesses. |
| Raw TP criterion | `QICLean.Channel.KrausRepresentation`: global `kraus_tp_of_sum_conjTranspose_mul` | Arbitrary finite input/output basis types, `K : Fin r → Matrix β α ℂ`; `∑ KᴴK = 1` implies trace preservation for every matrix. Imports only `QICLean.Channel.Basic`. |
| Kraus linear map | `QICLean.Channel.Schwarz.Basic`: `Kraus.map`, `Kraus.mapLM`, `Kraus.IsTP` | Finite-index Kraus sum and its linear-map packaging; `IsTP K` is exactly `∑ KᴴK = 1`. Imports MatrixAux, and bundles considerably more Schwarz theory. |
| Packaged channel | `QICLean.Channel.KrausMap`: `Kraus.isCPMap_mapLM`, `Kraus.isTracePreservingMap_mapLM_of_isTP`, `Kraus.isChannel_mapLM` | Useful bundled conclusions, but unnecessary dependency breadth for the initial trace probe. |
| Kraus CP definition | `QICLean.Channel.Basic`: global `IsCPMap`, `IsKrausCP`, `IsChannel` | CP here is defined by existence of a finite Kraus representation. `IsChannel` combines that with universal trace preservation. |
| Actual ancilla-positivity bridge | `QICLean.Channel.CompletelyPositiveBridge`: `IsCPMap.map_cstarMatrix_nonneg`, `IsCPMap.toCompletelyPositiveMap` | Proves the all-finite-ancilla positivity condition and packages Mathlib's `CompletelyPositiveMap`. This is the relevant semantic bridge for a later C06 claim. |

The names above are source declarations, not independently confirmed elaborated types. In particular, `densityMatrices` and the raw Kraus criterion are in the global namespace, while `pureStateProj` and its density theorem are in namespace `Matrix`.

## Mathlib 4.34 exact source candidates

| Module | Declaration | Role |
| --- | --- | --- |
| `Mathlib.LinearAlgebra.Matrix.PosDef` | `Matrix.PosSemidef`, `Matrix.PosSemidef.diagonal`, `Matrix.posSemidef_diagonal_iff` | Density PSD field and direct diagonal mixture positivity. |
| Same | `Matrix.posSemidef_vecMulVec_self_star` | PSD for `vecMulVec ψ (star ψ)`. |
| Same | `Matrix.PosSemidef.mul_mul_conjTranspose_same` | Positivity of `K * X * Kᴴ` for PSD input. |
| Same | `Matrix.posSemidef_sum` | PSD closure under finite Kraus sums. |
| Same | `Matrix.PosSemidef.smul`, `Matrix.PosSemidef.add` | Alternative mixture proof through convex combinations. |
| `Mathlib.LinearAlgebra.Matrix.Trace` | `Matrix.trace_diagonal`, `Matrix.trace_vecMulVec` | Exact trace normalizations. |
| Same | `Matrix.trace_sum`, `Matrix.trace_mul_cycle`, `Matrix.trace_mul_comm` | Kraus trace-preservation identity. |
| `Mathlib.Analysis.Complex.Order` | `Complex.zero_le_real`, `Complex.ofReal_nonneg` | Nonnegative real scalars embedded into the scoped complex order. |
| `Mathlib.Analysis.CStarAlgebra.CompletelyPositiveMap` | `CompletelyPositiveMap`, `CompletelyPositiveMap.map_cstarMatrix_nonneg` | Later all-ancilla CP contract; not required for C00 or TP. |

Use `open scoped ComplexOrder` for PSD over complex entries and `open scoped Matrix` for conjugate-transpose notation. The source candidate module list is not claimed to be import-minimized by a build.

Mathlib `Matrix.PosSemidef` is an actual Hermitian-and-nonnegative-quadratic-form predicate. The general definition quantifies over finitely supported vectors and therefore does not itself need a finite basis. For this pilot the finite basis is `Fin 2`.

## Proof sketches for the bounded pilot

### Basis density witnesses

Either define `basisProjector i` as the diagonal matrix with one at `i`, or as `vecMulVec (Pi.single i 1) (star (Pi.single i 1))`. The diagonal route uses `Matrix.PosSemidef.diagonal`, nonnegativity of zero and one, and `Matrix.trace_diagonal`; the outer-product route uses `Matrix.posSemidef_vecMulVec_self_star` and `Matrix.trace_vecMulVec`. With `Fin 2`, distinguish projectors zero and one by evaluating entry `(0,0)`.

If the contract explicitly calls them pure, prove idempotence and, if the chosen definition of purity requires it, rank one. Calling an arbitrary outer product a normalized pure state without a unit-vector premise would be wrong. For C00 it is sufficient to exhibit the two concrete basis projectors and discharge their density obligations; later rank-one conclusions in C05 require their own proof.

### Diagonal mixtures

Let `q : Fin 2 → ℂ` have entries `((1-p : ℝ) : ℂ)` and `(p : ℂ)`. Under `0 ≤ p` and `p ≤ 1`, prove `0 ≤ q i` by the two finite cases and `Complex.ofReal_nonneg`. Apply `Matrix.PosSemidef.diagonal`. Its trace reduces by `Matrix.trace_diagonal` and the two-element sum to `(1-p)+p=1`.

This avoids square roots, spectral decomposition, density compactness, rank machinery, and C-star operator norms.

### Kraus trace preservation

The proof works for any finite Kraus index type, and rectangular operators if desired. For each term cyclic trace gives

`trace (K i * X * (K i)ᴴ) = trace ((K i)ᴴ * K i * X)`.

Then finite-sum linearity and matrix right distributivity give

`trace (∑ i, K i * X * (K i)ᴴ) = trace ((∑ i, (K i)ᴴ * K i) * X)`.

Rewrite the normalization hypothesis and `Matrix.one_mul`. This is TP on every complex matrix, so it is stronger and cleaner than stating it only on densities. It proves no complete-positivity property by itself. Positivity of the same Kraus sum can separately be obtained using congruence and PSD sums. A later C06 declaration of complete positivity must also connect the Kraus form to the all-ancilla definition.

## Local QICLean import closure scan

The scan recursively followed source `import` lines between QICLean modules and listed external direct imports. It found:

| Selected import | QICLean modules in local closure | Direct Mathlib module names across that closure | Other external module imports |
| --- | ---: | ---: | --- |
| `QICLean.Channel.Basic` | 1 | 11 | None |
| `QICLean.Channel.KrausRepresentation` | 2 | 11 | None |
| `QICLean.Channel.KrausMap` | 5 | 18 | None |
| `QICLean.Channel.CompletelyPositiveBridge` | 2 | 12 | None |
| `QICLean.Analysis.TraceNormContractionCoefficient` | 9 | 23 | None |

The scan found no occurrences of `axiom`, `sorry`, `admit`, `native_decide`, or `implemented_by` in those respective QICLean module closures. The six directly inspected small modules also showed no `unsafe`, `elab`, `macro`, or `run_tac` occurrences. Ordinary tactic use includes simplification, finite sums, ring normalization, and positivity. Mathlib's own transitive modules and theorem proof terms were not exhaustively audited here.

Do not report the scan as proving axiom cleanliness, full QICLean trust, or successful builds. For release exports, `#print axioms` and full elaborated declaration inspection remain required.
