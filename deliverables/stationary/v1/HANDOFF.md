# Stage audit handoff: two-state stationary pilot

Completed from AUDIT_HANDOFF_TEMPLATE.md on 20 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/stationary/v1/`; nothing is asserted from an editor state.

## Scope

- Stage and accepted contract IDs: implementation round 2, milestone
  `stationary`, round `v1`, as specified in the root `NEXT_FABLE_TASK.md`
  received with the dissipator audit (`audits/dissipator/v1/`). Required:
  the weighted generator with a direct formula theorem; the four entry
  equations, trace annihilation, and Hermiticity preservation for arbitrary
  real rates and arbitrary complex `X`; the candidate
  `rhoStar(a,b) = diagonalState (a/(a+b))` with its diagonal presentation,
  stationarity, and trace-one algebraic uniqueness under only `a + b ≠ 0`;
  density validity and the unique stationary density under `0 ≤ a`,
  `0 ≤ b`, `0 < a + b`; and the four boundary cases. Also required first:
  record the dissipator acceptance and close findings F1 to F4.
- Commit under review: the commit tagged `stationary-milestone-v1`, whose
  tree contains this document. Obtain its hash with
  `git rev-parse stationary-milestone-v1^{commit}`; it is also recorded in
  `deliverables/stationary/v1/RECEIPT.json`, committed after the tag, and in
  the delivery message. Diff base: the accepted dissipator commit
  `be2ad90088b3c407d2aa18aafe3a2e806db35011`. Between them sits the
  housekeeping commit `26cd50698d171ed939310cd0289ce91257996282`, which
  stored the audit return, replaced the active assignment, and closed F1 to
  F4 without touching proof source. The accepted tag
  `dissipator-milestone-v1` was not moved.
- What is complete: all required results, in one new release module
  `FormalScience/OpenSystems/TwoStateStationary.lean` (30 public
  declarations: 2 definitions, 28 theorems; one `private` arithmetic lemma).
  Umbrella, export manifest (72 exports), and independent contracts (61
  theorem contracts) cover every new public declaration. Both validation
  scripts pass on the final source; the accepted 42-export baseline was
  reproduced before any source change. F1 to F4 are closed in `AGENTS.md`,
  D008, and D009; the dissipator acceptance is recorded in `TURNS.md`.
- What is explicitly incomplete: nothing from the assignment. Not attempted,
  by instruction: dynamics, matrix exponentials, semigroups, derivatives,
  convergence, norm estimates, channels, complete positivity, generic GKSL,
  the Markov bridge, entropy, circuits, OR; also the optional refinements
  (full kernel classification, faithfulness, rank-one theorem, square-root
  jump representation). The signed-rate cancellation warning is recorded in
  D010 and is not formalized, as permitted.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/stationary/v1/environment.json`).
  The user's workstation, as in the dissipator round.
- Lean toolchain: `leanprover/lean4:v4.34.0`, reported as
  `Lean (version 4.34.0, x86_64-unknown-linux-gnu, commit
  293d5d0c0c3f3dded4688b3ccd6a33939ac5102b, Release)`. Same installation as
  the dissipator round (`evidence/dissipator/setup/`). The release archive
  checksum was measured independently by the auditor
  (`audits/dissipator/v1/evidence/setup/toolchain-checksum.json`,
  `caaa9835...b646b`); no new workstation measurement was made.
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, clean. Same
  targeted cache as before; the new module imports only modules inside the
  README closure (`Mathlib.Tactic.FieldSimp`, `LinearCombination`, and
  `Linarith` are already present), so the README cache command is unchanged.
- Other dependency commits and licenses: unchanged and verified clean at
  their locked revisions. Licenses per the audited inventory
  (`audits/dissipator/v1/evidence/dependency_license_inventory.json`):
  mathlib, plausible, LeanSearchClient, importGraph, proofwidgets, aesop,
  Qq, batteries are Apache 2.0 at their package roots; Cli `e92c9f15` is
  MIT. Nothing was copied from any dependency or downstream project.
