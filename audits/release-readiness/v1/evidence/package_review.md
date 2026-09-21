# Independent package and evidence review: release-readiness v1

Decision: no blocking or nonblocking package finding. The submitted source and companion archives satisfy the issued two-artifact handoff protocol. Fresh Lean execution belongs to the root auditor's separate verification, rather than being inferred from Fable's logs.

## Exact archive identity and path integrity

The source ZIP is 3,553,183 bytes with SHA-256 `e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0`. Its ZIP comment is the submitted source commit `2a258df6654d1b3553d3affebd7e94405bb4e989`. It has 3,118 manifest payloads plus `SOURCE_MANIFEST.json`, hence 3,119 actual regular files. Every manifest path, byte length, and SHA-256 matches; no missing or extra path, duplicate, symlink, unsafe path, nested archive, or CRC error was found.

The companion ZIP is 142,213 bytes with SHA-256 `7c6bca2065fb4c0068ef2d1265b97197d09dbedd0173e33f34983f2442d35553`. Its 115 manifest payloads plus its manifest give 116 actual files. All exact-set and integrity checks pass. Its paths are repository-relative. Loose HANDOFF, POINTER, source RECEIPT, and consumer manifest attachments are byte-identical to their corresponding packaged copies.

Receipt separation is correct. The immutable source archive does not contain its own post-tag receipt or consumer evidence. The companion contains the source receipt and source digest, but does not contain `COMPANION_RECEIPT.json` or its own digest. The external companion receipt matches both archive identities. The source commit is supported by the ZIP comment and receipt; this artifact audit does not verify the remote Git branch or tags.

## Freeze against the actual prior accepted package

This review compares actual local extracted source bytes against the accepted Markov package, not merely Fable's stated hashes. All 16 frozen files are identical: eight release modules, the umbrella, contracts, exports, both gate scripts, toolchain, lakefile, and lockfile. Package version and dependency pins are unchanged. The candidate adds three anonymous examples in `examples/Usage.lean`, outside the release namespace and export list.

The archived Markov manifest has 2,609 payloads. None disappeared. Of those existing payloads, only the six intended live documentation records changed: `AGENTS.md`, `DECISIONS.md`, `NEXT_FABLE_TASK.md`, `README.md`, `TURNS.md`, and `docs/SCOPE_MEMO.md`. The regenerated source manifest itself is necessarily different and excluded from this old-payload count. There are 509 added payload paths.

All 1,591 earlier evidence payloads, 975 earlier audit payloads, and 16 earlier handoff/receipt payloads are byte-identical to the actual accepted Markov extraction. The newly integrated Markov audit return matches the auditor's actual output in all 207 payloads plus its manifest, 208 files total. Its frozen issued assignment is intact. This comparison uses archived manifest paths, deliberately excluding incidental local `__pycache__` output created when the earlier extraction was inspected.

## Submitted evidence cross-check

Three complete supplied evidence sets were checked independently: untouched baseline, candidate final, and companion archive-consumer. For each set:

- `verification.json` and `commands.json` have the same 32 command records, with every exit code zero.
- Every embedded stdout/stderr string matches its separate raw log byte content as decoded text.
- Every recorded source hash matches both the submitted candidate bytes and the accepted Markov hash map.
- Raw axiom diagnostics were reparsed independently, including multiline axiom lists. Exactly 216 unique reports match the JSON axiom map and the accepted Markov map. Each uses exactly `Classical.choice`, `Quot.sound`, and `propext`.
- Eight release-source re-elaborations and the contract re-elaboration have empty stdout and stderr.
- All nine dependency entries report the locked revision as HEAD and a clean tracked tree.
- The manifest remains eight modules, 216 exports, and 193 distinct contract exports.

Each supplied gate-test set has 15 passing cases and nine subprocess records, with the expected rejected fixtures distinguished from unexpected test failure. The raw logs agree with the command records. The two additional negative controls retain byte-identical Markov fixtures and fail before a project build with the intended module-coverage and unmentioned-contract errors. Their dependency inspection commands succeed first; “before any build” does not mean “before all subprocesses.”

The Markov manual inventory file is unchanged and hashes to the value cited in `inventory_linkage.json`. Its source/contract linkage matches the actual frozen files: 216 public declarations, 193 public theorems, 23 definitions/abbreviations, seven private helpers, no unlisted public declaration, and no missing theorem consumer. Reuse is sound here precisely because all relevant source and list bytes are frozen. This remains a manual source-review inventory aid, not a new guarantee that the verifier discovers declarations omitted from both lists.

The first baseline verification ran at 17:25:55Z to 17:26:22Z, its gate tests completed at 17:26:28Z, usage compilation was recorded at 17:28:15Z, and final verification ran at 17:33:15Z to 17:33:41Z. This is internally consistent with baseline-first execution. The artifact cannot independently reconstruct unshipped Git history or prove how an implementer edited files before recording them; that limitation does not affect the byte comparison or the fresh auditor rerun.

## Recipient-consumer claim

The companion identifies the exact delivered source archive and reports extraction without `.lake` or copied project build products. Its raw cache log shows all nine dependencies cloned and checked out at the named locked revisions. It shows 2,435 files decompressed and 74 already decompressed, consistent with the existing 2,509-artifact targeted closure. It explicitly prints “No files to download,” as expected from the disclosed reuse of the workstation's compressed Mathlib cache. The 95.230-second setup timing is retained.

All four top-level consumer exit-code files are zero: cache setup, verification, gate tests, and example compilation. The fresh consumer verification records the `/tmp/fs-consumer/formal-science` working directory, the accepted source hashes and axiom map, and a project build. The usage stdout and stderr are empty. The dependency-mode description is accurate: fresh project-source elaboration against reused pinned compiled dependencies, not a clean-network cache download or full Mathlib source rebuild. No stronger reproducibility claim is needed for the issued task.

## Result and limits

The package supplies concrete, mutually consistent evidence for the exact immutable candidate and its recipient check. No archival correction, source revision, verifier change, or mathematical API expansion is needed. The root auditor should combine this result with the independent execution and documentation/provenance review before announcing the candidate decision. Acceptance of this candidate does not mean publication, human semantic review, remote push, novel mathematics, or upstream acceptance occurred.

Machine-readable checks: `package_checks.json`. Reproducible artifact-inspection script: `check_package.py`.
