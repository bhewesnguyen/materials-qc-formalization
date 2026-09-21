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

## D010: two-state stationary pilot (stationary milestone, round v1)

`FormalScience/OpenSystems/TwoStateStationary.lean` implements the active
assignment. Contract-to-Lean mapping:

| Contract | Lean declaration |
| --- | --- |
| `L[a,b]` | `generator a b : QubitMatrix →ₗ[ℂ] QubitMatrix`, built as `(a : ℂ) • dissipatorLinearMap jumpZeroToOne + (b : ℂ) • dissipatorLinearMap jumpOneToZero`; the weighted formula is `generator_apply` (proof `rfl`) |
| four entry equations | `generator_apply_zero_zero`, `generator_apply_one_one`, `generator_apply_zero_one`, `generator_apply_one_zero` |
| trace, Hermiticity | `generator_trace`, `generator_isHermitian` |
| `rhoStar(a,b)` | `rhoStar a b := diagonalState (a / (a + b))`; `rhoStar_eq_diagonal` gives `diag(b/(a+b), a/(a+b))` under `a + b ≠ 0` |
| stationarity | `generator_rhoStar` under `a + b ≠ 0` |
| algebraic uniqueness | `generator_eq_zero_iff_of_trace_eq_one` under `a + b ≠ 0` and `trace X = 1`, for every complex `X` |
| density validity | `rhoStar_isDensity` under `0 ≤ a`, `0 ≤ b`, `0 < a + b` |
| density iff | `isDensity_generator_eq_zero_iff`, stated under only `a + b ≠ 0` (see below) |
| unique existence | `existsUnique_stationary_density` under the physical hypotheses |
| `a = 0`, `b > 0` | `rhoStar_zero_left` (no hypothesis), `isDensity_generator_zero_left_eq_zero_iff` |
| `a > 0`, `b = 0` | `rhoStar_zero_right` (needs `a ≠ 0`), `isDensity_generator_zero_right_eq_zero_iff` |
| `a = b = 0` | `generator_zero_zero`, `generator_zero_zero_of_isDensity`, `not_existsUnique_stationary_density_zero_zero` |
| `a = b = r > 0` | `rhoStar_same` (needs `r ≠ 0`), `isDensity_generator_same_eq_zero_iff` |

Design choices. The generator is the bundled linear map the contract offered
as its first option; linearity is therefore inherited and no separate
`generator_add` or `generator_smul` is exported. The entry equations are
derived from the accepted closed forms `dissipator_jumpZeroToOne_eq` and
`dissipator_jumpOneToZero_eq` by evaluating diagonal products entrywise.
Uniqueness is proved for an arbitrary complex matrix: the two off-diagonal
equations force the coherences to vanish because the real scalar
`(a + b) / 2` is nonzero, and the balance equation with trace one fixes both
populations by `linear_combination`; the unknown matrix is never assumed
diagonal, Hermitian, or positive.

Hypothesis placement. The contract lists the density iff under the
physical hypotheses; it is exported under only `a + b ≠ 0`, which is
strictly stronger and is what the unique-existence theorem consumes with
`hab.ne'`. Nonnegative rates appear exactly where they are needed: the
density validity of the candidate and the unique-existence endpoint. The
candidate identities `rhoStar_zero_left` and `rhoStar_same` carry the
minimal hypotheses their arithmetic needs (`none` and `r ≠ 0`); the
uniqueness specializations carry the physical `0 < b`, `0 < a`, `0 < r`.
`generator_zero_zero_of_isDensity` restates the contract line "every
density is stationary" literally; its density hypothesis is unused by
design and the general `generator_zero_zero` is the stronger statement.

Two small public helpers are exported because later milestones will reuse
them: `isSelfAdjoint_ofReal` (real casts are self-adjoint in `ℂ`) and
`qubitMatrix_ext` (four-entry extensionality on `Fin 2`). One arithmetic
lemma, `one_sub_div_add`, is `private`. Mathlib supplied
`Matrix.trace_fin_two`, `Matrix.diagonal_mul`, `Matrix.mul_diagonal`,
`Matrix.diagonal_apply_eq`, `Complex.conj_ofReal`, `Complex.star_def`,
`div_le_one₀`, `div_nonneg`, `eq_div_iff`, `div_ne_zero`, `zero_div`,
`div_self`, and the tactics `field_simp`, `linear_combination`, `linarith`,
`push_cast`, `ring`. No downstream source was consulted or copied.

Specification warning, recorded as requested and not formalized. For
signed real rates, `a + b = 0` does not imply `a = b = 0`: with `a = 1`,
`b = -1` the entry equation gives `L(X)_00 = -X_00 - X_11 = -trace X`, so no
trace-one matrix is stationary and `rhoStar 1 (-1) = diagonalState 0` is
not stationary. Every theorem that needs `a + b ≠ 0` states it; the
both-zero conclusions are stated for `a = b = 0` exactly. Lean division is
total, so `rhoStar a b` has a value at `a + b = 0`; which theorems apply
there is stated precisely in D011, S3.

