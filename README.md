# Formal Science: finite open systems, one audited milestone at a time

This is the small source base for the finite-dimensional open-systems
program. Three milestones are accepted: the Stage 0 density-state
representation probe and finite Kraus trace calculation, the finite
dissipator algebra (`FormalScience/OpenSystems/Dissipator.lean`), and the
two-state stationary pilot (`FormalScience/OpenSystems/TwoStateStationary.lean`).
The active assignment is the explicit two-state evolution in
`NEXT_FABLE_TASK.md`. `TURNS.md` indexes every implementation and audit
round, and `audits/stationary/v1/PORTFOLIO_STATUS.md` is the auditor's
ledger of the 39-area portfolio against the accepted local work.

It does not prove complete positivity, a semigroup, time evolution, or
convergence. No mathematical novelty is claimed.

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
lake exe cache get Mathlib.Analysis.Complex.Basic Mathlib.LinearAlgebra.Matrix.PosDef Mathlib.LinearAlgebra.Matrix.Trace Mathlib.Tactic.FinCases Mathlib.Tactic.NormNum
python3 scripts/verify.py
python3 scripts/test_verify.py
```

The first Lake command materializes the pinned dependencies and retrieves the
targeted Mathlib cache. Both open-systems modules import only modules already
in that cached closure, so the command list is unchanged. Do not run
`lake update` unless deliberately changing the lockfile. A fresh local
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
| `FormalScience.lean` | Umbrella import covering all three release modules |
| `Audit/Contracts.lean` | Independent consumer signatures for all 61 theorem contracts |
| `exports.json` | Required modules, public declarations, and version pins |
| `scripts/verify.py` | Build, contract, and transitive-axiom gate |
| `scripts/test_verify.py` | Deliberate failing cases for that gate |
| `DECISIONS.md` | Representation, dependency, and packaging decisions |
| `NEXT_FABLE_TASK.md` | The active assignment (stationary pilot), now implemented and awaiting audit |
| `AUDIT_HANDOFF_TEMPLATE.md` | Template for each review |
| `TURNS.md` | Index of implementation and audit rounds, with tags and decisions |
| `deliverables/<milestone>/v<k>/` | What the implementer sends: `HANDOFF.md`, `POINTER.json`, post-packaging `RECEIPT.json`, and the untracked archive |
| `audits/<milestone>/v<k>/` | What the auditor returns, stored as received |
| `audits/stage0/v1/Formal_Science_Stage0_Audit.md` | Accepted Stage 0 audit and release boundaries |
| `audits/dissipator/v1/Formal_Science_Dissipator_Audit_v1.md` | Accepted dissipator audit, with findings F1 to F4 |
| `audits/stationary/v1/Formal_Science_Stationary_Audit_v1.md` | Accepted stationary audit, with findings S1 to S3 and the portfolio ledger |
| `deliverables/dissipator/v1/HANDOFF.md` | Historical handoff for the accepted dissipator milestone |
| `deliverables/stationary/v1/HANDOFF.md` | Historical handoff for the accepted stationary pilot |
| `docs/PORTFOLIO_ROADMAP.md` | The broader 39-area research plan, context only |
| `docs/planning/` | The research plan PDF and the original 39-item gap inventory, context only |
| `evidence/stage0/` | Preserved evidence for the audited baseline |
| `evidence/dissipator/` | Preserved evidence for the accepted dissipator milestone |
| `evidence/stationary/v1/` | Preserved evidence for the accepted stationary pilot |
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
rates give the maximally mixed state. No dynamics, convergence, or channel
claim is made.

## Next step

The active assignment is the explicit two-state evolution specified in
`NEXT_FABLE_TASK.md`, issued with the stationary audit. Positivity,
complete positivity, convergence, generic GKSL, and the other branches
remain out of scope for it.

Public theorem scope and proof trust are separate from source provenance,
upstream acceptance, and novelty. The scripts are ordinary reproducibility and
axiom checks, not a hardened verifier against malicious compiler or metaprogram
modifications.
