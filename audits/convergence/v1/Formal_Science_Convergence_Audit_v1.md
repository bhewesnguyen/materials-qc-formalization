# Formal Science: convergence audit v1

## Accepted: quantitative convergence

Independent implementation audit v1 | 21 September 2026 | Prepared for Jett Sturges

**Verdict: accept convergence-milestone-v1. No proof revision round is needed.** The named Frobenius estimate, matrix-valued limit, physical consumers and rate boundaries meet the issued contracts. This completes the planned two-state mathematical benchmark. Two documentation corrections can accompany the next milestone.

### Exact submission reviewed

```text
Commit: a3cbac0692b4c106a89e80c91d18b0c2de4988cd
Tag: convergence-milestone-v1
Archive SHA-256:
322a46cb9c45db8663dcdee73ddb3899dc9c7cda0e9d3dfb1fbe1bd3f32b6d1d
```

| Check | Independent result |
| --- | --- |
| Archive integrity | 2,159,927 bytes; 1,998 manifest-covered payloads plus the manifest. Exact path set, sizes, hashes and CRC pass; no nested archives. |
| Release coverage | 7 modules, 187 exports, 167 theorem contracts, 20 definitions or abbreviations. The increment adds 1 definition and 28 theorems. |
| Fresh verification | All 31 verification commands exit 0. Seven release sources and the independent contract file re-elaborate. |
| Axioms and gates | Every export uses exactly propext, Classical.choice, Quot.sound. All 15 gate cases pass; both separate controls reject as intended. |
| Historical preservation | All 203 original Kraus audit-return files match exactly. The six accepted release modules, scripts and pins are unchanged. |

The source archive is accepted as supplied. Remote tag state, working-tree cleanliness and receipt commit 754c08b were not independently authenticated. No repository source, tag or remote was modified.

## The quantitative theorem is correct

The implementation explicitly names the Frobenius norm and proves its equality with Mathlib's scoped Frobenius instance. It does not silently use the default matrix norm. The independent consumer exposes the finite-sum definition and selects the same named scope.

```text
F(X) = sqrt(sum_i sum_j |X_ij|^2)
gamma = a+b      tau = trace(X)
T(X) = tau * rhoStar(a,b)      Y = X-T(X)
e = exp(-gamma*t)             c = exp(-gamma*t/2)
```

### Exact centered dynamics

For nonzero total rate, the two diagonal entries of Phi_t(X)-T(X) equal e times the corresponding entries of Y. The off-diagonal entries equal c times the corresponding entries of Y and need no rate restriction. These identities hold for arbitrary complex matrices and every real time, without Hermiticity, positivity or normalization premises.

```text
D = |Y_00|^2 + |Y_11|^2
C = |Y_01|^2 + |Y_10|^2
F(Phi_t(X)-T(X))^2 = e^2 D + c^2 C
```

The squared diagonal energy has rate 2*gamma; the squared coherence energy has rate gamma. The proof expands the four squared entry norms, uses positivity of real exponentials, and finishes by ring algebra. The contracts expose Real.exp and the trace factor.

### The sharp coefficient in the centered estimate

```text
gamma > 0, t >= 0:
F(Phi_t(X)-T(X)) <= exp(-gamma*t/2) F(X-T(X))
```

Because e=c^2 and 0<c<=1, the exact identity gives c^4 D+c^2 C <= c^2(D+C). Comparing nonnegative square roots gives the stated coefficient one. Individual rates need not be nonnegative for this algebraic result; physical channel conclusions retain their separate rate assumptions.

Trace-one inputs have T(X)=rhoStar. For equal-trace X and Z, apply the theorem to X-Z and use linearity to obtain the pairwise bound. Keeping the trace condition is essential.

## Limits, physical meaning and boundaries

| Endpoint | Audited meaning |
| --- | --- |
| Scalar error limit | F(Phi_t(X)-trace(X) rhoStar) tends to 0 for gamma>0. A squeeze uses the bound only at eventually nonnegative times. |
| Matrix-valued limit | Phi_t(X) tends to trace(X) rhoStar in the canonical matrix topology. Entrywise limits are assembled with tendsto_pi_nhds twice. |
| Physical consumer | For a,b>=0 and gamma>0, a density remains a density and satisfies the Frobenius estimate. The limit theorem also consumes accepted validity of rhoStar. |
| a=0, b>0 | Every trace-one input tends to the state-0 basis projector. |
| a>0, b=0 | Every trace-one input tends to the state-1 basis projector. |
| a=b=r>0 | Every trace-one input tends to the maximally mixed diagonal state. |
| a=b=0 | Every trajectory is constant. The two distinct basis densities rule out a single matrix attracting all densities. |

The matrix limit uses the canonical product topology with no target norm parameter. No norm-equivalence theorem is missing: the quantitative theorem names its norm, while the matrix limit is proved directly in the intended topology.

### The optional witness adds a useful check

E_01 is a flow eigenvector with eigenvalue c for all real rates and times. Its Frobenius norm is one, so F(Phi_t(E_01))=c. It saturates the centered all-matrix bound. E_01 is not a density, and no sharpness claim among density inputs is credited.