## D011: corrections carried forward from the stationary audit

The stationary audit (`audits/stationary/v1/`) accepted
`stationary-milestone-v1` at commit `a5347ca` with no proof revision and
three low-severity findings. The historical handoff
`deliverables/stationary/v1/HANDOFF.md` and its evidence are preserved
unchanged; the corrections are recorded here and applied to live documents.

S1, archived assignment. The dissipator return's manifest listed the issued
stationary assignment (`NEXT_FABLE_TASK.md`, 9319 bytes, SHA-256
`8c49d97f...d9fe0`) among its 143 payloads, but round 2 stored only the
other 142 under `audits/dissipator/v1/`, on the reasoning that the root copy
was identical at the time. The root copy later received a status note, so
the exact issued bytes lived only in Git history. The auditor supplied the
exact restoration; it is now at `audits/dissipator/v1/NEXT_FABLE_TASK.md`,
matches both the historical manifest and `git show 26cd506:NEXT_FABLE_TASK.md`,
and the old manifest is unchanged. Rule going forward, recorded in
AGENTS.md: the return manifest defines the payload set to store, including
the issued assignment; the root `NEXT_FABLE_TASK.md` is the only mutable
copy.

S2, record pointers. The stationary handoff cites the signature and axiom
logs as `27-export-signatures.stdout.log` and `28-axiom-audit.stdout.log`;
the run has 27 commands, so the correct files are
`evidence/stationary/v1/verification/26-export-signatures.stdout.log` and
`evidence/stationary/v1/verification/27-axiom-audit.stdout.log`. The README
"Next step" paragraph carried a duplicated sentence and a stale clause
about the stationary system; `TURNS.md` described evidence paths as
`evidence/<key>/` and claimed commit hashes could not be recorded although
the table already held historical hashes. All three live texts are
corrected in the round 3 housekeeping commit.

S3, wording. Two docstrings in `TwoStateStationary.lean` said the coherence
"decays at half the total rate". The theorems state that the `(0,1)` and
`(1,0)` entries of `L(X)` are `-(a+b)/2` times the corresponding entries of
`X`, for arbitrary real rates; decay is the physical reading for
nonnegative rates and there is no time evolution in that module. The
docstrings are changed to the algebraic statement in a comment-only edit
made after the untouched baseline was reproduced (`evidence/evolution/v1/reproduction/`),
so the module's source hash changes from `f5af6d98...` while the accepted
tag is untouched. Likewise, the D010 sentence "no theorem claims anything
about it there" (about `rhoStar a b` at `a + b = 0`) was too broad: the
four entry identities, `rhoStar_apply_one_one`, the off-diagonal lemmas,
`rhoStar_zero_left`, and the explicit both-zero results do apply at
`a + b = 0`; what does not apply is the stationary uniqueness theorem,
which requires `a + b ≠ 0` and does not cover nonzero signed cancellation.
For the record: generator Hermiticity preservation assumes a Hermitian
input, whereas the entry and trace identities hold for arbitrary complex
matrices.

## D012: explicit two-state evolution (evolution milestone, round v1)

`FormalScience/OpenSystems/TwoStateEvolution.lean` implements the active
assignment. Contract-to-Lean mapping:

| Contract | Lean declaration |
| --- | --- |
| `e(gamma,t)`, `f(gamma,t)`, `k(gamma,t)` | `expFactor γ t := Real.exp (-(γ * t))`, `halfExpFactor γ t := Real.exp (-(γ * t) / 2)`, `integratedExpFactor γ t := if γ = 0 then t else (1 - Real.exp (-(γ * t))) / γ` |
| scalar identities | `integratedExpFactor_zero`, `mul_integratedExpFactor` (`γ k = 1 - e`), `integratedExpFactor_add`, `halfExpFactor_add`, `hasDerivAt_expFactor`, `hasDerivAt_halfExpFactor`, `hasDerivAt_integratedExpFactor` (`k' = e`), plus the branch lemmas `integratedExpFactor_of_eq_zero`, `integratedExpFactor_of_ne_zero`, `halfExpFactor_of_eq_zero`, `expFactor_of_eq_zero`, `expFactor_zero`, `halfExpFactor_zero` |
| `evolution (a b t)` | `evolution a b t : QubitMatrix →ₗ[ℂ] QubitMatrix`; one bundled map whose underlying function is the `private` `evolutionFun` |
| four entry equations | `evolution_apply_zero_zero`, `evolution_apply_one_one`, `evolution_apply_zero_one`, `evolution_apply_one_zero`; structurally `evolution_apply_diag` (`X_ii + k * L(X)_ii`) and `evolution_apply_offDiag` (`f * X_ij`) |
| `Phi_0 = Id`, semigroup | `evolution_zero`, `evolution_add` (bundled-map equalities, all real rates and times) |
| trace, Hermiticity | `evolution_trace` (unconditional), `evolution_isHermitian` (Hermitian input) |
| matrix-valued derivative | `hasDerivAt_evolution : HasDerivAt (fun s => evolution a b s X) (generator a b (evolution a b t X)) t`, via the bridge `hasDerivAt_qubitMatrix` |
| fixed point, trace-linear formulas | `evolution_rhoStar` (`a + b ≠ 0`), `evolution_apply_zero_zero_of_ne_zero`, `evolution_apply_one_one_of_ne_zero`; the general `evolution_apply_of_generator_eq_zero` (`L X = 0 → Phi_t X = X`, no rate hypothesis) |
| zero total rate | `evolution_eq_id_add_smul_generator` (`a + b = 0 → Phi_t = Id + t • L`), `evolution_zero_zero`, `evolution_one_neg_one_basisProjector_zero` (`Phi_t E_00 = diagonalState t` at `a = 1, b = -1`) |
| boundary fixed states | `evolution_zero_left_basisProjector_zero`, `evolution_zero_right_basisProjector_one`, `evolution_same_diagonalState_half`, each from the general fixed-point lemma and a generator identity valid for every real remaining rate (`generator_zero_left_basisProjector_zero`, `generator_zero_right_basisProjector_one`, `generator_same_diagonalState_half`) |

