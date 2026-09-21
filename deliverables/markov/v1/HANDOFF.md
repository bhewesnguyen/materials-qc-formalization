# Stage audit handoff: finite Markov generator bridge, zero Hamiltonian

Completed from AUDIT_HANDOFF_TEMPLATE.md on 21 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/markov/v1/`; nothing is asserted from an editor state.

## Scope

- Stage and accepted contract IDs: implementation round 6, milestone
  `markov`, round `v1`, the Stage 4 extension issued with the convergence
  audit (`audits/convergence/v1/NEXT_FABLE_TASK.md`, copied unchanged to the
  root slot with a status note). Required: record the convergence
  acceptance with C1 and C2 and the D016 erratum; reproduce the accepted
  187-export baseline; then prove, on an arbitrary finite index type with
  destination-first real rates and ignored diagonal entries, contract A
  (rate matrix entries, zero column sums, the real `mulVec` action, mass
  conservation, physical nonnegativity), contract B (generator entry
  formulas, trace annihilation, Hermiticity preservation), contract C (the
  diagonal bridge with explicit coercion and the stationary `iff`),
  contract D (probability-vector and stationary-density consumers), and
  contract E (zero rates, ignored diagonal rates, and recovery of the
  accepted two-state generator on `Fin 2`).
- Commit under review: the commit tagged `markov-milestone-v1`, whose tree
  contains this document. Its hash is `git rev-parse
  markov-milestone-v1^{commit}`; it is also recorded in
  `deliverables/markov/v1/RECEIPT.json`, committed after the tag, and in
  the delivery message. Diff base: the accepted convergence commit
  `a3cbac0692b4c106a89e80c91d18b0c2de4988cd`. Between them sit the
  convergence receipt commit `754c08b` and the housekeeping commit
  `053683c`, which integrated the audit return, activated the assignment,
  recorded D017 and D018, and began tracking the user's scope memo, without
  touching proof source. The accepted tags `dissipator-milestone-v1`,
  `stationary-milestone-v1`, `evolution-milestone-v1`, `kraus-milestone-v1`,
  and `convergence-milestone-v1` were not moved.
- What is complete: all required results and the optional diagonal-rate
  corollaries, in one new release module
  `FormalScience/OpenSystems/FiniteMarkovBridge.lean` (3 definitions, 26
  theorems; one `private` helper). Umbrella, export manifest (216 exports),
  and independent contracts (193 theorem contracts) cover every new public
  declaration; the manual source-to-export and theorem-to-contract
  inventory is recorded in `evidence/markov/v1/inventory/`. Both validation
  scripts pass on the final source. The one comment-only change to accepted
  source (the C1 header fix in `TwoStateConvergence.lean`) was made after the
  baseline reproduction, with hashes recorded below.
- What is explicitly incomplete: nothing from the assignment. Not
  attempted, by instruction: matrix exponentials, classical or quantum
  transition semigroups, probability preservation over time, positivity or
  complete positivity of `Id + t • L_q`, irreducibility, Perron-Frobenius,
  mixing, detailed balance, stationary uniqueness, classification of
  non-diagonal stationary matrices, any Hamiltonian term, and every other
  portfolio branch. The stationary equivalence concerns diagonal inputs
  only.
- Deviation to note for the auditor: at the user's decision, the personal
  scope memo reviewed with the convergence audit is now tracked as
  `docs/SCOPE_MEMO.md`, with the review's seven corrections applied, so it
  ships in this archive. It is a planning note, not a release artifact: it
  is outside `exports.json` and the gate and claims no theorem (D018). The
  issued assignment asked that it not be modified or committed as part of
  the milestone; the user chose to track it for their own bookkeeping, and
  D018 records that decision.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/markov/v1/environment.json`); the
  user's workstation.
- Lean toolchain: `leanprover/lean4:v4.34.0`, `Lean (version 4.34.0,
  x86_64-unknown-linux-gnu, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b,
  Release)`; the same installation as the previous rounds. The release
  archive checksum was measured by the auditor (`caaa9835...b646b`).
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, clean. The
  new module imports `Mathlib.Data.Matrix.Basis`,
  `Mathlib.LinearAlgebra.Matrix.PosDef`, `Mathlib.LinearAlgebra.Matrix.Trace`,
  `Mathlib.Analysis.Complex.Order`, `Mathlib.Basic.Complex.BigOperators`, and
  `Mathlib.Tactic.FinCases`, all already inside the cached closure of the
  README command; no cache extension and no pin change this round.
