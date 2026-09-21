# Formal Science: stationary audit v1

## Accepted: the stationary milestone

Independent implementation audit v1 | 20 September 2026 | Prepared for Jett Sturges

**Verdict: accept stationary-milestone-v1. No proof revision is required.** The weighted generator, stationary density, uniqueness, and all required boundary cases have the intended meaning and reproduce independently. Three small record and wording findings can be closed at the start of the next turn.

### Exact submission reviewed

```text
Commit: a5347ca77a2b5e6678f514decb0ab4eee7b62943
Tag: stationary-milestone-v1
Archive SHA-256:
3d53dafea6d2963c15deca0ac5ae2ad20ef62bc650a70d25d9fb4d0941c7fce6
```

| Check | Independent result |
| --- | --- |
| Archive | 778,742 bytes. All 709 manifest-covered files match their recorded hashes and byte counts. Including the manifest, the ZIP contains 710 files. No extra paths or nested archives. |
| Proof coverage | 3 release modules, 72 public exports, 61 direct theorem contracts. Stationary adds 30 exports: 2 definitions and 28 theorems. |
| Fresh execution | 27 verification subprocesses exit 0. All release sources and the direct contracts re-elaborate. |
| Foundational assumptions | All 72 exports report exactly propext, Classical.choice, and Quot.sound. |
| Gate behavior | 15 of 15 self-test cases pass. The independently repeated omitted-module control rejects the intended omission. |
| Agreement | Fresh source-hash and axiom maps exactly match the submitted final evidence. |

The previous dissipator findings F1-F4 have been addressed. The mathematical implementation needs no repair, and a stationary v2 is unnecessary for the documentation corrections identified here.

The broader position is three accepted local milestones within a 39-area inventory. Hall is already an identified Mathlib reuse target. The other 38 areas need assessment, reuse, extension, or new work; this does not mean 38 missing formalizations.

## Generator and stationary solution

Reviewed source: FormalScience/OpenSystems/TwoStateStationary.lean, its dependencies, exports.json, and Audit/Contracts.lean. The model retains H=0, basis 0/1, a for 0 to 1, and b for 1 to 0.

```text
L[a,b](X) = (a : Complex) *scalar D[E_10](X)
          + (b : Complex) *scalar D[E_01](X)

L(X)_00 = -a X_00 + b X_11
L(X)_11 =  a X_00 - b X_11
L(X)_01 = -(a+b)/2 X_01
L(X)_10 = -(a+b)/2 X_10
```

Rates in the entry equations are cast to Complex. The bundled map is complex-linear by construction, and its formula theorem is definitional equality. The signs agree with the previously accepted jump conventions.

| Result | Assessment |
| --- | --- |
| Entry equations and trace | Correct for every complex qubit matrix and arbitrary real rates. Trace annihilation directly consumes the accepted dissipator trace law. |
| Hermiticity preservation | Correct when the input is Hermitian. Real rates need not be nonnegative. It does not claim that arbitrary non-Hermitian inputs become Hermitian. |
| Candidate | rhoStar(a,b) = diagonalState(a/(a+b)). At nonzero total rate, its explicit diagonal is (b/(a+b), a/(a+b)). The necessary division premise is retained. |
| Stationarity | The candidate is stationary when a+b is nonzero. The proof uses the component equations, with no physical positivity assumption. |
| Uniqueness | For any complex matrix X with trace X=1 and a+b nonzero, L(X)=0 iff X=rhoStar(a,b). The unknown X need not be diagonal, Hermitian, or PSD. |

### Why the uniqueness theorem is substantive

The two coherence equations force both off-diagonal entries to vanish by cancellation of the nonzero total-rate coefficient. The remaining balance equation and trace one determine the diagonal entries. The proof does not build the desired answer into an assumption.

The direct consumers expand the generator into weighted Mathlib matrix units and the candidate into its diagonal entries. All 28 new theorem exports have consumers, including uniqueness applied to an arbitrary trace-one matrix.

## Physical validity and boundaries

Algebraic uniqueness and existence of a valid density are separate results. The source correctly requires nonnegative rates and positive total rate only for the physical density endpoint.

