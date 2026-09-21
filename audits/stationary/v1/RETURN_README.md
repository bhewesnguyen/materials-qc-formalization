# Stationary v1 audit return

Decision: **accepted** at `a5347ca77a2b5e6678f514decb0ab4eee7b62943`,
tag `stationary-milestone-v1`. No proof revision is required. The next
assignment is `evolution`; the audit report explains three nonblocking
record and wording corrections to close first.

## Install without flattening paths

The ZIP uses repository-relative paths. Every file belongs under `audits/`.
It includes the stationary return at `audits/stationary/v1/` and one exact
restoration at `audits/dissipator/v1/NEXT_FABLE_TASK.md`. It does not include
Lean implementation source, a dependency cache, or a root active-task file.

1. Verify the ZIP against `audits/stationary/v1/RETURN_MANIFEST.json` inside
   it. Every non-directory entry except that manifest must have exactly one
   matching manifest path, byte length, and SHA-256. Require no missing or
   extra entries. The manifest excludes its own hash.
2. Extract into a temporary directory, then copy its `audits/` contents into
   the repository with paths preserved. Do not place this whole directory
   tree inside `audits/stationary/v1/`. If a destination already exists,
   compare it first and preserve unrelated content.
3. Preserve the issued `audits/stationary/v1/NEXT_FABLE_TASK.md` unchanged.
   Copy it to the root `NEXT_FABLE_TASK.md` to activate evolution. Later
   implementation status changes belong only in the root copy. Historical
   issued assignments record provenance and are not competing active tasks.
4. Use the prompt in `audits/stationary/v1/FABLE_KICKOFF.md`. It directs Fable
   to record acceptance, close S1-S3 in D011 and live documentation,
   reproduce the untouched accepted baseline, implement evolution, validate,
   commit, tag, and package. The user pushes.

Do not alter accepted tags, old handoffs, historical manifests, or prior
evidence. The original stationary submission and its post-tag receipt keep
their existing locations. The audit return's `evidence/` is the auditor's
independent run; new implementer evidence will use `evidence/evolution/v1/`.

## Contents

- `Formal_Science_Stationary_Audit_v1.pdf` and `.md`: acceptance, exact
  reviewed identity, mathematical findings, reproduction limits, and next scope.
- `AUDIT_RECEIPT.json`: machine-readable input identity, verdict, counts,
  findings, and next milestone.
- `PORTFOLIO_STATUS.md`: all 39 inventory rows and the 1/28/10 recorded
  evidence grouping. This is a reconciliation, not a new global search.
- `NEXT_FABLE_TASK.md`: the complete frozen evolution contract.
- `FABLE_KICKOFF.md`: copy/paste Cursor prompt.
- `evidence/`: fresh verification, gate cases, coverage-control fixture,
  environment, input integrity, and historical assignment restoration check.
- `RETURN_MANIFEST.json`: hashes of all return payloads, with paths relative
  to the repository/ZIP root, not relative to the manifest's own folder.

## Exact historical restoration

The included `audits/dissipator/v1/NEXT_FABLE_TASK.md` is the previously
issued stationary assignment, not the new evolution assignment.

```text
Bytes: 9319
SHA-256:
8c49d97f9380833fa7e53aea388308208a670911eca4b7d40c540663b15d9fe0
```

To compare the old dissipator return manifest with its archived folder,
remove the leading `audits/dissipator/v1/` from keys that have it; keep the
other keys unchanged; resolve every resulting path under that audit folder.
All 142 previously present payloads match, and the restored assignment
supplies the 143rd. The old manifest itself is excluded from those 143.
Keep that old manifest unchanged. The restoration check in the new evidence
records the mapping and the verified counts.

## Scope after acceptance

Three local milestones are accepted: Stage 0, dissipator, stationary.
The release has 72 exports and 61 theorem contracts. No full broad inventory
area has been closed by this pilot. Hall is already an identified Mathlib
reuse target; 38 areas remain in the assess/reuse/extend backlog.

Evolution is the next checkpoint. Finite Kraus/complete-positivity
certification and named-norm convergence follow in later audits. No further
authorization is needed for the ordinary reversible work in the issued
assignment; stop at its explicit handoff boundary.
