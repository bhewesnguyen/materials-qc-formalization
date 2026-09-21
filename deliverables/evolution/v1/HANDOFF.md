# Stage audit handoff: explicit two-state evolution

Completed from AUDIT_HANDOFF_TEMPLATE.md on 20 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/evolution/v1/`; nothing is asserted from an editor state.

## Scope

- Stage and accepted contract IDs: implementation round 3, milestone
  `evolution`, round `v1`, as issued with the stationary audit
  (`audits/stationary/v1/NEXT_FABLE_TASK.md`, copied unchanged to the root
  slot with a status note). Required: record the stationary acceptance and
  close S1 to S3; reproduce the accepted 72-export baseline; then one new
  module with a single bundled complex-linear evolution on all complex
  qubit matrices, its four entry formulas, `Phi_0 = Id`, the semigroup law,
  trace preservation, Hermiticity preservation for Hermitian input, the
  matrix-valued derivative, the `rhoStar` fixed point and trace-linear
  population formulas at nonzero total rate, the zero-total-rate identity
  `Phi_t = Id + t L`, the both-zero identity, the signed witness, and the
  one-zero-rate and equal-rate fixed states.
- Commit under review: the commit tagged `evolution-milestone-v1`, whose
  tree contains this document. Its hash is `git rev-parse
  evolution-milestone-v1^{commit}`; it is also recorded in
  `deliverables/evolution/v1/RECEIPT.json`, committed after the tag, and in
  the delivery message. Diff base: the accepted stationary commit
  `a5347ca77a2b5e6678f514decb0ab4eee7b62943`. Between them sit the
  stationary receipt commit `d7c53a6` and the housekeeping commit
  `783f1e4be57e18d26101380169152c634d9eaf12`, which integrated the audit
  return, restored the S1 file, activated the assignment, and closed S1 to
  S3 without touching proof source. The accepted tags
  `dissipator-milestone-v1` and `stationary-milestone-v1` were not moved.
- What is complete: all required results, in
  `FormalScience/OpenSystems/TwoStateEvolution.lean` (43 public
  declarations: 4 definitions, 39 theorems; one `private` function
  `evolutionFun` underlying the bundled map). Umbrella, export manifest (115
  exports), and independent contracts (100 theorem contracts) cover every
  new public declaration. Both validation scripts pass on the final source.
  The S3 docstring correction in `TwoStateStationary.lean` was made after
  the baseline reproduction, as a comment-only change.
- What is explicitly incomplete: nothing from the assignment. Not attempted,
  by instruction: density preservation by the flow, Kraus representation,
  complete positivity, Choi or Stinespring equivalences, norm contraction,
  convergence, ODE uniqueness, matrix exponentials, generic GKSL,
  Perron-Frobenius, the Markov bridge, entropy, circuits, and OR.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/evolution/v1/environment.json`); the
  user's workstation.
- Lean toolchain: `leanprover/lean4:v4.34.0`, `Lean (version 4.34.0,
  x86_64-unknown-linux-gnu, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b,
  Release)`; the same installation as the previous rounds. The release
  archive checksum was measured by the auditor (`caaa9835...b646b`).
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, clean. The
  cache closure was extended at the same revision by
  `lake exe cache get Mathlib.Analysis.SpecialFunctions.ExpDeriv
  Mathlib.Analysis.Complex.RealDeriv Mathlib.Analysis.Calculus.Deriv.Prod
  Mathlib.Analysis.Matrix.Normed` (339 files,
  `evidence/evolution/v1/setup/cache-get.log`); the README command lists
  these four modules. This is a dependency-scope change, not a pin change
  (D012).
- Other dependency commits and licenses: unchanged and verified clean at
  their locked revisions; eight package roots Apache 2.0 and `Cli`
  `e92c9f15` MIT, per `audits/dissipator/v1/evidence/dependency_license_inventory.json`.
  Nothing was copied from any dependency or downstream project.
