# Evolution v1 audit return

Decision: **accepted** at source commit
`a60a92b6064b4dde33a98d3c79be195c77595873`, tag
`evolution-milestone-v1`. No proof revision is required. The next milestone is
`kraus`: a four-Kraus certificate for the existing physical evolution and a
genuine all-finite-ancilla positivity theorem. Convergence follows separately.

## Integrate with paths preserved

The ZIP uses repository-relative paths, all under `audits/evolution/v1/`.
It contains no replacement release source, dependency cache, or root active-task
file. Preserve the complete received payload, including the issued assignment.

1. Verify the ZIP against `audits/evolution/v1/RETURN_MANIFEST.json` inside it.
   Every non-directory ZIP entry except that manifest must appear exactly once
   with matching byte count and SHA-256. Require no missing or extra entries.
   Manifest keys are relative to the repository/ZIP root, not the manifest's
   own folder. The manifest excludes its own hash.
2. Extract to a temporary location, then copy its `audits/` contents into the
   repository while preserving paths and unrelated files. Do not flatten the
   return or place the entire tree inside its own milestone folder. If a
   destination already exists, compare it before replacing anything.
3. Keep `audits/evolution/v1/NEXT_FABLE_TASK.md` unchanged as the issued task.
   Copy it to the root `NEXT_FABLE_TASK.md` to activate the next assignment.
   Implementation status changes belong only in the root copy.
4. Use `audits/evolution/v1/FABLE_KICKOFF.md` as the Cursor prompt. It directs
   Fable to record acceptance, close E1/E2 in D013 and live documentation,
   reproduce the untouched 115-export baseline, implement the bounded Kraus
   checkpoint, validate, commit, tag, and package. The user pushes.

The prior findings S1-S3 are closed. No further restoration of historical
assignments is needed. Preserve accepted tags, handoffs, manifests, and evidence.

## Contents

- `Formal_Science_Evolution_Audit_v1.pdf` and `.md`: verdict, mathematical
  findings, derivative/API clarification, reproduction, and next scope.
- `AUDIT_RECEIPT.json`: exact input identity, verdict, verification counts,
  documentation findings, portfolio counts, and next milestone.
- `PORTFOLIO_STATUS.md`: four accepted local milestones and all 39 inventory
  rows, with the recorded 1/28/10 coverage classification preserved.
- `NEXT_FABLE_TASK.md`: frozen issued Kraus assignment, including exact matrices,
  square-root conventions, physical boundaries, amplification, and CP endpoint.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `evidence/`: fresh verification and gate records, omitted-module control,
  derivative consumer without local matrix norm instances, environment,
  package integrity, and prior-evidence preservation checks.
- `reference/`: optional generic Kraus feasibility source plus compilation and
  axiom output. It is outside the accepted release and is not the requested
  four-Kraus certificate. Adopted helpers must pass the normal release gates.
- `RETURN_MANIFEST.json`: the immutable payload inventory for this return.

The standalone downloads may carry milestone-specific filenames to distinguish
them from earlier rounds. Inside the ZIP, the canonical filenames above are
preserved for the agreed repository layout.

## Two nonblocking corrections

E1: update the README introduction that still denies proving a semigroup or
time evolution. Both are now accepted; CP and density preservation are the next
task, with convergence still pending.

E2: clarify D012's derivative explanation. At the pinned Mathlib version,
`HasDerivAt` uses the canonical target topology and has no target matrix norm
argument. Compatible local norm structures are harmless proof infrastructure.
The auditor's direct consumer works without enabling them. No additional
norm-independence theorem or change to the accepted derivative is required.

Any source-comment cleanup must follow the untouched baseline reproduction.
No accepted theorem, proof, or definition needs changing.

## Reproduction boundary

The auditor re-elaborated all four release modules and 100 contracts using
the pinned runtime and third-party cache. The cache was extended by the same
four modules at the same revision. This is not a full Mathlib source rebuild.
All 115 export axiom reports and source-hash maps match the submitted evidence;
28 verification commands and 15 gate cases pass. The separate missing-module
control is an intentional rejection, not a failed audit.

Audit acceptance concerns the attached archive bytes identified by their hash.
No remote publication state, working-tree claim, or Git ancestry was independently
authenticated, and the audit did not push, retag, or modify release source.
