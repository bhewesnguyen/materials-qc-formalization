# Stage audit handoff: release-readiness candidate

Completed from AUDIT_HANDOFF_TEMPLATE.md on 21 September 2026 by the
implementation agent. Every claim below is backed by a file under
`evidence/release-readiness/v1/`; nothing is asserted from an editor state.
This is a documentation, provenance, consumer-reproduction, and packaging
checkpoint. It adds no public definition or theorem.

## Scope

- Stage and accepted contract IDs: round 7, milestone `release-readiness`,
  round `v1`, the Stage 5 checkpoint issued with the Markov audit
  (`audits/markov/v1/NEXT_FABLE_TASK.md`, copied unchanged to the root slot
  with a status note). Required: integrate the Markov acceptance with M1 and
  M2; reproduce the accepted 216-export baseline; freeze the mathematical
  surface byte for byte; add a changelog, an API guide, a readiness record,
  and a provenance and license inventory; compile three anonymous usage
  consumers outside the export inventory; record provenance and the
  project license status; package the exact candidate; then extract the
  delivered archive into a fresh directory and reproduce gates and usage
  from it, delivering that evidence in a companion archive with an external
  receipt.
- Commit under review: the commit tagged `release-readiness-milestone-v1`,
  whose tree contains this document. Its hash is `git rev-parse
  release-readiness-milestone-v1^{commit}`; it is also recorded in
  `deliverables/release-readiness/v1/RECEIPT.json`, committed after the tag
  together with the archive-consumer evidence, and in the delivery message.
  Diff base: the accepted Markov commit
  `4795b8b6dc6ec7a831b9158affe3ee199f60e01e`. Between them sit the Markov
  receipt commit `c42eccd` and the housekeeping commit `933024e`, which
  integrated the audit return, activated the assignment, recorded D020 and
  D021, and applied M1 and M2, without touching proof source. No accepted
  tag was moved.
- What is complete: everything the assignment requires up to the tag, and
  the post-tag archive-consumer reproduction described in "Trust evidence".
  The eight release modules, `Audit/Contracts.lean`, `FormalScience.lean`,
  `exports.json`, both scripts, `lean-toolchain`, and `lake-manifest.json`
  are byte-identical to the accepted Markov snapshot
  (`evidence/release-readiness/v1/freeze/freeze_check.json`). Added files:
  `LICENSE`, `NOTICE`, `CITATION.cff`, `CHANGELOG.md`, `docs/API_GUIDE.md`,
  `docs/RELEASE_READINESS.md`, `docs/PROVENANCE_AND_LICENSES.md`,
  `examples/Usage.lean`, the round 7 evidence, and this handoff with its
  pointer.
- What is explicitly incomplete: nothing from the assignment. Not done, by
  instruction: no public release, package registry entry, announcement,
  upstream pull request, or maintainer contact; no human semantic review;
  no new mathematics. Per-file Apache-2.0 headers are not added because
  they would change accepted source bytes (`docs/PROVENANCE_AND_LICENSES.md`,
  "Known gaps").
- Owner decisions. The project license was not pending: the owner selected
  the Apache License 2.0 on 21 September 2026 before this round began, and
  D021 records the decision, its scope, and the authorship disclosure. The
  candidate therefore ships with `LICENSE` and `NOTICE`. No other owner
  choice is outstanding for the candidate; publication remains a separate
  decision that this round does not make.

## Reproduction

- OS and architecture: Ubuntu 24.04.5 LTS, Linux 7.0.0-31-generic, x86_64,
  glibc 2.39, Python 3.12.3 (`evidence/release-readiness/v1/environment.json`);
  the user's workstation.
- Lean toolchain: `leanprover/lean4:v4.34.0`, `Lean (version 4.34.0,
  x86_64-unknown-linux-gnu, commit 293d5d0c0c3f3dded4688b3ccd6a33939ac5102b,
  Release)`. Lake `5.0.0-src+293d5d0`. Mathlib
  `5ed2965256430c3649e86755f9576b54eca72435`, clean; no new imports, no cache
  extension, no pin change. Package version `0.0.1` unchanged.
