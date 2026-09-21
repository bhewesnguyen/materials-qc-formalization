# Fable kickoff: evolution milestone v1

Copy the text below into Cursor after extracting the stationary audit return
at the repository root with its directory paths preserved. Integration
instructions are at `audits/stationary/v1/RETURN_README.md`.

```text
You are the implementation agent for formal-science. The independent audit
accepted stationary-milestone-v1 at source commit
a5347ca77a2b5e6678f514decb0ab4eee7b62943. Implement the next bounded milestone,
evolution, according to audits/stationary/v1/NEXT_FABLE_TASK.md. Work through setup,
implementation, validation, and handoff; do not stop after proposing a plan.

First read AGENTS.md, README.md, DECISIONS.md, the audit under
audits/stationary/v1/, AUDIT_HANDOFF_TEMPLATE.md, and the new assignment.
Store the issued assignment unchanged at
audits/stationary/v1/NEXT_FABLE_TASK.md before copying it into the mutable
root active slot. Restore the previously omitted issued stationary task at
audits/dissipator/v1/NEXT_FABLE_TASK.md using the exact restoration included
in this return
and its manifest, not the status-edited root copy.

Record stationary acceptance, repair the current README/TURNS/status and
versioned-path prose, and add D011 with the audit errata. Preserve the
historical handoffs, tags, receipts, and evidence. Reproduce the untouched
72-export baseline and both verification gates before any Lean source or
docstring change. Use evidence/evolution/v1/ for fresh evidence. Preserve
Stage0.lean and Dissipator.lean exactly.

Then implement FormalScience/OpenSystems/TwoStateEvolution.lean using one
bundled complex-linear map on all complex qubit matrices. The assignment's
k(gamma,t) branch is t when gamma=0 and (1-exp(-gamma*t))/gamma otherwise.
It must give the correct signed-cancellation flow Id+tL, not an identity
shortcut. Preserve a:0->1, b:1->0, gamma=a+b, and the existing generator.

Required endpoints include the four entry formulas, initial identity,
semigroup law for all real rates and times, trace preservation, Hermiticity
with a Hermitian-input premise, and a matrix-valued HasDerivAt endpoint
equal to generator a b applied to the evolved matrix. Entrywise derivative
lemmas alone do not finish that contract. Include the trace(X) factors in
the nonzero-gamma population formula, stationary fixed points, the
zero-total-rate Id+tL identity, and the signed E00 witness.

Search pinned Mathlib before adding helpers. Do not change dependencies,
accepted theorem signatures, or the axiom policy. Add direct consumer
contracts and every public export. Run both verification scripts against
the final source, retain raw logs and source hashes, and preserve the
deliberately invalid gate fixtures.

Stop before positivity, Kraus/CP certification, norm estimates, convergence,
generic GKSL, the Markov bridge, or any other portfolio branch. Mathematical
real-line evolution is not a claim that negative-time maps are channels.

Fill deliverables/evolution/v1/HANDOFF.md and POINTER.json. Package the exact
tested files using the current manifest/commit/tag/archive/verification/
external-receipt sequence. Use evolution-milestone-v1. Commit and tag; I
will push. Return the archive, full SHA-256, exact source commit, receipt,
raw evidence, deviations, and blockers for the next audit.

Use no em dashes in documentation or code comments. Execute routine
reversible work without asking for confirmation. If a substantive blocker
remains, report the exact failing target without weakening the assignment.
```
