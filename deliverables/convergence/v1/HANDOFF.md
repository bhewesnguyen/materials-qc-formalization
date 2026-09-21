# Stage audit handoff: quantitative two-state convergence

Completed from AUDIT_HANDOFF_TEMPLATE.md on 21 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/convergence/v1/`; nothing is asserted from an editor state.

## Scope

- Stage and accepted contract IDs: implementation round 5, milestone
  `convergence`, round `v1`, as issued with the Kraus audit
  (`audits/kraus/v1/NEXT_FABLE_TASK.md`, copied unchanged to the root slot
  with a status note). Required: record the Kraus acceptance and the three
  optional prose cleanups; reproduce the accepted 158-export baseline; then
  prove, for the accepted flow with `gamma = a + b`, a named Frobenius norm
  with the explicit finite-sum formula and a bridge to Mathlib's scoped
  instance, the exact centered error identity, the estimate
  `F(Phi_t X - trace X • rhoStar) ≤ exp(-(gamma t)/2) F(X - trace X • rhoStar)`
  for `gamma > 0`, `t ≥ 0`, on every complex matrix, the long-time limits
  of the scalar error and of the matrix, physical density consumers, and
  the rate boundaries including the both-zero non-attractor.
- Commit under review: the commit tagged `convergence-milestone-v1`, whose
  tree contains this document. Its hash is `git rev-parse
  convergence-milestone-v1^{commit}`; it is also recorded in
  `deliverables/convergence/v1/RECEIPT.json`, committed after the tag, and
  in the delivery message. Diff base: the accepted Kraus commit
  `6431c9cd411a3a804d2a86ae733e23f393fe9361`. Between them sit the Kraus
  receipt commit `2b39181` and the housekeeping commit `25862d0`, which
  integrated the audit return, activated the assignment, and recorded D015
  without touching proof source. The accepted tags
  `dissipator-milestone-v1`, `stationary-milestone-v1`,
  `evolution-milestone-v1`, and `kraus-milestone-v1` were not moved.
- What is complete: all required results and the optional saturating
  witness, in one new release module
  `FormalScience/OpenSystems/TwoStateConvergence.lean` (1 definition, 28
  theorems; one `private` helper). Umbrella, export manifest (187 exports),
  and independent contracts (167 theorem contracts) cover every new public
  declaration. Both validation scripts pass on the final source. The one
  comment-only change to accepted source (the `Kf` to `Kev` section comment
  in `Audit/Contracts.lean`, D015) was made after the baseline
  reproduction, with hashes recorded below.
- What is explicitly incomplete: nothing from the assignment. Not
  attempted, by instruction: trace-norm and diamond-norm contraction,
  operator-norm or norm-equivalence statements, spectral gaps, general
  Perron-Frobenius theory, the Markov bridge, Hamiltonian extensions,
  entropy, circuits, and OR. The Frobenius norm is not a contraction on
  every matrix (the stationary direction is fixed); the trace factor is
  therefore part of every estimate, and no unconditional
  `F(Phi_t X) ≤ F(X)` is claimed.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/convergence/v1/environment.json`);
  the user's workstation.
- Lean toolchain: `leanprover/lean4:v4.34.0`, `Lean (version 4.34.0,
  x86_64-unknown-linux-gnu, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b,
  Release)`; the same installation as the previous rounds. The release
  archive checksum was measured by the auditor (`caaa9835...b646b`).
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, clean. The
  new module imports `Mathlib.Analysis.Matrix.Normed` and
  `Mathlib.Analysis.SpecialFunctions.Exp`, both already inside the cached
  closure of the README command; no cache extension and no pin change this
  round.
- Other dependency commits and licenses: unchanged and verified clean at
  their locked revisions; eight package roots Apache 2.0 and `Cli` MIT, per
  `audits/dissipator/v1/evidence/dependency_license_inventory.json`. The
  only externally authored source adapted this round is the auditor's
  in-project probe `audits/kraus/v1/reference/ConvergenceApiProbe.lean`
  (D016).