- Dependencies and licenses: all nine checked-out HEADs equal their locked
  revisions and all nine top-level `LICENSE` files hash to the values in
  the audited round-1 inventory (eight Apache-2.0, `Cli` MIT);
  `evidence/release-readiness/v1/provenance/dependency_license_check.json`
  and `docs/PROVENANCE_AND_LICENSES.md`.
- Exact commands and exit codes:
  1. Baseline reproduction before any file of this round was added (tree at
     `933024e`): `python3 scripts/verify.py --output-dir
     evidence/release-readiness/v1/reproduction/verification` (exit 0; 32
     commands all exit 0; 216 exports; `source_sha256` and `axioms`
     identical to `evidence/markov/v1/verification/verification.json`) and
     `python3 scripts/test_verify.py --output-dir
     evidence/release-readiness/v1/reproduction/gate-tests` (exit 0; 15).
  2. Final verification on the candidate tree: `python3 scripts/verify.py
     --output-dir evidence/release-readiness/v1/verification` (exit 0; 32
     commands) and `python3 scripts/test_verify.py --output-dir
     evidence/release-readiness/v1/gate-tests` (exit 0; 15).
  3. Controls, both expected to fail, the round 6 fixtures re-run on this
     tree: `evidence/release-readiness/v1/gate-controls/missing-module/`
     (exit 1, coverage mismatch) and
     `.../unmentioned-contract-export/` (exit 1, unmentioned export); both
     reject before any build.
  4. Usage consumers: `lake env lean examples/Usage.lean` (exit 0, empty
     stdout and stderr; `evidence/release-readiness/v1/usage/`).
  5. Freeze check: `git show markov-milestone-v1:<path>` compared byte for
     byte with the working tree for every file hashed by `verify.py`; all
     identical (`evidence/release-readiness/v1/freeze/freeze_check.json`).
  6. Inventory linkage: the Markov manual inventory (216 public
     declarations, 193 theorems with consumers, 23 definitions, 7 private
     helpers) applies unchanged because the hashed files are identical
     (`evidence/release-readiness/v1/inventory/inventory_linkage.json`).
  7. Post-tag archive-consumer reproduction: see "Trust evidence".
- Release module/export manifest: unchanged; eight modules, 216 exports,
  193 contract exports.
- Raw log paths: `evidence/release-readiness/v1/{reproduction,verification,gate-tests,gate-controls,usage,provenance,freeze,inventory}/`,
  `evidence/release-readiness/v1/environment.json`, and after the tag
  `evidence/release-readiness/v1/archive-consumer/`. All earlier evidence
  trees are unchanged.

## Statement review

No statement changed. The mathematical surface is the accepted Markov
snapshot; its statement review is `deliverables/markov/v1/HANDOFF.md` and
the six earlier handoffs, and its accepted meaning is summarized per module
in the README and `docs/API_GUIDE.md`. The three consumers in
`examples/Usage.lean` are anonymous `example`s that apply
`evolution_isDensity` (nonnegative rates and time, density input),
`tendsto_evolution_of_isDensity` (nonnegative rates, `0 < a + b`, density
input), and `markovGenerator_diagonal` at `Fin 3` (arbitrary signed `q`,
arbitrary real `p`, explicit real-to-complex diagonal embedding). They are
outside `FormalScience/` and outside `exports.json`.

- Definitions and conventions: unchanged. The guide states destination-first
  rates, ignored diagonal `q` entries, zero Hamiltonian, signed rates on
  algebraic laws, nonnegative rates and time for the physical flow,
  positive total rate for attraction with the both-zero exception,
  trace-scaled equilibrium on arbitrary matrices, Frobenius rather than
  trace or diamond norm, arbitrary finite ancillas for complete positivity,
  and generator identities rather than a transition semigroup.
