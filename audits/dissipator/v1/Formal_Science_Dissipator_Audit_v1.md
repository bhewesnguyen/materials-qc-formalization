# Formal Science: finite dissipator audit v1

## Accepted: finite dissipator algebra

Independent audit v1 | 20 September 2026 | Prepared for Jett Sturges

**Verdict: accept dissipator-milestone-v1. No proof correction is required.** The agreed mathematics is present at the intended strength, the submitted source reproduces independently, and the four small documentation/process findings can be closed in the next implementation turn.

The submitted reorganization is sound. The implementation handoff, returned audits, project-wide planning, and chronological index have clear homes. There is no reason to undo it or request a dissipator v2 solely for the findings in this report.

### Snapshot under review

```text
Commit: be2ad90088b3c407d2aa18aafe3a2e806db35011
Tag: dissipator-milestone-v1
Archive SHA-256:
4efe92452daa010f454d1290fcda0b6dc35d0cd016d9ecfe213a5ce6da0bfb44
```

| Check | Independent result |
| --- | --- |
| Archive integrity | 346 manifest entries verified, plus the manifest itself: 347 regular files. No missing or extra files and no nested archives. |
| Release coverage | 2 modules, 42 named exports, and 33 direct theorem contracts. All are accounted for in the small source tree. |
| Fresh verification | 26 recorded subprocesses exit 0. Both release sources and the contract file re-elaborate. |
| Proof assumptions | All 42 transitive axiom reports contain exactly propext, Classical.choice, and Quot.sound. |
| Gate behavior | 15 self-test cases pass. An independently repeated omitted-module control rejects the intended omission. |
| Agreement with Fable | Fresh source-hash and axiom maps exactly match the submitted final verification maps. |

The new module adds 4 definitions and 23 theorems to Stage 0. Those are useful algebraic results, not 23 completed items from the broader 39-area portfolio. The next selected milestone is the complete two-state stationary pilot; dynamics remains separate.

## General laws: correct and well stated

Reviewed source: FormalScience/OpenSystems/Dissipator.lean. All general statements range over an arbitrary finite index type and square complex matrices. Conjugate transpose is denoted by V^H below.

```text
D[V](X) = V X V^H - (1/2) *scalar (V^H V X + X V^H V)
```

The definition matches the contract exactly. The last product is parsed as (X V^H) V; associativity makes it X(V^H V). The one-half coefficient acts by complex scalar multiplication. The two noncomputable definitions introduce no additional proof axiom.

| Declaration / source lines | Assessment |
| --- | --- |
| dissipator_add; dissipator_smul; 40-49 | Correct for arbitrary V, X, Y, and complex scalar. Distributivity and additive normalization do the work; no matrix commutativity is assumed. |
| dissipatorLinearMap; apply; 53-60 | A useful bundled interface. Its underlying function is the same dissipator definition and its application theorem is rfl, preventing two formulas from drifting apart. |
| dissipator_trace; 64-68 | Correct without density or Hermiticity premises. Cyclic trace reduces the proof to t - (1/2)(t+t) = 0. The final ring step is on complex scalars. |
| isHermitian_anticommutator; 71-75 | Correct even when the Hermitian factors do not commute. Adjoint reversal exchanges the two summands. |
| isSelfAdjoint_half; 78-80 | Correct, small scalar helper. It is not a new mathematical assumption or an extra restriction on the jump. |
| dissipator_isHermitian; 84-89 | Only X is assumed Hermitian. V is arbitrary. The proof combines V X V^H, the Hermitian factor V^H V, its anticommutator, and a real scalar. |

### Accepted design choices

Accept the generalization from qubits to arbitrary finite index types. It costs no new conceptual machinery and will be useful for a later Markov bridge. An empty index type is harmless for these algebraic identities; no trace-one assertion is made in this general section. Do not add an unnecessary nonemptiness premise.

Accept both direct linearity lemmas and the bundled map. Their roles are complementary. The proofs are already concise and readable; no mandatory elegance rewrite or namespace reorganization is justified.

## Qubit specializations: conventions held