- Exact clean-build commands and exit codes:
  1. Baseline reproduction before source changes (working tree at
     `26cd506`): `python3 scripts/verify.py --output-dir
     evidence/stationary/v1/reproduction/verification` (exit 0; 26 commands
     all exit 0; 42 exports; `source_sha256` identical to
     `evidence/dissipator/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir
     evidence/stationary/v1/reproduction/gate-tests` (exit 0; 15 cases).
  2. Final verification: `python3 scripts/verify.py --output-dir
     evidence/stationary/v1/verification` (exit 0; 27 commands all exit 0)
     and `python3 scripts/test_verify.py --output-dir
     evidence/stationary/v1/gate-tests` (exit 0; 15 cases).
  3. Coverage control, expected to fail: `python3 scripts/verify.py
     --manifest evidence/stationary/v1/gate-controls/missing-module/omitted-module.json
     --output-dir evidence/stationary/v1/gate-controls/missing-module`
     (exit 1; reason `Release module coverage mismatch:
     unlisted=['FormalScience.OpenSystems.TwoStateStationary']`). The
     altered manifest is retained as the control's input fixture, per the
     assignment.
  The 27 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and the eight other packages;
  `lake build FormalScience.Stage0 FormalScience.OpenSystems.Dissipator
  FormalScience.OpenSystems.TwoStateStationary FormalScience`;
  `lake env lean` on the three release sources and on
  `Audit/Contracts.lean`; `lake env lean --json Signatures.lean`;
  `lake env lean --json AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, three release
  modules, 72 exports (15 Stage 0, 27 dissipator, 30 stationary), 61
  contract exports (10, 23, 28). A source scan confirmed every public
  declaration of the new module is listed and no listed name is absent.
- Raw log paths: `evidence/stationary/v1/reproduction/{verification,gate-tests}/`,
  `evidence/stationary/v1/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `27-export-signatures.stdout.log` with `pp.explicit`
  types, `28-axiom-audit.stdout.log`), `evidence/stationary/v1/gate-tests/`
  (with the deliberately invalid fixtures),
  `evidence/stationary/v1/gate-controls/missing-module/` (with
  `omitted-module.json` and `control-stderr.log`), and
  `evidence/stationary/v1/environment.json`. `evidence/stage0/` and
  `evidence/dissipator/` are unchanged.

## Statement review

All new declarations are in namespace `FormalScience.OpenSystems`, source
path `FormalScience/OpenSystems/TwoStateStationary.lean`. Readable types
below are quoted from `#check`; fully explicit types are in
`evidence/stationary/v1/verification/27-export-signatures.stdout.log`.
`↑a` denotes the cast `(a : ℂ)` of a real rate.

### Definitions and conventions

| Declaration | Definition | Notes |
| --- | --- | --- |
| `generator` | `ℝ → ℝ → (QubitMatrix →ₗ[ℂ] QubitMatrix)`, `generator a b := (a : ℂ) • dissipatorLinearMap jumpZeroToOne + (b : ℂ) • dissipatorLinearMap jumpOneToZero` | Rate `a` weights `E_10` (population `0 -> 1`), rate `b` weights `E_01`; Hamiltonian zero; basis order `0, 1`. Bundled linear map, the contract's first option. `noncomputable` for the same complex-division reason as `dissipator`. |
| `rhoStar` | `ℝ → ℝ → QubitMatrix`, `rhoStar a b := diagonalState (a / (a + b))` | `diagonalState q = diag(1 - q, q)` with `q` the population of state `1`, unchanged from Stage 0. Total division gives a value at `a + b = 0`; no theorem claims anything there. |

Conventions preserved: all Stage 0 and dissipator declarations and their
signatures are unchanged (`FormalScience/Stage0.lean` hash `b8022c56...`,
`FormalScience/OpenSystems/Dissipator.lean` hash `abaec0a4...`, identical to
the accepted evidence).

### Helpers

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `isSelfAdjoint_ofReal` | A real cast is self-adjoint in `ℂ`. | `∀ (r : ℝ), IsSelfAdjoint (↑r : ℂ)` | none |
| `qubitMatrix_ext` | Four equal entries give equal qubit matrices. | `∀ {A B : QubitMatrix}, A 0 0 = B 0 0 → A 0 1 = B 0 1 → A 1 0 = B 1 0 → A 1 1 = B 1 1 → A = B` | the four entry equalities |

