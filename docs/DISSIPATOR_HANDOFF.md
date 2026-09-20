# Stage audit handoff: finite dissipator algebra

Completed from AUDIT_HANDOFF_TEMPLATE.md on 20 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/dissipator/`; nothing is asserted from memory of an editor state.

## Scope

- Stage and accepted contract IDs: implementation turn 1, "finite dissipator
  algebra", as specified in NEXT_FABLE_TASK.md and section "Fable's next
  implementation turn" of docs/STAGE0_AUDIT.md (decision D006). The four
  required results are: (1) additivity and complex homogeneity in `X`, or a
  bundled complex-linear map; (2) `trace(D[V](X)) = 0` for every `V`, `X`;
  (3) `X` Hermitian implies `D[V](X)` Hermitian, for every `V`; (4) the
  specializations `V = E_10` and `V = E_01` consume these results.
- Commit under review: the commit tagged `dissipator-milestone-v1`, whose
  tree contains this document. Obtain its hash with
  `git rev-parse dissipator-milestone-v1`. Its diff base is the baseline
  commit `cd7e6c60d08c5f33dd7a9c83253116f7de2ed610` ("Import audited Stage 0
  baseline and planning documents"), whose extracted files matched the
  shipped SOURCE_MANIFEST.json in all 125 entries. The exact tested source
  files are pinned by SHA-256 in
  `evidence/dissipator/verification/verification.json` (key `source_sha256`)
  and listed under "Trust evidence" below.
- What is complete: all four required results, in one new release module
  `FormalScience/OpenSystems/Dissipator.lean` (27 public declarations: 4
  definitions, 23 theorems). The umbrella, export manifest, and independent
  contract file cover every new declaration. Both validation scripts pass
  against the final source. Stage 0 was reproduced on this workstation before
  any proof source changed, with identical source hashes and identical axiom
  reports to the container evidence.
- What is explicitly incomplete: nothing from the assignment. Not attempted,
  by instruction: stationary states, the weighted two-jump generator, time
  evolution, semigroup or derivative identities, convergence, positivity or
  complete positivity of any map, generic GKSL, entropy, circuits, and
  operations research. No novelty is claimed for any lemma here.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39 (see `evidence/dissipator/environment.json`). This is the user's
  physical workstation, not a container. Python 3.12.3.
- Lean toolchain: `leanprover/lean4:v4.34.0`, reported as
  `Lean (version 4.34.0, x86_64-unknown-linux-gnu, commit
  293d5d0c0c3f3dded4688b3ccd6a33939ac5102b, Release)`. Installed by
  `elan toolchain install leanprover/lean4:v4.34.0` from
  `https://releases.lean-lang.org/lean4/v4.34.0/lean-4.34.0-linux.tar.zst`
  (`evidence/dissipator/setup/toolchain-install.log`). The compiler commit
  equals the Stage 0 record. The archive checksum was not captured because
  elan streams and discards the archive; the Stage 0 record for the same URL
  is `caaa9835...b646b`.
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, checked out
  clean. Dependencies were materialized and the targeted cache fetched by the
  README command `lake exe cache get Mathlib.Analysis.Complex.Basic
  Mathlib.LinearAlgebra.Matrix.PosDef Mathlib.LinearAlgebra.Matrix.Trace
  Mathlib.Tactic.FinCases Mathlib.Tactic.NormNum` (2170 cached files,
  `evidence/dissipator/setup/cache-get.log`). The new module imports only
  modules inside that closure, so the README command list is unchanged.
- Other dependency commits and licenses: unchanged from Stage 0 and verified
  clean at their locked revisions: plausible `118aa17e`, LeanSearchClient
  `ddf04cf3`, importGraph `e928b725`, proofwidgets `106ff4fa`, aesop
  `355695d5`, Qq `6a489d9a`, batteries `f2effa3d`, Cli `e92c9f15` (full hashes
  in `lake-manifest.json` and in `verification.json`, key `dependencies`).
  Mathlib and these packages are Apache 2.0 upstream; nothing was copied
  from them or from QICLean.
