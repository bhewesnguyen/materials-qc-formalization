# Formal Science: evolution audit v1

## Accepted: explicit two-state evolution

Independent implementation audit v1 | 21 September 2026 | Prepared for Jett Sturges

**Verdict: accept evolution-milestone-v1. No proof revision is required.** The explicit flow, all-real semigroup, full matrix derivative, fixed points, and signed-rate boundary satisfy the issued contracts. Independent execution reproduces the submitted results. Two small documentation corrections can accompany the next milestone.

### Exact submission reviewed

```text
Commit: a60a92b6064b4dde33a98d3c79be195c77595873
Tag: evolution-milestone-v1
Archive SHA-256:
f66b51b84a56c86f193ea33d3bb859f3f4325ffd9ae9b138ec6ec5093a0dd74f
```

| Check | Independent result |
| --- | --- |
| Input integrity | 1,162,373 bytes. All 1,080 manifest-covered files match their hashes and sizes. Including the manifest, there are 1,081 files. No extra paths or nested archives. |
| Public coverage | 4 release modules, 115 exports, and 100 direct theorem contracts. Evolution adds 4 definitions and 39 theorems, all accounted for. |
| Fresh execution | All 28 verification subprocesses exit 0. The four release sources and all direct contracts re-elaborate. |
| Proof assumptions | All 115 exports report exactly propext, Classical.choice, and Quot.sound. |
| Gate behavior | All 15 gate cases pass. A fresh retained omitted-module fixture triggers the intended coverage rejection. |
| Additional API check | Both matrix derivative theorems compile in an independent consumer without local matrix norm instances. |

The prior stationary findings S1-S3 are closed. The original issued assignments and audit returns are now preserved correctly, and the only earlier Lean source changes are the two authorized stationary docstrings.

Next: certify the existing physical flow with four Kraus operators and prove positivity after amplification by every finite ancilla. Quantitative convergence remains the checkpoint after that.

## The map and semigroup are correct

Reviewed implementation: FormalScience/OpenSystems/TwoStateEvolution.lean. Let gamma=a+b. Rates and times are arbitrary real numbers, and X is any complex qubit matrix.

```text
e(gamma,t) = exp(-gamma*t)
f(gamma,t) = exp(-gamma*t/2)
k(gamma,t) = if gamma=0 then t
             else (1-exp(-gamma*t))/gamma

Phi_t(X)_00 = X_00 + k*(-a*X_00 + b*X_11)
Phi_t(X)_11 = X_11 + k*( a*X_00 - b*X_11)
Phi_t(X)_01 = f*X_01
Phi_t(X)_10 = f*X_10
```

Real coefficients are cast to Complex. The private underlying function uses X_ii+k*L(X)_ii on the diagonal. The four public entry theorems expand L and match the literal formulas above. This structural definition preserves the contract and avoids duplicating the generator algebra.

| Endpoint | Assessment |
| --- | --- |
| Complex linearity | The sole public evolution map is bundled as QubitMatrix ->_linear[Complex] QubitMatrix. Its construction proves additivity and homogeneity on all matrices. |
| Initial condition | Phi_0=Id as a bundled-map equality for all rates. The proof uses k(gamma,0)=0 and f(gamma,0)=1. |
| Semigroup | Phi_(t+u)=Phi_t composed with Phi_u, for all rates and both real times. No positivity, trace, or nonzero-total-rate condition is hidden. |
| Trace | Trace is preserved unconditionally in X by cancellation of the two diagonal correction terms. |
| Hermiticity | Hermitian input gives Hermitian output. The real coefficients preserve conjugation; non-Hermitian inputs are not claimed to become Hermitian. |

### The scalar identities cover both rate branches

The semigroup proof uses gamma*k_t=1-e_t, k_(t+u)=k_t+e_t*k_u, and f_(t+u)=f_t*f_u. Each identity includes gamma=0. In the diagonal block, the generator matrix A satisfies A squared = -gamma*A; these identities yield the correct composition law.

The 13 public scalar lemmas are reasonable reusable helpers. The one public map, private implementation function, and direct formula consumers give a clear API. No refactor or helper removal is required.

