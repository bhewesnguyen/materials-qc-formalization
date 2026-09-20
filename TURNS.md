# Turn index

One row per implementation or audit round, oldest first. The milestone key
joins `evidence/<key>/`, `deliverables/<key>/v<k>/`, `audits/<key>/v<k>/`,
and the tag `<key>-milestone-v<k>`. Commit hashes are obtained with
`git rev-parse <tag>`; they are not written here because the commit contains
this file. The handoff layout and sequence are specified in AGENTS.md.

| Round | Milestone | Version | Tag | Implementer handoff | Auditor report | Date | Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | stage0 | v1 | none; delivered as an archive before this repository existed, content imported as commit `cd7e6c6` | built by the auditor; see `audits/stage0/v1/` | `audits/stage0/v1/Formal_Science_Stage0_Audit.md` | 2026-09-20 | Accepted. Hand to implementation for the finite dissipator algebra. |
| 1 | dissipator | v1 | `dissipator-milestone-v1` | `deliverables/dissipator/v1/HANDOFF.md` | `audits/dissipator/v1/` (pending) | 2026-09-20 | Pending independent audit. |