### Scope of acceptance

The boundary consumers use trace-one premises rather than PSD plus trace one. This is an allowed strengthening. Scalar aliases in theorem statements are acceptable because the independent contracts expose their exact exponentials. Nothing here proves trace-norm or diamond-norm contraction, generic spectral theory, or a general Perron-Frobenius theorem.

## Independent execution and gate limits

The prior transient runtime was unavailable. The auditor downloaded the official Lean 4.34.0 archive again and verified the same SHA-256 recorded in earlier rounds:

```text
caaa98356098c85dc0fcbbd28e1ec66f39eb6551829972b752ff20e1286b646b
```

The compiler commit is 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b and Mathlib is pinned to 5ed2965256430c3649e86755f9576b54eca72435. All nine dependencies were acquired at their exact locked Git revisions. The documented targeted cache covers 2,509 files; this is not a full dependency source rebuild.

### Fresh checks and historical comparison

- All seven release sources, 167 direct theorem contracts, explicit signatures and 187 transitive axiom reports were freshly checked. Source-hash and axiom maps match the submission.
- All 15 ordinary gate cases pass. The omitted-module fixture produces the expected coverage rejection. The unmentioned-contract-export fixture is rejected before the build step.
- The original accepted Kraus source archive and auditor-return ZIP were recovered and checked against their previously recorded hashes. All historical evidence and handoffs are preserved.
- Direct contract comparison confirms the original 139 consumer statements are unchanged; the earlier paragraph edit is comment-only. The 28 convergence contracts are appended.

### The abandoned control exposed a documented limitation

Removing a declaration from both export lists is not detected automatically. The gate checks release-module coverage, listed names, contract mentions and proof assumptions. It does not discover every intended public declaration. Fable disclosed the passed trial and replaced it with controls that test actual enforced checks.

This is not a proof failure in the submitted milestone. An independent source inventory accounts for all 187 public declarations and all 167 direct theorem consumers. The manual completeness check remains a release obligation. A mere textual mention of a name is not, on its own, evidence of a correctly stated consumer contract.

The returned evidence distinguishes intentional negative-test failures from the successful verification run. It includes commands, raw logs, fixtures, acquisition records, environment details, source hashes and package comparisons.

## Two low-severity documentation findings

**No theorem, definition, hypothesis or proof needs repair.** C1 and C2 concern prose and can be corrected during integration of the next milestone. Preserve the accepted snapshot and reproduce its baseline before changing a source comment.

### C1: the opening comment conflates two limits

Location: FormalScience/OpenSystems/TwoStateConvergence.lean, module header. The sentence saying both the scalar error and the matrix tend to trace(X) rhoStar is incorrect. The implemented scalar theorem tends to zero; the matrix theorem tends to trace(X) rhoStar. Replace the sentence with those two distinct statements.

### C2: README retains a stale exclusion

Location: README.md, introductory exclusions. It says the release does not prove convergence, despite the implemented module and later description. On integration, record convergence as accepted and retain the real exclusions: Choi/Stinespring equivalence, generic GKSL, and the other unimplemented branches.

This repeats the pattern behind the earlier E1 README finding: a static exclusion paragraph became stale when a milestone landed. Update the existing overview and exclusions together; a new test suite or documentation framework is unnecessary.

### Related wording precision

A fixed stationary direction rules out a uniform full-space factor strictly below one. It does not by itself refute nonexpansiveness F(Phi_t X)<=F(X). That unconditional inequality is false in general for a separate reason: for a=1, b=0 and X=I, the output is diag(e,2-e), and for t>0 its squared Frobenius norm is 2+2(1-e)^2 > 2=F(I)^2.

Keep the module description centered on the proved trace-fiber estimate. Record the corresponding historical D016 wording clarification in a new D017 erratum, rather than rewriting D016 or the submitted handoff. The displayed counterexample here is an explanatory calculation, not an additional claimed Lean release theorem.

### Preservation requirements

The six prior release modules, dependency pins and validation scripts remain unchanged. Fix the new header comment only after reproducing the accepted 187-export baseline, recording its changed hash. Keep every historical audit return, issued assignment, handoff and evidence tree immutable.

## How to read the personal scope memo

The memo is useful planning context and correctly separates local formal results from the heterogeneous research inventory. It is outside the submitted release. The original personal file is left unchanged; a separate review accompanies this return.

### Count the pilot and the program separately

After this acceptance the two-state core has six accepted increments: Stage 0, dissipator, stationary, evolution, Kraus and convergence. The Stage 4 extension comes next, followed by separate Stage 5 release work. The memo's seven-checkpoint denominator mixes the completed core with one extension while omitting release work. It is a chosen planning counter, not a completion fraction established by the original roadmap.

### Restore the Hamiltonian assumption

The memo's suggested generator drops the roadmap's diagonal-Hamiltonian restriction. For arbitrary H, the identity L(diag p)=diag(Qp) need not hold. With q=0 and the following matrices, the Hamiltonian creates off-diagonal entries:

```text
H = [[0,1],[1,0]]     diag(p) = [[1,0],[0,0]]
-i[H,diag(p)] = [[0,i],[-i,0]] != 0 = diag(Qp)
```

Use H=0 for the next bounded milestone. A real diagonal H, or a commutation premise for a particular input, is a valid later extension. The existing generic Kraus lemmas do not by themselves construct a finite-state CPTP semigroup.

### Treat tiers and effort as planning judgments

The 28 candidate-bearing rows do not all have their full target already proved elsewhere. Some sources cover narrower endpoints. Tier B's six listed alternatives overlap Tier A at rows 7 and 27; adding their session estimates does not produce a valid lower bound. Neither the approximately 40-session claim nor the 3-7-round forecast is validated by the pilot.

Use a budget for one precisely contracted target, then re-estimate from its dependency work. The pilot included generic finite lemmas as well as qubit algebra, and specification plus audit work was part of its cost. Fast implementation under prepared contracts does not establish comparable throughput on unrelated research areas.

The memo's 187/167 counts become accepted coverage counts with this audit. They were submission counts before it. The broader inventory can acquire meaningful completion criteria only after its rows are split into explicit endpoints.

## Portfolio status after six increments

| Accepted milestone | Cumulative exports | Theorem contracts |
| --- | --- | --- |
| Stage 0 | 15 | 10 |
| Dissipator | 42 | 33 |
| Stationary | 72 | 61 |
| Evolution | 115 | 100 |
| Kraus | 158 | 139 |
| Convergence | 187 | 167 |

There are seven release modules and 20 public definitions or abbreviations. These counts measure API and verification coverage. They are neither a mathematical novelty count nor a percentage of the portfolio completed.

| Branch | Areas | Mathlib target | Candidate | Unresolved / partial |
| --- | --- | --- | --- | --- |
| Quantum algorithms | 5 | 0 | 5 | 0 |
| Materials / open systems | 7 | 0 | 3 | 4 |
| Quantum information | 14 | 0 | 12 | 2 |
| Operations research | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

The 1/28/10 classification carries forward the corrected reconnaissance; this audit performs no new global literature search. Hall (#28) is the identified Mathlib reuse item. The remaining 38 areas form an assess/reuse/extend backlog, not 38 established missing formalizations.

### What is now complete locally

The explicit two-state benchmark now has its generator, stationary density and uniqueness, all-real flow and derivative, physical four-Kraus representation, all-finite-ancilla complete positivity, density preservation and quantitative Frobenius convergence. Positive total rate and both-zero rates are correctly separated.

Rows #10, #11, #13 and #15 have partial local contributions. The new work advances explicit relaxation under #10, model-specific attractivity under #11, and density convergence under #13. It does not complete generic GKSL, Perron-Frobenius, a full state toolbox or representation equivalences.

The local tally is one existing Mathlib endpoint identified for reuse, four broad rows advanced, and 34 rows without local implementation. No broad row is newly completed by this pilot. The accompanying ledger retains all 39 rows and their exact qualifications.

## Next: a finite Markov generator bridge

Issue one Stage 4 milestone, markov, in FormalScience/OpenSystems/FiniteMarkovBridge.lean. Reuse the accepted finite dissipator layer with zero Hamiltonian. Fix destination-first rates: q_ij is the jump rate from j to i, and supplied diagonal q entries are ignored.

```text
r_j = sum_(i != j) q_ij
Q_ij = q_ij (i != j),     Q_jj = -r_j
L_q(X) = sum_(i != j) q_ij D[E_ij](X)
L_q(diag(C p)) = diag(C (Q p))
(L_q X)_ij = -(r_i+r_j)/2 * X_ij   (i != j)
```

Require zero column sums, real-vector mass conservation, the diagonal and off-diagonal quantum entry formulas, trace annihilation, Hermiticity preservation, the diagonal stationary iff, and probability-to-PSD/trace-one consumers. Recover the accepted two-state generator from q=[[0,b],[a,0]]. Keep signed-rate algebra separate from physical off-diagonal nonnegativity.

The bridge is a generator result. It does not construct a Markov or quantum semigroup, establish mixing, classify all quantum stationary states, or prove complete positivity of an Euler step. No Hamiltonian or unrelated portfolio branch belongs in this turn. Pinned source/API inspection guides the assignment; the bridge itself is not claimed already compiled.

### Continue the established audit loop

- Verify the full return manifest and integrate its paths under audits/convergence/v1/. Preserve the frozen issued task; copy it to the mutable root NEXT_FABLE_TASK.md.
- Record acceptance and C1/C2, reproduce the unchanged 187-export baseline, then apply comment corrections and implement only the issued Markov contracts.
- Keep the independent consumer contracts and manual public-declaration inventory. Run the gates with raw evidence and retained control fixtures.
- Commit, tag and archive the exact tested source; verify every payload hash and byte count, then record the external receipt. The implementer commits and tags; the user pushes.

**Decision:** convergence v1 accepted. The two-state mathematical core is complete. Proceed to the finite Markov generator bridge; retain Stage 5 release work as a separate checkpoint.