- Exact clean-build commands and exit codes: the scripts ran three times,
  all recorded with per-command stdout/stderr and exit codes in
  `commands.json` next to each summary.
  1. Baseline reproduction before any source change:
     `python3 scripts/verify.py --output-dir evidence/dissipator/reproduction/verification`
     (exit 0, 25 commands all exit 0, status passed, `source_sha256`
     identical to `evidence/stage0/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir evidence/dissipator/reproduction/gate-tests`
     (exit 0, 15 cases passed).
  2. Final verification of the milestone source:
     `python3 scripts/verify.py --output-dir evidence/dissipator/verification`
     (exit 0, 26 commands all exit 0; the extra command is the explicit
     re-elaboration of the second release module) and
     `python3 scripts/test_verify.py --output-dir evidence/dissipator/gate-tests`
     (exit 0, 15 cases passed).
  3. Coverage control, expected to fail:
     `python3 scripts/verify.py --manifest <exports.json with the new module
     removed from release_modules> --output-dir evidence/dissipator/gate-controls/missing-module`
     (exit 1, reason `Release module coverage mismatch:
     unlisted=['FormalScience.OpenSystems.Dissipator']`).
  The 26 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and each of the eight other packages;
  `lake build FormalScience.Stage0 FormalScience.OpenSystems.Dissipator
  FormalScience`; `lake env lean FormalScience/Stage0.lean`;
  `lake env lean FormalScience/OpenSystems/Dissipator.lean`;
  `lake env lean Audit/Contracts.lean`; `lake env lean --json Signatures.lean`;
  `lake env lean --json AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, release modules
  `FormalScience.Stage0` and `FormalScience.OpenSystems.Dissipator`, 42
  exports (15 Stage 0, 27 new), 33 contract exports (10 Stage 0, 23 new).
  A source scan confirmed that all 27 declarations in the new module are
  listed and no listed name is absent.
- Raw log paths: `evidence/dissipator/setup/`,
  `evidence/dissipator/reproduction/{verification,gate-tests}/`,
  `evidence/dissipator/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `25-export-signatures.stdout.log` with
  `pp.explicit` types, `26-axiom-audit.stdout.log`),
  `evidence/dissipator/gate-tests/` (including the deliberately invalid
  fixtures), `evidence/dissipator/gate-controls/missing-module/`, and
  `evidence/dissipator/environment.json`. `evidence/stage0/` is unchanged.

## Statement review

All new declarations are in namespace `FormalScience.OpenSystems`, source
path `FormalScience/OpenSystems/Dissipator.lean`. Readable elaborated types
are quoted from `#check`; fully explicit types with universes are in
`evidence/dissipator/verification/25-export-signatures.stdout.log`.

### Definitions and conventions

| Declaration | Definition | Notes |
| --- | --- | --- |
| `dissipator` | `{n : Type u} → [Fintype n] → Matrix n n ℂ → Matrix n n ℂ → Matrix n n ℂ`, `dissipator V X := V * X * Vᴴ - (1 / 2 : ℂ) • (Vᴴ * V * X + X * Vᴴ * V)` | Exactly the contract formula; `ᴴ` is Mathlib `conjTranspose`; the one-half factor is an explicit complex scalar. `noncomputable` only because complex division has no executable code. |
| `dissipatorLinearMap` | `{n} → [Fintype n] → Matrix n n ℂ → (Matrix n n ℂ →ₗ[ℂ] Matrix n n ℂ)` with `toFun := dissipator V` | The bundled linear map is the plain definition plus the two linearity proofs; no second formula exists. |
| `jumpZeroToOne` | `QubitMatrix`, `Matrix.single 1 0 (1 : ℂ)` | `E_10 = |1><0|`, row 1, column 0. Moves population `0 -> 1`; carries rate `a` in the planned pilot (D003). |
| `jumpOneToZero` | `QubitMatrix`, `Matrix.single 0 1 (1 : ℂ)` | `E_01 = |0><1|`. Moves population `1 -> 0`; carries rate `b`. |

Conventions preserved: basis order `0, 1`; `QubitMatrix`, `IsDensity`,
`basisProjector`, `diagonalState`, and `krausMap` are untouched, and the ten
Stage 0 theorem signatures are unchanged (`FormalScience/Stage0.lean` hash
`b8022c56...c101f5` equals the Stage 0 evidence).

