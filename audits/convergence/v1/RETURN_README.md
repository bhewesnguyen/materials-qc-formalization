# Convergence v1 audit return

Decision: **accepted** at source commit
`a3cbac0692b4c106a89e80c91d18b0c2de4988cd`, tag
`convergence-milestone-v1`. No proof revision round is required. C1 and C2
are low-severity documentation corrections for integration of the next task.
The planned two-state mathematical core is complete after six accepted
increments. The selected Stage 4 extension is the bounded finite Markov
generator bridge with zero Hamiltonian. Stage 5 release work remains separate.

## Integrate the exact payload

Every ZIP path lies under `audits/convergence/v1/` and is relative to the
repository root. There is no replacement release source or root active task.

1. Verify the archive against `audits/convergence/v1/RETURN_MANIFEST.json`.
   Every non-directory entry except the manifest must appear exactly once
   with the recorded byte count and SHA-256. Require no extra or missing
   entries. Manifest keys are relative to the repository/ZIP root, not the
   manifest's own directory. The manifest excludes its own hash.
2. Extract to a temporary location and copy the paths into the repository
   without flattening them or nesting the full return under its own audit
   directory. Preserve unrelated files and compare existing destinations.
3. Keep `audits/convergence/v1/NEXT_FABLE_TASK.md` exactly as issued. Copy it
   to root `NEXT_FABLE_TASK.md` to activate the mutable implementation task.
   Do not remove the frozen issued copy or any earlier audit payload.
4. Use `FABLE_KICKOFF.md` as the Cursor prompt. Record acceptance, reproduce
   the untouched 187-export / 167-contract baseline, then apply source-comment
   corrections and implement only the issued Markov bridge. The implementer
   commits and tags; the user pushes. Accepted tags remain fixed.

## Findings carried forward

- C1: the convergence module header should say the scalar error tends to
  zero, while the matrix tends to `(trace X) • rhoStar`. The actual theorems
  already state the correct limits.
- C2: remove the stale README sentence denying convergence and update the
  overview and exclusions together.
- Related precision: a fixed stationary direction excludes a strict global
  factor below one; it alone does not disprove nonexpansiveness. Record the
  D016 wording clarification in D017, preserving historical D016 and handoff.

No accepted theorem, definition, hypothesis or proof needs repair. Make a
source-comment correction only after baseline reproduction, and record its
new hash. Validation scripts and dependency pins remain unchanged.

## Contents

- `Formal_Science_Convergence_Audit_v1.pdf` and `.md`: decision, mathematical
  review, reproduction, gate limits, findings, scope reconciliation and next task.
- `AUDIT_RECEIPT.json`: exact input identity, verification counts, decision,
  findings, preservation checks and next milestone.
- `PORTFOLIO_STATUS.md`: all 39 rows, six accepted increments and the unchanged
  1/28/10 reconnaissance classification, with local progress distinguished.
- `SCOPE_MEMO_REVIEW.md`: separate review of the personal planning note.
  The original memo remains unchanged and is not part of the release.
- `NEXT_FABLE_TASK.md`: frozen issued Markov assignment with exact rate
  orientation, self-jump exclusion, diagonal bridge and scope boundaries.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `evidence/`: fresh verification, gate tests, two controlled failures with
  fixtures, exact environment and runtime acquisition records, input receipt,
  source hashes, declaration inventory and package preservation checks.
- `RETURN_MANIFEST.json`: the immutable payload inventory.

Standalone downloads use milestone-specific names; the canonical filenames
inside this ZIP follow the agreed repository layout.

## Reproduction boundary

The auditor acquired the official pinned Lean runtime and all nine exact Git
dependencies, then fetched the documented 2,509-file cache closure. One truncated
extracted runtime library was restored from the verified official archive;
all 17,738 regular runtime files subsequently passed byte-hash comparison.
This setup repair changed no release source, dependency pin or proof policy.
Acquisition/retry logs are retained. The successful final verification is
fresh project elaboration against pinned compiled dependencies, not a full
Mathlib source rebuild.

All 31 verification commands pass, all seven release sources emit zero
diagnostics, every one of 187 exports has exactly the accepted three axioms,
and all 15 ordinary gate cases pass. The two retained controls intentionally
fail before the build step. The gate does not discover a declaration omitted
from both export lists; the separate manual source inventory checks all 187
public declarations and all 167 direct theorem consumers in this snapshot.

This acceptance concerns the supplied archive bytes. Remote Git publication,
ancestry, tag positions, receipt commit and working-tree status were not
independently authenticated. The audit did not push, retag or edit release code.
