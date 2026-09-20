# Stage 0 architecture decisions

## D001: Mathlib-only mathematical dependency

Selected Mathlib 4.34.0 at commit
`5ed2965256430c3649e86755f9576b54eca72435`, with matching Lean 4.34.0.
This stable release supplies the matrix, trace, PSD, and complex-order APIs
needed for the bounded probe. We are not claiming it is the best version for
every future quantum-information development.

QICLean was inspected at `af5430a1bb7050b86e7520035eccfa7e1e3249d6`.
Its density predicate agrees with the selected semantics, and its finite
Kraus trace-preservation theorem is a useful comparison. It is not imported.
Its Lean/Mathlib 4.35.0-rc1 pin and additional package requirements are
unnecessary for the first probe. Those package requirements were not thereby
established as proof dependencies of its small trace theorem.

Reconsider this decision when a concrete later contract needs generic GKSL,
entropy, or another substantial API. A general reason to avoid downstream
libraries is not being asserted.

## D002: explicit, unbundled density predicate

`IsDensity ρ := ρ.PosSemidef ∧ Matrix.trace ρ = 1` for 2 by 2 complex matrices.
This adds no new mathematical positivity definition. A later bundled state can
be introduced if a concrete consumer needs it; the current probe does not
justify another broad quantum framework.

Independent contract checks use the underlying Mathlib predicate and trace
directly. Defining an easier local density predicate would not satisfy those
checks unless the original mathematical conclusions still followed.

## D003: population and basis convention

Basis order is 0,1. `diagonalState populationOne` means
`diag(1-populationOne,populationOne)`.
In the planned model `a` is 0->1 and `b` is 1->0, so the stationary candidate
is `diagonalState (a/(a+b))` under nonnegative rates and positive total rate.
The later four-Kraus formula instead uses a parameter `populationZero=b/(a+b)`.
Keep these names distinct.

## D004: trace preservation is separate from CP

The current `krausMap` is an unnormalized finite matrix sum. The trace theorem
assumes completeness explicitly and works for every matrix. No CP predicate,
channel structure, ancilla theorem, or continuous-time dynamics is defined in
the baseline. Later claims must discharge these obligations separately.

## D005: ordinary proof trust plus independent signature checks

Release declarations may use only `propext`, `Classical.choice`, and
`Quot.sound`, or a subset. The export manifest includes definitions as well as
theorems for transitive-axiom reporting. Separate consumer signatures fix the
ten theorem contracts. Missing modules, missing declarations, unexpected
axioms, and failed contracts reject the gate.

This is not malicious-code hardening. A reviewer still needs to inspect
definitions, all changes to the audit scripts, and the correspondence between
formal statements and the intended mathematics.

## D006: next milestone refined after reconnaissance

Before solving the stationary system, Fable should prove the finite dissipator
trace and Hermiticity laws, with only the matrix-unit facts they require. This
is a bounded implementation checkpoint between the initial API probe and the
stationary-state release. It does not authorize the dynamics or OR branches.

## D007: dissipator representation (finite dissipator milestone)

`FormalScience/OpenSystems/Dissipator.lean` defines

```text
dissipator V X := V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)
```

as a plain definition carrying the exact contract formula, so an auditor
reads the formula directly and the consumer contracts can restate it without
the project name. The definition is `noncomputable` only because complex
division has no executable implementation; this attribute is irrelevant to
the proofs and does not appear in the axiom reports.

Linearity is delivered both ways: `dissipator_add` and `dissipator_smul` as
direct lemmas, and `dissipatorLinearMap V : Matrix n n ℂ →ₗ[ℂ] Matrix n n ℂ`
whose underlying function is `dissipator V` itself (`dissipatorLinearMap_apply`
is `rfl`). The bundled form is what the planned weighted generator
`a • D[E_10] + b • D[E_01]` will consume; the lemmas keep the plain
definition usable on its own.

The definition is stated for an arbitrary finite index type `n` with
`[Fintype n]`, not only for `QubitMatrix`. The proofs are identical, this
matches the generality already chosen for `krausMap` in Stage 0, and the
planned Markov bridge needs exactly this form. The assignment said "initially
on the qubit basis"; the qubit case is covered by the `E_10` and `E_01`
specializations below, so this is a strict generalization and not a weakening.
Nothing in the definition or the three laws assumes `V` Hermitian, unitary,
or normalized, and nothing assumes `X` is a density.

Basis jumps are named by direction to match D003: `jumpZeroToOne` is
`E_10 = Matrix.single 1 0 1 = |1><0|` (rate `a`, population `0 -> 1`) and
`jumpOneToZero` is `E_01 = Matrix.single 0 1 1 = |0><1|` (rate `b`).

Beyond the minimum required results, the module includes: the closed forms
`dissipator_jumpZeroToOne_eq` and `dissipator_jumpOneToZero_eq` in terms of
`basisProjector`, which the stationary-state milestone will consume directly;
`jumpZeroToOne_not_isHermitian` and `jumpOneToZero_not_isHermitian`, which
witness that the general laws are used outside the Hermitian case; the
convention witnesses `D[E_10](E_00) = E_11 - E_00` and
`D[E_01](E_11) = E_00 - E_11`, which pin the sign and direction conventions;
and two small general lemmas, `isHermitian_anticommutator` and
`isSelfAdjoint_half`, kept public because later generators reuse them.