- Exact clean-build commands and exit codes:
  1. Baseline reproduction before any source change (tree at `25862d0`):
     `python3 scripts/verify.py --output-dir evidence/convergence/v1/reproduction/verification`
     (exit 0; 30 commands all exit 0; 158 exports; `source_sha256`
     identical to `evidence/kraus/v1/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir evidence/convergence/v1/reproduction/gate-tests`
     (exit 0; 15 cases).
  2. Final verification: `python3 scripts/verify.py --output-dir
     evidence/convergence/v1/verification` (exit 0; 31 commands all exit 0)
     and `python3 scripts/test_verify.py --output-dir
     evidence/convergence/v1/gate-tests` (exit 0; 15 cases).
  3. Gate controls, expected to fail, each with its altered manifest
     retained: `evidence/convergence/v1/gate-controls/missing-module/`
     (`omitted-module.json`; exit 1, `Release module coverage mismatch:
     unlisted=['FormalScience.OpenSystems.TwoStateConvergence']`) and
     `evidence/convergence/v1/gate-controls/unmentioned-contract-export/`
     (`unmentioned-export.json`, which lists a nonexistent
     `tendsto_evolution_unmentioned` as an export and contract export;
     exit 1, `Contract file does not mention these fully qualified
     exports`), the second showing that an export without a consumer
     contract is rejected before any build.
  The 31 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and the eight other packages;
  `lake build` of the seven release modules and the umbrella; `lake env
  lean` on the seven release sources and on `Audit/Contracts.lean`;
  `lake env lean --json Signatures.lean`; `lake env lean --json
  AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, seven release
  modules, 187 exports (15 Stage 0, 27 dissipator, 30 stationary, 43
  evolution, 6 generic Kraus, 37 two-state Kraus, 29 convergence), 167
  contract exports (10, 23, 28, 39, 5, 34, 28). A source scan confirmed
  every public declaration of the new module is listed.
- Raw log paths: `evidence/convergence/v1/reproduction/{verification,gate-tests}/`,
  `evidence/convergence/v1/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `30-export-signatures.stdout.log` with `pp.explicit`
  types, and `31-axiom-audit.stdout.log`; the run has 31 commands so these
  numbers are correct for this round), `evidence/convergence/v1/gate-tests/`,
  `evidence/convergence/v1/gate-controls/{missing-module,unmentioned-contract-export}/`,
  and `evidence/convergence/v1/environment.json`. All earlier evidence
  trees are unchanged.

## Statement review

All declarations are in namespace `FormalScience.OpenSystems`, source path
`FormalScience/OpenSystems/TwoStateConvergence.lean`. Readable types are
quoted from `#check`; fully explicit types are in the signature log. `↑x`
is the cast of a real into `ℂ`; `e = expFactor (a+b) t = exp(-((a+b) t))`,
`c = halfExpFactor (a+b) t = exp(-((a+b) t)/2)`, `F = qubitFrobeniusNorm`,
`tau = Matrix.trace X`, and `Y = X - tau • rhoStar a b`.

### Definition and norm facts

| Declaration | Statement | Notes |
| --- | --- | --- |
| `qubitFrobeniusNorm` | `qubitFrobeniusNorm X := Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)` | real-valued; `noncomputable` |
| `qubitFrobeniusNorm_def` | the formula above, by `rfl` | exposes the finite sum |
| `qubitFrobeniusNorm_eq_norm` | `qubitFrobeniusNorm X = ‖X‖` under `open scoped Matrix.Norms.Frobenius` | bridge; the contract selects the scope explicitly |
| `qubitFrobeniusNorm_nonneg` | `0 ≤ F X` | none |
| `qubitFrobeniusNorm_sq` | `F X ^ 2 = ‖X 0 0‖^2 + ‖X 0 1‖^2 + ‖X 1 0‖^2 + ‖X 1 1‖^2` | none |
| `expFactor_pos` | `0 < e` | none |
| `expFactor_tendsto`, `halfExpFactor_tendsto` | `Tendsto (fun t => e) atTop (𝓝 0)`, same for `c` | `0 < γ` |

Conventions preserved: basis `0, 1`; `a` on `E_10`, `b` on `E_01`; zero
Hamiltonian; `evolution`, `rhoStar`, `IsDensity`, `basisProjector`,
`diagonalState`, `jumpOneToZero` reused unchanged. All six previously
accepted release modules are byte-identical to the accepted versions
(hashes below).

### Centered entries and exact identity (every complex `X`, every real `t`)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `evolution_sub_smul_rhoStar_apply_zero_zero` | `(Phi_t X - tau • rhoStar) 0 0 = ↑e * Y 0 0` | `a + b ≠ 0` |
| `evolution_sub_smul_rhoStar_apply_one_one` | `(Phi_t X - tau • rhoStar) 1 1 = ↑e * Y 1 1` | `a + b ≠ 0` |
| `evolution_sub_smul_rhoStar_apply_zero_one` | `(Phi_t X - tau • rhoStar) 0 1 = ↑c * Y 0 1` | none (every real rate pair) |
| `evolution_sub_smul_rhoStar_apply_one_zero` | `(Phi_t X - tau • rhoStar) 1 0 = ↑c * Y 1 0` | none |
| `qubitFrobeniusNorm_sq_evolution_sub` | `F(Phi_t X - tau • rhoStar)^2 = e^2 (‖Y 0 0‖^2 + ‖Y 1 1‖^2) + c^2 (‖Y 0 1‖^2 + ‖Y 1 0‖^2)` | `a + b ≠ 0` |

