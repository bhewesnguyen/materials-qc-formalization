# Turn index

One row per implementation or audit round, oldest first. The milestone key
joins `evidence/<key>/v<k>/`, `deliverables/<key>/v<k>/`, `audits/<key>/v<k>/`,
and the tag `<key>-milestone-v<k>`; the two pre-versioning evidence paths
`evidence/stage0/` and `evidence/dissipator/` are frozen exceptions. A tagged
commit is `git rev-parse <tag>^{commit}`. Historical hashes are recorded in
the table; the hash of the round currently being packaged is added by its
post-tag receipt commit. The handoff layout and sequence are specified in
AGENTS.md.

| Round | Milestone | Version | Tag | Implementer handoff | Auditor report | Date | Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | stage0 | v1 | none; delivered as an archive before this repository existed, content imported as commit `cd7e6c6` | built by the auditor; see `audits/stage0/v1/` | `audits/stage0/v1/Formal_Science_Stage0_Audit.md` | 2026-09-20 | Accepted. Hand to implementation for the finite dissipator algebra. |
| 1 | dissipator | v1 | `dissipator-milestone-v1` at commit `be2ad90088b3c407d2aa18aafe3a2e806db35011` | `deliverables/dissipator/v1/HANDOFF.md` | `audits/dissipator/v1/Formal_Science_Dissipator_Audit_v1.md` | 2026-09-20 | Accepted. No proof revision. Four low-severity process findings F1 to F4, closed in the round 2 housekeeping commit (D008 and D009). Next milestone: stationary. |
| 2 | stationary | v1 | `stationary-milestone-v1` at commit `a5347ca77a2b5e6678f514decb0ab4eee7b62943` (receipt `deliverables/stationary/v1/RECEIPT.json`) | `deliverables/stationary/v1/HANDOFF.md` | `audits/stationary/v1/Formal_Science_Stationary_Audit_v1.md` | 2026-09-20 | Accepted. No proof revision. Three low-severity record and wording findings S1 to S3, closed in the round 3 housekeeping commit (D011). Next milestone: evolution. |
| 3 | evolution | v1 | `evolution-milestone-v1` at commit `a60a92b6064b4dde33a98d3c79be195c77595873` (receipt `deliverables/evolution/v1/RECEIPT.json`) | `deliverables/evolution/v1/HANDOFF.md` | `audits/evolution/v1/Formal_Science_Evolution_Audit_v1.md` | 2026-09-21 | Accepted. No proof revision. Two low-severity documentation findings E1 and E2, closed in the round 4 housekeeping commit (D013). Next milestone: kraus. |
| 4 | kraus | v1 | `kraus-milestone-v1` at commit `6431c9cd411a3a804d2a86ae733e23f393fe9361` (receipt `deliverables/kraus/v1/RECEIPT.json`) | `deliverables/kraus/v1/HANDOFF.md` | `audits/kraus/v1/Formal_Science_Kraus_Audit_v1.md` | 2026-09-21 | Accepted. No proof revision and no findings; three optional prose cleanups recorded in D015. Next milestone: convergence. |
| 5 | convergence | v1 | `convergence-milestone-v1` at commit `a3cbac0692b4c106a89e80c91d18b0c2de4988cd` (receipt `deliverables/convergence/v1/RECEIPT.json`) | `deliverables/convergence/v1/HANDOFF.md` | `audits/convergence/v1/Formal_Science_Convergence_Audit_v1.md` | 2026-09-21 | Accepted. No proof revision; C1 and C2 (low, documentation) recorded in D017. Completes the two-state pilot. Next milestone: markov (Stage 4). |
| 6 | markov | v1 | `markov-milestone-v1` | `deliverables/markov/v1/HANDOFF.md` | `audits/markov/v1/` (pending) | 2026-09-21 | Pending independent audit. |
