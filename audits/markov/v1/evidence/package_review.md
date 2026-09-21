# Markov v1 package and recorded-evidence review

Reviewed the immutable submitted tree against the accepted convergence snapshot and the auditor's exact convergence return. No source, historical evidence, or submitted metadata was modified. Fresh Lean execution is handled separately by the root auditor.

## Outcome

No package or recorded-evidence blocker. The return is internally coherent and preserves the accepted history. One low-severity README scope sentence should be corrected during the next integration. Stage 5 release prerequisites remain separate from mathematical acceptance.

## Source and history integrity

- Accepted convergence manifest: 1,998 payloads. Markov manifest: 2,609 payloads. There are 611 added paths, nine changed paths, and no removed path.
- The nine changed paths are `AGENTS.md`, `Audit/Contracts.lean`, `DECISIONS.md`, `FormalScience.lean`, `FormalScience/OpenSystems/TwoStateConvergence.lean`, `NEXT_FABLE_TASK.md`, `README.md`, `TURNS.md`, and `exports.json`.
- All 1,309 pre-existing evidence files, 651 pre-existing audit files, and 13 pre-existing deliverable files remain byte-identical. The source manifest itself is excluded from these payload comparisons by design.
- All 324 files in the exact convergence return, including its manifest, match the integrated copies byte for byte. The original return ZIP has SHA-256 `371acbf0b438f801c404cbd4de6a66e4bd1bc707cfca688c3c9e8c51cf94016f`.
- Historical return manifests validate: dissipator 143 payloads, stationary 144, evolution 157, Kraus 202, convergence 323. The old dissipator manifest's three original root keys are checked at their documented preserved locations under `audits/dissipator/v1/`; this is the previously accepted relocation, not a new mismatch.
- Six previous release modules are byte-identical. The only changed earlier release module is `TwoStateConvergence.lean`; its difference is entirely in the opening block comment. Whitespace-normalized comment-stripped source is identical.
- The 167 earlier theorem contracts are preserved; the new Markov section appends 26 theorem contracts, with an additional pointwise consumer for the bundled two-state recovery theorem.
- Both gate scripts, `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json` are byte-identical to the accepted snapshot. Export and module lists preserve the previous lists as prefixes.
- The frozen issued Markov task matches the exact auditor return. The root active task preserves its body and adds only the status wrapper.

## Recorded verification and inventory

Baseline reproduction records 31 successful commands, 187 exports and 167 theorem contracts. Its source hashes, parsed axioms, and manifest are exactly equal to the accepted convergence evidence. Final records contain 32 successful commands, 216 exports, and 193 theorem contracts. Every separate stdout/stderr log agrees with its embedded command record, and the independent command log equals `verification.json`'s command list. All 16 final source hashes match the submitted files.

Reparsing the raw axiom logs reproduces both JSON axiom maps. Every export in both runs reports exactly `{propext, Classical.choice, Quot.sound}`. Both baseline and final gate-test runs record 15 passing expected-outcome cases, and their raw logs agree with their command records. The new module and contract re-elaborations emit no diagnostics in the submitted logs.

An independent comment-stripped declaration scan finds 216 public declarations: 193 theorems and 23 definitions or abbreviations, plus seven private helpers. Every public declaration is exported; every theorem is listed in `contract_exports` and occurs as an exact fully qualified token in executable contract source. The namespace/declaration structure is simple and was inspected. The new 26 contracts directly apply the named theorems. This scan corroborates the submitted manual inventory; it does not turn the ordinary gate into a semantic completeness checker.

Both retained negative fixtures differ from the release manifest in the advertised way:

- `missing-module` removes only `FormalScience.OpenSystems.FiniteMarkovBridge` from `release_modules`, preserving exports, and records the expected coverage mismatch.
- `unmentioned-contract-export` appends the nonexistent qualified name `FormalScience.OpenSystems.markovGenerator_unmentioned` to both export lists, with no corresponding consumer, and records the expected missing-mention rejection.

Each control performs 20 environment/dependency checks and rejects before a build. This validates the checks the gate actually enforces. A declaration deleted from both manifest lists is still a manual source-inventory obligation. Nothing here claims the verifier automatically proves declaration-level completeness.

## Earlier findings and scope memo

C1 is closed: the module header now distinguishes scalar error tending to zero from the matrix tending to `trace X • rhoStar`. The additional header clarification correctly avoids the invalid inference that a fixed stationary direction alone disproves nonexpansiveness. C2's denial of convergence is removed from the README. D017 preserves historical D016 and supplies the correct uncentered counterexample `Phi_t I = diag(e, 2-e)`, with squared Frobenius norm `2 + 2(1-e)^2` for `a=1,b=0`.

D018 explicitly records the user's decision to track the corrected personal scope memo despite the earlier task's default boundary. It is marked as planning context outside `exports.json` and the verification gate. The loose memo attachment matches `docs/SCOPE_MEMO.md` byte for byte. This recorded, user-chosen organizational change is acceptable and needs no further permission discussion. The seven requested memo corrections are visibly incorporated, including `H=0`, the Hamiltonian counterexample, the disjoint tier tally, withdrawal of a lower-bound throughput forecast, and separation of accepted coverage counts from broad-area completion.

## Proposed low-severity finding M1

`README.md`, introductory exclusion paragraph, still says the release proves nothing about general finite dimension “beyond the generic Kraus and dissipator layers.” The new Markov module is explicitly over arbitrary finite index types and establishes a further generator-level diagonal bridge. Update that exception on acceptance to include the finite Markov generator bridge. Preserve the separate exclusions for general finite-state dynamics, generic GKSL, Perron-Frobenius, and convergence beyond the two-state model.

This is the same stale-exclusion pattern as E1 and C2, not a repeated proof defect. A short scope consistency pass during release preparation is more useful than adding a test for prose. No proof-repair round is needed for this sentence.

## Stage 5 observations, not current blockers

There is no top-level `LICENSE`, `COPYING`, `NOTICE`, `CITATION`, `AUTHORS`, or `CONTRIBUTING` file in the submitted tree; `lakefile.toml` still gives package version `0.0.1`. Existing dependency-license evidence identifies eight Apache-2.0 packages and one MIT package, but that does not select a license for the project's own code. The generic Kraus source already records adaptation provenance in D014. A release preparation checkpoint should collate actual authorship and source provenance, establish an owner-approved project license if public reuse is intended, write a bounded changelog and citation metadata, and preserve the exact pin and audited mathematical surface. License choice, public release, upstream contribution, and maintainer acceptance should not be inferred from this mathematical audit.

Evidence: `package_checks.json`, generated by `check_package.py`, records exact comparisons and inventory counts. This review makes no claim to have verified remote Git refs or pushes.