### Generator contracts (arbitrary real `a`, `b`; arbitrary complex `X`)

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `generator_apply` | Weighted formula. | `∀ (a b : ℝ) (X : QubitMatrix), generator a b X = ↑a • dissipator jumpZeroToOne X + ↑b • dissipator jumpOneToZero X` (proof `rfl`) | none |
| `generator_apply_zero_zero` | `L(X)_00 = -a X_00 + b X_11` | `∀ (a b : ℝ) (X), generator a b X 0 0 = -↑a * X 0 0 + ↑b * X 1 1` | none |
| `generator_apply_one_one` | `L(X)_11 = a X_00 - b X_11` | `∀ (a b : ℝ) (X), generator a b X 1 1 = ↑a * X 0 0 - ↑b * X 1 1` | none |
| `generator_apply_zero_one` | `L(X)_01 = -(a+b)/2 X_01` | `∀ (a b : ℝ) (X), generator a b X 0 1 = -(↑(a + b) / 2) * X 0 1` | none |
| `generator_apply_one_zero` | `L(X)_10 = -(a+b)/2 X_10` | `∀ (a b : ℝ) (X), generator a b X 1 0 = -(↑(a + b) / 2) * X 1 0` | none |
| `generator_trace` | `trace(L(X)) = 0` | `∀ (a b : ℝ) (X), Matrix.trace (generator a b X) = 0` | none |
| `generator_isHermitian` | Hermiticity preserved. | `∀ (a b : ℝ) {X}, X.IsHermitian → (generator a b X).IsHermitian` | only `X` Hermitian |

Proof routes: the entries follow from the accepted closed forms
`dissipator_jumpZeroToOne_eq` and `dissipator_jumpOneToZero_eq` by
`Matrix.diagonal_mul`, `Matrix.mul_diagonal`, and `ring`; trace and
Hermiticity are inherited from `dissipator_trace` and
`dissipator_isHermitian` through `Matrix.trace_smul` and
`Matrix.IsHermitian.smul` with `isSelfAdjoint_ofReal`.

### Stationary contracts

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `rhoStar_eq_diagonal` | `rhoStar = diag(b/(a+b), a/(a+b))` | `∀ (a b : ℝ), a + b ≠ 0 → rhoStar a b = Matrix.diagonal ![↑(b / (a + b)), ↑(a / (a + b))]` | `a + b ≠ 0` |
| `rhoStar_apply_zero_zero` | entry `(0,0)` | `∀ (a b : ℝ), a + b ≠ 0 → rhoStar a b 0 0 = ↑(b / (a + b))` | `a + b ≠ 0` |
| `rhoStar_apply_one_one` | entry `(1,1)` | `∀ (a b : ℝ), rhoStar a b 1 1 = ↑(a / (a + b))` | none |
| `rhoStar_apply_zero_one`, `rhoStar_apply_one_zero` | coherences vanish | `∀ (a b : ℝ), rhoStar a b 0 1 = 0`, `... 1 0 = 0` | none |
| `generator_rhoStar` | stationarity | `∀ (a b : ℝ), a + b ≠ 0 → generator a b (rhoStar a b) = 0` | `a + b ≠ 0` |
| `generator_eq_zero_iff_of_trace_eq_one` | algebraic uniqueness | `∀ (a b : ℝ), a + b ≠ 0 → ∀ (X : QubitMatrix), Matrix.trace X = 1 → (generator a b X = 0 ↔ X = rhoStar a b)` | `a + b ≠ 0`, `trace X = 1`; `X` arbitrary complex |
| `rhoStar_isDensity` | candidate is a density | `∀ (a b : ℝ), 0 ≤ a → 0 ≤ b → 0 < a + b → IsDensity (rhoStar a b)` | physical hypotheses |
| `isDensity_generator_eq_zero_iff` | density iff | `∀ (a b : ℝ), a + b ≠ 0 → ∀ {ρ}, IsDensity ρ → (generator a b ρ = 0 ↔ ρ = rhoStar a b)` | `a + b ≠ 0`, density |
| `existsUnique_stationary_density` | unique existence | `∀ (a b : ℝ), 0 ≤ a → 0 ≤ b → 0 < a + b → ∃! ρ, IsDensity ρ ∧ generator a b ρ = 0` | physical hypotheses |