## The derivative endpoint is complete

```text
HasDerivAt (fun s : Real => evolution a b s X)
  (generator a b (evolution a b t X)) t
```

The statement holds for all real rates and all real t, with arbitrary complex X. It is a matrix-valued derivative, not merely four unassembled scalar identities. Its value is L(Phi_t X), with the generator applied to the evolved matrix.

### Proof route and hypotheses

- The real coefficient derivatives are k prime = e and f prime = -(gamma/2)*f, with gamma held fixed. No joint differentiability in gamma is claimed.
- HasDerivAt.ofReal_comp transports the real derivatives to Complex. Multiplication by fixed entries and addition of the initial diagonal entries give the four entry derivatives.
- The identity gamma*k_t=1-e_t converts each diagonal derivative into the corresponding entry of L(Phi_t X).
- Applying hasDerivAt_pi twice assembles the matrix derivative. The all-real-time extension gives an ordinary two-sided derivative at zero.

### What the pinned API actually says

At this Mathlib pin, HasDerivAt is defined in the topological-vector-space section of Analysis/Calculus/Deriv/Basic.lean. Its target arguments include the additive group, module, topology, and continuous scalar multiplication. There is no target matrix norm argument. The explicit exported signature uses instTopologicalSpaceMatrix.

The proof enables compatible sup-norm structures locally. That is harmless, but D012 overstates their role by saying the theorem is formally relative to that chosen norm. The exported result is in the canonical finite-product matrix topology. The auditor compiled a separate consumer of both derivative theorems with no local matrix norm instances; it succeeds.

Correct that description in the next documentation turn. There is no missing norm-independence obligation and no reason to change the theorem. A later quantitative convergence estimate will still need an explicitly named norm.

### The notation option does not weaken verification

The single set_option quotPrecheck false in applies only to the local notation containing the explicit if. The pinned Lean implementation describes it as eager name analysis for syntax quotations. It does not disable elaboration, kernel checking, or the axiom gate. The contracts still spell out Real.exp and the correct zero branch.

## Fixed points and exceptional rates

| Regime or premise | Accepted result |
| --- | --- |
| L(X)=0, any rates | Phi_t(X)=X for every real t. Diagonal corrections vanish; coherences either have multiplier one at gamma=0 or vanish by the stationary equation. |
| gamma!=0 | rhoStar is fixed. The two population formulas retain trace(X), so they apply to every complex matrix and preserve linearity. |
| gamma=0 | Phi_t=Id+t*L as bundled maps. This includes signed cancellation with a nonzero generator. |
| a=b=0 | Phi_t=Id for every real t. |
| a=1, b=-1 | Phi_t(E_00)=diagonalState(t)=diag(1-t,t), for every real t. This is an algebraic witness, not an all-time density assertion. |
| a=0, arbitrary b | E_00 is fixed for every real t. |
| b=0, arbitrary a | E_11 is fixed for every real t. |
| a=b=r, arbitrary r | diagonalState(1/2) is fixed for every real t, including r=0. |

### The trace factor is present where it matters

```text
Phi_t(X)_00 = e*X_00 + (1-e)*(b/gamma)*trace(X)
Phi_t(X)_11 = e*X_11 + (1-e)*(a/gamma)*trace(X)
                              when gamma != 0
```

Replacing trace(X) by the constant one would describe only the trace-one slice and would no longer define a linear map on all matrices. Both the source and direct consumers retain the factor. The accepted stationary density remains the same candidate with the same basis and rate convention.

### Additional exports are justified

The general fixed-point theorem is a useful strengthening. The three unrestricted boundary generator identities let the boundary flow results hold at arbitrary real remaining rates, including zero. The entrywise Hermiticity criterion and derivative bridge are small, ordinary helpers, all covered by contracts and axiom reports.

The flow and solution curve are proved. Positivity, complete positivity, density preservation, convergence, ODE uniqueness, and identification with a matrix exponential are outside this accepted milestone.

## Reproduction and preserved history

### Independent execution against the delivered bytes

The auditor verified the archive before extraction, kept an unchanged review copy, and ran the existing scripts from a separate reproduction copy. Lean 4.34.0 and all nine dependency revisions match the submitted lockfile; tracked dependency files are clean.

