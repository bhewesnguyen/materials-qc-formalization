# Formal Science: release-readiness audit v1

## Accepted: release-readiness candidate

Independent implementation audit v1 | 21 September 2026 | Prepared for Jett Sturges

**Verdict: accept release-readiness-milestone-v1 with three nonblocking documentation findings.** The frozen mathematical surface, compiled usage examples, provenance records and exact-archive recipient check meet the bounded assignment. No proof, package, pin or verifier revision is required.

```text
Commit: 2a258df6654d1b3553d3affebd7e94405bb4e989
Tag: release-readiness-milestone-v1
Source ZIP SHA-256:
e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0
Companion ZIP SHA-256:
7c6bca2065fb4c0068ef2d1265b97197d09dbedd0173e33f34983f2442d35553
```

| Check | Independent result |
| --- | --- |
| Source archive | 3,553,183 bytes; 3,118 manifest payloads plus the manifest. All paths, hashes, sizes and CRC validate. |
| Companion archive | 142,213 bytes; 115 payloads plus its manifest. Receipt separation is correct; no self-referential archive digest. |
| Mathematical freeze | All 16 frozen project files match actual accepted Markov bytes. Eight modules, 216 exports, 193 theorem contracts, 23 definitions or abbreviations. |
| Fresh verification | All 32 commands exit 0; all eight sources and the contract file emit zero diagnostics. All 216 axiom reports contain exactly the accepted three axioms. |
| Gates and usage | All 15 gate cases pass. The three anonymous usage examples compile with zero diagnostics. |

R1 corrects API-guide names and assumptions; R2 corrects authorship wording; R3 refreshes the live contribution table and one changelog reference. Close these in the ordinary integration commit. Do not create another mathematical or packaging milestone solely for these edits.

This accepts the supplied candidate bytes. It does not authenticate remote Git state or establish human semantic review, publication, upstream acceptance, or novelty. The original roadmap's broader Stage 5 gate remains separate.

## Reproduction and the frozen mathematics

### A direct comparison, not just matching reported hashes

The eight release modules, umbrella import, contract file, export list, both verification scripts, toolchain, Lake configuration and lockfile are byte-identical to the previously accepted Markov extraction. Version 0.0.1 and all dependency pins are unchanged. No named mathematical declaration was added.

| Anonymous consumer | Verified statement |
| --- | --- |
| Density preservation | For nonnegative a, b and t, evolution a b t maps every qubit density to a density. Both rates may be zero. |
| Long-time density limit | For nonnegative rates with a+b>0, rhoStar is a density and every density trajectory tends to it. The both-zero exception is explained. |
| Three-state Markov bridge | On Fin 3, arbitrary signed real q and real p satisfy the diagonal intertwining formula, with the real-to-complex embedding explicit. |

Each example imports only FormalScience and directly applies an accepted public theorem. They sit outside the release export inventory. Fresh compilation confirms all three statements without adding an API layer or a new mathematical result.

### What the recipient evidence establishes

Fable's companion identifies the exact source ZIP. Its logs show extraction without project build outputs, nine dependency clones at locked revisions, and the documented cache setup. The 2,435 decompressed files plus 74 already decompressed files account for the 2,509-artifact targeted closure. The local compressed cache supplied the artifacts; this was not a clean-network cache download.

The auditor separately built an isolated extraction using the previously validated pinned dependency trees and compiled cache. All source-hash, manifest and axiom maps match Fable's baseline, final and recipient records. No full Mathlib source rebuild is claimed by either reproduction.

One initial auditor run was interrupted by an execution transport reset before its final summary. Partial logs are retained. The unchanged commands were restarted successfully; no source, gate or pin was repaired or weakened.

### Pinned execution base

```text
Lean: 4.34.0
Compiler: 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b
Mathlib:  5ed2965256430c3649e86755f9576b54eca72435
```

## R1: make the API guide exact

Severity: low; nonblocking. Location: docs/API_GUIDE.md. The guide broadly captures the mathematics correctly, but it promises the actual names and assumptions and has several concrete inaccuracies in that map.

### The zero-left boundary is unconditional

