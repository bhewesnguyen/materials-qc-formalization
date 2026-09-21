# Formal Science: Markov audit v1

## Accepted: finite Markov bridge

Independent implementation audit v1 | 21 September 2026 | Prepared for Jett Sturges

**Verdict: accept markov-milestone-v1. No proof revision round is required.** The arbitrary finite-state generator bridge meets contracts A-E, including signed-rate algebra, diagonal stationarity, probability-to-density consumers, and recovery of the accepted two-state generator.

### Exact submission reviewed

```text
Commit: 4795b8b6dc6ec7a831b9158affe3ee199f60e01e
Tag: markov-milestone-v1
Archive SHA-256:
ec3f3a115926efb2ba7081d3d98227ee8939004911a92a9cb76c13770317e07c
```

| Check | Independent result |
| --- | --- |
| Archive integrity | 2,906,595 bytes; 2,609 manifest payloads plus the manifest. Exact paths, sizes, hashes and CRC pass; no nested archives. |
| Accepted API | 8 modules, 216 exports, 193 distinct theorem contracts, 23 definitions or abbreviations. New: 3 definitions and 26 public theorems. |
| Fresh execution | 32 verification commands exit 0. All eight release sources and the independent contract file emit zero diagnostics. |
| Proof gate | All 216 exports use exactly propext, Classical.choice, Quot.sound. All 15 gate cases pass; two separate negative controls reject before building. |
| Preserved history | All 324 files of the prior convergence audit return match exactly. Earlier evidence and deliverables remain unchanged. |

Two low-severity documentation findings, M1 and M2, can be closed while preparing the next release-readiness candidate. The bounded Stage 4 extension is complete; a generic finite-state quantum dynamics theory is not claimed.

Acceptance concerns the supplied archive bytes. Remote Git ancestry, tag positions, receipt commit c42eccd, pushes and working-tree cleanliness were not independently authenticated. The auditor changed no submitted source or Git ref.

## The generator formulas are correct

The implementation uses an arbitrary finite index type with decidable equality. Rates are destination-first: q i j moves population from source j to destination i. The supplied diagonal q j j is ignored. The Hamiltonian is zero.

```text
r_j = sum_(i != j) q_ij
Q_ij = q_ij (i != j)       Q_jj = -r_j
L_q(X) = sum_(i != j) q_ij D[E_ij](X)
```

### Contract A: classical generator

The rate matrix is defined independently of the quantum output. Its columns sum to zero, and its action on a real column vector is inflow minus outflow. Summing that action gives zero total infinitesimal mass. Only the two nonnegativity certificates require nonnegative off-diagonal rates; every algebraic identity admits arbitrary signed real rates.

### Contract B: matrix-unit dissipators and full entries

```text
D[E_ij](X) = E_ii X_jj - (E_jj X + X E_jj)/2
(L_q X)_ii = sum_(j != i) q_ij X_jj - r_i X_ii
(L_q X)_ij = -(r_i+r_j)/2 * X_ij       (i != j)
```

The first dissipator term places X_jj at position (i,i). The adjoint product is E_jj, so the anticommutator subtracts half of row j and half of column j. The weighted sum gives the stated population and coherence laws. The coherence coefficient depends on the two source exit rates, with the correct factor one half.

These entry statements apply to every complex matrix. Trace annihilation consumes the accepted dissipator trace law; Hermiticity preservation consumes its Hermitian-input law and the reality of each scalar. Neither structural property requires rate nonnegativity.

### Why the exclusion mask matters

D[E_jj] is generally a nonzero dephasing map. Its coefficient must be zero here for arbitrary supplied diagonal rates to be ignored. The literal mask is present in exitRate and markovGenerator, and rateMatrix replaces its diagonal by the negative exit rate. The mask as one real scalar cast to complex is correct.

## The bridge, stationarity and boundaries

```text
C : real -> complex
L_q(diag(C p)) = diag(C (Q.mulVec p))
L_q(diag(C p)) = 0  <->  Q.mulVec p = 0
```

Contract C is an intertwining identity for arbitrary real vectors, not a definition chosen to make the result tautological. Off-diagonal outputs vanish by the coherence formula, and diagonal outputs agree with the independently defined classical action. The real-to-complex cast is explicit in both the public statement and its independent consumer.

### Contract D: probability vectors give densities

If p is entrywise nonnegative and sums to one, its complex diagonal is positive semidefinite with trace one. If Qp=0 as well, that diagonal is stationary. Rate nonnegativity is not needed for this implication: probability normalization and the stationary premise already supply exactly what is used. No existence or uniqueness theorem for generic stationary vectors is inferred.