- Other dependency commits and licenses: unchanged and verified clean at
  their locked revisions; eight package roots Apache 2.0 and `Cli` MIT, per
  `audits/dissipator/v1/evidence/dependency_license_inventory.json`. No
  externally authored proof text was adopted this round; the auditor's API
  route list (`audits/convergence/v1/evidence/next_scope_and_api_notes.md`)
  was confirmed name by name at the pin (D019).
- Exact clean-build commands and exit codes:
  1. Baseline reproduction before any source change (tree at `053683c`):
     `python3 scripts/verify.py --output-dir evidence/markov/v1/reproduction/verification`
     (exit 0; 31 commands all exit 0; 187 exports; `source_sha256` identical
     to `evidence/convergence/v1/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir evidence/markov/v1/reproduction/gate-tests`
     (exit 0; 15 cases).
  2. Final verification: `python3 scripts/verify.py --output-dir
     evidence/markov/v1/verification` (exit 0; 32 commands all exit 0) and
     `python3 scripts/test_verify.py --output-dir evidence/markov/v1/gate-tests`
     (exit 0; 15 cases).
  3. Gate controls, expected to fail, each with its altered manifest
     retained: `evidence/markov/v1/gate-controls/missing-module/`
     (`omitted-module.json`; exit 1, `Release module coverage mismatch:
     unlisted=['FormalScience.OpenSystems.FiniteMarkovBridge']`) and
     `evidence/markov/v1/gate-controls/unmentioned-contract-export/`
     (`unmentioned-export.json`, listing a nonexistent
     `markovGenerator_unmentioned` as an export and contract export; exit 1,
     `Contract file does not mention these fully qualified exports`). Both
     reject before the build step.
  4. Manual declaration inventory: `evidence/markov/v1/inventory/declaration_inventory.json`
     scans all eight release modules; 216 public declarations (193 theorems,
     23 definitions), 7 private helpers, no unlisted public declaration, no
     theorem without a fully qualified consumer mention, no export absent
     from source. The scan aids the human review the verifier deliberately
     does not automate; it is not a gate and the verifier is unchanged.
  The 32 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and the eight other packages;
  `lake build` of the eight release modules and the umbrella; `lake env
  lean` on the eight release sources and on `Audit/Contracts.lean`;
  `lake env lean --json Signatures.lean`; `lake env lean --json
  AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, eight release
  modules, 216 exports (15 Stage 0, 27 dissipator, 30 stationary, 43
  evolution, 6 generic Kraus, 37 two-state Kraus, 29 convergence, 29
  Markov), 193 contract exports (10, 23, 28, 39, 5, 34, 28, 26).
- Raw log paths: `evidence/markov/v1/reproduction/{verification,gate-tests}/`,
  `evidence/markov/v1/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `31-export-signatures.stdout.log` with `pp.explicit`
  types, and `32-axiom-audit.stdout.log`; the run has 32 commands so these
  numbers are correct for this round), `evidence/markov/v1/gate-tests/`,
  `evidence/markov/v1/gate-controls/{missing-module,unmentioned-contract-export}/`,
  `evidence/markov/v1/inventory/`, and `evidence/markov/v1/environment.json`.
  All earlier evidence trees are unchanged.

## Statement review

All declarations are in namespace `FormalScience.OpenSystems`, source path
`FormalScience/OpenSystems/FiniteMarkovBridge.lean`, over `{n : Type*}` with
`[Fintype n] [DecidableEq n]` bound per declaration. Readable types are
quoted from `#check`; fully explicit types are in the signature log. `↑x`
is the cast of a real into `ℂ`; `E_ij = Matrix.single i j (1 : ℂ)`; `r_j =
exitRate q j`; `Q = rateMatrix q`; `L_q = markovGenerator q`; `diag ↑p =
Matrix.diagonal fun i => (p i : ℂ)`.

### Definitions and conventions

| Declaration | Definition | Notes |
| --- | --- | --- |
| `exitRate` | `exitRate q j := ∑ i, if i = j then 0 else q i j` | destination first: `q i j` is the rate from `j` to `i`; the diagonal entry is excluded literally |
| `rateMatrix` | `rateMatrix q := Matrix.of fun i j => if i = j then -exitRate q j else q i j` | column `j` carries the rates out of `j`; `q j j` never enters |
| `markovGenerator` | `markovGenerator q := ∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipatorLinearMap (Matrix.single i j 1)` | bundled `Matrix n n ℂ →ₗ[ℂ] Matrix n n ℂ`; `noncomputable`; `H = 0` |

