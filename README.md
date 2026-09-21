# Formal Science: finite open systems, one audited milestone at a time

This is the small source base for the finite-dimensional open-systems
program. Six increments are accepted, completing the planned two-state
mathematical benchmark: the Stage 0 density-state representation probe and
finite Kraus trace calculation, the finite dissipator algebra
(`FormalScience/OpenSystems/Dissipator.lean`), the two-state stationary
pilot (`FormalScience/OpenSystems/TwoStateStationary.lean`), the explicit
two-state evolution with its semigroup law and matrix-valued derivative
(`FormalScience/OpenSystems/TwoStateEvolution.lean`), the four-Kraus
certification of that evolution with all-finite-ancilla positivity
(`FormalScience/Quantum/FiniteKraus.lean`,
`FormalScience/OpenSystems/TwoStateKraus.lean`), and the quantitative
Frobenius convergence to the stationary projection
(`FormalScience/OpenSystems/TwoStateConvergence.lean`). A seventh accepted
increment, the Stage 4 zero-Hamiltonian finite Markov generator bridge
(`FormalScience/OpenSystems/FiniteMarkovBridge.lean`), extends the
generator algebra to an arbitrary finite state set. The active checkpoint
is the Stage 5 release-readiness candidate in `NEXT_FABLE_TASK.md`, which
freezes this mathematical surface and adds documentation, provenance, and
consumer reproduction without new API. `TURNS.md` indexes every
implementation and audit round, and `audits/markov/v1/PORTFOLIO_STATUS.md`
is the auditor's ledger of the 39-area portfolio against the accepted
local work.

Beyond the generic finite Kraus and dissipator laws and the finite Markov
generator bridge, the dynamical and convergence results concern the
explicit two-state model. General finite-state CPTP dynamics and
convergence are not established here, and neither are Choi or Stinespring
equivalence, generic GKSL or Perron-Frobenius results, or trace-norm or
diamond-norm contraction. No mathematical novelty is claimed. The
per-module paragraphs under "Mathematical surface" are the authoritative
statement of what is and is not proved.

## Exact dependency base

- Lean: `leanprover/lean4:v4.34.0`
- Mathlib: `5ed2965256430c3649e86755f9576b54eca72435` (v4.34.0)
- Additional direct mathematical dependencies: none
- Transitive dependency revisions: recorded in `lake-manifest.json`

Use the project toolchain. Do not replace these pins with a global Lean version
or run a broad dependency update while repairing a proof.

## Reproduce in Cursor on Ubuntu

Prerequisites: Git, Python 3, and an existing working Lean/elan installation.
Unpack this directory, open it in Cursor, and use its `lean-toolchain` file.

```bash
elan toolchain install leanprover/lean4:v4.34.0
lake exe cache get Mathlib.Analysis.Complex.Basic Mathlib.LinearAlgebra.Matrix.PosDef Mathlib.LinearAlgebra.Matrix.Trace Mathlib.Tactic.FinCases Mathlib.Tactic.NormNum Mathlib.Analysis.SpecialFunctions.ExpDeriv Mathlib.Analysis.Complex.RealDeriv Mathlib.Analysis.Calculus.Deriv.Prod Mathlib.Analysis.Matrix.Normed
python3 scripts/verify.py
python3 scripts/test_verify.py
```

The first Lake command materializes the pinned dependencies and retrieves the
targeted Mathlib cache. The first five modules are the Stage 0 closure; the
last four were added for the evolution module (real exponential
derivatives, real-to-complex derivatives, the finite-product derivative
bridge, and the matrix norm), at the same Mathlib revision (D012). Do not
run `lake update` unless deliberately changing the lockfile. A fresh local
reproduction is required before a milestone extends the source.

The scripts also accept `--lake /absolute/path/to/lake` for an isolated
toolchain and `--output-dir` to record a run in a tracked evidence directory.
The Stage 0 evidence was produced in a Linux x86_64 container; the dissipator
and stationary evidence (`evidence/dissipator/`, `evidence/stationary/v1/`)
was produced on the Ubuntu 24.04 workstation recorded in each tree's
`environment.json`. Evidence for new rounds is versioned as
`evidence/<milestone>/v<k>/`.

## Source map

