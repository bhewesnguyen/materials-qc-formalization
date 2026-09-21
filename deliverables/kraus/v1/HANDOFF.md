# Stage audit handoff: four-Kraus certification of the two-state evolution

Completed from AUDIT_HANDOFF_TEMPLATE.md on 21 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/kraus/v1/`; nothing is asserted from an editor state.

## Scope

- Stage and accepted contract IDs: implementation round 4, milestone `kraus`,
  round `v1`, as issued with the evolution audit
  (`audits/evolution/v1/NEXT_FABLE_TASK.md`, copied unchanged to the root
  slot with a status note). Required: record the evolution acceptance and
  close E1 and E2; reproduce the accepted 115-export baseline; then certify
  the accepted flow as a trace-preserving finite Kraus map for `0 ≤ a`,
  `0 ≤ b`, `0 ≤ t` with the exact four operators, completeness, equality on
  every complex matrix, positivity and density preservation, the
  independently defined blockwise amplifier with its lifted-Kraus identity,
  the all-finite-ancilla PSD theorem, the tensor-action check, and the
  boundary identities at both-zero rates, time zero, and each one-zero-rate
  direction.
- Commit under review: the commit tagged `kraus-milestone-v1`, whose tree
  contains this document. Its hash is `git rev-parse
  kraus-milestone-v1^{commit}`; it is also recorded in
  `deliverables/kraus/v1/RECEIPT.json`, committed after the tag, and in the
  delivery message. Diff base: the accepted evolution commit
  `a60a92b6064b4dde33a98d3c79be195c77595873`. Between them sit the evolution
  receipt commit `90030e1` and the housekeeping commit
  `ae74628`, which integrated the audit return, activated the assignment,
  and closed E1 and E2 without touching proof source. The accepted tags
  `dissipator-milestone-v1`, `stationary-milestone-v1`, and
  `evolution-milestone-v1` were not moved.
- What is complete: all required results, in two new release modules:
  `FormalScience/Quantum/FiniteKraus.lean` (1 definition, 5 theorems) and
  `FormalScience/OpenSystems/TwoStateKraus.lean` (3 definitions, 34
  theorems; three `private` helpers). Umbrella, export manifest (158
  exports), and independent contracts (139 theorem contracts) cover every
  new public declaration. Both validation scripts pass on the final source.
  The one comment-only change to accepted source (the docstring of
  `qubitMatrix_isHermitian_of_entries` in `TwoStateEvolution.lean`) was made
  after the baseline reproduction, with hashes recorded below.
- What is explicitly incomplete: nothing from the assignment. Not attempted,
  by instruction: norm contraction, convergence, spectral gaps,
  faithfulness, Choi or Stinespring equivalence, generic GKSL,
  Perron-Frobenius, the Markov bridge, Hamiltonian extensions, entropy,
  circuits, and OR. No adapter to Mathlib's C*-algebra
  `CompletelyPositiveMap` hierarchy was built, as permitted; the endpoint is
  the explicit universally quantified PSD statement.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/kraus/v1/environment.json`); the
  user's workstation.
- Lean toolchain: `leanprover/lean4:v4.34.0`, `Lean (version 4.34.0,
  x86_64-unknown-linux-gnu, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b,
  Release)`; the same installation as the previous rounds. The release
  archive checksum was measured by the auditor (`caaa9835...b646b`).
- Lake version: `Lake version 5.0.0-src+293d5d0 (Lean version 4.34.0)`.
- Mathlib commit: `5ed2965256430c3649e86755f9576b54eca72435`, clean. The
  new modules import `Mathlib.LinearAlgebra.Matrix.Kronecker` and
  `Mathlib.Analysis.Real.Sqrt`, both already inside the cached closure of
  the README command; no cache extension and no pin change this round.
- Other dependency commits and licenses: unchanged and verified clean at
  their locked revisions; eight package roots Apache 2.0 and `Cli` MIT, per
  `audits/dissipator/v1/evidence/dependency_license_inventory.json`. The
  only externally authored source adapted this round is the auditor's
  in-project probe `audits/evolution/v1/reference/KrausProbe.lean` (D014).