Proof route for uniqueness: from `L X = 0` the entries `(0,1)` and `(1,0)`
give `-(↑(a+b)/2) * X_01 = 0` and likewise for `X_10`; since
`↑(a+b)/2 ≠ 0` (from `a + b ≠ 0` by `Complex.ofReal_ne_zero` and
`div_ne_zero`), `mul_eq_zero` forces both coherences to zero. The `(0,0)`
entry gives `-↑a X_00 + ↑b X_11 = 0`; with `Matrix.trace_fin_two` and
`trace X = 1`, `linear_combination` yields `X_11 (↑a + ↑b) = ↑a` and
`X_00 (↑a + ↑b) = ↑b`, hence the diagonal of `rhoStar` by `eq_div_iff`.
`qubitMatrix_ext` assembles the four entries. The unknown `X` is never
assumed diagonal, Hermitian, or positive. Density validity is
`div_nonneg` and `div_le_one₀` fed to the audited `diagonalState_isDensity`.

### Boundary cases

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `rhoStar_zero_left` | `a = 0`: candidate is `E_00` | `∀ (b : ℝ), rhoStar 0 b = basisProjector 0` | none (`0 / x = 0` for every `x`) |
| `isDensity_generator_zero_left_eq_zero_iff` | `a = 0`, `b > 0`: unique stationary density is `E_00` | `∀ (b : ℝ), 0 < b → ∀ {ρ}, IsDensity ρ → (generator 0 b ρ = 0 ↔ ρ = basisProjector 0)` | `0 < b`, density |
| `rhoStar_zero_right` | `b = 0`: candidate is `E_11` | `∀ (a : ℝ), a ≠ 0 → rhoStar a 0 = basisProjector 1` | `a ≠ 0` |
| `isDensity_generator_zero_right_eq_zero_iff` | `a > 0`, `b = 0`: unique stationary density is `E_11` | `∀ (a : ℝ), 0 < a → ∀ {ρ}, IsDensity ρ → (generator a 0 ρ = 0 ↔ ρ = basisProjector 1)` | `0 < a`, density |
| `generator_zero_zero` | `a = b = 0`: generator vanishes | `∀ (X : QubitMatrix), generator 0 0 X = 0` | none |
| `generator_zero_zero_of_isDensity` | every density is stationary | `∀ {ρ}, IsDensity ρ → generator 0 0 ρ = 0` | density (unused by the proof; literal contract line) |
| `not_existsUnique_stationary_density_zero_zero` | unique existence fails | `¬ ∃! ρ, IsDensity ρ ∧ generator 0 0 ρ = 0` | none; witnesses `basisProjector 0 ≠ basisProjector 1` |
| `rhoStar_same` | `a = b = r ≠ 0`: maximally mixed | `∀ (r : ℝ), r ≠ 0 → rhoStar r r = diagonalState (1 / 2)` | `r ≠ 0` |
| `isDensity_generator_same_eq_zero_iff` | `a = b = r > 0`: unique stationary density | `∀ (r : ℝ), 0 < r → ∀ {ρ}, IsDensity ρ → (generator r r ρ = 0 ↔ ρ = diagonalState (1 / 2))` | `0 < r`, density; no `a ≠ b` premise anywhere |

- Nontrivial witness / boundary cases: the physical hypotheses are
  satisfiable (any `a, b ≥ 0` not both zero); `basisProjector 0` and
  `basisProjector 1` from Stage 0 are the distinct densities that refute
  uniqueness at `a = b = 0`; the one-zero-rate results show uniqueness does
  not need faithfulness, since the unique stationary density is a rank-one
  projector there. The signed-rate trap (`a = 1`, `b = -1`, where
  `L(X)_00 = -trace X`) is recorded in D010 as a specification warning and
  is respected by keeping `a + b ≠ 0` on every theorem that needs it.
- Existing source matched or extended: everything reused from Mathlib is
  listed in D010; the audited `diagonalState_isDensity`,
  `diagonalState_zero`, `diagonalState_one`, `basisProjector_isDensity`,
  `basisProjector_zero_ne_one`, and the dissipator closed forms and laws are
  consumed directly. No downstream source was consulted or copied.