| File | Role |
| --- | --- |
| `FormalScience/Stage0.lean` | Definitions and ten probe theorems |
| `FormalScience/OpenSystems/Dissipator.lean` | Dissipator definition, linearity, trace, Hermiticity, basis-jump specializations |
| `FormalScience/OpenSystems/TwoStateStationary.lean` | Weighted two-jump generator, entry equations, stationary candidate, uniqueness, boundary cases |
| `FormalScience/OpenSystems/TwoStateEvolution.lean` | Explicit complex-linear flow, semigroup, matrix-valued derivative, fixed points, zero-total-rate identities |
| `FormalScience/Quantum/FiniteKraus.lean` | Generic finite Kraus positivity, blockwise ancilla amplification, lifted-Kraus identity, tensor action |
| `FormalScience/OpenSystems/TwoStateKraus.lean` | Four Kraus operators, completeness, all-matrix representation, density preservation, complete positivity, boundaries |
| `FormalScience/OpenSystems/TwoStateConvergence.lean` | Named Frobenius norm with Mathlib bridge, centered error identity, contraction estimate, long-time limits, physical and boundary consumers |
| `FormalScience/OpenSystems/FiniteMarkovBridge.lean` | Finite classical rate matrix, zero-Hamiltonian matrix-unit dissipator generator, entry formulas, diagonal bridge, stationary densities, two-state recovery |
| `FormalScience.lean` | Umbrella import covering all eight release modules |
| `Audit/Contracts.lean` | Independent consumer signatures for all 193 theorem contracts |
| `exports.json` | Required modules, public declarations, and version pins |
| `scripts/verify.py` | Build, contract, and transitive-axiom gate |
| `scripts/test_verify.py` | Deliberate failing cases for that gate |
| `DECISIONS.md` | Representation, dependency, and packaging decisions |
| `NEXT_FABLE_TASK.md` | The active checkpoint (Stage 5 release-readiness candidate), now prepared and awaiting audit |
| `LICENSE`, `NOTICE` | Apache License 2.0 for the project's own material, with the copyright line and authorship disclosure (D021) |
| `CITATION.cff`, `CHANGELOG.md` | Citation metadata for the candidate; the seven accepted increments with tags, commits, and capabilities |
| `docs/API_GUIDE.md` | Theorem map with full Lean names and assumptions, and the conventions every statement follows |
| `docs/RELEASE_READINESS.md` | Candidate scope, verified facts, evidence pointers, gate limitations, and outstanding decisions |
| `docs/PROVENANCE_AND_LICENSES.md` | Origin of every part of the repository and the pinned dependency license inventory |
| `examples/Usage.lean` | Three compiled anonymous consumers of the public API; documentation, not part of the export inventory |
| `deliverables/release-readiness/v1/HANDOFF.md` | Completed handoff for the release-readiness candidate |
| `evidence/release-readiness/v1/` | Reproduction, verification, gate-test, control, usage, provenance, freeze, and archive-consumer evidence for this round |
| `deliverables/markov/v1/HANDOFF.md` | Historical handoff for the accepted finite Markov generator bridge |
| `evidence/markov/v1/` | Preserved evidence for the accepted finite Markov generator bridge, including the manual declaration inventory |
| `deliverables/convergence/v1/HANDOFF.md` | Historical handoff for the accepted quantitative convergence |
| `evidence/convergence/v1/` | Preserved evidence for the accepted quantitative convergence |
| `AUDIT_HANDOFF_TEMPLATE.md` | Template for each review |
| `TURNS.md` | Index of implementation and audit rounds, with tags and decisions |
| `deliverables/<milestone>/v<k>/` | What the implementer sends: `HANDOFF.md`, `POINTER.json`, post-packaging `RECEIPT.json`, and the untracked archive |
| `audits/<milestone>/v<k>/` | What the auditor returns, stored as received |
| `audits/stage0/v1/Formal_Science_Stage0_Audit.md` | Accepted Stage 0 audit and release boundaries |
| `audits/dissipator/v1/Formal_Science_Dissipator_Audit_v1.md` | Accepted dissipator audit, with findings F1 to F4 |
| `audits/stationary/v1/Formal_Science_Stationary_Audit_v1.md` | Accepted stationary audit, with findings S1 to S3 |
| `audits/evolution/v1/Formal_Science_Evolution_Audit_v1.md` | Accepted evolution audit, with findings E1 and E2 and the auditor's Kraus feasibility probe under `reference/` |
| `audits/kraus/v1/Formal_Science_Kraus_Audit_v1.md` | Accepted Kraus audit, no findings, with a convergence API probe under `reference/` |
| `audits/convergence/v1/Formal_Science_Convergence_Audit_v1.md` | Accepted convergence audit, with findings C1 and C2 and the first scope memo review |
| `audits/markov/v1/Formal_Science_Markov_Audit_v1.md` | Accepted Markov audit, with findings M1 and M2, the portfolio ledger, and the second scope memo review |
| `docs/SCOPE_MEMO.md` | The owner's planning memo on program scope, a shipped planning document outside the Lean export inventory and proof gate |
| `deliverables/dissipator/v1/HANDOFF.md` | Historical handoff for the accepted dissipator milestone |
| `deliverables/stationary/v1/HANDOFF.md` | Historical handoff for the accepted stationary pilot |
| `deliverables/evolution/v1/HANDOFF.md` | Historical handoff for the accepted explicit evolution |
| `deliverables/kraus/v1/HANDOFF.md` | Historical handoff for the accepted four-Kraus certification |
| `docs/PORTFOLIO_ROADMAP.md` | The broader 39-area research plan, context only |
| `docs/planning/` | The research plan PDF and the original 39-item gap inventory, context only |
| `evidence/stage0/` | Preserved evidence for the audited baseline |
| `evidence/dissipator/` | Preserved evidence for the accepted dissipator milestone |
| `evidence/stationary/v1/` | Preserved evidence for the accepted stationary pilot |
| `evidence/evolution/v1/` | Preserved evidence for the accepted explicit evolution |
| `evidence/kraus/v1/` | Preserved evidence for the accepted four-Kraus certification |
| `SOURCE_MANIFEST.json` | SHA-256 of every tracked project file except itself |