- Exact clean-build commands and exit codes:
  1. Baseline reproduction before any source change (tree at `783f1e4`):
     `python3 scripts/verify.py --output-dir evidence/evolution/v1/reproduction/verification`
     (exit 0; 27 commands all exit 0; 72 exports; `source_sha256` identical
     to `evidence/stationary/v1/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir evidence/evolution/v1/reproduction/gate-tests`
     (exit 0; 15 cases).
  2. Final verification: `python3 scripts/verify.py --output-dir
     evidence/evolution/v1/verification` (exit 0; 28 commands all exit 0)
     and `python3 scripts/test_verify.py --output-dir
     evidence/evolution/v1/gate-tests` (exit 0; 15 cases).
  3. Coverage control, expected to fail: `python3 scripts/verify.py
     --manifest evidence/evolution/v1/gate-controls/missing-module/omitted-module.json
     --output-dir evidence/evolution/v1/gate-controls/missing-module`
     (exit 1; `Release module coverage mismatch:
     unlisted=['FormalScience.OpenSystems.TwoStateEvolution']`); the
     altered manifest is retained as the control's input fixture.
  The 28 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and the eight other packages;
  `lake build` of the four release modules and the umbrella; `lake env
  lean` on the four release sources and on `Audit/Contracts.lean`;
  `lake env lean --json Signatures.lean`; `lake env lean --json
  AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, four release
  modules, 115 exports (15 Stage 0, 27 dissipator, 30 stationary, 43
  evolution), 100 contract exports (10, 23, 28, 39). A source scan confirmed
  every public declaration of the new module is listed.
- Raw log paths: `evidence/evolution/v1/setup/`,
  `evidence/evolution/v1/reproduction/{verification,gate-tests}/`,
  `evidence/evolution/v1/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `27-export-signatures.stdout.log` with `pp.explicit`
  types, and `28-axiom-audit.stdout.log`; the run has 28 commands so these
  numbers are correct for this round), `evidence/evolution/v1/gate-tests/`,
  `evidence/evolution/v1/gate-controls/missing-module/`, and
  `evidence/evolution/v1/environment.json`. All earlier evidence trees are
  unchanged.

## Statement review

All new declarations are in namespace `FormalScience.OpenSystems`, source
path `FormalScience/OpenSystems/TwoStateEvolution.lean`. Readable types are
quoted from `#check`; fully explicit types are in the signature log. `↑x`
is the cast of a real into `ℂ`; `γ` abbreviates `a + b` in prose only.

### Definitions and conventions

| Declaration | Definition | Notes |
| --- | --- | --- |
| `expFactor` | `ℝ → ℝ → ℝ`, `expFactor γ t := Real.exp (-(γ * t))` | `e(gamma,t)` |
| `halfExpFactor` | `halfExpFactor γ t := Real.exp (-(γ * t) / 2)` | `f(gamma,t)`, the coherence coefficient |
| `integratedExpFactor` | `integratedExpFactor γ t := if γ = 0 then t else (1 - Real.exp (-(γ * t))) / γ` | `k(gamma,t)`; the zero branch is visible in the definition |
| `evolution` | `ℝ → ℝ → ℝ → (QubitMatrix →ₗ[ℂ] QubitMatrix)`; underlying function `evolutionFun a b t X = Matrix.of fun i j => if i = j then X i j + ↑(k (a+b) t) * generator a b X i j else ↑(f (a+b) t) * X i j` | one bundled map, no density, trace, Hermiticity, or positivity premise; `noncomputable` because of real division and classical decidability of `γ = 0` |

Conventions preserved: basis `0, 1`; `a` on `E_10` (population `0 -> 1`),
`b` on `E_01`; zero Hamiltonian; `generator` and `rhoStar` reused
unchanged. `Stage0.lean` and `Dissipator.lean` are byte-identical to the
accepted versions (hashes below); `TwoStateStationary.lean` differs from
the accepted version only in the two docstrings named in D011, S3.

### Scalar layer (arbitrary real `γ`, `t`, `u`)

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `expFactor_zero`, `halfExpFactor_zero`, `integratedExpFactor_zero` | `e(γ,0) = 1`, `f(γ,0) = 1`, `k(γ,0) = 0` | none |
| `integratedExpFactor_of_eq_zero`, `halfExpFactor_of_eq_zero`, `expFactor_of_eq_zero` | at `γ = 0`: `k = t`, `f = 1`, `e = 1` | `γ = 0` |
| `integratedExpFactor_of_ne_zero` | `k = (1 - e) / γ` | `γ ≠ 0` |
| `mul_integratedExpFactor` | `γ * k(γ,t) = 1 - e(γ,t)` | none (both branches) |
| `integratedExpFactor_add` | `k(γ,t+u) = k(γ,t) + e(γ,t) * k(γ,u)` | none |
| `halfExpFactor_add` | `f(γ,t+u) = f(γ,t) * f(γ,u)` | none |
| `hasDerivAt_expFactor` | `HasDerivAt (fun s => e(γ,s)) (-γ * e(γ,t)) t` | none |
| `hasDerivAt_halfExpFactor` | `HasDerivAt (fun s => f(γ,s)) (-(γ/2) * f(γ,t)) t` | none |
| `hasDerivAt_integratedExpFactor` | `HasDerivAt (fun s => k(γ,s)) (e(γ,t)) t` | none |