### Estimate

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `qubitFrobeniusNorm_evolution_sub_le` | all-matrix contraction in the trace fiber | `∀ {a b : ℝ}, 0 < a + b → ∀ (t : ℝ), 0 ≤ t → ∀ (X : QubitMatrix), qubitFrobeniusNorm (evolution a b t X - X.trace • rhoStar a b) ≤ halfExpFactor (a + b) t * qubitFrobeniusNorm (X - X.trace • rhoStar a b)` | `0 < a + b`, `0 ≤ t`; `X` arbitrary |
| `qubitFrobeniusNorm_evolution_sub_rhoStar_le` | trace-one specialization | `X.trace = 1 → F(Phi_t X - rhoStar) ≤ c F(X - rhoStar)` | `0 < a + b`, `0 ≤ t` |
| `qubitFrobeniusNorm_evolution_sub_evolution_le` | equal-trace pair bound | `X.trace = Z.trace → F(Phi_t X - Phi_t Z) ≤ c F(X - Z)` | `0 < a + b`, `0 ≤ t` |

### Limits (canonical matrix topology, `Filter.atTop`)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `tendsto_qubitFrobeniusNorm_evolution_sub` | `Tendsto (fun t => F(Phi_t X - tau • rhoStar)) atTop (𝓝 0)` | `0 < a + b`; `X` arbitrary |
| `tendsto_qubitMatrix` | four entrywise limits along any filter give the matrix limit | none |
| `tendsto_evolution` | `Tendsto (fun t => Phi_t X) atTop (𝓝 (tau • rhoStar))` | `0 < a + b`; `X` arbitrary |
| `tendsto_evolution_of_trace_eq_one` | `X.trace = 1 → Tendsto (fun t => Phi_t X) atTop (𝓝 (rhoStar a b))` | `0 < a + b` |

### Physical consumers and boundaries

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `evolution_isDensity_and_qubitFrobeniusNorm_le` | `IsDensity (Phi_t ρ) ∧ F(Phi_t ρ - rhoStar) ≤ c F(ρ - rhoStar)` | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `0 ≤ t`, `IsDensity ρ` |
| `tendsto_evolution_of_isDensity` | `IsDensity (rhoStar a b) ∧ Tendsto (fun t => Phi_t ρ) atTop (𝓝 (rhoStar a b))` | `0 ≤ a`, `0 ≤ b`, `0 < a + b`, `IsDensity ρ` |
| `tendsto_evolution_zero_left` | `Tendsto (fun t => evolution 0 b t X) atTop (𝓝 (basisProjector 0))` | `0 < b`, `X.trace = 1` |
| `tendsto_evolution_zero_right` | `Tendsto (fun t => evolution a 0 t X) atTop (𝓝 (basisProjector 1))` | `0 < a`, `X.trace = 1` |
| `tendsto_evolution_same` | `Tendsto (fun t => evolution r r t X) atTop (𝓝 (diagonalState (1/2)))` | `0 < r`, `X.trace = 1` |
| `not_exists_common_limit_zero_zero` | `¬ ∃ σ, ∀ ρ, IsDensity ρ → Tendsto (fun t => evolution 0 0 t ρ) atTop (𝓝 σ)` | none |
| `evolution_jumpOneToZero` | `evolution a b t E_01 = ↑c • E_01` | none (every real rate pair and time) |
| `qubitFrobeniusNorm_jumpOneToZero` | `F E_01 = 1` | none |
| `qubitFrobeniusNorm_evolution_jumpOneToZero` | `F(Phi_t E_01) = c` | none |