| Boundary | Verified meaning |
| --- | --- |
| All rates zero | exitRate and rateMatrix vanish; markovGenerator equals the zero bundled linear map. |
| Diagonal-only rates | Arbitrary diagonal entries are ignored, giving the same zero generator and rate matrix. |
| Two-state recovery | q=[[0,b],[a,0]] gives Q=[[-a,b],[a,-b]] and bundled equality with the previously accepted generator a b, for signed a,b. |
| Empty and singleton | No Nonempty assumption leaks into algebra. Empty probability normalization is impossible; singleton rates are all excluded diagonal jumps. |

### API choices and independent contracts

Making dissipator_single public is useful and within scope. Matrix.of with finite-vector notation denotes the required explicit two-state matrices without extending the cached imports. There are 26 new consumed public theorems and 27 new example blocks: the two-state recovery theorem has both bundled and pointwise consumers. Counts of theorem contracts refer to distinct exported theorem names.

This is a zero-Hamiltonian generator result. It does not build a generic Markov or CPTP semigroup, establish mixing or irreducibility, classify the full quantum kernel, or assert positivity of an Euler step.

## Independent verification and preservation

The auditor reused the official Lean runtime and pinned dependency cache validated in the convergence audit, then built and re-elaborated this project in an isolated extraction. This is fresh project verification, not a full Mathlib source rebuild or a new download of the runtime.

```text
Lean 4.34.0
Compiler: 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b
Mathlib:  5ed2965256430c3649e86755f9576b54eca72435
```

All nine exact dependency revisions and tracked status were rechecked. Fresh source-hash, export-manifest and transitive-axiom maps match the submitted final evidence exactly. The eight modules, all consumer contracts, signatures and axiom queries compile successfully.

### The checks establish the stated boundary

- All 32 verification subprocesses succeed; all 15 expected-outcome gate tests pass. The omitted-module and unmentioned-contract-export fixtures fail before any release build, for their intended reasons.
- A separate source inventory accounts for 216 public declarations: 193 theorems and 23 definitions or abbreviations, plus seven private helpers. Every public name is exported and each theorem has a direct consumer.
- The ordinary gate does not discover a declaration omitted from both export lists. Its contract-name check is textual. Manual source and semantic contract review remain necessary and were performed for this snapshot.

### Earlier work remains intact

The accepted convergence payload has 1,998 manifest entries; the new payload has 2,609. There are 611 additions, nine changed paths and no removal. All 1,309 pre-existing evidence files, 651 audit files and 13 deliverable files are byte-identical. Historical return manifests validate, including the previously documented dissipator path relocations.

Six earlier release modules are unchanged. The seventh changes only its opening convergence comment, closing C1 after baseline reproduction. The previous 167 theorem contracts and their elaborated signatures are preserved. Both verifier scripts and all pins are unchanged. C2 is closed, and D017 correctly records the historical D016 wording erratum.

Commands, raw logs, control fixtures, source hashes, environment notes, mathematical review and preservation checks accompany this report. Successful verification is distinguished from intentional negative-test failures.

## Documentation findings and recorded decisions

**M1 and M2 are nonblocking.** No Lean theorem, definition, hypothesis, proof, gate script or dependency pin needs repair. Apply these prose changes in the release-readiness round while keeping the mathematical surface byte-identical.

### M1: README excludes a result now present

The introductory scope sentence excludes general finite-dimensional results beyond the Kraus and dissipator layers. It must also include the accepted finite Markov generator bridge. Keep the real limitation clear: the dynamical and convergence theorems concern the explicit two-state model; generic finite-state CPTP dynamics and convergence remain future work.

### M2: qualify the tracked planning memo

Row 13 says every density converges to the stationary density without stating positive total rate. Require nonnegative rates and a+b>0. At a=b=0 every trajectory is constant and there is no common attractor. Nearby correct discussion does not make the standalone table sentence accurate.

The remaining corrections are planning precision: replace the claim that the portfolio can never reach 100 percent with the absence of defined completion criteria; describe the hard rows as research-scale formalization; remove the unsupported one-audit-round forecast; and qualify the Hall and CAR/Hubbard reuse shortcuts by actual statement, import and dependency checks. SCOPE_MEMO_REVIEW.md supplies exact replacements.

### Tracking the memo is an accepted organizational choice

D018 records the user decision to track docs/SCOPE_MEMO.md. That decision supersedes the older assignment boundary. The loose attachment matches the tracked file exactly. Keep it tracked and describe it as a shipped planning document outside the Lean export inventory and proof gate. Do not rewrite the historical issued task or seek the same permission again.