### Map and required contracts (arbitrary real `a`, `b`, `t`, `u`; arbitrary `X`)

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `evolution_apply_diag` | diagonal structure | `∀ (a b t : ℝ) (X) (i : Fin 2), evolution a b t X i i = X i i + ↑(k (a+b) t) * generator a b X i i` | none |
| `evolution_apply_offDiag` | off-diagonal structure | `∀ (a b t) (X) {i j}, i ≠ j → evolution a b t X i j = ↑(f (a+b) t) * X i j` | `i ≠ j` |
| `evolution_apply_zero_zero` | `Phi(X)_00 = X_00 + k(-a X_00 + b X_11)` | `evolution a b t X 0 0 = X 0 0 + ↑(k (a+b) t) * (-↑a * X 0 0 + ↑b * X 1 1)` | none |
| `evolution_apply_one_one` | `Phi(X)_11 = X_11 + k(a X_00 - b X_11)` | `evolution a b t X 1 1 = X 1 1 + ↑(k (a+b) t) * (↑a * X 0 0 - ↑b * X 1 1)` | none |
| `evolution_apply_zero_one`, `evolution_apply_one_zero` | `Phi(X)_01 = f X_01`, `Phi(X)_10 = f X_10` | `evolution a b t X 0 1 = ↑(f (a+b) t) * X 0 1`, likewise `1 0` | none |
| `evolution_zero` | `Phi_0 = Id` | `∀ (a b : ℝ), evolution a b 0 = LinearMap.id` | none |
| `evolution_add` | semigroup | `∀ (a b t u : ℝ), evolution a b (t + u) = evolution a b t ∘ₗ evolution a b u` | none |
| `evolution_trace` | trace preserved | `∀ (a b t) (X), Matrix.trace (evolution a b t X) = Matrix.trace X` | none |
| `qubitMatrix_isHermitian_of_entries` | entrywise Hermiticity criterion | `∀ {A}, star (A 0 0) = A 0 0 → star (A 1 1) = A 1 1 → star (A 1 0) = A 0 1 → A.IsHermitian` | the three entry facts |
| `evolution_isHermitian` | Hermiticity preserved | `∀ (a b t) {X}, X.IsHermitian → (evolution a b t X).IsHermitian` | `X` Hermitian |
| `hasDerivAt_qubitMatrix` | entrywise to matrix derivative | `∀ {φ : ℝ → QubitMatrix} {φ'} {t}, (four entry HasDerivAt facts) → HasDerivAt φ φ' t` | the four entry derivatives |
| `hasDerivAt_evolution` | matrix-valued derivative | `∀ (a b t : ℝ) (X), HasDerivAt (fun s => evolution a b s X) (generator a b (evolution a b t X)) t` | none |
| `evolution_apply_of_generator_eq_zero` | stationary matrices are fixed | `∀ (a b t) {X}, generator a b X = 0 → evolution a b t X = X` | `L X = 0` only |
| `evolution_rhoStar` | `rhoStar` fixed | `∀ (a b t), a + b ≠ 0 → evolution a b t (rhoStar a b) = rhoStar a b` | `a + b ≠ 0` |
| `evolution_apply_zero_zero_of_ne_zero` | trace-linear `(0,0)` | `a + b ≠ 0 → evolution a b t X 0 0 = ↑(e (a+b) t) * X 0 0 + ↑((1 - e (a+b) t) * (b / (a+b))) * Matrix.trace X` | `a + b ≠ 0` |
| `evolution_apply_one_one_of_ne_zero` | trace-linear `(1,1)` | `a + b ≠ 0 → evolution a b t X 1 1 = ↑(e (a+b) t) * X 1 1 + ↑((1 - e (a+b) t) * (a / (a+b))) * Matrix.trace X` | `a + b ≠ 0` |
| `evolution_eq_id_add_smul_generator` | zero total rate | `∀ (a b t), a + b = 0 → evolution a b t = LinearMap.id + ↑t • generator a b` | `a + b = 0` |
| `evolution_zero_zero` | both rates zero | `∀ (t : ℝ), evolution 0 0 t = LinearMap.id` | none |
| `evolution_one_neg_one_basisProjector_zero` | signed witness | `∀ (t : ℝ), evolution 1 (-1) t (basisProjector 0) = diagonalState t` | none |
| `generator_zero_left_basisProjector_zero`, `generator_zero_right_basisProjector_one`, `generator_same_diagonalState_half` | generator identities at the boundary states | `∀ (b : ℝ), generator 0 b (basisProjector 0) = 0`; `∀ (a : ℝ), generator a 0 (basisProjector 1) = 0`; `∀ (r : ℝ), generator r r (diagonalState (1/2)) = 0` | none |
| `evolution_zero_left_basisProjector_zero`, `evolution_zero_right_basisProjector_one`, `evolution_same_diagonalState_half` | boundary fixed states | `∀ (b t : ℝ), evolution 0 b t (basisProjector 0) = basisProjector 0`; `∀ (a t : ℝ), evolution a 0 t (basisProjector 1) = basisProjector 1`; `∀ (r t : ℝ), evolution r r t (diagonalState (1/2)) = diagonalState (1/2)` | none |

