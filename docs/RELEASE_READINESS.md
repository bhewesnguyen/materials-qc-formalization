# Release readiness record

Candidate: `release-readiness-milestone-v1`, prepared 21 September 2026 from
the accepted Markov snapshot `4795b8b6dc6ec7a831b9158affe3ee199f60e01e`
(tag `markov-milestone-v1`), and accepted by the independent
release-readiness audit on the same day
(`audits/release-readiness/v1/Formal_Science_Release_Readiness_Audit_v1.md`,
commit under review `2a258df6654d1b3553d3affebd7e94405bb4e989`) with three
low-severity documentation findings closed in the integration commit
(D022). This document separates three things that are easy to conflate:
what the independent audits have accepted mathematically, what this
candidate verified about the package a recipient receives, and what
remains an owner or publication decision. Acceptance of the candidate is
not a human-review result and does not complete the roadmap's broader
Stage 5 gate. The pointers below are to files in this repository; the
post-tag archive-consumer evidence is committed after the tag and was also
delivered in a companion archive, as the assignment required.

## 1. Exact candidate scope

- Package `formal-science`, version `0.0.1` (unchanged; the tag names an
  audit candidate, not a public semantic-version release).
- Mathematical surface, frozen byte for byte at the accepted Markov
  snapshot: eight release modules, 216 exports, 193 distinct theorem
  contracts, 23 definitions or abbreviations, `Audit/Contracts.lean`,
  `FormalScience.lean`, `exports.json`, `scripts/verify.py`,
  `scripts/test_verify.py`, `lean-toolchain`, `lake-manifest.json`. The
  byte-for-byte comparison is recorded in
  `evidence/release-readiness/v1/freeze/freeze_check.json`.
- Added in this candidate, all outside the export inventory and the proof
  gate: `LICENSE`, `NOTICE`, `CITATION.cff`, `CHANGELOG.md`,
  `docs/API_GUIDE.md`, `docs/PROVENANCE_AND_LICENSES.md`, this record,
  `examples/Usage.lean`, and the round 7 evidence and handoff.
- Live documentation corrections M1 and M2 from the Markov audit (D020).

## 2. Verified facts about the accepted mathematics

These are the auditor's accepted results; the candidate reproduces them
but does not re-decide them.

- Seven mathematical increments accepted by independent audit with no
  proof revision ever requested: Stage 0, dissipator, stationary,
  evolution, Kraus, convergence, Markov (`TURNS.md`, `audits/<key>/v1/`).
- Every one of the 216 exports depends on exactly `propext`,
  `Classical.choice`, and `Quot.sound` (`evidence/markov/v1/verification/32-axiom-audit.stdout.log`,
  reproduced this round in
  `evidence/release-readiness/v1/verification/`).
- No `sorry`, `admit`, custom axiom, `native_decide`, or `implemented_by`
  in any release module. `noncomputable` markers are code-generation
  attributes only.
- Each public theorem has a fully spelled-out consumer in
  `Audit/Contracts.lean`; the manual source-to-export and
  theorem-to-contract inventory of the accepted snapshot is
  `evidence/markov/v1/inventory/declaration_inventory.json`, linked to the
  unchanged source hashes in
  `evidence/release-readiness/v1/inventory/inventory_linkage.json`.
- What the mathematics does and does not cover is stated per module in the
  README's "Mathematical surface" and in `docs/API_GUIDE.md`. In one
  sentence: beyond the generic finite Kraus and dissipator laws and the
  finite Markov generator bridge, the dynamical and convergence results
  concern the explicit two-state model with zero Hamiltonian.

## 3. Verified facts about this candidate

Recorded under `evidence/release-readiness/v1/`:

- `reproduction/`: both verification scripts on the untouched accepted
  source before any file of this round was added (32 commands exit 0, 216
  exports, 15 gate cases, source hashes and axiom map identical to the
  accepted Markov evidence).
- `verification/`, `gate-tests/`: the same scripts on the final candidate
  tree.
- `gate-controls/`: the two negative-control fixtures of round 6 re-run on
  this tree, both rejecting before any build.
- `usage/`: `lake env lean examples/Usage.lean`, exit 0, no diagnostics.
- `provenance/`: dependency revisions and license hashes confirmed against
  the audited round-1 inventory.
- `archive-consumer/` (post-tag): the tagged archive extracted into a fresh
  directory with no copied project build outputs, dependencies materialized
  at the locked revisions, and both scripts plus the usage file run from
  the extracted package. The reproduction mode (fresh clone of the pinned
  dependencies and the documented Mathlib cache, or a reused pinned cache)
  is stated in `archive-consumer/README.md`. This is fresh local-source
  re-elaboration against pinned compiled dependencies, not a full Mathlib
  source rebuild.

## 4. Known gate limitations

- `scripts/verify.py` checks release-module coverage, listed exports, a
  textual contract mention for every contract export, the build,
  re-elaboration of every release source and of the contract file, explicit
  signatures, and transitive axioms. It does not discover a public
  declaration omitted from both export lists; that check is the manual
  inventory above, reviewed each round. The contract statements are
  written explicitly and were semantically reviewed by the implementation
  and independent audit agents. The textual check alone does not validate
  their meaning. No human semantic review is recorded.
- Verification reuses Mathlib's compiled cache at the pin; no round has
  rebuilt Mathlib from source.
- Successful compilation and an accepted axiom report do not establish
  that a statement is the intended mathematics; that is what the audits'
  semantic review and the spelled-out contracts are for.
- Remote Git history, tag positions, and pushes are authenticated by the
  owner, not by the audits, which review the delivered archive bytes.

## 5. Outstanding decisions and non-claims

- License: selected. Apache License 2.0 for the project's own material
  (D021, `LICENSE`, `NOTICE`). Per-file license headers are not added
  because they would change accepted source bytes.
- Human review: not done. No mathematician has reviewed the statements or
  proofs; the audits were performed by an AI agent independent of the
  implementer. Any public claim about the results should say so.
- Publication: not done and not implied. No GitHub Release, package
  registry entry, announcement, upstream pull request, or maintainer
  contact has been made or is made by this candidate. Whether and where to
  publish is the owner's decision, subject to the AI-disclosure policies of
  any target.
- Novelty: not claimed. The results are explicit finite-dimensional
  formalizations of standard mathematics.
- Portfolio: no broad row of the 39-area inventory is complete
  (`audits/markov/v1/PORTFOLIO_STATUS.md`).
