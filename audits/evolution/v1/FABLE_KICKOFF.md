# Cursor kickoff: finite Kraus milestone

Copy the prompt below into Fable after placing the evolution audit return at
the repository root and extracting its repository-relative paths.

```text
Please integrate the evolution audit return using its RETURN_README.md and
verify the supplied paths against RETURN_MANIFEST.json. Preserve its frozen
issued task under audits/evolution/v1/NEXT_FABLE_TASK.md, then activate the
same task in the root NEXT_FABLE_TASK.md.

The evolution milestone at a60a92b6064b4dde33a98d3c79be195c77595873,
tag evolution-milestone-v1, is accepted. Record acceptance and the E1/E2
documentation errata in current project records and D013 without rewriting
historical handoffs. Reproduce the untouched 115-export / 100-contract baseline
before any accepted Lean source comment change.

Implement the full new kraus milestone in NEXT_FABLE_TASK.md: the exact four
Kraus operators for the existing two-state evolution, completeness, equality
on every complex matrix, positivity and density preservation, and the genuine
all-finite-ancilla PSD theorem using the independently defined blockwise
amplifier. Cover both-zero rates, both one-zero-rate directions, and time zero.
Keep a,b,t >= 0 as the physical certification domain; do not add a positive
total-rate premise or change the earlier signed-rate evolution.

Use the existing pinned dependencies and finite-matrix APIs. Do not start
convergence, norm contraction, Choi/Stinespring equivalence, or another branch.
Preserve accepted APIs, proof sources, tags, and evidence. Run both verification
scripts, keep full raw evidence and a missing-module control fixture, and
package the exact tested source according to AGENTS.md. You commit and tag;
I will push. Do not stop at a plan, and stop for audit once this milestone is
complete. Follow the no-em-dash documentation convention.
```
