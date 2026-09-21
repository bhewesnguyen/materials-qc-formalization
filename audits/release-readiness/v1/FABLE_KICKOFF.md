# Fable kickoff: record acceptance and close release readiness

Copy and paste the following into Cursor after placing the audit-return ZIP at the repository root.

```text
The independent release-readiness v1 audit return is at the repository root. Complete its bounded audit-integration/closure assignment now.

Read AGENTS.md, then safely inspect and verify the return against audits/release-readiness/v1/RETURN_MANIFEST.json: CRC, safe paths, exact payload set, byte counts, and SHA-256. Integrate it with repository-relative paths preserved. Read its audit, RETURN_README.md, and NEXT_FABLE_TASK.md. Keep the returned payload immutable and follow that issued task.

The accepted source is 2a258df6654d1b3553d3affebd7e94405bb4e989, tag release-readiness-milestone-v1. Record acceptance and any concrete nonblocking documentation corrections in live project records. Keep all accepted Lean source, contracts, exports, scripts, pins, package version, and examples/Usage.lean byte-identical. The counts remain 8 modules, 216 exports, 193 theorem contracts, and 23 definitions: seven mathematical increments plus one release-readiness checkpoint.

This is one ordinary integration commit, not a new implementation round. Verify the returned payload and the frozen-source comparison, refresh the current SOURCE_MANIFEST.json using the existing staged-byte protocol, and commit. Do not rerun unchanged proof gates merely for status edits. Do not generate another tag or archive. The user pushes.

Finish with root NEXT_FABLE_TASK.md stating that the accepted checkpoint is integrated and no new mathematical implementation is active, with a pointer to the immutable closure assignment. Preserve the distinction between candidate acceptance and human review, publication, or upstream acceptance. Do not publish, contact maintainers, or choose a new research branch. Return the integration commit, checks, unchanged counts, and any actual blocker; otherwise stop at the completed checkpoint. Use no em dashes.
```