The grouped boundary row assigns b != 0 to rhoStar_zero_left. The accepted theorem has no such premise. Its two neighboring theorems do require their displayed nonzero premises. Split the row or list the first condition as none.

```text
FormalScience.OpenSystems.rhoStar_zero_left (b : real):
  rhoStar 0 b = basisProjector 0

Boundary premises:
  rhoStar_zero_left:  none
  rhoStar_zero_right: a != 0
  rhoStar_same:       r != 0
```

The zero-left identity holds even when b=0. It specifies the chosen candidate at that boundary; it does not assert uniqueness or a common attractor at both-zero rates. The proof and accepted contracts need no change.

### Use actual declaration namespaces

The shown setup opens Stage0 and OpenSystems but not FormalScience.Quantum. Consequently the short generic Kraus names in the guide are not in scope under its own setup. An isolated Lean probe confirms the expected unknown-name diagnostic and successful fully qualified alternatives.

```text
FormalScience.Quantum.krausMap_posSemidef
FormalScience.Quantum.amplify
FormalScience.Quantum.amplify_krausMap
FormalScience.Quantum.amplify_kronecker
```

Provide fully qualified declaration names and full import paths as the issued task requested. Expand suffix abbreviations. Module names are not automatically theorem namespaces: dissipator_trace lives in FormalScience.OpenSystems, not in a nested Dissipator declaration namespace. Add the Quantum opening if short-name examples remain.

### Keep the assumptions column self-contained

Explicitly list i != j for markovGenerator_apply_of_ne and rateMatrix_nonneg_of_ne. The current words coherence and off-diagonal convey the intent, but the actual theorem premises should be visible. Also distinguish theorem consumer contracts from definitions anchored by formula consumers in the introduction.

These changes concern discoverability and statement fidelity. The three canonical usage examples already compile correctly, and no accepted theorem is mathematically wrong.

## R2 and R3: precise project records

### R2: contracts were not human-written

Severity: low; nonblocking. docs/RELEASE_READINESS.md, Section 4, calls the consumer contracts human-written. This contradicts D021 and the otherwise clear AI-authorship disclosure. Replace that sentence with the factual account: the contracts are explicitly written and semantically reviewed by the implementation and independent audit agents; the textual name check alone does not validate their meaning. No human semantic review is recorded.

This is a localized inconsistency, not evidence that AI involvement is hidden. NOTICE, D021, README and the readiness record's later section state it clearly. In docs/PROVENANCE_AND_LICENSES.md, also narrow the universal phrase about every later document to implementation-authored files, preserving the separately described auditor and pre-repository planning origins.

### R3: refresh the live contribution table and one reference

Severity: low; nonblocking. docs/SCOPE_MEMO.md, Section 4, still links the convergence ledger and labels its table after convergence, despite updating the surrounding status to accepted Markov. Update the link and epoch to the current accepted ledger, then add the already accepted contributions:

| Broad row | Markov contribution to include |
| --- | --- |
| 10: GKSL characterization | Arbitrary finite zero-Hamiltonian matrix-unit generator, population/coherence equations and diagonal classical bridge. This is not generic GKSL characterization. |
| 11: Quantum Perron-Frobenius | Diagonal stationary iff Qp=0, and stationary probability vectors give stationary densities. No generic uniqueness, irreducibility or mixing. |
| 13: States | Arbitrary finite probability vectors give complex PSD trace-one diagonal matrices. No partial trace, purification or generic dynamics. |

Keep row 15 unchanged and preserve the four-partial-row tally. This is an update to an existing result ledger, not new mathematical credit. In CHANGELOG.md, the Kraus entry incorrectly labels the evolution docstring copy edit E1; identify it as the optional copy edit recorded in D013. E1 concerned README scope.

### M1 and M2 are closed

The previous README correction and all seven requested scope-memo wording changes were applied correctly. R3 addresses remaining table currency and a new historical reference, rather than reopening those findings. Keep all historical handoffs, audits, evidence and issued assignments immutable.

## Provenance, preservation and trust boundary

### The recorded license decision is implemented consistently

D021 records the owner's Apache-2.0 selection for project material, with dependencies retaining their own licenses. LICENSE is 11,358 bytes with SHA-256 cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30. The auditor fetched the official Apache text and confirmed byte-for-byte equality. This checks the text and recorded scope, not copyright ownership.