The definitions use the correct row-then-column convention: jumpZeroToOne = E_10 and jumpOneToZero = E_01. The associated rates in the planned pilot remain a for 0 to 1 and b for 1 to 0.

| Pair of results | Meaning and assessment |
| --- | --- |
| Adjoints, lines 106-112 | E_10^H = E_01 and E_01^H = E_10. Correct direct reuse of Mathlib matrix-unit adjoints. |
| Adjoint products, 116-125 | E_10^H E_10 = E_00 and E_01^H E_01 = E_11. The source projectors are correct. |
| Sandwich products, 128-137 | E_10 X E_01 = X_00 E_11 and E_01 X E_10 = X_11 E_00, for arbitrary X. |
| Closed forms, 140-151 | Both anticommutator terms and the factor one half are retained. These are useful direct inputs for the next generator component equations. |
| Trace consumers, 154-161 | Both proofs directly apply the general dissipator_trace theorem. They satisfy the required reuse condition. |
| Hermiticity consumers, 164-171 | Both directly apply dissipator_isHermitian with only input Hermiticity. Neither jump is required to be Hermitian. |
| Non-Hermitian witnesses, 175-184 | Correct off-diagonal contradictions. These guard against accidentally restricting the general laws to Hermitian jump matrices. |
| Direction witnesses, 188-202 | D[E_10](E_00) = E_11-E_00 and D[E_01](E_11) = E_00-E_11. Correct signs and population flow. |

### Why the additions are useful

Accept all eight results beyond the requested minimum: two closed forms, two non-Hermitian witnesses, two direction witnesses, and the two small helpers. Each supports either the next proof or a meaningful check of conventions. Removing them would not improve this release.

The direction witness also explains why the dissipator itself is not a positive map: it sends E_00 to diag(-1,1). The source makes no erroneous positivity or channel claim. Complete positivity belongs to later time-evolution maps.

Stage 0 is unchanged. In particular, diagonalState q is still diag(1-q,q), with q the population of state 1. Its density predicate is still Mathlib PSD together with trace one.

## Reproduction and proof-trust evidence

### Fresh run against the exact delivered source

The auditor used a separate extraction, the official Lean 4.34.0 release, the submitted lockfile, and the README cache command. Both validation scripts ran unchanged. Fresh verification finished on 20 September 2026; the final gate-test record is timestamped 22:06:49 UTC.

```text
python3 scripts/verify.py --lake <pinned-lake> \
  --output-dir <auditor-evidence>/verification
python3 scripts/test_verify.py --lake <pinned-lake> \
  --output-dir <auditor-evidence>/gate-tests
```

The raw records contain the actual absolute paths, commands, compiler output, and exit codes. The fresh run checks all nine git dependencies at their locked revisions with clean tracked files, builds both release modules and the umbrella, re-elaborates both local sources, compiles the direct contracts, and prints signatures and transitive axioms.

### The checks agree, but establish different things

- Source inspection establishes that the definitions, hypotheses, and formulas express the intended dissipator mathematics.
- The 33 direct consumers spell out key formulas, Hermiticity as an adjoint equality, and the jumps as Mathlib matrix units. Every theorem has a corresponding consumer.
- The 42 axiom reports include definitions as well as theorems. No custom axiom, sorryAx, or native-evaluation axiom enters these exports.
- The 15 gate cases include valid controls, forbidden assumptions, missing exports, a changed False-premise signature, and malformed report cases. Expected failing subprocesses are successful negative tests.
- A fresh omitted-module fixture causes the coverage gate to reject FormalScience.OpenSystems.Dissipator as unlisted. The auditor preserved the altered manifest with the rejection output.

### Reproduction boundary

The dependency cache supplies third-party compiled artifacts; this is not a full source rebuild of Mathlib. Local release proofs and consumer checks were re-elaborated. The accepted axiom policy is ordinary Lean foundational trust, not a claim of axiom-free mathematics or malicious-code hardening.

The toolchain archive was independently hashed and matches the Stage 0 checksum. Fable correctly recorded its own workstation checksum as unmeasured. The auditor measurement does not retroactively turn that null field into a workstation measurement.

## Four small corrections to carry forward