| Hypotheses | Accepted conclusion |
| --- | --- |
| a+b != 0 | rhoStar is stationary and is the unique trace-one stationary complex matrix. No general density-existence claim follows for signed rates. |
| a>=0, b>=0, a+b>0 | rhoStar is PSD with trace one, and there exists exactly one density rho satisfying L(rho)=0. |
| a=0, b>0 | The unique stationary density is E_00. It need not be faithful. |
| a>0, b=0 | The unique stationary density is E_11. Strict positivity of both rates is unnecessary. |
| a=b=0 | The generator is zero on every matrix. Two distinct basis densities explicitly refute unique stationary-density existence. |
| a=b=r, r>0 | The unique stationary density is diagonalState(1/2). No unequal-rate assumption occurs. |

### Accepted strengthening and API choices

- The density-input stationarity biconditional needs only a+b != 0. This does not assert that rhoStar is a density for every signed rate pair.
- rhoStar_zero_left legitimately has no premise on b; rhoStar_same needs only r != 0. These algebraic equalities respect Lean total division.
- Keep generator_zero_zero_of_isDensity. Its unused density premise is a harmless explicit corollary of the stronger zero-generator theorem. Removing it would create unnecessary API churn.
- The two small public helpers and four candidate-entry lemmas are useful additions. The private arithmetic helper introduces no extra axiom.

### Zero total rate is not always the zero generator

With signed rates a=1 and b=-1, the total rate vanishes but L(X)_00=-trace(X). Thus no trace-one stationary matrix exists in that example. The both-zero results correctly concern a=b=0, not all signed cancellation pairs.

No density-preserving dynamics, convergence, complete positivity, generic GKSL characterization, or general Perron-Frobenius theorem is established by this milestone. The implementation stops at the agreed stationary boundary.

## Independent reproduction and trust

### What was run

The auditor verified the attached archive, extracted an immutable review copy, and ran both unchanged validation scripts from a separate reproduction copy. The local project was freshly built and each release source was explicitly re-elaborated.

```text
python3 scripts/verify.py --lake <pinned-lake> \
  --output-dir <auditor-evidence>/verification
python3 scripts/test_verify.py --lake <pinned-lake> \
  --output-dir <auditor-evidence>/gate-tests
```

The raw JSON and stdout/stderr records contain the actual absolute paths, commands, compiler responses, dependency revisions, and exit codes. Fresh verification finished at 2026-09-20T22:50:42.734185+00:00.

| Evidence | What it establishes |
| --- | --- |
| Pinned environment | Lean 4.34.0; compiler commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b. Mathlib commit 5ed2965256430c3649e86755f9576b54eca72435. All nine dependency HEADs match and tracked files are clean. |
| Kernel and contracts | 27 successful verification subprocesses; all three local release modules and the 61 contracts compile. Every exported theorem has a direct consumer. |
| Axiom policy | Every one of the 72 exported definitions/theorems reports only the accepted foundational set. This includes dependencies of the private helper through its consumers. |
| Negative controls | 15 gate cases pass. A retained altered export manifest independently triggers the expected unlisted TwoStateStationary module rejection. |
| Frozen history | The 109 Stage 0 evidence files and 213 dissipator evidence files match the prior submission byte for byte. Earlier source, scripts, and dependency pins are unchanged. |

### Reproduction boundary

The prior audit toolchain, pinned dependency checkouts, and official compiled cache were reused. Their revisions and tracked cleanliness were checked again. This is fresh local proof elaboration, not a full source rebuild of Mathlib. The toolchain archive checksum is preserved in environment.json.

Compilation, allowed axioms, exact consumer types, and mathematical interpretation are distinct checks. Together they support this acceptance. They do not establish novelty, upstream acceptance, or a new global audit of external quantum libraries.

## Three nonblocking corrections

Close these in the next implementation turn. Preserve accepted tags, historical handoffs, and prior evidence. No mathematical theorem or accepted premise needs changing.