### General laws (arbitrary finite index type `n`, arbitrary `V`)

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `dissipator_add` | `D[V]` is additive in `X`. | `∀ {n} [Fintype n] (V X Y : Matrix n n ℂ), dissipator V (X + Y) = dissipator V X + dissipator V Y` | none beyond finiteness of `n` |
| `dissipator_smul` | `D[V]` is complex-homogeneous in `X`. | `∀ {n} [Fintype n] (V : Matrix n n ℂ) (c : ℂ) (X : Matrix n n ℂ), dissipator V (c • X) = c • dissipator V X` | none |
| `dissipatorLinearMap_apply` | The bundled map applies the defining formula. | `∀ {n} [Fintype n] (V X : Matrix n n ℂ), dissipatorLinearMap V X = dissipator V X` (proof `rfl`) | none |
| `dissipator_trace` | Every dissipator output is traceless. | `∀ {n} [Fintype n] (V X : Matrix n n ℂ), (dissipator V X).trace = 0` | none: `X` is not a density, `V` is arbitrary |
| `isHermitian_anticommutator` | The anticommutator of Hermitian matrices is Hermitian. | `∀ {n} [Fintype n] {A X : Matrix n n ℂ}, A.IsHermitian → X.IsHermitian → (A * X + X * A).IsHermitian` | both inputs Hermitian |
| `isSelfAdjoint_half` | One half is a real scalar. | `IsSelfAdjoint (1 / 2 : ℂ)`, i.e. `star (1 / 2 : ℂ) = 1 / 2` | none |
| `dissipator_isHermitian` | Hermiticity is preserved for every `V`. | `∀ {n} [Fintype n] (V : Matrix n n ℂ) {X : Matrix n n ℂ}, X.IsHermitian → (dissipator V X).IsHermitian` | only `X` Hermitian |

Proof routes, for the reviewer: the trace law is `Matrix.trace_mul_cycle`
on `V * X * Vᴴ`, `Matrix.mul_assoc` plus `Matrix.trace_mul_comm` on
`X * Vᴴ * V`, then `ring` on `t - (1/2) * (t + t) = 0`. Hermiticity is
`Matrix.isHermitian_mul_mul_conjTranspose V hX` for the first term,
`Matrix.isHermitian_conjTranspose_mul_self V` and the local anticommutator
lemma for the bracket, `Matrix.IsHermitian.smul` with `isSelfAdjoint_half`
for the scalar, and `Matrix.IsHermitian.sub`. Linearity is distributivity of
matrix multiplication (`mul_add`, `add_mul`, `Matrix.mul_smul`,
`Matrix.smul_mul`) followed by `abel` or `smul_comm`.