Design choices. The map is defined entrywise through `Matrix.of`: on the
diagonal `X_ii + k * (generator a b X)_ii`, off the diagonal `f * X_ij`.
Reusing the generator's diagonal entries makes the public entry theorems
one rewrite each and makes the fixed-point lemma immediate. The `if` on
real `γ` uses the classical decidable equality of `ℝ`, so the scalar
functions and the map are `noncomputable`, like every earlier definition
involving real division. The semigroup law reduces to the scalar identity
`k(t+u) = k_t + e_t k_u` and to `γ k_t = 1 - e_t`, and the derivative to
`k' = e` and `f' = -(γ/2) f`, all proved with explicit `γ = 0` and `γ ≠ 0`
branches. The `γ = 0` branch of `k` is `t`, so signed cancellation
(`a = -b ≠ 0`) yields `Phi_t = Id + t L` with `L ≠ 0`, as the assignment
requires; `evolution_one_neg_one_basisProjector_zero` witnesses it.

Norm on matrices. `HasDerivAt` needs a normed-space structure on
`QubitMatrix`. Mathlib provides none globally; `Matrix.normedAddCommGroup`
and `Matrix.normedSpace` (the entrywise supremum norm) are enabled as local
instances in the `Derivative` section of the module and again in the
derivative section of `Audit/Contracts.lean`. In finite dimension every
norm gives the same derivative, but the Lean statement is formally relative
to this instance; a later convergence milestone must name its own norm
(the roadmap asks for Frobenius) separately. The bridge
`hasDerivAt_qubitMatrix` is `hasDerivAt_pi` applied twice, which works
because the matrix norm is definitionally the Pi norm.

Dependency scope. The module imports `Mathlib.Analysis.SpecialFunctions.ExpDeriv`,
`Mathlib.Analysis.Complex.RealDeriv`, `Mathlib.Analysis.Calculus.Deriv.Prod`,
and `Mathlib.Analysis.Matrix.Normed`. These are outside the Stage 0 cache
closure, so the README cache command now lists them; the fetch added 339
cached files at the same Mathlib revision (`evidence/evolution/v1/setup/cache-get.log`).
No dependency pin changed. Mathlib supplied `Real.exp_add`,
`HasDerivAt.exp`, `HasDerivAt.const_mul`, `HasDerivAt.const_sub`,
`HasDerivAt.div_const`, `HasDerivAt.mul_const`, `HasDerivAt.const_add`,
`HasDerivAt.ofReal_comp`, `hasDerivAt_id'`, `hasDerivAt_pi`,
`Matrix.IsHermitian.ext`, `Matrix.IsHermitian.apply`, `Matrix.of_apply`,
`star_mul'`, and the earlier trace, cast, and matrix-unit lemmas. No
downstream source was consulted or copied.

Public surface. The scalar layer (three definitions, thirteen lemmas) is
exported because the convergence milestone will reuse it. The two generic
helpers `qubitMatrix_isHermitian_of_entries` and `hasDerivAt_qubitMatrix`
are exported for the same reason. In `Audit/Contracts.lean` the `k` branch
is written with an explicit `if`; the local notation carrying it needs
`set_option quotPrecheck false`, which disables only an eager syntax check
and does not change what the notation elaborates to.

What is not claimed. Nothing about positivity, complete positivity, density
preservation by the flow, Kraus representation, norm estimates, convergence,
ODE uniqueness, or matrix exponentials. Negative times are covered by the
algebra only; no channel interpretation is attached to them.