Conventions preserved: `Matrix.mulVec` for the column action `Q p`; the
accepted `dissipator`, `dissipatorLinearMap`, `generator`, `IsDensity`,
`qubitMatrix_ext` reused unchanged; on `Fin 2`, `a` is the `0 → 1` rate
`q 1 0` and `b` the `1 → 0` rate `q 0 1`, matching the accepted
`jumpZeroToOne = E_10`. All seven previously accepted release modules are
byte-identical to the accepted versions except the C1 comment in
`TwoStateConvergence.lean` (hashes below).

### Contract A: the classical rate matrix (arbitrary signed `q` unless stated)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `exitRate_def` | `exitRate q j = ∑ i, if i = j then 0 else q i j` (proof `rfl`) | none |
| `rateMatrix_apply_of_ne` | `i ≠ j → Q i j = q i j` | none |
| `rateMatrix_apply_diag` | `Q j j = -r_j` | none |
| `rateMatrix_sum_col` | `∑ i, Q i j = 0` | none |
| `rateMatrix_mulVec_apply` | `(Q.mulVec p) i = (∑ j, if i = j then 0 else q i j * p j) - r_i * p i` | none |
| `sum_rateMatrix_mulVec` | `∑ i, (Q.mulVec p) i = 0` | none |
| `exitRate_nonneg` | `0 ≤ r_j` | `∀ i j, i ≠ j → 0 ≤ q i j` |
| `rateMatrix_nonneg_of_ne` | `i ≠ j → 0 ≤ Q i j` | `∀ i j, i ≠ j → 0 ≤ q i j` |

### Contract B: the quantum generator (every complex `X`, arbitrary signed `q`)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `dissipator_single` | `dissipator E_ij X = Matrix.single i i (X j j) - (1/2 : ℂ) • (E_jj * X + X * E_jj)` | none |
| `markovGenerator_apply` | `L_q X = ∑ j, ∑ i, ((if i = j then 0 else q i j : ℝ) : ℂ) • dissipator E_ij X` | none |
| `markovGenerator_apply_diag` | `L_q X i i = (∑ j, if i = j then 0 else ↑(q i j) * X j j) - ↑r_i * X i i` | none |
| `markovGenerator_apply_of_ne` | `i ≠ j → L_q X i j = -↑((r_i + r_j) / 2) * X i j` | none |
| `markovGenerator_trace` | `Matrix.trace (L_q X) = 0` | none |
| `markovGenerator_isHermitian` | `X.IsHermitian → (L_q X).IsHermitian` | Hermitian input only |

### Contract C: the diagonal bridge (every real `p`, arbitrary signed `q`)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `markovGenerator_diagonal` | `L_q (diag ↑p) = Matrix.diagonal fun i => ↑((Q.mulVec p) i)` | none |
| `markovGenerator_diagonal_eq_zero_iff` | `L_q (diag ↑p) = 0 ↔ Q.mulVec p = 0` | none |

### Contract D: probability and stationary density consumers

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `diagonal_ofReal_posSemidef_trace_one` | `(diag ↑p).PosSemidef ∧ Matrix.trace (diag ↑p) = 1` | `∀ i, 0 ≤ p i`, `∑ i, p i = 1` |
| `stationary_diagonal_density` | `(diag ↑p).PosSemidef ∧ Matrix.trace (diag ↑p) = 1 ∧ L_q (diag ↑p) = 0` | `∀ i, 0 ≤ p i`, `∑ i, p i = 1`, `Q.mulVec p = 0`; no rate nonnegativity |

### Contract E: boundaries and pilot recovery

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `exitRate_zero`, `rateMatrix_zero`, `markovGenerator_zero` | `exitRate 0 j = 0`, `rateMatrix 0 = 0`, `markovGenerator 0 = 0` (bundled maps) | none |
| `exitRate_diagonal`, `rateMatrix_diagonal`, `markovGenerator_diagonal_rates` | for `q = Matrix.diagonal d`: `exitRate q j = 0`, `rateMatrix q = 0`, `markovGenerator q = 0` | none (diagonal rates are ignored by definition) |
| `rateMatrix_two` | `rateMatrix (Matrix.of ![![0, b], ![a, 0]]) = Matrix.of ![![-a, b], ![a, -b]]` | none (every real `a`, `b`) |
| `markovGenerator_two` | `markovGenerator (Matrix.of ![![0, b], ![a, 0]]) = generator a b` (bundled maps) | none |