All nine dependency license files were independently hashed at their locked revisions and match the existing inventory: eight Apache-2.0 and Cli under MIT. Both adapted auditor reference probes retain their recorded source hashes and D014/D016 provenance. No license choice remains outstanding for this bounded candidate.

CITATION.cff parses as YAML, matches version 0.0.1 and Apache-2.0, and invents no release date. Its addition is useful and within scope; no CFF schema-validator or remote repository authentication is claimed. Keeping per-file headers unchanged respects the explicit source freeze and need not cause another implementation round.

Official license text checked: https://www.apache.org/licenses/LICENSE-2.0.txt (21 September 2026). Local fetch bytes and hash checks are included in evidence/license_checks.json.

### Historical records are preserved

All 1,591 pre-existing evidence files, 975 audit files and 16 handoff/receipt files match the accepted Markov extraction. Its newly integrated audit return also matches all 208 files including the manifest. Of the prior 2,609 payloads, only six intended live documentation files changed; none was removed. The candidate adds 509 payloads.

The source archive excludes its post-tag receipt and subsequent consumer evidence. The companion contains the source receipt but excludes its own external receipt and digest. Loose attachments match packaged copies. These are correct implementations of the two-archive protocol.

### What remains outside the gate

The ordinary gate checks listed exports, module coverage, contract mentions, compilation and transitive axioms. It does not discover a declaration omitted from both export lists or establish semantics from a name mention. The unchanged manual inventory can be reused because its linked source and list bytes are unchanged. It is a manual source-review aid, not evidence of human mathematical review.

Submitted negative controls were inspected with their retained fixtures and raw logs. They exercise the same frozen inputs independently tested in the Markov audit; no redundant fresh run of those two additional controls is claimed here. Remote Git state, human review, public release and upstream acceptance remain outside this artifact audit.

## Close this checkpoint without another round

| Unit of progress | Accepted status |
| --- | --- |
| Two-state benchmark | Six mathematical increments complete. |
| Selected Stage 4 extension | Finite H=0 Markov generator bridge complete; seventh mathematical increment. |
| Release-readiness candidate | One accepted preparation checkpoint, with bounded documentation errata. Zero new public exports. |
| Current API | 8 modules; 216 exports; 193 theorem contracts; 23 definitions or abbreviations. |
| Broader 39-area inventory | 1 identified Mathlib reuse row, 4 partly advanced rows, 34 without local implementation. No broad row fully closed by this project. |

The corrected reconnaissance remains 1 Mathlib reuse endpoint, 28 candidate-bearing rows and 10 unresolved or partial-only rows. Those labels are carried forward, not freshly searched here. They measure something different from local progress. The full ledger accompanies this report.

### One ordinary integration commit

- Verify this return against RETURN_MANIFEST.json and integrate its repository-relative paths under audits/release-readiness/v1/. Preserve the immutable issued task and every historical payload.
- Record candidate acceptance, close R1-R3 in live documentation, and update the current status. Keep all accepted Lean, contracts, scripts, exports, pins, package version and examples/Usage.lean byte-identical.
- Check the corrected names and assumptions against the existing API, verify the frozen-byte comparison, regenerate the current source manifest, and commit. The user pushes. No new tag, archive or audit packet is needed.
- Leave root NEXT_FABLE_TASK.md explicitly inactive after closure, pointing to the immutable closure assignment. Return the integration commit and concise checks, then stop.

### The broader release and next theorem are separate choices

The original roadmap's Stage 5 gate mentions a stable downstream release and human review. Accepting this bounded candidate does not complete that larger gate. Do not publish, contact maintainers, assert a human-review result, or choose a new research branch as part of housekeeping.

The current implementation phase is ready to pause after integration. A later phase can begin with one owner-selected theorem contract or a separately authorized publication plan. There is no reason to invent another packaging stage solely to acknowledge acceptance.

**Decision:** release-readiness v1 accepted with R1-R3 as low-severity documentation corrections. Preserve the source tag and both submitted archives; complete ordinary integration and close the active task.