Proof design. The norm is defined by the finite sum and bridged to
Mathlib's `Matrix.frobenius_norm_def` by rewriting `x ^ (1/2 : ℝ)` as
`Real.sqrt` and `‖z‖ ^ (2 : ℝ)` as `‖z‖ ^ 2`. The four centered entries
come from the accepted trace-linear population formulas
(`evolution_apply_zero_zero_of_ne_zero` and its `1 1` twin), the accepted
coherence formulas, and the accepted `rhoStar` entries, closed by
`field_simp` and `ring` after `Matrix.trace_fin_two`; the off-diagonal
entries need no rate hypothesis because `rhoStar` has zero coherence. The
squared identity is the four-entry expansion with the private
`norm_ofReal_mul_sq` (`‖↑r * z‖^2 = r^2 ‖z‖^2` for `0 ≤ r`). The estimate
uses `e = c^2` (accepted `halfExpFactor_sq`) and `0 < c ≤ 1` (accepted
`halfExpFactor_pos`, `halfExpFactor_le_one`, which is where `0 < a + b` and
`0 ≤ t` enter) to bound `c^4 D + c^2 C ≤ c^2 (D + C)` with `D`, `C` the
diagonal and coherence energies, then takes square roots with
`Real.sqrt_le_sqrt` and `Real.sqrt_sq`. The scalar limit squeezes between
`0` and `c F(Y)` using `tendsto_of_tendsto_of_tendsto_of_le_of_le'`
eventually for `t ≥ 0`, with `c → 0` from `Real.tendsto_exp_atBot`
composed with `Tendsto.const_mul_atTop_of_neg`. The matrix limit is
entrywise through `tendsto_qubitMatrix` (`tendsto_pi_nhds` twice and
`fin_cases`), using `Complex.continuous_ofReal` to cast the scalar limits
and `Tendsto.mul_const`, `.add`, `.sub` on the explicit entry formulas; no
norm-to-topology equivalence is used or claimed. The physical consumers
pair the accepted `evolution_isDensity` and `rhoStar_isDensity` with the
trace-one statements. The rate boundaries rewrite the trace-one matrix
limit with the accepted `rhoStar_zero_left`, `rhoStar_zero_right`, and
`rhoStar_same`. The both-zero non-attractor uses the accepted
`evolution_zero_zero` to make each trajectory constant, then
`tendsto_nhds_unique` on the two basis densities and
`basisProjector_zero_ne_one`.

- Nontrivial witness / boundary cases: the estimate is stated for every
  complex matrix with only `0 < a + b` and `0 ≤ t`; the exact identity and
  the centered entries hold for every real `t` with only `a + b ≠ 0`. The
  matrix unit `E_01` is an eigenvector with eigenvalue `c`, so
  `F(Phi_t E_01) = c F(E_01)` saturates the estimate's prefactor and
  exponent; `E_01` is not a density, and no claim is made about sharpness
  among densities. At `a = b = 0` the flow is the identity and the two
  basis projectors show no common limit exists. Negative times are covered
  by the exact identity but excluded from the estimate, where `c ≤ 1` needs
  `t ≥ 0`.
- Existing source matched or extended: Mathlib supplied the Frobenius
  definition, square-root, exponential-limit, product-topology, and
  uniqueness-of-limit lemmas listed in D016; the auditor's probe supplied
  the bridge and scalar-limit shapes, adapted with provenance recorded.
  The accepted entry formulas, `rhoStar` entries and boundary identities,
  `evolution_zero_zero`, `evolution_isDensity`, `rhoStar_isDensity`, and
  the Kraus-round scalar facts are consumed directly.
- Any difference from the accepted contract, all recorded in D016: (a) the
  estimate and identities are stated on every complex matrix with the
  `trace X` factor, and the trace-one and pairwise forms are derived
  consumers, as the assignment preferred; (b) the boundary limit consumers
  take a trace-one premise rather than `IsDensity`, which the assignment
  explicitly welcomed; (c) `halfExpFactor` and `expFactor` appear in the
  theorem statements, with the consumer contracts restating them as
  `Real.exp`; (d) the optional witness is included as three theorems; (e)
  `tendsto_qubitMatrix` is exported as a reusable bridge; (f) two gate
  controls were retained, the second of a new kind.
- Downstream use: with this round the planned two-state benchmark
  (dissipator, stationary state, explicit evolution, Kraus certification,
  quantitative convergence) is complete pending audit. The natural
  continuations named by the portfolio ledger are the Stage 4 extension to
  general finite dimension or a different branch; none is started.

## Trust evidence