- Any difference from the accepted contract, all recorded in D010:
  (a) `isDensity_generator_eq_zero_iff` is exported under only `a + b ≠ 0`
  rather than the listed physical hypotheses; this is strictly stronger and
  the assignment asked to keep nonnegativity off the algebraic helpers.
  (b) `rhoStar_zero_left` needs no hypothesis on `b` and `rhoStar_same`
  needs only `r ≠ 0`; the uniqueness specializations carry the physical
  `0 < b`, `0 < a`, `0 < r`. (c) `generator_zero_zero_of_isDensity` carries
  an unused density hypothesis because it restates the contract line
  literally; `generator_zero_zero` is the stronger statement. (d) Two
  reusable helpers (`isSelfAdjoint_ofReal`, `qubitMatrix_ext`) and four
  `rhoStar` entry lemmas are exported beyond the contract's list. (e) No
  separate `generator_add`/`generator_smul` are exported; linearity is the
  bundled map's `map_add`/`map_smul`, as the assignment allowed.
- Downstream use: the generator, entry equations, `rhoStar`, and the
  unique-existence endpoint are the inputs of a future dynamics milestone
  (explicit channel, semigroup, convergence to `rhoStar`), which is not
  started.

## Trust evidence

- Transitive axiom output for every exported theorem: all 72 exports,
  including the two new definitions, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/stationary/v1/verification/28-axiom-audit.stdout.log`, parsed
  into `verification.json` key `axioms`; one report per export).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or
  `implemented_by`. `noncomputable` markers are code-generation attributes.
- Every release module actually compiled: `lake build` of the three release
  modules and the umbrella (2190 jobs, the local modules being the last four;
  the rest are cached dependency artifacts), followed by explicit `lake env
  lean` re-elaboration of the three release sources and of
  `Audit/Contracts.lean`. The coverage control shows the gate fails if the
  new module is omitted.
- Validation gate fixture results: 15 of 15 cases passed with their expected
  outcomes (`evidence/stationary/v1/gate-tests/gate_tests.json`). The
  scripts are byte-identical to the accepted versions (`scripts/verify.py`
  `9a6d01e5...`, `scripts/test_verify.py` `44dddfe2...`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `9dc6d4ab4675483dbb5456d96cfe5410c4ca696b80052cf592452ad04fd52a37`;
  `FormalScience.lean` `b449c56cc9ba8eb837c3b51902d5e513be7a6ea6f4d92f92f42622df26b4d06a`;
  `Audit/Contracts.lean` `3d6dcd2bda1e71c20768f5d7c97f2419d3c9da4130689ed085f0d29ffe1b8aa6`;
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`;
  `FormalScience/OpenSystems/TwoStateStationary.lean` `f5af6d980671d19a8388168441319d2e03a89c93b5cba61d32474690a1e0155e`.
- Semantic review decision: self-review by the implementer only. Every
  elaborated type was read against the contract; the contract file restates
  the generator as the weighted matrix-unit formula, the candidate as the
  explicit diagonal, and densities as Mathlib PSD plus trace one, and
  applies uniqueness to an arbitrary trace-one complex matrix. The
  independent audit decision is pending.

## Blockers and next step

- Exact unresolved goal or API problem: none. Every declaration compiled on
  the first attempt with the Mathlib names listed in D010.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): the
  dynamics pilot of the roadmap, that is the explicit time-evolution maps
  `Phi_t` on all matrices with `s = exp(-(a+b) t)`, the identities
  `Phi_0 = Id` and `Phi_(t+u) = Phi_t ∘ Phi_u`, the four-Kraus
  representation proving complete positivity and trace preservation through
  the Stage 0 Kraus API, and the derivative identity; convergence in an
  explicitly named norm as a separate gate. `rhoStar` and the entry
  equations of this module are the intended inputs.
- Changes requiring a contract decision: (a) accept the `a + b ≠ 0`
  strengthening of the density iff; (b) accept the minimal hypotheses on
  the two candidate identities; (c) accept or remove the literal
  `generator_zero_zero_of_isDensity`; (d) accept the six extra exported
  helpers and entry lemmas; (e) confirm the dynamics pilot, or another
  milestone, as the next assignment. No validation-script change is
  proposed; the scripts are unchanged.
- Suggested reviewer focus: check the sign and direction conventions in the
  entry equations against D003 (rate `a` on `E_10` moves population from
  `0` to `1`, so `L(X)_11` gains `+a X_00`); confirm that
  `generator_eq_zero_iff_of_trace_eq_one` quantifies `X` over all complex
  matrices with only the trace hypothesis; confirm the boundary theorems
  carry no hidden faithfulness or unequal-rate premise; and read the `Lw`
  and `Rho` abbreviations at the top of the stationary section of
  `Audit/Contracts.lean`, since the entry contracts rely on them.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