All four findings are nonblocking. None changes a theorem statement, proof term, dependency revision, or the acceptance verdict. Preserve the submitted v1 documents and evidence as historical records; record corrections in this audit and the next live instructions.

| ID / location | Finding and concrete remedy |
| --- | --- |
| F1: packaging order; AGENTS.md, D008 | The instruction says to commit and tag, then regenerate the manifest before committing. Put the steps in executable order: finalize and stage intended files; hash the exact intended bytes; stage the manifest; check agreement; commit; tag; archive; verify. Matching tracked filenames alone does not guarantee matching bytes. |
| F2: evidence rounds; AGENTS.md, D008, TURNS.md | Deliverables and audits have v1/v2 paths, but evidence is only milestone-keyed. Preserve existing v1 paths. Use evidence/<milestone>/v<round>/ for new work so a later round cannot overwrite the evidence addressed by an earlier handoff. |
| F3: explanatory citation; HANDOFF.md, lines 174-179 | basisProjector_zero_ne_one proves E_00 != E_11, not E_00 != I. The jumps are indeed nonunitary: compare the (1,1) entry of E_00 and I, or the (0,0) entry of E_11 and I. Correct the explanation; an additional exported theorem is unnecessary. |
| F4: license inventory; HANDOFF.md, reproduction | The claim that all nine dependencies are Apache 2.0 is inaccurate. At its pinned revision, Cli has a top-level MIT license; the other eight package-root licenses are Apache 2.0. Correct future provenance summaries. No dependency change is needed. |

### No additional rejection is warranted

The reported count of 346 refers to manifest-covered files. The physical archive contains 347 because the manifest excludes its own hash. This is not lost content. The detached handoff and pointer match their archived copies byte for byte.

The in-tree pointer avoids embedding its own containing commit hash or archive digest. That is sensible. This delivered ZIP comment supplies the full commit, and the external digest identifies the exact bytes. For future convenience, record the commit and archive digest in a post-packaging receipt or delivery message.

The old control did not retain its temporary altered manifest. Its failure was reproducible, and the auditor has now retained that fixture. Keeping future control inputs is a small convenience, not grounds for expanding the verification system.

## Next milestone: stationary two-state pilot

**Proceed to one bounded stationary-state milestone.** The accepted closed forms now support the weighted generator, its component equations, and unique stationary density as one connected proof task. No further algebra-only checkpoint is needed.

Use real rates a,b, basis 0,1, zero Hamiltonian, and gamma = a+b. Reuse the bundled dissipator map or one transparent equivalent function:

```text
L[a,b](X) = (a : Complex) *scalar D[E_10](X)
          + (b : Complex) *scalar D[E_01](X)
```

For every complex qubit matrix X and arbitrary real rates, prove the four components, trace annihilation, and preservation of Hermiticity. Rates are cast into the complex numbers in these formulas:

```text
L(X)_00 = -a X_00 + b X_11
L(X)_11 =  a X_00 - b X_11
L(X)_01 = -(a+b)/2 X_01
L(X)_10 = -(a+b)/2 X_10
```

### Keep algebraic and physical assumptions separate

Define rhoStar(a,b) = diagonalState(a/(a+b)). If a+b is nonzero, prove it equals diag(b/(a+b),a/(a+b)), is stationary, and is the unique trace-one stationary complex matrix. This stronger algebraic uniqueness statement needs neither PSD nor Hermiticity:

```text
trace(X) = 1  ->  (L[a,b](X) = 0 <-> X = rhoStar(a,b))
```

With a >= 0, b >= 0, and a+b > 0, additionally prove rhoStar is a density. Derive a public unique-existence endpoint for densities satisfying L(rho)=0. The nonnegative-rate assumptions establish density validity; they are not necessary for the entry algebra or the trace-one uniqueness argument.

### Proof route

The off-diagonal equations and nonzero total rate force both coherences to vanish. The diagonal balance equation and trace one determine both populations. For density validity, prove 0 <= a/(a+b) <= 1 and consume the already audited diagonalState_isDensity theorem. Do not assume the unknown stationary state is diagonal.

These are proposed contracts derived from the fixed model, not additional Lean theorems proved in this audit. The accompanying NEXT_FABLE_TASK.md gives the full implementation and validation assignment.

