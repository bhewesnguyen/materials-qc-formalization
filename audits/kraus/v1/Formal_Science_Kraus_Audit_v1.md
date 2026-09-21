# Formal Science: Kraus audit v1

## Accepted: four-Kraus certification

Independent implementation audit v1 | 21 September 2026 | Prepared for Jett Sturges

**Verdict: accept kraus-milestone-v1. No proof revision round is needed.** The explicit four-operator certificate equals the accepted evolution on every complex qubit matrix, preserves trace, and establishes complete positivity for every finite ancilla. Independent Lean execution reproduces the submitted results.

### Exact submission reviewed

```text
Commit: 6431c9cd411a3a804d2a86ae733e23f393fe9361
Tag: kraus-milestone-v1
Archive SHA-256:
ef84addb5fbba564d69c12d8b9875e0f4a0227332a20b42dbcfe28f2e7d851f8
```

| Check | Independent result |
| --- | --- |
| Package integrity | 1,623,234 bytes; 1,514 manifest-covered payloads plus the manifest itself. Exact path set, hashes, sizes and CRC pass. No nested archives. |
| Public coverage | 6 release modules, 158 exports, 139 direct theorem consumer contracts. This increment adds 4 definitions and 39 theorems. |
| Fresh execution | All 30 verification subprocesses exit 0. All six release sources and independent contracts re-elaborate. |
| Axiom audit | Every one of the 158 exports reports exactly propext, Classical.choice, and Quot.sound. |
| Gate controls | All 15 gate cases pass. Both fresh omitted-module controls reject the intended missing module. |
| Earlier findings | E1 and E2 are closed. Historical returns, handoffs and evidence are preserved. |

Acceptance applies to the supplied source snapshot. It does not certify a remote tag or push status. The post-tag receipt is internally consistent with the archive; its commit is reported by the implementer.

## The mathematical certificate

The conventions remain consistent: rate a multiplies the jump E_10 from state 0 to state 1, and rate b multiplies E_01 in the reverse direction. The equilibrium population of state 0 is p = b/(a+b). Physical certification assumes only a >= 0, b >= 0 and t >= 0, including a+b = 0.

```text
gamma = a + b       p = b / gamma
c = exp(-gamma*t/2) d = sqrt(1-c^2)
K0 = sqrt(p) diag(1,c)
K1 = sqrt(p) d E_01
K2 = sqrt(1-p) diag(c,1)
K3 = sqrt(1-p) d E_10
```

Real square roots are cast into complex matrix scalars. The scalar layer proves the needed nonnegativity and bounds before using square-root identities. Products of casts in K1 and K3 have the intended value; the contracts spell out that exact elaborated form.

### Normalization and equality on all inputs

The completeness theorem proves sum_j K_j^H K_j = I. Its diagonal equations reduce to p + (1-p)(c^2+d^2) = 1 and p(c^2+d^2) + (1-p) = 1. The four Kraus-sum entry formulas then match the accepted evolution:

```text
00: (p+(1-p)c^2) X00 + p(1-c^2) X11
11: (1-p)(1-c^2) X00 + ((1-p)+p c^2) X11
01: c X01                    10: c X10
```

**The representation theorem quantifies over every complex matrix X.** It does not assume Hermiticity, positivity, trace one, diagonality or separability. The nonzero-total-rate proof uses the accepted trace-linear population formulas, preserving the trace factor.

### The zero-rate branch is genuine

With nonnegative rates, a+b = 0 implies a=b=0. Total real division gives p=0, while c=1 and d=0, so the family is [0,0,I,0] and represents the identity. Signed cancellation such as a=1, b=-1 is outside the physical certificate and is not confused with this branch.

The trace consumer directly applies the Stage 0 completeness-to-trace theorem. Positivity follows from Kraus congruence and finite sums; density preservation combines positivity with the accepted trace law.

## Why the CP endpoint is sufficient

Ordinary positivity on qubit matrices would leave a gap. This milestone supplies the required all-finite-ancilla statement and the bridge identifying the amplified map.

### An independent block definition

```text
Amp_m(Phi)(Y)[(r,i),(s,j)]
  = Phi(fun u v => Y[(r,u),(s,v)])[i,j]
```

The generic amplifier is defined by blocks, with the ancilla index first. It is not defined to be a Kraus sum. The generic lifting theorem proves, for every input Y, that this block action equals conjugation by the lifted operators I_m tensor K_j:

```text
Amp_m(krausMap K)(Y)
  = sum_j (I_m tensor K_j) Y (I_m tensor K_j)^H
```