| ID / priority | Finding and concrete remedy |
| --- | --- |
| S1 / low; Archived assignment | The preserved dissipator return is missing the original NEXT_FABLE_TASK.md listed in its manifest. All 142 other payloads match. The exact 9,319-byte original is recoverable and is included in this return at audits/dissipator/v1/NEXT_FABLE_TASK.md. Restore it without editing the old manifest. The root task remains the only mutable active assignment. |
| S2 / low; Record pointers | The stationary handoff cites log numbers 27 and 28; the actual signature and axiom logs are 26-export-signatures.stdout.log and 27-axiom-audit.stdout.log under evidence/stationary/v1/verification/. Record an erratum. Update the duplicated and stale README next-step paragraph and the TURNS.md forward evidence pattern to evidence/<key>/v<k>/. |
| S3 / low; Scope wording | Replace the coherence docstrings saying decays with the algebraic coefficient statement. Arbitrary signed rates and no time evolution are involved yet. Correct the blanket claim that no theorem applies at a+b=0: unconditional entry identities and the explicit both-zero results do apply. The nonzero-total-rate stationary uniqueness theorem does not cover signed cancellation. |

### Exact restoration supplied

```text
audits/dissipator/v1/NEXT_FABLE_TASK.md
Bytes: 9319
SHA-256:
8c49d97f9380833fa7e53aea388308208a670911eca4b7d40c540663b15d9fe0
```

The old return manifest has 143 payload entries and excludes itself. The preserved folder currently has 142 payloads plus that manifest; restoring the issued task completes the set. Verification uses the documented mapping from original return-root paths into the audit folder. No contract text was substantively lost.

### Previous findings are closed

F1 now gives an executable staging, manifest, commit, tag, archive, and receipt sequence. F2 versions new evidence by round. F3 corrects the projector-versus-identity explanation. F4 records the dependency-license erratum. The post-tag stationary RECEIPT is correctly external to the archive it hashes.

Keep historical handoffs unchanged and record these new errata in D011. Make the live docstring changes only after reproducing the untouched accepted baseline; subsequent evidence should record their new source hashes.

## The broader formalization tally

**39 research areas; three accepted local milestones.** These are different units. Public declarations and theorem contracts measure audited API coverage, not the percentage of research areas completed.

| Branch | Areas | Mathlib; reuse | Candidates | Unresolved /; partial only |
| --- | --- | --- | --- | --- |
| Quantum algorithms | 5 | 0 | 5 | 0 |
| Materials / open systems | 7 | 0 | 3 | 4 |
| Quantum information | 14 | 0 | 12 | 2 |
| Operations research | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

This grouping reconciles the recorded portfolio reconnaissance; it is not a fresh global search. Candidate means a relevant source, reported result, or narrower endpoint that still requires a precise reuse audit. Unresolved means the recorded search did not establish the matching full target, not proof of worldwide absence.

### What has actually been completed locally

- Stage 0: the agreed finite matrix, density, and Kraus trace foundation.
- Dissipator: general finite-dimensional dissipator algebra and qubit jump specializations.
- Stationary: the two-state generator, stationary density, arbitrary trace-one uniqueness, and boundary cases.

Together these give 72 public exports: 61 theorem contracts and 11 definitions or abbreviations. The pilot contributes narrow pieces to #10 GKSL, #11 quantum Perron-Frobenius, #13 state foundations, and #15 channel representations. None of those broad areas is fully closed by the pilot.

### What remains in the portfolio