- Exact clean-build commands and exit codes:
  1. Baseline reproduction before any source change (tree at `ae74628`):
     `python3 scripts/verify.py --output-dir evidence/kraus/v1/reproduction/verification`
     (exit 0; 28 commands all exit 0; 115 exports; `source_sha256` identical
     to `evidence/evolution/v1/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir evidence/kraus/v1/reproduction/gate-tests`
     (exit 0; 15 cases).
  2. Final verification: `python3 scripts/verify.py --output-dir
     evidence/kraus/v1/verification` (exit 0; 30 commands all exit 0) and
     `python3 scripts/test_verify.py --output-dir evidence/kraus/v1/gate-tests`
     (exit 0; 15 cases).
  3. Coverage controls, expected to fail, each with its altered manifest
     retained as `omitted-module.json`:
     `evidence/kraus/v1/gate-controls/missing-module/` (exit 1, `Release
     module coverage mismatch: unlisted=['FormalScience.OpenSystems.TwoStateKraus']`)
     and `evidence/kraus/v1/gate-controls/missing-generic-module/` (exit 1,
     `unlisted=['FormalScience.Quantum.FiniteKraus']`), the second showing
     that the coverage scan reaches the new `FormalScience/Quantum/`
     directory.
  The 30 commands of run 2, in order: `lake env lean --version`;
  `lake --version`; `git rev-parse HEAD` and `git status --porcelain
  --untracked-files=no` for Mathlib and the eight other packages;
  `lake build` of the six release modules and the umbrella; `lake env lean`
  on the six release sources and on `Audit/Contracts.lean`;
  `lake env lean --json Signatures.lean`; `lake env lean --json
  AxiomQueries.lean`.
- Release module/export manifest: `exports.json`, schema 1, six release
  modules, 158 exports (15 Stage 0, 27 dissipator, 30 stationary, 43
  evolution, 6 generic Kraus, 37 two-state Kraus), 139 contract exports
  (10, 23, 28, 39, 5, 34). Source scans confirmed every public declaration
  of both new modules is listed.
- Raw log paths: `evidence/kraus/v1/reproduction/{verification,gate-tests}/`,
  `evidence/kraus/v1/verification/` (including `Signatures.lean`,
  `AxiomQueries.lean`, `29-export-signatures.stdout.log` with `pp.explicit`
  types, and `30-axiom-audit.stdout.log`; the run has 30 commands so these
  numbers are correct for this round), `evidence/kraus/v1/gate-tests/`,
  `evidence/kraus/v1/gate-controls/{missing-module,missing-generic-module}/`,
  and `evidence/kraus/v1/environment.json`. All earlier evidence trees are
  unchanged.

## Statement review

Generic declarations are in namespace `FormalScience.Quantum`, source path
`FormalScience/Quantum/FiniteKraus.lean`; two-state declarations are in
`FormalScience.OpenSystems`, source path
`FormalScience/OpenSystems/TwoStateKraus.lean`. Readable types are quoted
from `#check`; fully explicit types are in the signature log. `↑x` is the
cast of a real into `ℂ`; `krausMap K X` is the Stage 0 sum
`∑ j, K j * X * (K j)ᴴ`; `⊗ₖ` is Mathlib's Kronecker product.

### Definitions and conventions

| Declaration | Definition | Notes |
| --- | --- | --- |
| `amplify` | `{α β} → (m : ℕ) → (Matrix α α ℂ → Matrix β β ℂ) → Matrix (Fin m × α) (Fin m × α) ℂ → Matrix (Fin m × β) (Fin m × β) ℂ`; `amplify m Φ Y (r, i) (s, j) = Φ (Matrix.of fun u v => Y (r, u) (s, v)) i j` | ancilla index first; takes an unbundled function, so linearity enters only where a bundled map is supplied |
| `equilibriumZero` | `equilibriumZero a b := b / (a + b)` | `p`, the equilibrium population of state `0`; total division gives `0` at zero total rate; not the `diagonalState` parameter |
| `jumpAmplitude` | `jumpAmplitude γ t := Real.sqrt (1 - halfExpFactor γ t ^ 2)` | `d`; `c = halfExpFactor γ t = exp(-(γ t)/2)` is the accepted coherence coefficient |
| `evolutionKraus` | `evolutionKraus a b t : Fin 4 → QubitMatrix`, `![↑√p • diag(1, ↑c), (↑√p * ↑d) • jumpOneToZero, ↑√(1-p) • diag(↑c, 1), (↑√(1-p) * ↑d) • jumpZeroToOne]` | `jumpOneToZero = E_01`, `jumpZeroToOne = E_10`; scalar products are products of casts |

Conventions preserved: basis `0, 1`; `a` on `E_10`, `b` on `E_01`; zero
Hamiltonian; `evolution`, `generator`, `rhoStar`, `krausMap`, `IsDensity`
reused unchanged. `Stage0.lean`, `Dissipator.lean`, and
`TwoStateStationary.lean` are byte-identical to the accepted versions
(hashes below). `TwoStateEvolution.lean` differs from the accepted version
only in the docstring named in D013.

### Generic layer

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `krausMap_posSemidef` | `∀ [Fintype α] [Fintype β] [Fintype κ] (K : κ → Matrix β α ℂ) {X}, X.PosSemidef → (krausMap K X).PosSemidef` | PSD input only; no normalization |
| `amplify_apply` | `amplify m Φ Y (r, i) (s, j) = Φ (Matrix.of fun u v => Y (r, u) (s, v)) i j` (proof `rfl`) | none |
| `amplify_krausMap` | `∀ [Fintype α] [Fintype κ] (m) (K) (Y), amplify m (krausMap K) Y = krausMap (fun j => 1 ⊗ₖ K j) Y` | none; every `Y` |
| `amplify_krausMap_posSemidef` | `Y.PosSemidef → (amplify m (krausMap K) Y).PosSemidef` | PSD input |
| `amplify_kronecker` | `∀ (m) (Φ : Matrix α α ℂ →ₗ[ℂ] Matrix β β ℂ) (A) (X), amplify m Φ (A ⊗ₖ X) = A ⊗ₖ Φ X` | `Φ` complex-linear |

### Scalar facts

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `halfExpFactor_sq` | `c^2 = expFactor γ t` | none |
| `halfExpFactor_pos` | `0 < c` | none |
| `halfExpFactor_le_one` | `c ≤ 1` | `0 ≤ γ`, `0 ≤ t` |
| `one_sub_halfExpFactor_sq_nonneg` | `0 ≤ 1 - c^2` | `0 ≤ γ`, `0 ≤ t` |
| `jumpAmplitude_sq` | `d^2 = 1 - c^2` | `0 ≤ γ`, `0 ≤ t` |
| `equilibriumZero_nonneg`, `equilibriumZero_le_one` | `0 ≤ p`, `p ≤ 1` | `0 ≤ a`, `0 ≤ b` |
| `one_sub_equilibriumZero` | `1 - p = a / (a + b)` | `a + b ≠ 0` |
| `equilibriumZero_of_add_eq_zero` | `p = 0` | `a + b = 0` |
| `eq_zero_of_add_eq_zero` | `a = 0 ∧ b = 0` | `0 ≤ a`, `0 ≤ b`, `a + b = 0` |

### Certificate (physical hypotheses `0 ≤ a`, `0 ≤ b`, `0 ≤ t` unless stated)

| Declaration | Informal statement | Elaborated Lean type | Assumptions |
| --- | --- | --- | --- |
| `evolutionKraus_apply_zero/one/two/three` | the four operators | `evolutionKraus a b t 0 = ↑√(equilibriumZero a b) • Matrix.diagonal ![1, ↑(halfExpFactor (a+b) t)]`, etc. (proofs `rfl`) | none |
| `evolutionKraus_complete` | `∑ Kjᴴ Kj = 1` | `∀ {a b t}, 0 ≤ a → 0 ≤ b → 0 ≤ t → ∑ j, (evolutionKraus a b t j)ᴴ * evolutionKraus a b t j = 1` | physical |
| `krausMap_evolutionKraus_apply_zero_zero` | `(p + (1-p) c^2) X_00 + p (1 - c^2) X_11` | as displayed, with real coefficients cast | physical |
| `krausMap_evolutionKraus_apply_one_one` | `(1-p)(1 - c^2) X_00 + ((1-p) + p c^2) X_11` | as displayed | physical |
| `krausMap_evolutionKraus_apply_zero_one`, `..._one_zero` | `c X_01`, `c X_10` | as displayed | physical |
| `evolution_eq_krausMap` | all-matrix representation | `∀ {a b t}, 0 ≤ a → 0 ≤ b → 0 ≤ t → ∀ (X : QubitMatrix), evolution a b t X = krausMap (evolutionKraus a b t) X` | physical; `X` arbitrary |
| `krausMap_evolutionKraus_trace` | trace consumer of completeness | `(krausMap (evolutionKraus a b t) X).trace = X.trace` | physical |
| `evolution_posSemidef` | positivity | `X.PosSemidef → (evolution a b t X).PosSemidef` | physical, PSD input |
| `evolution_isDensity` | density preservation | `IsDensity X → IsDensity (evolution a b t X)` | physical, density input |
| `amplify_evolution_eq_krausMap` | lifted-Kraus identity | `∀ (m) (Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) ℂ), amplify m (evolution a b t) Y = krausMap (fun j => 1 ⊗ₖ evolutionKraus a b t j) Y` | physical; every `m`, every `Y` |
| `amplify_evolution_posSemidef` | complete positivity | `∀ (m) {Y}, Y.PosSemidef → (amplify m (evolution a b t) Y).PosSemidef` | physical, PSD input; every `m` |
| `amplify_evolution_kronecker` | tensor action | `∀ (a b t : ℝ) (m) (A) (X), amplify m (evolution a b t) (A ⊗ₖ X) = A ⊗ₖ evolution a b t X` | none (arbitrary real rates and times) |

### Boundaries

| Declaration | Statement | Assumptions |
| --- | --- | --- |
| `evolutionKraus_zero_zero` | `evolutionKraus 0 0 t = ![0, 0, 1, 0]` | none (every real `t`) |
| `krausMap_evolutionKraus_zero_zero` | `krausMap (evolutionKraus 0 0 t) X = X` | `0 ≤ t` |
| `evolutionKraus_time_zero` | `evolutionKraus a b 0 = ![↑√p • 1, 0, ↑√(1-p) • 1, 0]` | none (every real rate pair) |
| `krausMap_evolutionKraus_time_zero` | `krausMap (evolutionKraus a b 0) X = X` | `0 ≤ a`, `0 ≤ b` |
| `evolutionKraus_zero_left` | `evolutionKraus 0 b t = ![diag(1, ↑c), ↑d • jumpOneToZero, 0, 0]` with `c, d` at `γ = 0 + b` | `0 < b` (so `p = b/b = 1`) |
| `evolutionKraus_zero_right` | `evolutionKraus a 0 t = ![0, 0, diag(↑c, 1), ↑d • jumpZeroToOne]` with `c, d` at `γ = a + 0` | none (every real `a`, including `0`) |
| `evolution_isDensity_zero_left` | `IsDensity X → IsDensity (evolution 0 b t X)` | `0 ≤ b`, `0 ≤ t` |
| `evolution_isDensity_zero_right` | `IsDensity X → IsDensity (evolution a 0 t X)` | `0 ≤ a`, `0 ≤ t` |

Proof design. Completeness and the four entry formulas are entrywise via
`qubitMatrix_ext`: `simp` expands the four-term sum, the diagonal and
matrix-unit products, and the conjugation of real casts; off-diagonal
entries close under `simp`, and each diagonal residual is closed by
`linear_combination` with the three square-root facts `(√p)^2 = p`,
`(√(1-p))^2 = 1 - p`, `d^2 = 1 - c^2` (private `sqrt_facts`, which is where
`0 ≤ p ≤ 1` and `0 ≤ 1 - c^2`, hence the physical hypotheses, are used). The
representation splits on `a + b = 0`: at zero total rate nonnegativity
forces `a = b = 0`, `p = 0`, `c = 1`, and both sides reduce to `X` via the
accepted `evolution_zero_zero`; otherwise the Kraus entries are compared
with the accepted trace-linear population formulas using `c^2 = e`,
`p = b/γ`, `1 - p = a/γ`, and `trace X = X_00 + X_11`, closed by
`field_simp` and `ring`. Positivity is the generic Kraus lemma through the
representation; density preservation adds the accepted unconditional
`evolution_trace`. The lifted-Kraus identity rewrites the flow as the Kraus
sum (function extensionality from the representation) and applies the
generic `amplify_krausMap`; complete positivity then follows from the
generic PSD lemma on the lifted family. The tensor-action check is the
generic `amplify_kronecker` at the bundled `evolution a b t`. Boundary
family identities are `funext` plus `fin_cases` over `Fin 4` with the
scalar facts `p = 0`, `p = 1`, `c = 1`, `d = 0` as appropriate; the
represented-map identities specialize the representation to the accepted
`evolution_zero_zero` and `evolution_zero`.

- Nontrivial witness / boundary cases: the both-zero case is covered
  without any positive-total-rate premise, with the family collapsing to
  `![0, 0, 1, 0]`; at time zero the two nonzero operators are `√p • 1` and
  `√(1-p) • 1`, whose squares sum to one, and no single operator is
  required to be the identity; both one-zero-rate directions are covered,
  with `evolutionKraus_zero_right` valid at `a = 0` as well. The
  physical hypotheses are satisfiable by any nonnegative triple. Signed
  cancellation `a = -b ≠ 0` is deliberately outside the certificate: total
  division would give `p = 0` there, and the family is not claimed to
  represent the accepted flow in that regime.
- Existing source matched or extended: Mathlib supplied the PSD, Kronecker,
  square-root, exponential, and finite-sum lemmas listed in D014; the
  auditor's probe supplied the shape of the generic layer, adapted with
  provenance recorded. The accepted Stage 0 `krausMap_trace_preserving`,
  the evolution entry and fixed-point theorems, and the dissipator
  matrix-unit identities are consumed directly.
- Any difference from the accepted contract, all recorded in D014: (a) the
  generic layer is stated for arbitrary finite system indices `α`, `β`,
  which the assignment allowed; (b) the scalar products in `K1`, `K3` are
  elaborated as products of casts `↑√p * ↑d`, and the consumer contracts
  restate them in that form; (c) `evolutionKraus_zero_right` holds for
  every real `a` and `evolutionKraus_time_zero` for every real rate pair,
  stronger than the physical statements requested; (d) the ten scalar facts
  and the four entry formulas of the Kraus sum are exported as public
  theorems rather than kept private, since the convergence checkpoint will
  reuse them; (e) two coverage controls were retained instead of one.
- Downstream use: the certificate and the trace-linear entry formulas are
  the inputs of the remaining dynamics checkpoint named by the audit,
  quantitative convergence in a named norm. It is not started.

## Trust evidence

- Transitive axiom output for every exported theorem: all 158 exports,
  including the four new definitions, report exactly
  `[propext, Classical.choice, Quot.sound]`
  (`evidence/kraus/v1/verification/30-axiom-audit.stdout.log`, parsed into
  `verification.json` key `axioms`; one report per export).
- Standard foundational axioms accepted: `propext`, `Classical.choice`,
  `Quot.sound`.
- Forbidden/custom/native assumptions detected: none. The release modules
  contain no `sorry`, `admit`, `axiom`, `native_decide`, or
  `implemented_by`. `noncomputable` markers are code-generation attributes.
- Every release module actually compiled: `lake build` of the six release
  modules and the umbrella (2532 jobs, the local modules being the last
  seven; the rest are cached dependency artifacts), followed by explicit
  `lake env lean` re-elaboration of the six release sources and of
  `Audit/Contracts.lean`. The two coverage controls show the gate fails if
  either new module is omitted.
- Validation gate fixture results: 15 of 15 cases passed with their expected
  outcomes (`evidence/kraus/v1/gate-tests/gate_tests.json`). The scripts are
  byte-identical to the accepted versions (`scripts/verify.py`
  `9a6d01e5...`, `scripts/test_verify.py` `44dddfe2...`).
- Source hashes of the tested files (SHA-256, from `verification.json`):
  `lean-toolchain` `8733782dc070a99b312039cda424f601b80f3be6f6f512627da5ba25adc27632`;
  `lakefile.toml` `7ce638070ed8dd0a0d64280ecbdd5a9ac0fcfa26ae2b190e321aac3ff12003fe`;
  `lake-manifest.json` `bf782855f3900257333229a005a4158c054550761a2fcaaba57348b3ab9db3a7`;
  `exports.json` `1cf6810464f628bcd3fc19c4b0db4c6692c9e8bfa04f75e677e76046cfd22e73`;
  `FormalScience.lean` `ed276880575737f2ea0f30fe0ea6efa2a8c797e868bace540a1fba8a6a01b079`;
  `Audit/Contracts.lean` `7bc313231a4271a598c99f28a6bd989652b68a802c0dea28633e2a271a40eab6`;
  `scripts/verify.py` `9a6d01e56f55913084038636cb5fbedaf7dd4a40638304e61488cc7619fad757`;
  `scripts/test_verify.py` `44dddfe2bcd28c016eda7e6d33e6331975de521a01a27387988601954df2d596`;
  `FormalScience/Stage0.lean` `b8022c56e22bd3d9f0fc965a769015d8484520dc3a0915e2c3d5e8b97dc101f5`;
  `FormalScience/OpenSystems/Dissipator.lean` `abaec0a4a01fe746599ffbc3117ed7dd6ce1d42c88861fced777684e26577ada`;
  `FormalScience/OpenSystems/TwoStateStationary.lean` `745efb74d87359f6cacae50625e316e473f7dd27a595a9689fab083baff855e1`;
  `FormalScience/OpenSystems/TwoStateEvolution.lean` `541772ee2f865c567bede484e2a5e25562531da1294e5fdcb7abc0c4cd069e37`
  (changed from the accepted `8071d0962bae6a3c8e2d74dda1cc69364b5e9a6fe4de0320c7f63c4fb15d3be0`
  by one docstring only, D013);
  `FormalScience/Quantum/FiniteKraus.lean` `1fe2ec3bb001f4503a29a91dd1cc1fa907effa74f8128817c53a4c1551b0e5e5`;
  `FormalScience/OpenSystems/TwoStateKraus.lean` `f21f85bb6595cf64407734bd7795b3fe01b962a6cab7bacab1d98b4433a79f87`.
- Semantic review decision: self-review by the implementer only. Every
  elaborated type was read against the issued contract; the contract file
  pins each of the four operators with `Real.sqrt`, `Real.exp`, real
  division, and the matrix units, writes the Kraus sums as explicit `∑`,
  exposes the amplifier's block formula, the lifted-Kraus identity on
  arbitrary `Y`, the all-`m` PSD conclusion, the tensor action, and the
  both-zero and time-zero cases. The independent audit decision is pending.

## Blockers and next step

- Exact unresolved goal or API problem: none. Two adjustments were made
  during implementation: the section-level `Fintype` instances of the
  generic module were replaced by per-declaration binders so that no
  exported statement carries an unused instance, and the both-zero family
  identity needed its scalar hypotheses stated at `γ = 0` rather than
  `0 + 0` to match `simp`'s normal form. In the contract file, spelling the
  whole family inside a `∑` made the unifier time out, so the four
  operators are pinned individually in fully spelled-out contracts and the
  family is referred to by name inside sums.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): the
  remaining dynamics checkpoint named by the audits, quantitative
  convergence: define the Frobenius norm explicitly on `QubitMatrix` (or a
  verified equivalent), prove `‖evolution a b t ρ - rhoStar a b‖ ≤
  exp(-(a+b) t / 2) ‖ρ - rhoStar a b‖` for `0 ≤ a`, `0 ≤ b`, `0 < a + b`,
  `0 ≤ t`, and deduce convergence as `t → ∞`. The entry formulas of the
  evolution and Kraus modules are the intended inputs.
- Changes requiring a contract decision: (a) accept the generic layer's
  arbitrary finite indices; (b) accept the product-of-casts form of the
  `K1`, `K3` scalars; (c) accept the stronger unconditional boundary family
  identities; (d) accept the exported scalar facts and Kraus-sum entry
  formulas; (e) confirm the next checkpoint. No validation-script change is
  proposed; the scripts are unchanged.
- Suggested reviewer focus: confirm `equilibriumZero a b = b / (a + b)` is
  the equilibrium population of state `0` and that `K1 = (√p * d) • E_01`
  carries the `1 → 0` jump while `K3 = (√(1-p) * d) • E_10` carries
  `0 → 1`; confirm that `evolution_eq_krausMap` quantifies over every
  complex `X` with only the three physical hypotheses; confirm that
  `amplify_evolution_posSemidef` quantifies over every `m` and every PSD
  `Y` and that `amplify_evolution_eq_krausMap` needs no positivity of `Y`;
  read the private `sqrt_facts` for where the hypotheses enter; and check
  that the only change to accepted source is the one docstring.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