Proof design. Entries follow from the definition and the generator entry
theorems. `evolution_zero` uses `k(γ,0) = 0` and `f(γ,0) = 1`. The
semigroup law reduces, entry by entry, to `k(t+u) = k_t + e_t k_u`,
`f(t+u) = f_t f_u`, and `γ k_t = 1 - e_t`, closed by `linear_combination`
with the coefficient `k_u * (∓a X_00 ± b X_11)`. Trace preservation is the
cancellation of the two diagonal `k` terms. Hermiticity is entrywise with
`Matrix.IsHermitian.apply` and the conjugation of real casts. The
derivative is assembled from `hasDerivAt_pi` twice (with Mathlib's matrix
norm enabled locally), the scalar derivative lemmas transported to `ℂ` by
`HasDerivAt.ofReal_comp`, and the identity `γ k_t = 1 - e_t` which turns
`k' D = e_t D` into `L(Phi_t X)_ii`. The general fixed-point lemma handles
the off-diagonal entries by cases: at zero total rate `f = 1`, otherwise
`L X = 0` forces the coherences to vanish. The trace-linear formulas
substitute `k = (1 - e)/γ` and close by `field_simp` and `ring`. The
zero-total-rate identity uses `k = t` and `f = 1`; the signed witness
specializes it to `a = 1`, `b = -1`, where `L E_00 = E_11 - E_00`.

- Nontrivial witness / boundary cases: `evolution_one_neg_one_basisProjector_zero`
  shows the zero-total-rate branch is not the identity for signed rates
  (`Phi_t E_00 = diag(1 - t, t)`), while `evolution_zero_zero` shows it is
  the identity when both rates vanish. The one-zero-rate and equal-rate
  fixed states hold for every real remaining rate, including zero, as the
  assignment permits. All statements quantify over arbitrary real times,
  including negative ones; this is algebra, not a channel claim.
- Existing source matched or extended: Mathlib supplied every exponential,
  derivative, Pi-derivative, matrix-norm, and Hermitian lemma used (list in
  D012). No matrix-exponential or ODE framework was introduced.
- Any difference from the accepted contract, all recorded in D012: (a) the
  map is defined through its diagonal `X_ii + k L(X)_ii` and off-diagonal
  `f X_ij` structure rather than by four literal entry expressions; the
  four public entry theorems restate the contract's formulas exactly. (b)
  The general fixed-point lemma `evolution_apply_of_generator_eq_zero` is
  exported beyond the contract; the required fixed-state results are its
  instances. (c) The scalar layer, the entrywise Hermiticity criterion, and
  the derivative bridge are exported as reusable helpers. (d) The
  boundary-state generator identities are stated for arbitrary real
  remaining rates rather than reusing the stationary module's positive-rate
  iff theorems, because those carry positivity hypotheses the contract does
  not want here.
- Downstream use: the flow, its semigroup law, and the trace-linear
  formulas are the inputs of the next checkpoints named by the audit,
  finite Kraus certification with complete positivity and named-norm
  convergence. Neither is started.

## Trust evidence

