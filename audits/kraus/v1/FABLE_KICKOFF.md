# Cursor kickoff: explicit two-state convergence

Copy the prompt below into Fable after placing the Kraus audit return at the
repository root. The return contains the exact issued assignment under
`audits/kraus/v1/`.

```text
Please integrate the Kraus audit return using its RETURN_README.md. Verify the
archive's exact payload against audits/kraus/v1/RETURN_MANIFEST.json, preserve
repository-relative paths, and keep the frozen issued task at
audits/kraus/v1/NEXT_FABLE_TASK.md. Activate its editable copy as the root
NEXT_FABLE_TASK.md.

The Kraus milestone at 6431c9cd411a3a804d2a86ae733e23f393fe9361,
tag kraus-milestone-v1, is accepted with no proof-repair round. Record acceptance
and the three minor prose clarifications in D015 and current project status,
without rewriting historical decisions or handoffs. Preserve accepted tags.
Reproduce the untouched 158-export / 139-contract baseline before editing any
accepted Lean or contract source.

Implement the complete convergence milestone in NEXT_FABLE_TASK.md. Define and
identify the exact Frobenius norm, prove the centered entry formulas and exact
squared error split, prove the exp(-(a+b)*t/2) estimate for every complex matrix
relative to (trace X) times rhoStar, and prove both the norm-error limit and the
matrix-valued limit. The algebraic bound needs only a+b>0 and t>=0, not PSD or
individual-rate nonnegativity. Add trace-one and equal-trace pair consumers, plus an explicit
physical density consumer of the accepted Kraus result. Cover both one-zero
rate limits, equal positive rates, and the absence of a common attractor at
both-zero rates. Keep the sharp coherence witness optional and bounded.

Keep pinned dependencies, the accepted flow and stationary state, proof trust,
and existing APIs. Use the exact named norm for constants and canonical matrix
topology for Tendsto; do not create a norm-equivalence detour. Do not begin a
general gap theorem, Perron-Frobenius, Hamiltonian extension, or another branch.

Run both verification scripts, retain full raw evidence and the missing-module
control fixture, and package the exact tested source according to AGENTS.md.
You commit and tag; I will push. Do not stop at a plan. Stop for audit after the
milestone is complete, and follow the no-em-dash documentation convention.
```
