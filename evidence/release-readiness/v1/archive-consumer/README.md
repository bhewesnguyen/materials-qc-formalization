# Archive-consumer reproduction

What a recipient of `Formal_Science_Release_Readiness_Handoff.zip` gets, checked
by doing it. Input archive SHA-256 `e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0`
(3553183 bytes). Extracted into a fresh temporary directory
(`/tmp/fs-consumer/formal-science`) with no `.lake` directory and no copied project
build output; all 3118 extracted files match the archived
`SOURCE_MANIFEST.json` (`extraction_check.json`).

## Commands, in order, from the extracted package

1. `lake exe cache get` with the nine modules named in the README. Exit 0,
   real	1m35.230s; user	1m0.862s; sys	0m24.370s. This cloned all nine dependencies at
   their locked revisions over the network and decompressed 2435 pinned Mathlib
   build artifacts into the extraction. Dependency mode, stated plainly: the
   compressed artifacts were served from this machine's local Mathlib cache
   store (`/home/jett/.cache/mathlib`), populated in earlier rounds, so the tool reported
   "No files to download". A machine without that store downloads the same
   artifacts from the Mathlib cache server. This is fresh local-source
   re-elaboration against pinned compiled dependencies, not a full Mathlib
   source rebuild.
2. `python3 scripts/verify.py --output-dir .../archive-consumer/verification`. Exit 0:
   status `passed`, 32 commands all exit 0, 8 release modules, 216 exports,
   193 contract exports, every export on exactly `propext`, `Classical.choice`,
   `Quot.sound`, all nine dependency pins exact and clean.
3. `python3 scripts/test_verify.py --output-dir .../archive-consumer/gate-tests`. Exit 0:
   15 cases passed.
4. `lake env lean examples/Usage.lean`. Exit 0, empty stdout and stderr.

The source hashes and axiom map recorded from the extraction are identical to
the working-tree candidate verification (`environment.json`,
`matches_working_tree_candidate_verification`). Raw logs: `01-*` to `04-*`,
`verification/`, `gate-tests/`. The toolchain was the elan-managed
`leanprover/lean4:v4.34.0` selected by the archived `lean-toolchain`, already
installed on this machine.