- Transitive axiom output for every exported theorem: all 115 exports,
  including the four new definitions, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/evolution/v1/verification/28-axiom-audit.stdout.log`, parsed
  into `verification.json` key `axioms`; one report per export).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or
  `implemented_by`. `noncomputable` markers are code-generation attributes.
  The local matrix-norm instances are ordinary Mathlib definitions enabled
  in a section; they add no axioms.
- Every release module actually compiled: `lake build` of the four release
  modules and the umbrella (2530 jobs, the local modules being the last
  five; the rest are cached dependency artifacts), followed by explicit
  `lake env lean` re-elaboration of the four release sources and of
  `Audit/Contracts.lean`. The coverage control shows the gate fails if the
  new module is omitted.
- Validation gate fixture results: 15 of 15 cases passed with their expected
  outcomes (`evidence/evolution/v1/gate-tests/gate_tests.json`). The scripts
  are byte-identical to the accepted versions (`scripts/verify.py`
  `9a6d01e5...`, `scripts/test_verify.py` `44dddfe2...`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `8a48ec136eb9f4d156c8ea3d8f4feb5ca4162f005249d86cf0095f456c5b193c`;
  `FormalScience.lean` `fec7f9348266f7b142fe16989e55357ca2507f7cfc1bcd811b780c5fa55aea2f`;
  `Audit/Contracts.lean` `57376aa867a2e28a5a071587e65096b11144574a304c6061dd2fa329b74e9da4`;
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`;
  `FormalScience/OpenSystems/TwoStateStationary.lean` `745efb74d87359f6cacae50625e316e473f7dd27a595a9689fab083baff855e1`
  (changed from the accepted `f5af6d98...` by the two S3 docstrings only);
  `FormalScience/OpenSystems/TwoStateEvolution.lean` `8071d0962bae6a3c8e2d74dda1cc69364b5e9a6fe4de0320c7f63c4fb15d3be0`.
- Semantic review decision: self-review by the implementer only. Every
  elaborated type was read against the issued contract; the contract file
  spells out the exponentials and the `k` branch with `Real.exp` and an
  explicit `if`, restates all four entries, the trace-linear formulas, the
  `Id + t L` identity, the signed witness, and the matrix-valued derivative
  with the generator expanded to its weighted formula. The independent
  audit decision is pending.

## Blockers and next step

- Exact unresolved goal or API problem: none. Two formulations of the
  scalar derivative helpers were adjusted after a first compile (a
  function-shape mismatch in composing `HasDerivAt.neg` with `const_mul`,
  and the need to `subst` before simplifying the `γ = 0` branch); one
  `linear_combination` coefficient in the semigroup proof was corrected to
  use `γ k_t = 1 - e_t` at time `t`. The contract file needed
  `set_option quotPrecheck false` for the notation carrying an `if`.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): the
  first of the two remaining dynamics checkpoints named by the stationary
  audit, a finite Kraus representation of `evolution a b t` for `0 ≤ a`,
  `0 ≤ b`, `0 ≤ t` through the Stage 0 Kraus API (`krausMap`,
  `krausMap_trace_preserving`), with complete positivity quantified over
  finite ancillas or through a proved equivalent finite-dimensional
  criterion, and density preservation as its corollary. The trace-linear
  formulas of this module are the intended inputs.
- Changes requiring a contract decision: (a) accept the structural
  definition of the map with the four entry theorems as the contract
  surface; (b) accept the exported scalar layer and the two generic
  helpers; (c) accept the general fixed-point lemma and the
  arbitrary-rate boundary generator identities; (d) accept the
  dependency-scope extension of the cache command and the local matrix-norm
  instances as the formal setting of the derivative; (e) confirm the next
  checkpoint. No validation-script change is proposed; the scripts are
  unchanged.
- Suggested reviewer focus: confirm that `integratedExpFactor` has the
  `t` branch at `γ = 0` and that `evolution_one_neg_one_basisProjector_zero`
  is stated for `a = 1`, `b = -1`; confirm `hasDerivAt_evolution` carries
  no hypothesis and that its derivative is the generator applied to the
  evolved matrix, not to `X`; read the `Derivative` section's local
  instances and the matching section in `Audit/Contracts.lean`; confirm the
  trace-linear formulas keep the `Matrix.trace X` factor; and check that
  `TwoStateStationary.lean` differs from the accepted version only in the
  two docstrings.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