## Boundary cases and limits of the next claim

| Rate regime | Required result |
| --- | --- |
| a=0, b>0 | rhoStar is basisProjector 0. The general uniqueness theorem still applies. |
| a>0, b=0 | rhoStar is basisProjector 1. The general uniqueness theorem still applies. |
| a=b=0 | L is zero on every matrix. Every density is stationary. The two distinct basis densities explicitly refute uniqueness. |
| a=b=r, r>0 | rhoStar is diagonalState(1/2), and uniqueness applies. No unequal-rate premise is allowed. |

### Two important specification traps

A unique stationary density need not be faithful. The one-zero-rate cases remain unique and have a basis-projector stationary state. Strict positivity of both rates, rank, and positive definiteness must not become hidden premises of uniqueness.

For signed real rates, a+b=0 does not imply a=b=0. For example, a=1 and b=-1 give L(X)_00=-trace(X), so no trace-one stationary matrix exists. The physical both-zero conclusion needs nonnegative rates, or an explicit a=b=0 hypothesis.

Lean division is total. The definition diagonalState(a/(a+b)) therefore has a value at a+b=0. Its name does not establish the nonzero-denominator diagonal-ratio identity or unique stationarity there. Keep the relevant hypotheses on each theorem.

### Stop after the stationary endpoint

Do not add a semigroup, exponential solution, derivative identity, convergence estimate, norm theory, time-evolution channel, complete-positivity proof, generic GKSL theorem, Markov bridge, entropy, circuits, or OR branch. Those remain separate milestones.

A full kernel classification, a faithfulness theorem, and the square-root jump representation are optional future refinements. The next release is complete when it has a valid stationary density, uniqueness, the specified boundary cases, and reproducible proof evidence.

### Portfolio position

Stage 0 and finite dissipator algebra are accepted integration milestones within the finite open-systems program. The 39-area roadmap remains an inventory of audit, reuse, and formalization candidates. Neither the current release nor the next stationary pilot settles generic GKSL or the surrounding broad research areas.

## How to use the returned handoff

| Returned file or directory | Action |
| --- | --- |
| Formal_Science_Dissipator_Audit_v1.pdf and .md | Store as received under audits/dissipator/v1/. This is the acceptance decision and correction record. |
| NEXT_FABLE_TASK.md | Use as the single active root assignment after recording acceptance in TURNS.md. It includes F1-F4 and the complete stationary contract. |
| FABLE_KICKOFF.md | Copy its prompt into Cursor to start the next implementation turn. |
| AUDIT_RECEIPT.json | Records exact input identity, accepted scope, verification counts, findings, and the next milestone. |
| evidence/ inside the audit return | Auditor-generated setup, archive verification, build, signature, axiom, gate-test, and omitted-module-control records. These are separate from Fable's preserved evidence. |

### The next round uses the agreed structure

```text
Milestone: stationary
Tag: stationary-milestone-v1
Evidence: evidence/stationary/v1/
Handoff: deliverables/stationary/v1/HANDOFF.md
Future audit: audits/stationary/v1/
```

Keep the accepted dissipator tag and historical paths unchanged. The implementer commits and tags; the user publishes. The audit did not push a branch, move a tag, or inspect the remote publication state.

### Pinned provenance and review limits

Lean is 4.34.0 at compiler commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b. Mathlib is pinned at 5ed2965256430c3649e86755f9576b54eca72435. The full lockfile fixes all nine dependencies. The audit evidence records package-root license headings and hashes, including the MIT-licensed Cli revision e92c9f15fdfacc8536f31cfb3b7ad26c3c8cd204.

The archive contains no Git history. Its comment agrees with the claimed commit, and the digest fixes the reviewed bytes, but this audit does not independently authenticate the remote tag or baseline history. The source and proof evidence are sufficient for the stated acceptance.

Source inspection, compiler acceptance, transitive-axiom checks, and mathematical interpretation support this verdict. No novelty, comprehensive quantum-information coverage, upstream acceptance, or completed stationary/dynamics result is claimed. The implementation itself required no modification during this audit.