## Mathematical surface

`QubitMatrix` is `Matrix (Fin 2) (Fin 2) ℂ`. `IsDensity` is exactly Mathlib PSD
plus complex trace one, using the scoped standard order on complex numbers.
`basisProjector i` is proved equal to `Matrix.single i i 1`.
`diagonalState populationOne` is `diag(1-populationOne,populationOne)`.

The finite Kraus sum accepts rectangular matrices `K_j : Matrix β α ℂ` and
acts on arbitrary input matrices `X : Matrix α α ℂ`. Its weighted-trace
identity is unconditional; its trace-preservation theorem explicitly assumes
`sum_j K_jᴴ K_j = I`.

The two distinct basis densities witness nonvacuity. A singleton identity
Kraus family witnesses that completeness is satisfiable. These examples do not
replace the universally quantified theorems.

`dissipator V X` is `V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)`
for square complex matrices over any finite index type. It is additive and
complex-homogeneous in `X` (also packaged as `dissipatorLinearMap V`), its
trace is zero for every `V` and every `X`, and it maps Hermitian `X` to
Hermitian output for every `V`. The jump matrix carries no hypothesis. The
basis jumps `jumpZeroToOne = E_10` and `jumpOneToZero = E_01` consume these
laws, come with their adjoint and matrix-unit product identities and closed
forms, and are proved not Hermitian. The dissipator is a generator component;
no positivity or complete positivity claim is made about it.

`generator a b` is the weighted two-jump generator
`(a : ℂ) • D[E_10] + (b : ℂ) • D[E_01]` with zero Hamiltonian, as a
complex-linear map on `QubitMatrix`. For arbitrary real rates and arbitrary
complex `X` its four entries are `-a X_00 + b X_11`, `a X_00 - b X_11`, and
`-(a+b)/2` times each coherence; its trace is zero and it preserves
Hermiticity. `rhoStar a b = diagonalState (a / (a + b))`. Under only
`a + b ≠ 0` it equals `diag(b/(a+b), a/(a+b))`, is stationary, and is the
unique stationary matrix among all complex matrices of trace one. Under
`0 ≤ a`, `0 ≤ b`, `0 < a + b` it is a density and is the unique stationary
density. The one-zero-rate cases give the basis projectors, both zero rates
give a zero generator with no unique stationary density, and equal positive
rates give the maximally mixed state. The stationary module itself makes no
convergence or channel claim; those are the later modules below.

`evolution a b t` is an explicit complex-linear map on all qubit matrices,
for arbitrary real rates and real time. With `gamma = a + b`,
`e = exp(-gamma t)`, `f = exp(-(gamma t)/2)`, and `k = t` if `gamma = 0`
else `(1 - e)/gamma`, its diagonal entries are `X_ii + k * L(X)_ii` and its
off-diagonal entries `f * X_ij`. It satisfies `Phi_0 = Id` and
`Phi_(t+u) = Phi_t ∘ Phi_u` as bundled maps, preserves the trace of every
matrix and the Hermiticity of Hermitian input, and has the matrix-valued
derivative `L(Phi_t X)` at every real time. Stationary matrices are fixed
points; at nonzero total rate the populations follow the trace-linear
formula `e X_ii + (1 - e) (rate / gamma) trace X`; at zero total rate
`Phi_t = Id + t L`, and the signed pair `a = 1, b = -1` moves `E_00` along
`diagonalState t`. For arbitrary signed rates and times nothing is claimed
about positivity; the certification below covers the physical domain.