Mathlib at the pin was searched before adding lemmas. Reused directly:
`Matrix.trace_mul_cycle`, `Matrix.trace_mul_comm`, `Matrix.trace_sub`,
`Matrix.trace_add`, `Matrix.trace_smul`, `Matrix.isHermitian_mul_mul_conjTranspose`,
`Matrix.isHermitian_conjTranspose_mul_self`, `Matrix.IsHermitian.sub`,
`Matrix.IsHermitian.smul`, `Matrix.conjTranspose_single`,
`Matrix.single_mul_single_same`, `Matrix.single_mul_mul_single`,
`Matrix.smul_single`, `Matrix.mul_smul`, `Matrix.smul_mul`, `star_div₀`,
`star_ofNat`. No Mathlib lemma stating Hermiticity of an anticommutator was
found at the pin, so `isHermitian_anticommutator` is proved locally in four
rewrites. No QICLean or other downstream source was imported or copied.

## D008: evidence and packaging conventions after Stage 0

The project now lives at the repository root. `evidence/stage0/` is
preserved unchanged. Each later milestone records fresh evidence under a
tracked `evidence/<milestone>/` tree, here `evidence/dissipator/`, with
`setup/` (toolchain and cache logs), `reproduction/` (the baseline rerun
before any source change), `verification/` and `gate-tests/` (the final
runs), `gate-controls/` (deliberately failing runs that show the gate covers
the new module), and `environment.json`. The scripts' default output
directories `evidence/latest/` and `evidence/selftest-latest/` remain
ignored by Git and are for iteration only.

`SOURCE_MANIFEST.json` covers every Git-tracked file except itself, so its
scope is reproducible with `git ls-files`. Toolchains, `.lake/`, and the
local Python environment are excluded by construction.

The implementation and audit loop uses one key per milestone. The key (for
example `stationary`) names `evidence/<key>/v<k>/`, `deliverables/<key>/v<k>/`,
`audits/<key>/v<k>/`, and the tag `<key>-milestone-v<k>`, where `k` is the
round number and increments only if an audit sends the milestone back.
Evidence is versioned by round (audit finding F2) so that a later round
cannot overwrite the evidence an earlier handoff cites; the two paths that
predate this rule, `evidence/stage0/` and `evidence/dissipator/`, are frozen
as delivered and are not renamed. `deliverables/` holds what the implementer
sends (the completed handoff template as `HANDOFF.md`, a `POINTER.json`
naming the tag, diff base, and evidence, and after packaging a
`RECEIPT.json` with the archive digest and commit); `audits/` holds what the
auditor returns, stored as received with original file names; `TURNS.md`
indexes every round in order, since per-milestone directories do not show
chronology on their own.

Each document has one tracked location. The Stage 0 audit lives only at
`audits/stage0/v1/`; the redundant root copy and the `docs/` copy were
removed. The research plan lives as `docs/PORTFOLIO_ROADMAP.md` (Markdown,
with a provenance note) and `docs/planning/Lean_Formalization_Research_Plan.pdf`;
the original 39-item inventory is `docs/planning/MISSING_PROOFS_INVENTORY.md`.

Archives are derived artifacts: `git archive` of the tag, written into the
`deliverables/<key>/v<k>/` directory, which `.gitignore` excludes through
`*.zip`, so no archive ever nests earlier archives. Audit finding F1
corrected the packaging sequence and its wording. The manifest is generated
after the intended files are staged and their staged bytes are confirmed to
equal the working-tree bytes; it hashes those final bytes and excludes
itself; it is then staged, the commit is made, the tag is created, the
archive is produced from the tag, and the completed archive is verified
path by path against the manifest for byte count and SHA-256. Agreement is
a checked result of that verification, not an assumption from matching
filenames. The archive digest and `git rev-parse <tag>^{commit}` are
recorded afterwards in a `RECEIPT.json` committed after the tag, never
inside the archive they describe. The Stage 0 and dissipator return
archives are kept on disk under `audits/` but are not tracked. The
implementer commits and tags; the user pushes. Accepted tags are never
moved.

## D009: corrections carried forward from the dissipator audit

The dissipator audit (`audits/dissipator/v1/`) accepted
`dissipator-milestone-v1` at commit `be2ad90` with no proof revision and
four low-severity findings. F1 and F2 are closed above. The remaining two
are documentation errata; the historical handoff
`deliverables/dissipator/v1/HANDOFF.md` is preserved unchanged and these
corrections are recorded here.

F3, non-unitarity citation. The v1 handoff wrote that the jumps are not
unitary because `E_10ᴴ E_10 = E_00 ≠ 1`, "visible from
`jumpZeroToOne_conjTranspose_mul_self` and `basisProjector_zero_ne_one`".
The cited Stage 0 theorem proves `E_00 ≠ E_11`, not `E_00 ≠ I`. The
conclusion stands for a different reason: entry `(1,1)` of `E_00` is `0`
while entry `(1,1)` of `I` is `1` (and symmetrically entry `(0,0)` of
`E_11` against `I`). No exported theorem states non-unitarity and none is
required; the dissipator laws never assume it.

F4, dependency licenses. The v1 handoff said all nine pinned packages are
Apache 2.0. At the pinned revisions, eight package roots carry Apache 2.0
(mathlib, plausible, LeanSearchClient, importGraph, proofwidgets, aesop,
Qq, batteries) and `Cli` at `e92c9f15` carries an MIT license. The
auditor's per-package inventory with license file hashes is at
`audits/dissipator/v1/evidence/dependency_license_inventory.json`. Future
provenance summaries use this inventory. No dependency changes.

