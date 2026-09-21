# Markov v1 audit return

Decision: **accepted** at source commit
`4795b8b6dc6ec7a831b9158affe3ee199f60e01e`, tag `markov-milestone-v1`.
No proof revision round is required. M1 and M2 are low-severity documentation
corrections to apply during the next release-readiness round.

The six-increment two-state benchmark and the selected bounded Stage 4 finite
Markov generator bridge are complete: seven accepted mathematical increments,
eight release modules, 216 exports, 193 distinct theorem contracts, and 23
definitions or abbreviations. This does not complete any whole broad portfolio
row, construct generic finite-state dynamics, or publish a release.

## Integrate the exact payload

All ZIP entries lie under `audits/markov/v1/` with repository-relative paths.
This return contains no replacement release source and no root active task.

1. Before integration, verify safe paths, uniqueness, CRC and the exact file
   set against `audits/markov/v1/RETURN_MANIFEST.json`. Every payload except
   that manifest appears exactly once with byte count and SHA-256. Manifest
   keys are relative to the repository/ZIP root, not the manifest directory.
2. Extract temporarily, compare existing destinations, and copy paths as
   received. Do not flatten them, nest the return under another audit folder,
   remove earlier payloads, or overwrite unrelated work.
3. Keep `audits/markov/v1/NEXT_FABLE_TASK.md` unchanged as the issued assignment.
   Copy it to root `NEXT_FABLE_TASK.md` to activate the mutable implementation
   task. Record the acceptance and findings in the live project records.
4. Use `FABLE_KICKOFF.md` in Cursor. Reproduce the untouched accepted baseline
   before candidate work. Freeze release source, contracts, exports, scripts,
   umbrella imports and pins byte for byte. Apply only the bounded next task.
   The implementer commits and tags; the user pushes. Accepted tags stay fixed.

## Findings and recorded choices

- **M1:** README's exception for generic finite-dimensional results must also
  include the newly accepted finite Markov generator bridge.
- **M2:** qualify the scope memo's density convergence by positive total rate,
  and apply the bounded planning/reuse wording corrections in the accompanying
  `SCOPE_MEMO_REVIEW.md`. The memo is shipped planning documentation outside
  the Lean export inventory and proof gate.
- **D018 accepted:** keep `docs/SCOPE_MEMO.md` tracked as the user decided. Do
  not reinstate the superseded no-commit instruction in the older frozen task.
- **Earlier findings closed:** C1 and C2 are corrected; D017 records the D016
  wording erratum. No new comment change in Lean source is required.

No theorem, definition, hypothesis, proof, gate script or dependency pin needs
repair. The missing original-project license is a release-readiness decision,
not a Markov proof blocker. The next task completes the candidate first and
returns any genuinely unresolved owner choice without silently assigning it.

## Contents

- `Formal_Science_Markov_Audit_v1.pdf` and `.md`: decision, mathematical review,
  execution, preservation, findings, tally, and next checkpoint.
- `AUDIT_RECEIPT.json`: exact input identity, source hashes, decision and counts.
- `NEXT_FABLE_TASK.md`: frozen Stage 5 release-readiness assignment.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `PORTFOLIO_STATUS.md`: the full 39-row ledger and seven accepted increments.
- `SCOPE_MEMO_REVIEW.md`: precise live-document wording corrections.
- `evidence/`: fresh verification and gate logs, both negative-control fixtures,
  environment, package preservation and independent mathematical review.
- `RETURN_MANIFEST.json`: authoritative immutable payload inventory.

The standalone task, kickoff, portfolio and scope downloads have descriptive
names. Their bytes match the canonical files in this ZIP.

## Reproduction boundary

The auditor reused the official Lean 4.34.0 runtime and exact pinned dependency
cache validated in the convergence audit. All nine dependency revisions and
tracked status were rechecked. The current project was built and its sources
re-elaborated in an isolated extraction. No existing project build outputs were
copied into that extraction. This is not a full Mathlib source rebuild or a
repeated full runtime archive scan.

All 32 verification commands exit 0. All eight release sources and the contract
file emit zero diagnostics. Every export reports exactly `propext`,
`Classical.choice`, and `Quot.sound`; all 15 ordinary gate cases pass. Both
retained negative controls reject before building. Manual declaration and
semantic contract reviews complement the gate: it does not discover a public
declaration omitted from both export lists, and a name mention alone does not
prove that a consumer states the intended mathematics.

The supplied archive has 2,609 manifest-covered files plus its manifest, with
SHA-256 `ec3f3a115926efb2ba7081d3d98227ee8939004911a92a9cb76c13770317e07c`.
All prior evidence, handoffs and integrated audit returns are preserved. This
acceptance is for those supplied bytes; remote Git history, ref positions,
working-tree cleanliness and receipt commit publication were not authenticated.
The auditor did not modify release source, push, retag or publish.

## Next checkpoint

Use milestone `release-readiness`, round `v1`, with tag
`release-readiness-milestone-v1`. Prepare documentation and provenance, three
anonymous compiled usage examples, and a tagged candidate with the mathematical
surface frozen. Reproduce the exact delivered source archive in a fresh project
directory, allowing only honestly reported pinned dependency-cache reuse.

The post-tag consumer evidence and receipt travel in a separate manifested
companion ZIP, so the tagged source archive remains immutable. Keep the companion
ZIP's digest external to it. No new theorem program, upstream submission,
maintainer contact or public-release action is authorized by this assignment.