- Transitive axiom output for every exported theorem: all 187 exports,
  including the new definition, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/convergence/v1/verification/31-axiom-audit.stdout.log`, parsed
  into `verification.json` key `axioms`; one report per export).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or
  `implemented_by`. `noncomputable` markers are code-generation attributes.
- Every release module actually compiled: `lake build` of the seven
  release modules and the umbrella (2533 jobs, the local modules being the
  last eight; the rest are cached dependency artifacts), followed by
  explicit `lake env lean` re-elaboration of the seven release sources and
  of `Audit/Contracts.lean`. The coverage control shows the gate fails if
  the new module is omitted; the contract control shows an export without
  a consumer contract is rejected.
- Validation gate fixture results: 15 of 15 cases passed with their
  expected outcomes (`evidence/convergence/v1/gate-tests/gate_tests.json`).
  The scripts are byte-identical to the accepted versions
  (`scripts/verify.py` `9a6d01e5...`, `scripts/test_verify.py`
  `44dddfe2...`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `878bc7ca5fd5b6a816acc3fd433218fa123ae84fc0e226dec75ecaf04803322c`;
  `FormalScience.lean` `8349432e2a6c8a58357dcf41bd0042a2ede16fb77db606b1cbbe3d10b25b8945`;
  `Audit/Contracts.lean` `f0deb195c61e388a6b735794366d8ed9f1562c24f8854b69a122c9865e8f57a4`
  (from the accepted `7bc313231a4271a598c99f28a6bd989652b68a802c0dea28633e2a271a40eab6`,
  first to `de3426dbce50bc8bf9cb74373279c8ef3b686759c21899a7a6e64ce7a25bb77d`
  by the comment-only `Kf` to `Kev` fix, D015, then by the 28 added
  convergence contracts);
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`;
  `FormalScience/OpenSystems/TwoStateStationary.lean` `745efb74d87359f6cacae50625e316e473f7dd27a595a9689fab083baff855e1`;
  `FormalScience/OpenSystems/TwoStateEvolution.lean` `541772ee2f865c567bede484e2a5e25562531da1294e5fdcb7abc0c4cd069e37`;
  `FormalScience/Quantum/FiniteKraus.lean` `1fe2ec3bb001f4503a29a91dd1cc1fa907effa74f8128817c53a4c1551b0e5e5`;
  `FormalScience/OpenSystems/TwoStateKraus.lean` `f21f85bb6595cf64407734bd7795b3fe01b962a6cab7bacab1d98b4433a79f87`;
  `FormalScience/OpenSystems/TwoStateConvergence.lean` `2f2406e3a9c9f7e3ccfa6f751ad0255964bd81524f8bf0b044e889c387f741c6`.
- Semantic review decision: self-review by the implementer only. Every
  elaborated type was read against the issued contract; the contract file
  spells the norm as `Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)`, checks the bridge
  with `open scoped Matrix.Norms.Frobenius in`, writes every exponential as
  `Real.exp`, keeps the `Matrix.trace X •` factor visible, and states both
  limits as `Filter.Tendsto ... Filter.atTop (nhds ...)`. The independent
  audit decision is pending.

## Blockers and next step

- Exact unresolved goal or API problem: none. Two adjustments were made
  during implementation: in the matrix-limit proof, `have` statements
  built from `tendsto_const_nhds` needed their full types written out
  because the constant cannot be inferred without an expected type; and
  the witness norm needed `Real.sqrt_sq` supplied to `simp` explicitly.
  Two `ring` calls that closed only through `ring_nf` normalization were
  replaced by explicit limit-point equalities so that the final source
  elaborates with no diagnostics at all.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): this
  completes the planned two-state benchmark. The implementer proposes no
  specific successor; the portfolio ledger names the Stage 4 extension to
  general finite dimension and the other branches, and the audit should
  select one.
- Changes requiring a contract decision: (a) accept the trace-fiber
  formulation on every complex matrix, with the trace-one and pairwise
  forms as consumers; (b) accept the trace-one premise on the boundary
  limit consumers; (c) accept `halfExpFactor` and `expFactor` in theorem
  statements with `Real.exp` in the contracts; (d) accept the optional
  witness and the exported `tendsto_qubitMatrix` bridge; (e) select the
  next milestone. No validation-script change is proposed; the scripts are
  unchanged.
- Suggested reviewer focus: confirm `qubitFrobeniusNorm_eq_norm` is stated
  against the Frobenius instance and not the default operator norm (the
  contract selects `Matrix.Norms.Frobenius` explicitly); confirm the
  estimate quantifies over every complex `X` and carries the `trace X`
  factor on both sides; confirm `tendsto_evolution` targets the matrix
  `trace X • rhoStar a b` in the product topology with no norm-equivalence
  step; check that the only change to accepted source is the one comment;
  and note that `E_01` saturation is a prefactor check, not a density
  sharpness claim.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
