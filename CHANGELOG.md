# Changelog

Package `formal-science`, version `0.0.1` throughout. Each entry names the
tag and the commit under audit (`git rev-parse <tag>^{commit}`), the
auditor's decision, and the capability the increment added. Counts are
cumulative exports and distinct theorem contracts in `exports.json`. No
public release has been made; the release-readiness entry describes a
candidate prepared for independent audit, not a publication.

## release-readiness v1 (candidate, tag `release-readiness-milestone-v1`)

Documentation, provenance, consumer reproduction, and packaging only. The
eight release modules, `Audit/Contracts.lean`, `FormalScience.lean`,
`exports.json`, both verification scripts, `lean-toolchain`, and
`lake-manifest.json` are byte-identical to the accepted Markov snapshot
(216 exports, 193 theorem contracts, 23 definitions or abbreviations).
Added: `LICENSE` (Apache License 2.0, owner decision D021), `NOTICE`,
`CITATION.cff`, this changelog, `docs/API_GUIDE.md`,
`docs/RELEASE_READINESS.md`, `docs/PROVENANCE_AND_LICENSES.md`, and the
compiled anonymous consumers `examples/Usage.lean` (outside the export
inventory). Live documentation corrections M1 (README scope sentence) and
M2 (scope memo wording) from the Markov audit, recorded in D020. Fresh
baseline reproduction and, after tagging, a fresh-extraction reproduction
of the delivered archive, recorded under `evidence/release-readiness/v1/`.

## markov v1 (tag `markov-milestone-v1`, commit `4795b8b6dc6ec7a831b9158affe3ee199f60e01e`)

Accepted (`audits/markov/v1/`), findings M1 and M2, both low, documentation.
Adds `FormalScience/OpenSystems/FiniteMarkovBridge.lean`: on an arbitrary
finite index type with destination-first real rates and ignored diagonal
entries, `exitRate`, `rateMatrix` with zero column sums and mass-conserving
`mulVec` action, the zero-Hamiltonian `markovGenerator` as a bundled sum of
matrix-unit dissipators, population and coherence entry formulas, trace
annihilation and Hermiticity preservation for signed rates, the diagonal
bridge `L_q(diag p) = diag(Q p)` with its stationary equivalence,
probability-vector and stationary-density consumers, zero and diagonal-only
rate families, and recovery of the two-state `generator a b`. 216 exports,
193 contracts. One comment-only change to the convergence module header
(C1).

## convergence v1 (tag `convergence-milestone-v1`, commit `a3cbac0692b4c106a89e80c91d18b0c2de4988cd`)

Accepted (`audits/convergence/v1/`), findings C1 and C2, both low,
documentation. Adds `FormalScience/OpenSystems/TwoStateConvergence.lean`:
the named Frobenius norm `qubitFrobeniusNorm` with its finite-sum formula
and a proved bridge to Mathlib's scoped Frobenius instance; centered entry
identities and the exact squared error split for nonzero total rate; the
estimate `F(Phi_t X - trace X • rhoStar) ≤ exp(-(a+b) t / 2) F(X - trace X •
rhoStar)` for positive total rate and nonnegative time on every complex
matrix, with trace-one and equal-trace-pair consumers; scalar and matrix
long-time limits; density consumers; the three positive-total-rate boundary
limits and the both-zero non-attractor; the `E_01` saturating witness. 187
exports, 167 contracts. Completes the planned two-state benchmark.

## kraus v1 (tag `kraus-milestone-v1`, commit `6431c9cd411a3a804d2a86ae733e23f393fe9361`)

Accepted (`audits/kraus/v1/`), no findings, three optional prose cleanups.
Adds `FormalScience/Quantum/FiniteKraus.lean` (generic finite Kraus
positivity, blockwise ancilla amplification `amplify`, lifted-Kraus
identity, tensor action) and `FormalScience/OpenSystems/TwoStateKraus.lean`
(the four-operator family `evolutionKraus`, completeness, equality with the
flow on every complex matrix for nonnegative rates and time, positivity and
density preservation, all-finite-ancilla complete positivity, boundary
families). 158 exports, 139 contracts. One docstring-only change to the
evolution module (E1).

## evolution v1 (tag `evolution-milestone-v1`, commit `a60a92b6064b4dde33a98d3c79be195c77595873`)

Accepted (`audits/evolution/v1/`), findings E1 and E2, both low,
documentation. Adds `FormalScience/OpenSystems/TwoStateEvolution.lean`: the
explicit complex-linear flow `evolution a b t` for arbitrary real rates and
time, `Phi_0 = Id`, the semigroup law `Phi_(t+u) = Phi_t ∘ Phi_u`, trace
preservation, Hermiticity preservation, the matrix-valued derivative
`d/dt Phi_t X = L(Phi_t X)`, fixed points, trace-linear population formulas,
zero-total-rate identities, and boundary fixed points. 115 exports, 100
contracts.

## stationary v1 (tag `stationary-milestone-v1`, commit `a5347ca77a2b5e6678f514decb0ab4eee7b62943`)

Accepted (`audits/stationary/v1/`), findings S1 to S3, all low, records and
wording. Adds `FormalScience/OpenSystems/TwoStateStationary.lean`: the
weighted two-jump generator `generator a b` with zero Hamiltonian, its entry
equations, trace and Hermiticity laws, the stationary candidate `rhoStar`,
uniqueness among trace-one matrices for nonzero total rate and among
densities for physical rates, and the degenerate-rate boundary cases. 72
exports, 61 contracts.

## dissipator v1 (tag `dissipator-milestone-v1`, commit `be2ad90088b3c407d2aa18aafe3a2e806db35011`)

Accepted (`audits/dissipator/v1/`), findings F1 to F4, all low, process.
Adds `FormalScience/OpenSystems/Dissipator.lean`: `dissipator V X` over any
finite index type, additivity and complex homogeneity (also bundled as
`dissipatorLinearMap`), zero trace for every jump matrix and input,
Hermiticity preservation, and the basis-jump specializations `E_10`, `E_01`
with their closed forms. 42 exports, 33 contracts.

## stage0 v1 (no tag; imported as commit `cd7e6c6`)

Built and audited by the independent auditor before this repository
existed (`audits/stage0/v1/`). `FormalScience/Stage0.lean`: `QubitMatrix`,
the density predicate `IsDensity`, basis projectors and diagonal states with
their density proofs, the finite Kraus sum `krausMap` with its trace
identity and trace preservation under completeness, and the validation
scripts `scripts/verify.py` and `scripts/test_verify.py`. 15 exports, 10
contracts.