This is an all-input identity, not merely a check on product states. Applying the generic PSD congruence and sum lemmas proves amplified positivity for every natural m and every positive semidefinite Y. Rectangular generic Kraus families are handled with only the needed finite-index assumptions.

| Endpoint | Audit conclusion |
| --- | --- |
| Generic finite Kraus PSD | Correct; no normalization premise is required. |
| Lifted-Kraus identity | Correct for arbitrary input blocks and every m. |
| Model complete positivity | For nonnegative a, b, t and every m, PSD Y implies PSD Amp_m(evolution)(Y). |
| Tensor convention | For every complex ancilla matrix A and input X, Amp_m(Phi)(A tensor X) = A tensor Phi(X). |
| Density preservation | Physical evolution maps PSD, trace-one inputs to PSD, trace-one outputs. |

Together with the accepted complex linearity, semigroup law and trace theorem, this establishes an explicit CPTP semigroup for the physical parameter range. No adapter to Mathlib's abstract CompletelyPositiveMap hierarchy is required for the issued endpoint.

Choi/Stinespring equivalences, a generic GKSL characterization, convergence, spectral gaps and entropy claims remain outside the accepted scope.

## Reproduction and trust boundary

| Layer | What was checked |
| --- | --- |
| Pinned environment | Lean 4.34.0, compiler 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b; Mathlib 5ed2965256430c3649e86755f9576b54eca72435. All nine locked dependency heads match and tracked trees are clean. |
| Release execution | Fresh lake build, six source elaborations, independent contracts, explicit signatures, and per-export transitive axiom queries. |
| Source identity | The fresh source-hash map and axiom map exactly match the submitted final verification. Both new modules have complete public export coverage. |
| Negative controls | Omitting TwoStateKraus or FiniteKraus from the release manifest independently fails the module-coverage check with exit 1 and the correct missing name. |
| Historical evidence | All 158 files of the previous audit return are byte-identical. All three historical return manifests pass; all prior implementer evidence is unchanged. |
| Input identity | Loose handoff and pointer equal the archived versions. ZIP comment, pointer and external receipt agree on the source identity. |

### What the execution establishes

The auditor reused the exact previously acquired Lean runtime and pinned Mathlib cache, then freshly elaborated the submitted project sources and independent consumers. No cache extension was needed. This is a fresh local proof check against pinned compiled dependencies, not a full rebuild of every dependency from source.

The kernel and the accepted Lean foundation axioms remain the logical trust base. The gate tests exercise direct and transitive forbidden axioms, sorryAx, missing exports, malformed or missing reports, and a vacuous false-premise contract. Source review checks the intended mathematics; an axiom whitelist alone cannot do that.

### Boundaries of the record

A source archive contains no complete Git history. The audit corroborates its recorded commit from supplied package metadata and compares file snapshots. It does not independently confirm the remote ref, working-tree cleanliness, receipt commit 2b39181, or publication. No repository or remote mutation was performed.

Raw commands, stdout/stderr, fixtures, package comparisons, source hashes and the input receipt accompany the returned report. The small convergence API probe is explicitly exploratory and does not implement or certify the next milestone.

## Findings, deviations and preservation

**No blocking mathematical, contract or packaging finding.** All mandatory Kraus endpoints are present and have the intended hypotheses. Acceptance is unconditional on a separate repair submission.

### Previous findings closed

E1: README now describes the accepted evolution and semigroup accurately, with the remaining exclusions. E2: D012 and D013 correctly describe HasDerivAt in the canonical matrix topology without a target norm argument. The one change to earlier Lean source is the documented Hermiticity docstring correction; proof bodies are unchanged.

### Declared deviations accepted

- Generic finite index types strengthen the reusable layer. Per-declaration instances avoid unnecessary assumptions.
- The unconditional time-zero and zero-right family identities are valid strengthenings. A family identity outside physical rates is not being presented as a channel certificate.
- Public scalar and entry lemmas support the convergence consumer. All 43 new exports are accounted for: 4 definitions and 39 theorem contracts.
- Two omission controls cover both the model module and the new Quantum directory. The generic probe provenance is disclosed in D014.

### Three optional prose cleanups

| Location | Suggested clarification |
| --- | --- |
| Contracts comment | Change the stale family name Kf to the actual local notation Kev. |
| D014 zero-left wording | The theorem was requested with b > 0; algebraically b != 0 suffices for p=b/b=1. Do not describe positivity as mathematically necessary. |
| Proof-method prose | The simp-only description fits completeness off-diagonal entries. Kraus-map off-diagonal entries also use linear_combination. |

