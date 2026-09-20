# Formal Science: Stage 0 baseline and finite dissipator algebra

This is the small source base for the finite-dimensional open-systems
program. It contains the audited Stage 0 density-state representation probe
and general finite Kraus trace calculation, plus the first bounded milestone
built on it: the finite dissipator algebra in
`FormalScience/OpenSystems/Dissipator.lean`. The Stage 0 report records the
build and audit evidence for the baseline; `deliverables/dissipator/v1/HANDOFF.md`
is the completed handoff for the dissipator milestone, which awaits its
independent audit. `TURNS.md` indexes every implementation and audit round.

It does not prove complete positivity, a Lindblad stationary state, a
semigroup, or convergence. No mathematical novelty is claimed.

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
targeted Mathlib cache. The dissipator module imports only modules already in
that cached closure, so the command list is unchanged. Do not run
`lake update` unless deliberately changing the lockfile. A fresh local
reproduction is required before a milestone extends the source.

The scripts also accept `--lake /absolute/path/to/lake` for an isolated
toolchain and `--output-dir` to record a run in a tracked evidence directory.
The Stage 0 evidence was produced in a Linux x86_64 container; the dissipator
evidence in `evidence/dissipator/` was produced on the Ubuntu 24.04
workstation recorded in `evidence/dissipator/environment.json`.

## Source map

| File | Role |
| --- | --- |
| `FormalScience/Stage0.lean` | Definitions and ten probe theorems |
| `FormalScience/OpenSystems/Dissipator.lean` | Dissipator definition, linearity, trace, Hermiticity, basis-jump specializations |
| `FormalScience.lean` | Umbrella import covering both release modules |
| `Audit/Contracts.lean` | Independent consumer signatures for all 33 theorem contracts |
| `exports.json` | Required modules, public declarations, and version pins |
| `scripts/verify.py` | Build, contract, and transitive-axiom gate |
| `scripts/test_verify.py` | Deliberate failing cases for that gate |
| `DECISIONS.md` | Representation, dependency, and packaging decisions |
| `NEXT_FABLE_TASK.md` | The dissipator assignment, now implemented and awaiting audit |
| `AUDIT_HANDOFF_TEMPLATE.md` | Template for each review |
| `TURNS.md` | Index of implementation and audit rounds, with tags and decisions |
| `deliverables/<milestone>/v<k>/` | What the implementer sends: `HANDOFF.md`, `POINTER.json`, and the untracked archive |
| `audits/<milestone>/v<k>/` | What the auditor returns, stored as received |
| `audits/stage0/v1/Formal_Science_Stage0_Audit.md` | Completed Stage 0 audit and release boundaries |
| `deliverables/dissipator/v1/HANDOFF.md` | Completed handoff for the dissipator milestone |
| `docs/PORTFOLIO_ROADMAP.md` | The broader 39-area research plan, context only |
| `docs/planning/` | The research plan PDF and the original 39-item gap inventory, context only |
| `evidence/stage0/` | Preserved evidence for the audited baseline |
| `evidence/dissipator/` | Fresh setup, reproduction, verification, gate-test, and control evidence |
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

## Next step

The dissipator milestone is implemented and its handoff is
`deliverables/dissipator/v1/HANDOFF.md`. The next turn is an independent
audit of that handoff, to be stored under `audits/dissipator/v1/`. No further milestone is active until the audit selects one; the
stationary-state system, dynamics, complete positivity, and the other
branches remain out of scope.

Public theorem scope and proof trust are separate from source provenance,
upstream acceptance, and novelty. The scripts are ordinary reproducibility and
axiom checks, not a hardened verifier against malicious compiler or metaprogram
modifications.
