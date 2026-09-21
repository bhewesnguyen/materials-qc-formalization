# Active assignment: integrate the release-readiness audit and close the checkpoint

This is routine audit integration, not a new mathematical milestone or a second release-readiness candidate. It applies with the acceptance decision in the accompanying release-readiness v1 audit.

Accepted source: `2a258df6654d1b3553d3affebd7e94405bb4e989`, tag `release-readiness-milestone-v1`. Preserve that tag and every earlier accepted tag.

The accepted mathematical surface remains eight release modules, 216 exports, 193 theorem contracts, and 23 definitions or abbreviations. Seven mathematical increments are accepted. This checkpoint adds documentation, provenance, three anonymous usage examples, and archive-consumer reproduction; it adds no public mathematical result.

## 1. Verify and integrate the audit return

Read `AGENTS.md`, the accompanying audit, and its `RETURN_README.md`. Verify the return's CRC, safe relative paths, exact payload set, byte counts, and SHA-256 values against `audits/release-readiness/v1/RETURN_MANIFEST.json`. Extract temporarily and preserve the repository-relative paths. Compare any existing files before replacement; do not flatten paths or introduce another audit directory layer.

Store the returned files exactly as received under `audits/release-readiness/v1/`. Its manifest defines the immutable payload. Keep the issued task and kickoff there unchanged. Root `NEXT_FABLE_TASK.md` is the mutable active slot.

The source archive and the companion consumer-evidence archive were reviewed separately. Retain their existing receipts and evidence. Do not put the companion's digest inside the companion archive, rewrite the tagged source archive to include later evidence, or relocate historical records.

## 2. Record acceptance and current status

Update the existing round 7 row in `TURNS.md` with the full accepted source commit, report path, and acceptance decision. Do not create an eighth mathematical increment. Add one concise `DECISIONS.md` entry recording audit integration, the actual finding IDs if any, and closure of the candidate preparation.

Update the live README, `AGENTS.md`, `docs/RELEASE_READINESS.md`, and `docs/SCOPE_MEMO.md` where they describe the candidate as pending. State that the bounded release-readiness candidate is accepted. Make only concrete nonblocking documentation corrections named in the audit. Preserve historical handoffs, issued tasks, evidence, audits, and source tags.

Carry the accompanying audit's three documentation corrections into this same commit:

- R1, API guide exactness: state that `FormalScience.OpenSystems.rhoStar_zero_left` is unconditional; only the other two listed boundary theorems need their displayed nonzero premise. Provide fully qualified exported declaration and import names, including the `FormalScience.Quantum` declarations; do not rely on a missing namespace opening or incomplete suffix shorthand. Display the `i ≠ j` premise on off-diagonal entry statements. Distinguish theorem consumers from definitions in the introduction. Check names against the unchanged export list and assumptions against the actual types.
- R2, trust and provenance wording: replace the readiness record's claim that the consumer contracts were "human-written" with the factual account that they were AI-authored and semantically reviewed by the separate audit agent. Preserve the clear statement that no human semantic review of the proofs has occurred. Tighten the provenance document's "every later ... document" wording so it refers to implementation-authored files and preserves the separately identified auditor and planning origins.
- R3, live ledger and history: update the scope memo's Section 4 local-contribution table, header, and source link from the convergence ledger to the current accepted ledger. Add the finite Markov generator contribution to rows 10, 11, and 13; row 15 remains unchanged. Keep the same four partly advanced rows and do not imply a new channel, generic dynamics, or a completed broad portfolio row. Correct `CHANGELOG.md` so the evolution docstring copyedit is attributed to the optional D013 cleanup, not to finding E1. M1 and M2 are closed and should not be reopened.

Keep these distinctions explicit:

- Seven accepted mathematical increments, plus one release-readiness checkpoint.
- Eight modules, 216 exports, 193 theorem contracts, 23 definitions or abbreviations.
- The selected two-state benchmark and finite Markov generator bridge are complete.
- Candidate preparation is complete; human semantic review, publication, and any upstream contribution have not occurred by virtue of this audit.
- The original roadmap's broader Stage 5 release/human-review gate is not declared complete.
- The 39-area portfolio retains four partly advanced rows, one Mathlib reuse/reference row, and 34 rows without local implementation; no broad row is declared fully completed.

Preserve the recorded owner-selected Apache-2.0 license and factual AI-assistance/provenance disclosure. Do not add per-file license headers, claim a legal review, or alter licensing scope as part of this integration.

## 3. Preserve the accepted package

Keep byte-identical to the accepted release-readiness source: all eight release modules, `FormalScience.lean`, `Audit/Contracts.lean`, `exports.json`, both verification scripts, `lean-toolchain`, `lake-manifest.json`, `lakefile.toml`, and `examples/Usage.lean`. Keep dependency revisions and package version unchanged. Confirm those bytes against the accepted tag; a hash comparison is sufficient for this documentation-only integration.

Do not add a theorem, definition, API rename, import, proof cleanup, consumer example, new validation framework, or dependency update. Validate the corrected documentation names and assumptions against the existing sources and export list. Do not repeat the full Lean/gate/consumer runs when their inputs remain unchanged. If an unexpected source mismatch appears, identify it and resolve its origin instead of silently changing the accepted source or claiming that status-only checks cover it.

## 4. Commit and stop

After the live status updates are complete, replace root `NEXT_FABLE_TASK.md` with a concise inactive checkpoint note: release-readiness v1 accepted and integrated; no mathematical implementation is active; next theorem contract or publication decision belongs to the owner. Point to the immutable issued closure task and the accepted audit. Keep that historical task unchanged.

Stage only intended integration and live-documentation changes, regenerate root `SOURCE_MANIFEST.json` over the final staged payload set using the existing protocol, verify staged/working equality and manifest hashes, and commit. Do not create a new milestone tag or handoff archive for this ordinary integration commit. Do not move any accepted tag. The user pushes.

Return a short completion note with the integration commit, unchanged API counts, audit-return verification result, accepted-source comparison result, and any concrete unresolved issue. If there is none, state that no implementation task remains active.

Do not publish a release, contact anyone, submit an upstream PR, invent a human-review result, or begin a new portfolio branch. No further audit round is requested for this status-only integration. All documentation and code comments use no em dashes.
