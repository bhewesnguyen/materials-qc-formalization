# Formal Science: Stage 0 baseline

This is the small source baseline for the finite-dimensional open-systems
program. It contains a density-state representation probe and a general finite
Kraus trace calculation. The accompanying Stage 0 report records the build and
audit evidence for this delivered snapshot.

It does not yet prove complete positivity, a Lindblad stationary state, a
semigroup, or convergence. No mathematical novelty is claimed for these probes.

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
targeted Mathlib cache. Do not run `lake update` unless deliberately changing
the lockfile. A fresh local reproduction is required before Fable extends the
baseline.

The scripts also accept `--lake /absolute/path/to/lake` for an isolated
toolchain. Its sibling `lean` must match the pin. The delivered evidence was
produced in a Linux x86_64 container, not on your physical Ubuntu workstation.

## Source map

| File | Role |
| --- | --- |
| `FormalScience/Stage0.lean` | Definitions and ten probe theorems |
| `FormalScience.lean` | Umbrella import covering the release module |
| `Audit/Contracts.lean` | Independent consumer signatures |
| `exports.json` | Required modules, public declarations, and version pins |
| `scripts/verify.py` | Build, contract, and transitive-axiom gate |
| `scripts/test_verify.py` | Deliberate failing cases for that gate |
| `DECISIONS.md` | Representation and dependency decisions |
| `NEXT_FABLE_TASK.md` | Bounded next implementation assignment |
| `AUDIT_HANDOFF_TEMPLATE.md` | Template for the next review |
| `docs/STAGE0_AUDIT.md` | Completed audit and release boundaries |
| `evidence/stage0/` | Preserved evidence for this delivered baseline |
| `SOURCE_MANIFEST.json` | Hashes for the delivered project files |

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

## Next step

Read AGENTS.md and NEXT_FABLE_TASK.md. Reproduce this baseline, then implement
only the finite dissipator algebra milestone specified there. Return the
changed source and fresh evidence for the next independent audit.

Public theorem scope and proof trust are separate from source provenance,
upstream acceptance, and novelty. The scripts are ordinary reproducibility and
axiom checks, not a hardened verifier against malicious compiler or metaprogram
modifications.