Proof design. `dissipator_single` unfolds the accepted dissipator and uses
`Matrix.conjTranspose_single`, `Matrix.single_mul_mul_single`, and
`Matrix.single_mul_single_same`; its private entry form
(`dissipator_single_apply`) uses the `single_mul_apply` and
`mul_single_apply` lemmas. `markovGenerator_apply` is `LinearMap.sum_apply`
and `LinearMap.smul_apply` on the bundled sum. The two entry formulas
expand every summand by the private entry form, split each summand into an
`i' = i` part and a `j' = i` (or `j' = j`) part by `split_ifs <;> ring`,
collapse with `Finset.sum_ite_eq'`, `Finset.sum_ite_irrel`, and the
distributive sum lemmas, and cast `exitRate` with `Complex.ofReal_sum`.
Trace and Hermiticity are the accepted `dissipator_trace` and
`dissipator_isHermitian` through the sum and scalar lemmas with
`Complex.conj_ofReal`. The diagonal bridge is entrywise from the entry
formulas; the `iff` uses `Matrix.diagonal_eq_zero` and
`Complex.ofReal_eq_zero`. The density consumer uses
`Matrix.PosSemidef.diagonal` with `Complex.zero_le_real` under `open scoped
ComplexOrder` and `Matrix.trace_diagonal`. The `Fin 2` recovery is
`LinearMap.ext` with the accepted `qubitMatrix_ext` and `generator_apply_*`,
the two exit rates and inflow sums evaluated by `Fin.sum_univ_two`.

- Nontrivial witness / boundary cases: the empty index type satisfies every
  algebraic law and cannot satisfy `∑ i, p i = 1`, so no cardinality bound
  was added; the all-zero and diagonal-only rate families give zero `Q` and
  zero `L_q`, showing the self-jump exclusion is by definition; the `Fin 2`
  recovery checks sign, transpose, and basis conventions against the
  accepted generator, whose stationary density and dynamics are not
  reproved. Signed rates are admitted on every algebraic law; physical
  nonnegativity appears only on the two classical certificates.
- Existing source matched or extended: Mathlib supplied the matrix-unit,
  diagonal, `mulVec`, trace, PSD, and finite-sum lemmas listed in D019; the
  accepted generic dissipator layer is consumed directly with no adapter.
  The bounded pinned-source keyword search found no named endpoint for a
  Markov generator, rate matrix, Lindblad, or GKSL object (D019 records the
  scope and the one false-positive substring hit). This is not a claim of
  absence from downstream projects or of novelty.
- Any difference from the accepted contract, all recorded in D019: (a) the
  mask is a real scalar under one cast rather than an `ite`-valued linear
  map, which the assignment allowed; (b) `dissipator_single` is exported as
  a public reusable lemma with a clear consumer, and its entry form is
  private; (c) the optional diagonal-rate corollaries are included as three
  theorems; (d) the `Fin 2` matrices are written as `Matrix.of ![![_, _],
  ![_, _]]` because `Mathlib.Data.Matrix.Notation` is outside the cached
  closure; (e) a manual declaration inventory file is added under evidence
  as an aid to the required human review, without any verifier change.
- Downstream use: the bridge gives the generator side of a finite classical
  Markov chain inside the accepted quantum algebra. A real diagonal
  Hamiltonian, the classical semigroup, or the Euler-step positivity
  question would be separate milestones; none is started.

## Trust evidence