### Qubit specializations (consumers of the general laws)

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `jumpZeroToOne_conjTranspose` | `E_10ᴴ = E_01` | `jumpZeroToOneᴴ = jumpOneToZero` | none |
| `jumpOneToZero_conjTranspose` | `E_01ᴴ = E_10` | `jumpOneToZeroᴴ = jumpZeroToOne` | none |
| `jumpZeroToOne_conjTranspose_mul_self` | `E_10ᴴ E_10 = E_00` | `jumpZeroToOneᴴ * jumpZeroToOne = basisProjector 0` | none |
| `jumpOneToZero_conjTranspose_mul_self` | `E_01ᴴ E_01 = E_11` | `jumpOneToZeroᴴ * jumpOneToZero = basisProjector 1` | none |
| `jumpZeroToOne_mul_mul_conjTranspose` | `E_10 X E_10ᴴ = X_00 E_11` | `∀ (X : QubitMatrix), jumpZeroToOne * X * jumpZeroToOneᴴ = X 0 0 • basisProjector 1` | none |
| `jumpOneToZero_mul_mul_conjTranspose` | `E_01 X E_01ᴴ = X_11 E_00` | `∀ (X : QubitMatrix), jumpOneToZero * X * jumpOneToZeroᴴ = X 1 1 • basisProjector 0` | none |
| `dissipator_jumpZeroToOne_eq` | Closed form of `D[E_10]`. | `∀ X, dissipator jumpZeroToOne X = X 0 0 • basisProjector 1 - (1 / 2) • (basisProjector 0 * X + X * basisProjector 0)` | none |
| `dissipator_jumpOneToZero_eq` | Closed form of `D[E_01]`. | `∀ X, dissipator jumpOneToZero X = X 1 1 • basisProjector 0 - (1 / 2) • (basisProjector 1 * X + X * basisProjector 1)` | none |
| `dissipator_jumpZeroToOne_trace` | Trace law at `V = E_10`. | `∀ (X : QubitMatrix), (dissipator jumpZeroToOne X).trace = 0`; proof term `dissipator_trace jumpZeroToOne X` | none |
| `dissipator_jumpOneToZero_trace` | Trace law at `V = E_01`. | `∀ (X : QubitMatrix), (dissipator jumpOneToZero X).trace = 0`; proof term `dissipator_trace jumpOneToZero X` | none |
| `dissipator_jumpZeroToOne_isHermitian` | Hermiticity law at `V = E_10`. | `∀ {X : QubitMatrix}, X.IsHermitian → (dissipator jumpZeroToOne X).IsHermitian`; proof term `dissipator_isHermitian jumpZeroToOne hX` | `X` Hermitian |
| `dissipator_jumpOneToZero_isHermitian` | Hermiticity law at `V = E_01`. | `∀ {X : QubitMatrix}, X.IsHermitian → (dissipator jumpOneToZero X).IsHermitian`; proof term `dissipator_isHermitian jumpOneToZero hX` | `X` Hermitian |
| `jumpZeroToOne_not_isHermitian` | `E_10` is not Hermitian. | `¬ jumpZeroToOne.IsHermitian` | none |
| `jumpOneToZero_not_isHermitian` | `E_01` is not Hermitian. | `¬ jumpOneToZero.IsHermitian` | none |
| `dissipator_jumpZeroToOne_basisProjector_zero` | `D[E_10](E_00) = E_11 - E_00` | `dissipator jumpZeroToOne (basisProjector 0) = basisProjector 1 - basisProjector 0` | none |
| `dissipator_jumpOneToZero_basisProjector_one` | `D[E_01](E_11) = E_00 - E_11` | `dissipator jumpOneToZero (basisProjector 1) = basisProjector 0 - basisProjector 1` | none |

- Nontrivial witness / boundary cases: the two `not_isHermitian` theorems
  show the general laws are consumed at non-Hermitian `V`, as the contract
  demands; they are also not unitary (`E_10ᴴ E_10 = E_00 ≠ 1`, visible from
  `jumpZeroToOne_conjTranspose_mul_self` and Stage 0's
  `basisProjector_zero_ne_one`, though no separate theorem states
  non-unitarity). The convention witnesses show `D[E_10]` moves population
  from `0` to `1` with a positive sign on `E_11` and a negative sign on
  `E_00`, matching the planned `L(X)_11 = a X_00 + ...` component equation;
  a sign or direction error in the definition would have made these fail.
  The trace and Hermiticity laws are not vacuous: they hold on the concrete
  inputs `basisProjector 0` and `basisProjector 1`, and the closed forms show
  the output is nonzero there.
- Existing source matched or extended: Mathlib at the pin supplied every
  trace, adjoint, matrix-unit, and Hermitian-closure lemma used (list in
  DECISIONS.md D007). No Mathlib lemma on Hermiticity of an anticommutator
  was found, so it is proved locally. QICLean has generator-level material
  but was neither imported nor consulted for proof text; its snapshot was
  inspected in Stage 0 only.
- Any difference from the accepted contract: two deliberate choices, both
  recorded in DECISIONS.md D007. (a) The definition and the three general
  laws are stated for an arbitrary finite index type `n`, not only for
  `QubitMatrix`; the qubit case is exactly the specialization section, so
  the contract is satisfied and nothing is weakened. (b) Both the direct
  lemmas and the bundled linear map are provided, whereas the contract asked
  for either. In addition, the module contains results not required by the
  contract: the two closed forms, the two `not_isHermitian` witnesses, the
  two convention witnesses, and the two helper lemmas. None of these change
  any required statement.
- Downstream use: the closed forms and the bundled linear map are the
  intended inputs of the next candidate milestone, the weighted generator
  `a • D[E_10] + b • D[E_01]` and its component equations. The general-`n`
  statements are the intended inputs of the Markov bridge in the roadmap.
  Neither is started here.