Hall (#28) is an identified Mathlib reuse/reference item. The pinned source includes Finset.all_card_le_biUnion_card_iff_exists_injective in Mathlib/Combinatorics/Hall/Basic.lean. That external module was identified, not added to this release or independently rebuilt here.

The remaining 38 areas form the assess/reuse/extend backlog: 28 candidate-bearing rows and 10 unresolved or partial-only rows (#6, #8, #9, #12, #21, #25, #31, #36, #38, #39). PORTFOLIO_STATUS.md provides the full row-by-row ledger and next actions.

## Next: explicit two-state evolution

Refine the roadmap dynamics stage into three reviewable checkpoints: (1) explicit linear evolution, semigroup, and derivative; (2) finite Kraus representation and properly quantified complete positivity; (3) named-norm convergence. Only the first is the next active assignment.

### A formula valid for all real rates and times

```text
gamma = a+b
c(gamma,t) = exp(-gamma*t/2)
k(gamma,t) = if gamma=0 then t
             else (1-exp(-gamma*t))/gamma

Phi(X)_00 = X_00 + k*(-a*X_00 + b*X_11)
Phi(X)_11 = X_11 + k*( a*X_00 - b*X_11)
Phi(X)_01 = c*X_01
Phi(X)_10 = c*X_10
```

Cast real coefficients to Complex. Bundle Phi as a complex-linear map on all qubit matrices. At nonzero total rate, also prove its diagonal entries equal e*X_00+(1-e)*(b/gamma)*trace(X) and e*X_11+(1-e)*(a/gamma)*trace(X), where e=exp(-gamma*t). The trace factor is essential to linearity.

| Required endpoint | Scope |
| --- | --- |
| Initial value and composition | Phi_0=Id; Phi_(t+u)=Phi_t composed with Phi_u for all real rates and times. |
| Trace and Hermiticity | Trace is preserved for every X. Hermiticity is preserved when X is Hermitian. |
| Matrix-valued derivative | HasDerivAt for t -> Phi_t(X), with derivative L(Phi_t(X)), at every real time. Entrywise differentiation may be used to construct this endpoint. |
| Fixed point and boundaries | rhoStar is fixed for gamma!=0. Phi[0,0,t]=Id. At gamma=0 prove Phi_t(X)=X+t*L(X), including a signed-cancellation witness. |

The k branch matters: gamma=0 with nonzero signed rates does not have identity evolution. For a=1,b=-1, Phi_t(E_00)=diagonalState(t). The extension to all real time makes the derivative statement ordinary two-sided calculus; it does not give a quantum-channel claim for negative time.

These are the next implementation contracts, not Lean results proved in this audit. Stop before density preservation by the flow, CPTP, general ODE uniqueness, matrix-exponential identification, convergence, or another research branch.

## Using the returned package

Support files are under audits/stationary/v1/ unless another path is shown.

| File or directory | Purpose |
| --- | --- |
| audits/stationary/v1/ | This report in PDF and Markdown, audit receipt, raw auditor evidence, portfolio snapshot, and the frozen issued next assignment. Preserve the entire return folder as received. |
| audits/dissipator/v1/NEXT_FABLE_TASK.md | The exact missing historical assignment. Restore at this path; do not replace it with the current task. |
| Root NEXT_FABLE_TASK.md | Create the editable root copy from the issued assignment during integration. The frozen copy in audits records what was issued; it is not a second active task. |
| FABLE_KICKOFF.md | A copy/paste Cursor prompt to record acceptance, close S1-S3, reproduce the baseline, and implement only evolution. |
| RETURN_MANIFEST.json and; RETURN_README.md | Hashes and installation instructions for the return itself. Validate the path set and bytes before integrating. |

### Next round identity

```text
Milestone: evolution
Module: FormalScience/OpenSystems/TwoStateEvolution.lean
Tag: evolution-milestone-v1
Evidence: evidence/evolution/v1/
Handoff: deliverables/evolution/v1/HANDOFF.md
Future audit: audits/evolution/v1/
```

Extract the return at the repository root, preserving its audits/ paths. Keep the current pins and representation. Reproduce the accepted 72-export baseline before any Lean source edit, then implement the bounded task and run the existing gates. The implementer commits and tags; the user pushes. Accepted tags are never moved.

### Identity and review limits

The supplied archive comment and external receipt agree on commit a5347ca77a2b5e6678f514decb0ab4eee7b62943. The declared diff base is be2ad90088b3c407d2aa18aafe3a2e806db35011, with housekeeping commit 26cd50698d171ed939310cd0289ce91257996282. The receipt is reported in a later commit, d7c53a6.

This audit accepts the attached bytes identified by their digest. The ZIP contains no Git history, and no remote tag, push state, or commit ancestry was independently authenticated. No source, tag, branch, or remote was changed during the audit.

Primary records: the submitted stationary handoff and pointer; the active stationary contract; the three release modules; Audit/Contracts.lean; exports.json; D009-D010; AGENTS.md; the portfolio roadmap; and the new auditor evidence included with this return.