These do not require changing a theorem or reopening this milestone. If adopted, correct the live contract comment after baseline reproduction and record the historical prose clarifications in a new decision entry. Preserve archived handoffs and audit returns.

### Precision for the next contract

A future decay estimate toward rhoStar needs trace(X)=1. For arbitrary X the stationary target is trace(X) times rhoStar. The new assignment states this explicitly. It also restricts pairwise contraction to equal-trace pairs; the stationary direction prevents a universal strict contraction on all matrices.

## Portfolio tally after acceptance

**Five bounded milestones are accepted:** Stage 0, dissipator, stationary, evolution and Kraus. The project now has six release modules, 158 exports, 139 theorem consumer contracts, and 19 definitions or abbreviations. These measure verification coverage, not novelty or percentage of the research portfolio completed.

| Milestone | Cumulative exports | Theorem contracts |
| --- | --- | --- |
| Stage 0 | 15 | 10 |
| Dissipator | 42 | 33 |
| Stationary | 72 | 61 |
| Evolution | 115 | 100 |
| Kraus | 158 | 139 |

### The broader inventory still contains 39 areas

| Branch | Areas | Mathlib target | Candidate | Unresolved / partial |
| --- | --- | --- | --- | --- |
| Quantum algorithms | 5 | 0 | 5 | 0 |
| Materials / open systems | 7 | 0 | 3 | 4 |
| Quantum information | 14 | 0 | 12 | 2 |
| Operations research | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

This carries forward the corrected reconnaissance; no new global literature search was performed for this audit. Hall (#28) is the identified Mathlib reuse item. The other 38 areas form an assess/reuse/extend backlog, not 38 proven missing formalizations. A candidate may cover only a narrower statement.

The ten unresolved or partial-only areas remain #6, #8, #9, #12, #21, #25, #31, #36, #38 and #39. This records the limits of the established search evidence, not proof that no formalization exists.

### What this increment advances

#10 now includes a concrete CPTP semigroup, but not the generic GKSL characterization. #11 still has stationary uniqueness without an attractivity theorem. #13 gains a density-preserving physical flow. #15 gains a four-Kraus certificate and all-finite-ancilla CP, without Choi/Stinespring equivalences. None of those broad rows is closed at its full inventory scope.

## Next milestone and integration

### Issue convergence as the next bounded task

Use TwoStateConvergence.lean and the accepted evolution. Define an explicit Frobenius quantity by sqrt(sum of squared entry norms), identify it with Mathlib's scoped Frobenius norm, and keep matrix limits in the canonical topology. A compiled API probe confirms the relevant norm and scalar-limit bridge at the existing pin.

```text
gamma = a+b > 0       T(X) = trace(X) * rhoStar
Delta = X-T(X)        R_t = evolution_t(X)-T(X)
D = |Delta00|^2 + |Delta11|^2
C = |Delta01|^2 + |Delta10|^2
||R_t||_F^2 = exp(-2*gamma*t) D + exp(-gamma*t) C
||R_t||_F <= exp(-gamma*t/2) ||Delta||_F   (t >= 0)
```

Require the corresponding matrix limit to T(X), trace-one and physical-density consumers, and the one-zero-rate stationary limits. Both-zero rates give identity evolution, so there is no common stationary attractor for all density inputs. No positive definiteness, primitivity or generic spectral theorem should be inferred from these special cases.

### Preserve the implementation / audit loop

- Extract the audit return at the repository root with its paths preserved under audits/kraus/v1/. Verify the full RETURN_MANIFEST.json payload, including the frozen issued next task.
- Record acceptance in TURNS.md and copy the issued NEXT_FABLE_TASK.md to the mutable root slot. Retain the frozen copy, earlier returns and evidence unchanged.
- Reproduce the accepted 158-export baseline before source edits. Then implement only the issued convergence assignment, with versioned evidence and direct contracts.
- Follow the established commit, tag, manifest, archive and post-tag receipt protocol. The implementer commits; the user pushes. Do not move accepted tags.

The return includes this report in PDF and Markdown, a machine-readable audit receipt, raw evidence, the full 39-row portfolio ledger, the immutable next assignment, and a ready-to-paste Cursor kickoff. The kickoff points Fable to the exact assignment rather than expanding the scope in conversation.

**Decision:** Kraus v1 accepted. Proceed to quantitative convergence. The broader research queue remains visible and bounded by the portfolio ledger.