## Trust evidence

- Transitive axiom output for every exported theorem: all 42 exports,
  including the four new definitions, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/dissipator/verification/26-axiom-audit.stdout.log`, parsed
  into `verification.json` key `axioms`; one report per export, no
  duplicates, no missing reports).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or `implemented_by`.
  The `noncomputable` markers on two definitions are code-generation
  attributes, not trust assumptions, and do not appear in axiom reports.
- Every release module actually compiled: `lake build FormalScience.Stage0
  FormalScience.OpenSystems.Dissipator FormalScience` completed (2189 jobs,
  of which the local modules are the last three; the remainder are cached
  dependency artifacts and must not be described as newly proved modules),
  followed by explicit `lake env lean` re-elaboration of both release
  sources and of `Audit/Contracts.lean`. The umbrella reaches both modules;
  the coverage control shows the gate fails if the new module is omitted.
- Validation gate fixture results: 15 of 15 cases passed with their expected
  outcomes (`evidence/dissipator/gate-tests/gate_tests.json`), identical in
  kind to Stage 0: allowed-control, allowed-propext, direct-axiom,
  transitive-axiom, sorry-proof, missing-export, false-premise-axiom-control,
  signature-control, signature-false-premise, and the six parser cases.
  The scripts are byte-identical to the audited Stage 0 versions
  (`scripts/verify.py` `9a6d01e5...ad757`, `scripts/test_verify.py`
  `44dddfe2...2d596`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `4e668b999760eed3ab01b5cbb41cba273180996c06ebf54218794ea367842547`;
  `FormalScience.lean` `3bd6beee423f1b590d16cf25e5e83589413a22565fe50505333217f77fb1445d`;
  `Audit/Contracts.lean` `664584326bb64639f376aca05ec98af99440b7db44b1fd6aba27e32ade7bacc0`;
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`.
- Semantic review decision: self-review by the implementer only. The
  elaborated types were read against the informal contract, quantifier by
  quantifier, and the independent contract file restates each conclusion
  with the formula, `ᴴ`, and matrix units spelled out. The independent audit
  decision is pending and is the purpose of this handoff.

## Blockers and next step

- Exact unresolved goal or API problem: none. The only compile-time issue
  encountered was Lean's refusal to generate executable code for a definition
  using complex division; marking `dissipator` and `dissipatorLinearMap`
  `noncomputable` resolved it without touching any statement.
- Approaches already tried: none abandoned. Every lemma compiled on its
  first or second attempt using the Mathlib names listed in D007.
- Proposed bounded next task (for the audit to confirm or replace): the
  weighted two-jump generator `L(X) = a • D[E_10](X) + b • D[E_01](X)` with
  real rates, its four component equations, and `L(diagonalState (a/(a+b)))
  = 0` under `0 ≤ a`, `0 ≤ b`, `0 < a + b`. Uniqueness and the degenerate
  rate cases belong to the same or the following turn per ROADMAP Cycle B.
  The closed forms in this module are the intended inputs.
- Changes requiring a contract decision: (a) accept the general-`n`
  statement of the definition and laws (D007); (b) accept that both direct
  lemmas and the bundled linear map are exported; (c) accept the eight
  additional declarations beyond the minimum, or ask for their removal from
  the export list; (d) accept D008's evidence and manifest conventions,
  including that `SOURCE_MANIFEST.json` now covers every tracked file except
  itself and that `docs/PORTFOLIO_ROADMAP.md` duplicates the research plan.
  No validation-script change is proposed; the scripts are unchanged.
- Suggested reviewer focus: confirm `Matrix.single 1 0 1` is the intended
  `E_10 = |1><0|` under the row-then-column reading and matches D003's rate
  direction; read the `dissipator` definition character by character against
  the contract formula, in particular the parenthesization `X * Vᴴ * V`
  meaning `(X * Vᴴ) * V`; confirm that `dissipator_isHermitian` quantifies
  `V` explicitly and universally with no hypothesis; and confirm the contract
  file restatements in `Audit/Contracts.lean` are the statements you intended,
  since the gate only checks that they compile and mention each export by
  name.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