For `0 ≤ a`, `0 ≤ b`, `0 ≤ t`, `evolutionKraus a b t` is the four-operator
family `sqrt p • diag(1, c)`, `(sqrt p * d) • E_01`,
`sqrt (1-p) • diag(c, 1)`, `(sqrt (1-p) * d) • E_10` with `p = b/(a+b)`
(total division), `c = exp(-(a+b)t/2)`, `d = sqrt(1 - c^2)`. It is complete
(`∑ Kjᴴ Kj = 1`), and `evolution a b t X = ∑ Kj X Kjᴴ` for every complex
matrix `X`, so the flow preserves positive semidefiniteness and densities.
The generic layer `amplify m Φ` applies a map blockwise on `Fin m × Fin 2`
(ancilla first); for the flow it equals the Kraus sum of the lifted operators
`1 ⊗ₖ Kj`, and it maps positive semidefinite matrices to positive
semidefinite matrices for every `m` and every input, entangled or not, which
is complete positivity in explicit finite-matrix form. Both-zero rates, time
zero, and each one-zero-rate direction are covered explicitly.

`qubitFrobeniusNorm X = sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)` is the named
Frobenius norm, proved equal to Mathlib's scoped Frobenius instance. For
every complex matrix `X` with `tau = trace X` and `Y = X - tau • rhoStar`,
and `gamma = a + b ≠ 0`, the centered flow has entries `e Y_00`, `e Y_11`,
`c Y_01`, `c Y_10`, so `F(Phi_t X - tau • rhoStar)^2 = e^2 (|Y_00|^2 +
|Y_11|^2) + c^2 (|Y_01|^2 + |Y_10|^2)` exactly. For `gamma > 0` and
`t ≥ 0`, `F(Phi_t X - tau • rhoStar) ≤ c F(Y)` on every complex matrix,
with trace-one and equal-trace-pair consumers; the scalar error tends to
zero and `Phi_t X` tends to `tau • rhoStar` in the canonical matrix
topology. Densities stay densities while contracting toward `rhoStar`, the
one-zero-rate cases converge to the basis projectors, equal positive rates
to the maximally mixed state, and at both rates zero no single matrix
attracts every density. `E_01` is an eigenvector with eigenvalue `c`,
saturating the prefactor. The trace factor is essential: the Frobenius
norm is not contracted on every matrix, and nothing is claimed about trace
or diamond norms, spectral gaps, or general dimension.

On an arbitrary finite index type with real rates `q`, destination first
(`q i j` is the rate from `j` to `i`, diagonal entries ignored by
definition), `exitRate q j = ∑_{i ≠ j} q i j` and `rateMatrix q` has `q i j`
off the diagonal and `-exitRate q j` on it. Every column sums to zero and
`(Q p)` has zero total mass; physical off-diagonal rates give nonnegative
exit rates and entries. `markovGenerator q = ∑_j ∑_{i ≠ j} q i j • D[E_ij]`
is the zero-Hamiltonian generator built from the accepted dissipator; on
every complex matrix its populations obey `∑_{j ≠ i} q i j X_jj - r_i X_ii`
and its coherences are scaled by `-(r_i + r_j)/2`, it annihilates the trace
and preserves Hermiticity, all for signed rates. The diagonal bridge
`L_q(diag p) = diag(Q p)` holds with the real-to-complex coercion explicit,
so diagonal stationarity is exactly `Q p = 0`; probability vectors give PSD
trace-one diagonal matrices and stationary ones give stationary densities.
Zero and diagonal-only rates give zero `Q` and zero `L_q`, and on `Fin 2`
with `q = [[0, b], [a, 0]]` the bridge recovers the accepted `generator a b`.
This is a generator result: no semigroup, exponential, positivity of
`Id + t • L_q`, mixing, or Hamiltonian claim is made.

## License and status

The project's own material is licensed under the Apache License, Version
2.0 (`LICENSE`, `NOTICE`, D021). Dependencies keep their own licenses, listed
in `docs/PROVENANCE_AND_LICENSES.md`. The implementation and the audits
were produced by AI agents under the owner's direction; no human semantic
review of the proofs has taken place, and no public release or upstream
submission has been made. `docs/RELEASE_READINESS.md` separates the
accepted mathematics, the verified candidate, and the open decisions.

## Next step

The Stage 5 release-readiness candidate is prepared and its handoff is
`deliverables/release-readiness/v1/HANDOFF.md`. The next turn is an
independent audit of that candidate, to be stored under
`audits/release-readiness/v1/`. The mathematical surface is frozen at the
accepted Markov snapshot; no further milestone is active until the audit
selects one.

Public theorem scope and proof trust are separate from source provenance,
upstream acceptance, and novelty. The scripts are ordinary reproducibility and
axiom checks, not a hardened verifier against malicious compiler or metaprogram
modifications.
