# Kraus v1 audit return

Decision: **accepted** at source commit
`6431c9cd411a3a804d2a86ae733e23f393fe9361`, tag `kraus-milestone-v1`.
No proof revision round is needed. The next milestone is `convergence`:
an explicit Frobenius error estimate and long-time matrix limit for the
accepted two-state evolution.

## Integrate with paths preserved

All ZIP paths are repository-relative and lie under `audits/kraus/v1/`.
The return includes no replacement release source, dependency cache, or root
active-task file. Keep the full immutable payload, including the issued task.

1. Verify the archive against `audits/kraus/v1/RETURN_MANIFEST.json` inside it.
   Every non-directory entry except the manifest must occur exactly once with
   matching byte count and SHA-256; no extra or missing paths are allowed.
   Keys are relative to the repository/ZIP root, not the manifest's folder.
   The manifest excludes its own hash.
2. Extract to a temporary location and copy paths into the repository without
   flattening them or nesting the whole return inside its own audit folder.
   Preserve unrelated files and compare any existing destination first.
3. Keep `audits/kraus/v1/NEXT_FABLE_TASK.md` unchanged as issued. Copy it to the
   root `NEXT_FABLE_TASK.md` to activate the mutable implementation assignment.
4. Use `audits/kraus/v1/FABLE_KICKOFF.md` for Cursor. Record acceptance in
   `TURNS.md` and current project status. Reproduce the untouched 158-export /
   139-contract baseline before source edits. Implement only the issued
   convergence checkpoint, validate, commit, tag, and package. The user pushes.

E1 and E2 are closed. Preserve all accepted tags, handoffs, historical audit
returns and evidence. The three optional prose clarifications in the report
can be recorded in D015; they are not a theorem repair. Preserve historical
D014 and handoffs. If fixing the live contract-comment typo, do it after the
baseline reproduction and record the new hash.

## Contents

- `Formal_Science_Kraus_Audit_v1.pdf` and `.md`: verdict, semantic review,
  reproduction, trust boundary, optional prose clarifications and next scope.
- `AUDIT_RECEIPT.json`: exact input identity, verdict, counts and next task.
- `PORTFOLIO_STATUS.md`: five accepted increments and all 39 inventory rows,
  preserving the recorded 1/28/10 classification.
- `NEXT_FABLE_TASK.md`: exact frozen convergence assignment, including trace
  scaling, named norm, squared-energy rates, limits and physical boundaries.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `evidence/`: fresh verification/gate output, two omission controls with
  retained fixtures, source hashes, package preservation, environment and
  input receipt. Logs with deliberate failures are expected negative tests.
- `reference/ConvergenceApiProbe.lean`: optional, compiled norm/scalar-limit
  feasibility source. It is outside the accepted release and does not prove
  the pending evolution convergence endpoint. Its execution and axiom output
  are under `evidence/convergence-api-probe/`.
- `RETURN_MANIFEST.json`: exact immutable payload inventory.

Standalone downloads use milestone-specific filenames; canonical names inside
this ZIP follow the agreed repository layout.

## Reproduction boundary

The auditor freshly elaborated all six release modules and 139 direct theorem
contracts using the exact pinned runtime and previously acquired third-party
cache. No cache extension was needed. This is not a full Mathlib source rebuild.
All 158 axiom reports use exactly the accepted three axioms. Source-hash and
axiom maps match the submitted evidence. All 30 verification commands and 15
gate cases pass; both omitted-module controls fail as intended.

The package identity is checked against the supplied archive bytes, pointer,
receipt and ZIP comment. No remote tag, publication state, working-tree claim
or Git ancestry was authenticated. The audit did not push, retag or modify
release source.