- Nontrivial witness / boundary cases: unchanged from the accepted rounds.
- Existing source matched or extended: none; no Lean release source
  changed.
- Any difference from the assignment: (a) `CITATION.cff` is added beyond
  the four requested documents, with factual fields only and no release
  date; (b) the license is applied rather than reported pending, because
  the owner decided before the round (D021); (c) the two controls are
  re-run rather than only retained; (d) the fresh-extraction reproduction
  mode actually used is stated in
  `evidence/release-readiness/v1/archive-consumer/README.md`.
- Downstream use: the candidate is the citable package for the seven
  accepted increments. Publication, human review, and the next mathematical
  branch are separate decisions.

## Trust evidence

- Transitive axiom output for every exported theorem: all 216 exports
  report exactly `[propext, Classical.choice, Quot.sound]`
  (`evidence/release-readiness/v1/verification/32-axiom-audit.stdout.log`),
  identical to the accepted Markov evidence.
- Forbidden/custom/native assumptions detected: none.
- Every release module actually compiled: `lake build` of the eight
  modules and the umbrella, then explicit re-elaboration of the eight
  release sources and `Audit/Contracts.lean`, all with zero diagnostics.
- Validation gate fixture results: 15 of 15; both controls reject.
- Source hashes: identical to the accepted Markov snapshot for every file
  hashed by `verify.py` (`freeze_check.json`, `verification.json`). Added
  files: `LICENSE`
  `cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30`
  (canonical Apache-2.0 text); `examples/Usage.lean`
  `dbb30a99c81368b0861ecf1ade6e47cdcfc5af09c394a5202ad9d00b22827909`; the
  documents' hashes are in `SOURCE_MANIFEST.json`.
- Archive-consumer reproduction (post-tag, committed with the receipt):
  the tagged archive was extracted into a fresh temporary directory, its
  contents verified against the archived `SOURCE_MANIFEST.json`, no project
  build output copied, dependencies materialized at the locked revisions,
  and from that directory both verification scripts and `lake env lean
  examples/Usage.lean` were run with only the documented setup. Commands,
  outputs, exit codes, source hashes, environment, pin checks, axiom
  output, gate results, the input archive digest, and the reproduction
  mode are under `evidence/release-readiness/v1/archive-consumer/`. Summary
  values (surface, exit codes, mode) are in
  `archive-consumer/README.md` and `RECEIPT.json`.
- Semantic review decision: self-review by the implementer only; the
  independent release-readiness audit decision is pending. No human
  semantic review of the mathematics has taken place.

## Blockers and next step

- Exact unresolved goal or API problem: none.
- Approaches already tried: none abandoned.
- Proposed bounded next task (for the audit to confirm or replace): none
  proposed by the implementer. The auditor's ledger names the candidates
  (a diagonal-Hamiltonian extension, finite-state dynamics, or another
  branch); publication of this candidate is the owner's separate decision.
- Changes requiring a contract decision: none mathematical. For the audit
  to confirm: the inclusion of `CITATION.cff`; the applied license and its
  recorded scope (D021); the wording of `docs/RELEASE_READINESS.md` on human
  review and publication.
- Suggested reviewer focus: confirm the byte-for-byte freeze against
  `markov-milestone-v1`; confirm that `examples/Usage.lean` contains only
  anonymous examples and is outside `FormalScience/` and `exports.json`;
  confirm the fresh-extraction evidence exercises the delivered archive
  and states its dependency mode honestly; read `NOTICE` and
  `docs/PROVENANCE_AND_LICENSES.md` for factual accuracy about authorship
  and the two adapted probes; and check that no document claims
  publication, human review, or novelty.

Do not substitute a theorem count, grep result, screenshot, or successful
compilation of one umbrella file with incomplete imports for the evidence
above.