- Transitive axiom output for every exported theorem: all 216 exports,
  including the three new definitions, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/markov/v1/verification/32-axiom-audit.stdout.log`, parsed into
  `verification.json` key `axioms`; one report per export).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or
  `implemented_by`. `noncomputable` markers are code-generation attributes.
- Every release module actually compiled: `lake build` of the eight release
  modules and the umbrella (2534 jobs, the local modules being the last
  nine; the rest are cached dependency artifacts), followed by explicit
  `lake env lean` re-elaboration of the eight release sources and of
  `Audit/Contracts.lean`; the new module and the contract file elaborate
  with zero diagnostics. The coverage control shows the gate fails if the
  new module is omitted; the contract control shows an export without a
  consumer contract is rejected.
- Validation gate fixture results: 15 of 15 cases passed with their
  expected outcomes (`evidence/markov/v1/gate-tests/gate_tests.json`). The
  scripts are byte-identical to the accepted versions (`scripts/verify.py`
  `9a6d01e5...`, `scripts/test_verify.py` `44dddfe2...`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `ecd3faefdc5b4198b4791f070714b3b4b7278ee24bd569391f072ab19f99affa`;
  `FormalScience.lean` `53441ed9d9f12701777a888c5c1e51fd1178dd1a2b18225130a44f41910abf04`;
  `Audit/Contracts.lean` `19fc9cb7652f434ef794e75a5dd9b0f695317f019e7e7405e273d4379fd25f66`
  (from the accepted `f0deb195c61e388a6b735794366d8ed9f1562c24f8854b69a122c9865e8f57a4`
  by the 26 appended Markov contracts only; the 167 accepted statements
  are unchanged);
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`;
  `FormalScience/OpenSystems/TwoStateStationary.lean` `745efb74d87359f6cacae50625e316e473f7dd27a595a9689fab083baff855e1`;
  `FormalScience/OpenSystems/TwoStateEvolution.lean` `541772ee2f865c567bede484e2a5e25562531da1294e5fdcb7abc0c4cd069e37`;
  `FormalScience/Quantum/FiniteKraus.lean` `1fe2ec3bb001f4503a29a91dd1cc1fa907effa74f8128817c53a4c1551b0e5e5`;
  `FormalScience/OpenSystems/TwoStateKraus.lean` `f21f85bb6595cf64407734bd7795b3fe01b962a6cab7bacab1d98b4433a79f87`;
  `FormalScience/OpenSystems/TwoStateConvergence.lean` `0d8634368db3fe805b4d15f97584e2ced30f1c79f0f35994929149b41d611e89`
  (changed from the accepted `2f2406e3a9c9f7e3ccfa6f751ad0255964bd81524f8bf0b044e889c387f741c6`
  by the C1 header comment only, D017);
  `FormalScience/OpenSystems/FiniteMarkovBridge.lean` `18842b875a294fdbab6963b5bf201d6b12935d96cf902bc7484747fd5ca768f9`.
- Semantic review decision: self-review by the implementer only. Every
  elaborated type was read against the issued contract; the contract file
  writes the exit rate as its finite sum with the `if i = j then 0 else _`
  exclusion, the rate matrix entrywise, the generator as the explicit
  dissipator sum over matrix units, both entry cases, the diagonal identity
  with the coercion visible, the stationary `iff`, PSD and trace one in
  Mathlib's predicates, the zero and diagonal families, and the `Fin 2`
  identification both as bundled-map equality and pointwise against the
  spelled-out weighted generator `Lw`. The independent audit decision is
  pending.

## Blockers and next step

- Exact unresolved goal or API problem: none. Adjustments made during
  implementation: `Matrix.single_mul_apply_of_ne` and its twin take the
  scalar as their first explicit argument, so the entry lemma supplies the
  inequality to `simp` instead of positionally; `Finset.sum_div` is not in
  the cached closure, so the coherence formula pulls the constants out with
  `Finset.mul_sum` and `Finset.sum_mul` and finishes by `ring`; the density
  lemma needs `open scoped ComplexOrder` for `Complex.zero_le_real`; and the
  contract notations containing `if` need `set_option quotPrecheck false`,
  as in round 3, while an index-polymorphic lambda notation did not apply
  cleanly, so the notations use the section index type and the `Fin 2`
  contracts are spelled out in full.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): the
  implementer proposes no specific successor. The assignment names Stage 5
  release work as a separate checkpoint, and the portfolio ledger lists the
  other branches; the audit should select.
- Changes requiring a contract decision: (a) accept the scalar-mask form of
  the generator definition; (b) accept the public `dissipator_single`; (c)
  accept the three diagonal-rate corollaries; (d) accept the `Matrix.of`
  spelling of the `Fin 2` matrices; (e) note the tracked `docs/SCOPE_MEMO.md`
  (D018) as a non-release planning document; (f) select the next milestone.
  No validation-script change is proposed; the scripts are unchanged.
- Suggested reviewer focus: confirm the destination-first reading of
  `q i j` against `rateMatrix_two` and `markovGenerator_two` (with
  `q 1 0 = a` the `0 → 1` rate, matching `jumpZeroToOne = E_10`); confirm
  that every algebraic statement quantifies over arbitrary signed real `q`
  and that `∀ i j, i ≠ j → 0 ≤ q i j` appears only on the two
  nonnegativity certificates; confirm the diagonal bridge carries the
  coercion `fun i => (p i : ℂ)` and `((Q.mulVec p) i : ℂ)` explicitly and is
  not stated through a transpose; read `markovGenerator_apply_of_ne` for
  the `-(r_i + r_j)/2` coefficient; and check that the only change to
  accepted source is the C1 comment.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
