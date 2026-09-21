# Release-readiness v1 audit return

Decision: **accepted**, source commit
`2a258df6654d1b3553d3affebd7e94405bb4e989`, tag
`release-readiness-milestone-v1`, with three low-severity nonblocking
live-documentation findings, R1-R3. No proof, package, verifier or dependency
revision round is required. All earlier M1/M2 requested corrections are closed.

This completes the bounded candidate preparation. It adds one release-readiness
checkpoint to seven accepted mathematical increments, not an eighth mathematical
increment. The original roadmap's broader Stage 5 human-review and public-release
gate is not declared complete. No public or upstream action is authorized.

## Exact integration

Every ZIP path is repository-relative under `audits/release-readiness/v1/`.
This return contains no replacement project source and no root active task.

1. Verify safe unique paths, CRC, exact payload set, byte counts and SHA-256
   against `audits/release-readiness/v1/RETURN_MANIFEST.json`. Manifest keys
   are relative to the repository/ZIP root. Only the manifest itself is
   excluded from its payload hash list.
2. Extract temporarily, compare existing destinations and integrate the
   paths as received. Do not flatten, double-nest, relocate older records or
   replace unrelated files.
3. Keep the returned `NEXT_FABLE_TASK.md` and `FABLE_KICKOFF.md` unchanged.
   Follow the issued closure task, using an editable root task copy during
   integration. Apply R1-R3 to live documentation and record acceptance.
4. Preserve all mathematical files, contracts, scripts, exports, pins,
   package version and `examples/Usage.lean` byte for byte. A hash comparison
   and targeted documentation-name/assumption checks suffice for this
   documentation-only commit; do not rerun unchanged proof gates routinely.
5. Regenerate the current staged source manifest and commit the integration.
   Do not make a new milestone tag, source archive, companion or audit packet.
   The user pushes. Finish with root `NEXT_FABLE_TASK.md` explicitly inactive
   and pointing to the immutable issued closure task.

## Findings

- R1: API guide exactness: unconditional zero-left identity, full names and
  namespaces, explicit off-diagonal premises, theorem/definition distinction.
- R2: replace the human-written contracts claim with the actual AI-agent
  authorship/review description; qualify the broad origin wording.
- R3: advance the memo's contribution table to Markov and correct the
  changelog's E1 attribution to the optional D013 docstring cleanup.

`DOCUMENTATION_CORRECTIONS.md` provides exact bounded remedies. Preserve all
historical handoffs, audits, evidence, decisions and tags. The owner's Apache-2.0
selection recorded in D021 remains in place; it is not an outstanding candidate
choice and is not reopened by this audit.

## Contents

- `Formal_Science_Release_Readiness_Audit_v1.pdf` and `.md`: decision,
  reproduction, findings, provenance, trust boundary and closure plan.
- `AUDIT_RECEIPT.json`: exact input identities, hashes, decision and counts.
- `DOCUMENTATION_CORRECTIONS.md`: precise R1-R3 remedies.
- `NEXT_FABLE_TASK.md`: frozen ordinary integration/closure task.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `PORTFOLIO_STATUS.md`: all 39 rows and the unchanged mathematical tally.
- `evidence/`: fresh verification, gate and usage logs; interrupted-run record;
  package comparisons; documentation probe; license and provenance checks.
- `RETURN_MANIFEST.json`: authoritative immutable return payload inventory.

Standalone downloads use descriptive names; their bytes match the canonical
files in this return. The source and companion archives supplied by Fable remain
unchanged and are not nested inside this return.

## Reproduction and authority limits

Both input archives passed exact-set, hash, size, safe-path and CRC checks.
Source SHA-256:
`e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0`.
Companion SHA-256:
`7c6bca2065fb4c0068ef2d1265b97197d09dbedd0173e33f34983f2442d35553`.
The source has 3,118 payloads plus its manifest; the companion has 115 plus its
manifest. Receipt separation and loose attachments are correct.

All 16 frozen project files match the actual accepted Markov extraction. All
historical payloads are preserved, including the exact 208-file Markov audit
return. The unchanged manual inventory is correctly linked to the current source.

The auditor independently built and re-elaborated an isolated copy of the
verified source using the previously validated pinned Lean runtime and exact
dependency trees/cache. All 32 verification commands and all 15 gate cases pass;
every one of 216 exports uses exactly `propext`, `Classical.choice`, `Quot.sound`.
All eight source checks, contracts and the three anonymous usage examples emit
zero diagnostics. Source-hash, manifest and axiom maps match Fable's final and
recipient evidence. One execution transport reset interrupted an initial run;
partial logs were retained and unchanged commands restarted successfully.

Fable's consumer logs separately substantiate fresh dependency clones and
2,509 targeted cache artifacts, with reused local compressed-cache storage.
Neither run rebuilds all Mathlib source. The two additional submitted negative
controls and fixtures were inspected; the frozen inputs match those independently
exercised in the Markov audit. No redundant fresh execution of those two controls
is claimed here. The ordinary gate does not discover omissions from both lists
or establish a contract's meaning from a textual mention alone.

The license file was independently fetched from the official Apache URL and
matched byte for byte. Dependency license and adapted-probe hashes were checked.
This is a consistency/provenance check, not a determination of copyright ownership.
No human semantic review, publication, remote Git authentication, novelty or
upstream acceptance is credited by this audit. No source, tag or remote was changed.

## End of the active phase

Complete the ordinary integration commit and stop. No next mathematical branch
has been selected. A later theorem contract or publication decision belongs to
the owner; do not start another implementation merely to keep the audit loop moving.
