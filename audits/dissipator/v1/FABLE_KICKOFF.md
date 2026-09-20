# Cursor kickoff: stationary pilot

Copy the text below into Fable after placing the audit return in the project.

---

The dissipator milestone has passed independent audit. Read
`audits/dissipator/v1/Formal_Science_Dissipator_Audit_v1.md`, `AGENTS.md`,
`README.md`, `DECISIONS.md`, and the new root `NEXT_FABLE_TASK.md` from the
audit return. The active milestone is now `stationary`, round `v1`.

Work through the assignment to completion. First record the accepted
dissipator decision in `TURNS.md` and close findings F1-F4 in the live
instructions and future handoff practice. Preserve the accepted tag,
historical v1 handoff, and all prior evidence. The findings require no
changes to the accepted Lean proofs.

Reproduce the current pinned 42-export baseline before extending it. Record
new evidence under `evidence/stationary/v1/` as directed.

Implement only the two-state stationary pilot: weighted generator, all four
entry equations, trace and Hermiticity laws, the candidate
`diagonalState (a/(a+b))`, density validity, trace-one algebraic uniqueness,
the unique stationary-density endpoint, and the one-zero, both-zero, and
equal-positive-rate boundary cases. Follow the exact hypotheses and
conventions in `NEXT_FABLE_TASK.md`. In particular, do not assume the unknown
stationary matrix is diagonal, and do not require both rates to be strictly
positive for uniqueness.

Reuse the accepted dissipator API. Preserve dependency pins, theorem
contracts, and the axiom policy. Update the release imports, exports, and
direct consumer checks. Run both validation scripts and retain the raw
evidence. Do not weaken statements or bypass checks to get a passing build.

Return `deliverables/stationary/v1/HANDOFF.md`, the pointer, a verified source
archive, its full SHA-256, the exact commit, and any deviations or blockers.
Follow the corrected manifest/commit/tag/archive sequence. The implementer
commits and tags; I will push. Do not publish or retag the accepted
dissipator release.

Proceed without routine confirmation. Stop after the stationary milestone
for the next audit. Do not begin dynamics, convergence, complete positivity,
generic GKSL, or another portfolio branch. Use no em dashes in documentation
or code comments.