### D019 and the next release boundary

The scalar exclusion mask, public matrix-unit identity and existing finite-matrix notation are sound choices. The pinned-source search supports only the reported narrow search result, not novelty or absence of equivalent mathematics everywhere.

There is no top-level project license in the supplied snapshot. This is not a mathematical blocker. The next candidate should collate provenance and dependency licenses, complete the concrete package, and report an unresolved owner license choice if no prior decision exists. Public release or upstream acceptance is not implied.

## Portfolio tally after Markov acceptance

| Accepted increment | Exports | Theorem contracts |
| --- | --- | --- |
| Stage 0 | 15 | 10 |
| Dissipator | 42 | 33 |
| Stationary | 72 | 61 |
| Evolution | 115 | 100 |
| Kraus | 158 | 139 |
| Convergence | 187 | 167 |
| Finite Markov bridge | 216 | 193 |

Seven mathematical increments are accepted: the six-increment two-state benchmark plus the bounded zero-Hamiltonian Stage 4 generator bridge. There are eight modules and 23 definitions or abbreviations. These are coverage counts, not independent novelty counts or a portfolio completion percentage.

| Original branch | Areas | Mathlib | Candidate | Unresolved / partial |
| --- | --- | --- | --- | --- |
| Quantum algorithms | 5 | 0 | 5 | 0 |
| Materials / open systems | 7 | 0 | 3 | 4 |
| Quantum information | 14 | 0 | 12 | 2 |
| Operations research | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

The corrected 1/28/10 reconnaissance labels are carried forward, not re-searched globally in this audit. Across the 39 broad rows: one identified Mathlib reuse endpoint, four rows with local partial progress, and 34 without local implementation. No broad row is newly declared complete.

Markov strengthens rows 10, 11 and 13 through finite generator algebra, the diagonal stationary equivalence and probability-to-density embedding. Row 15 retains the previously accepted finite Kraus and all-ancilla positivity work. Generic GKSL, generic uniqueness and mixing, Choi/Stinespring equivalence, and other branches remain outside this result.

The detailed 39-row ledger is in PORTFOLIO_STATUS.md. Stage 5 release readiness is next. A diagonal Hamiltonian extension, generic dynamics, and a new research branch require separate bounded assignments.

## Next: a bounded release-readiness candidate

The next task is release-readiness/v1 with tag release-readiness-milestone-v1. Preserve the accepted eight modules, 216 exports, 193 theorem contracts, all gate scripts, contracts, imports and dependency pins byte for byte. No new mathematical API is requested.

### Concrete deliverables

- Integrate this return by its exact manifest paths, freeze the issued task and activate a root copy. Record Markov acceptance, reproduce the untouched baseline, then apply M1/M2 to live documentation.
- Prepare a concise changelog, API guide, readiness record and factual provenance/license inventory. Keep signed-rate algebra, physical hypotheses, the zero-rate exception and generator-versus-flow scope explicit.
- Compile three anonymous public-API consumers: two-state density preservation, convergence under positive total rate, and the Fin 3 diagonal Markov bridge. Keep them outside the release export inventory.
- Commit and tag the candidate, archive the exact tag, and verify every payload. Extract that actual archive into a fresh directory without copied project build outputs, then rerun verification, gates and usage examples.
- Package post-tag archive-consumer evidence with a separate manifest and external receipt. A pinned dependency cache is permitted and must be reported. Keep each archive digest outside the archive it identifies.

### Preparation and publication are separate decisions

If no owner decision on the project license is already recorded, complete the candidate and return that concrete choice as pending. Do not infer the local license from dependency licenses, claim human review has happened, publish a GitHub Release, contact maintainers or submit upstream work. The implementer commits and tags; the user pushes.

### How to continue

The return ZIP contains the immutable report, AUDIT_RECEIPT.json, full evidence, SCOPE_MEMO_REVIEW.md, PORTFOLIO_STATUS.md, NEXT_FABLE_TASK.md and a copy/paste FABLE_KICKOFF.md under audits/markov/v1/. Verify RETURN_MANIFEST.json before integration; its keys are repository-relative and its payload set is authoritative.

The source archive and subsequent consumer-evidence archive are deliberately separate so the verified source package remains immutable. This checkpoint ends at independent release-readiness audit, with any owner decisions plainly identified.

**Decision:** Markov v1 accepted. The selected mathematical extension is complete. Proceed to release-readiness preparation with the current mathematical surface frozen.