```text
python3 scripts/verify.py --lake <pinned-lake>
python3 scripts/test_verify.py --lake <pinned-lake>
```

The actual commands include separate auditor output directories, recorded in the raw evidence. Fresh verification finished at 2026-09-21T01:01:30.411660+00:00; the gate tests finished at 01:01:38.771222+00:00. Source-hash and axiom maps exactly match the submitted final maps.

| Record | Independent observation |
| --- | --- |
| Compiler and Mathlib | Lean compiler commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b; Mathlib 5ed2965256430c3649e86755f9576b54eca72435. |
| Cache extension | The same four new Mathlib cache roots were fetched successfully, adding 339 files at the unchanged pin. This is a disclosed dependency-scope extension. |
| Prior proof source | Stage0.lean, Dissipator.lean, both scripts, and dependency pins are unchanged. TwoStateStationary.lean changes only the two authorized docstrings. |
| Prior evidence | All 109 Stage 0, 213 dissipator, and 217 stationary evidence files match their earlier delivered bytes. |
| Audit returns | All 145 files of the prior stationary return are preserved. The restored issued assignment makes all 143 historical dissipator return payloads match. |
| Baseline evidence | The submitted pre-edit baseline has the exact accepted 72-export source-hash, manifest, and axiom maps. Earlier 61 contract bodies remain unchanged. |

### Review boundary

The auditor reused the prior pinned runtime and dependency checkouts and extended the official compiled cache. All local release proofs and contracts were freshly re-elaborated; this is not a full Mathlib source rebuild. The accepted axiom policy is ordinary Lean foundational trust, not an axiom-free claim.

The ZIP comment, detached handoff/pointer, and external receipt agree on the reviewed identity. The source archive does not authenticate remote branch state or commit ancestry. No source, branch, tag, or remote was changed by the audit.

## Two corrections and portfolio position

Both findings are low severity and nonblocking. Record them in D013 and update live documentation. Keep the submitted handoff, accepted tag, historical evidence, and theorem signatures unchanged.

| ID | Finding and remedy |
| --- | --- |
| E1; README scope | The opening still says the project does not prove a semigroup or time evolution. These are now proved. Replace that sentence with the accepted scope and retain the real remaining work: density preservation, complete positivity, and convergence. Update the milestone status to four accepted increments. |
| E2; Derivative API | D012 says HasDerivAt requires a matrix norm and is formally relative to the selected instance. At this pin the exported result uses canonical matrix topology. Describe the local sup-norm structures as proof infrastructure and cite the successful no-local-norm consumer in this audit. No new theorem is needed to close this wording issue. |

Optional copy edit: the Hermiticity helper docstring says Two qubit matrices although the criterion concerns one matrix. Correct it to A qubit matrix during a comment-only pass after the next untouched baseline reproduction. This does not warrant another finding or revision round.

### Four accepted local milestones

| Milestone | Cumulative exports | Theorem contracts |
| --- | --- | --- |
| Stage 0 | 15 | 10 |
| Dissipator | 42 | 33 |
| Stationary | 72 | 61 |
| Evolution | 115 | 100 |

The 115 public exports comprise 100 theorem contracts and 15 definitions or abbreviations. They are not 115 completed research questions. The pilot now includes explicit evolution and a semigroup/ODE solution, while complete positivity and convergence remain unproved in the release.

### The broader inventory is unchanged

The recorded portfolio contains 39 areas: 5 quantum algorithms, 7 materials/open systems, 14 quantum information, and 13 operations research. Hall is an identified Mathlib reuse target; 28 rows have relevant source or reported candidates; 10 are unresolved or partial-only in the recorded search. Thus 38 areas remain in the assess/reuse/extend backlog.

No broad inventory area is fully closed by this pilot. The returned PORTFOLIO_STATUS.md updates all 39 rows without claiming a new global search or upgrading external candidates to locally verified results.

## Next: a four-Kraus certificate

Milestone kraus will certify the already accepted evolution for nonnegative real a, b, and t, including both-zero rates. Keep the current all-real evolution definition and prove the physical properties under explicit hypotheses.

### Concrete operator family

```text
gamma = a+b
p = b/gamma             (totalized real division)
c = halfExpFactor gamma t
d = sqrt(1-c^2)

K_0 = sqrt(p)     *scalar diag(1,c)
K_1 = sqrt(p)*d   *scalar E_01
K_2 = sqrt(1-p)   *scalar diag(c,1)
K_3 = sqrt(1-p)*d *scalar E_10
```

All matrix entries and scalar coefficients are cast to Complex. Here p is the equilibrium population of state zero; it is not the population-one parameter used by diagonalState. The four-element family should remain transparent in the consumer contracts.

| Required proof | Purpose |
| --- | --- |
| Coefficient bounds | From a,b,t>=0 derive p in [0,1], c in [0,1], c squared = expFactor gamma t, and the square-root identities used in the certificate. |
| Completeness | Sum over j of K_j^H K_j equals I, including both-zero rates. Consume the existing Kraus trace theorem with this proved premise. |
| Exact equality | For every complex matrix X, evolution a b t X equals the existing finite krausMap of this family applied to X. Keep off-diagonal and trace-linear behavior. |
| PSD and density | Prove finite Kraus sums preserve PSD, then deduce that the physical evolution preserves the existing PSD-and-trace-one density predicate. |

### The physical zero-total-rate boundary works

Nonnegative a,b with gamma=0 force a=b=0. Total division gives p=0, while c=1 and d=0; hence K_2=I and the other three operators vanish. At t=0, the two diagonal operators are sqrt(p)*I and sqrt(1-p)*I. Both boundaries give the identity channel without changing the evolution formula.

Also retain both one-zero-rate cases and equal rates. No strictly positive rate or time premise should exclude these valid boundaries. These are proposed implementation contracts; the current release does not yet contain this certificate.

## Complete positivity and the handoff

### Quantify over every finite ancilla

Fix the ordering as ancilla first, system second. For m a natural number and Y indexed by (Fin m x Fin 2), define amplification by applying Phi to each 2 by 2 system block:

```text
Y_rs(i,j) = Y((r,i),(s,j))
Amp_m(Phi)(Y)((r,i),(s,j)) = Phi(Y_rs)(i,j)
```

Require the pure-tensor identity Amp_m(Phi)(A tensor X)=A tensor Phi(X) for complex-linear Phi. For a finite Kraus map, prove the blockwise amplification equals the Kraus sum with lifted operators I_m tensor K_j. PSD of the latter follows from PSD under conjugation and finite sums.

**Required endpoint:** for every m and every PSD complex Y on the joint matrix space, Amp_m(evolution a b t)(Y) is PSD whenever a,b,t are nonnegative. Arbitrary Y includes entangled inputs. Positivity of the qubit map alone or checks only on product inputs do not satisfy this contract.

A small generic positivity/amplification feasibility probe compiled at the existing pin and is included under reference/. It is outside the 115-export release. It does not prove the four-operator certificate or the physical evolution endpoint; Fable must integrate any reused helpers through the ordinary export, contract, and axiom gates.

### Return layout and next round

Extract the return at the repository root, preserving its audits/evolution/v1/ paths. Keep the issued task there unchanged and copy it to the root NEXT_FABLE_TASK.md. Use FABLE_KICKOFF.md for Cursor. The report, receipt, evidence, portfolio snapshot, reference probe, and return manifest all remain together in the audit folder.

```text
Next key: kraus
Tag: kraus-milestone-v1
Evidence: evidence/kraus/v1/
Handoff: deliverables/kraus/v1/HANDOFF.md
Future audit: audits/kraus/v1/
```

Reproduce the untouched 115-export baseline before source edits. Use the existing pins, scripts, and archive-verification protocol. The implementer commits and tags; the user pushes. Keep convergence, Choi/Stinespring equivalences, generic GKSL, and other branches outside this checkpoint.

Primary records: the issued evolution task, four release modules, direct contracts, export manifest, D011-D012, handoff/pointer/receipt, pinned Mathlib and Lean source, and fresh auditor evidence. The next task specifies all formulas and proof obligations in full.
