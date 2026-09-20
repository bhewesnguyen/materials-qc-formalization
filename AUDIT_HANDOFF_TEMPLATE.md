# Stage audit handoff

## Scope

- Stage and accepted contract IDs:
- Commit under review:
- What is complete:
- What is explicitly incomplete:

## Reproduction

- OS and architecture:
- Lean toolchain:
- Lake version:
- Mathlib commit:
- Other dependency commits and licenses:
- Exact clean-build commands and exit codes:
- Release module/export manifest:
- Raw log paths:

## Statement review

For each exported theorem:

- Exact declaration and source path:
- Informal mathematical statement:
- Fully elaborated Lean type:
- Definitions and conventions:
- All assumptions:
- Nontrivial witness / boundary cases:
- Existing source matched or extended:
- Any difference from the accepted contract:
- Downstream use:

## Trust evidence

- Transitive axiom output for every exported theorem:
- Standard foundational axioms accepted:
- Forbidden/custom/native assumptions detected:
- Every release module actually compiled:
- Validation gate fixture results, if the harness was introduced:
- Semantic review decision:

## Blockers and next step

- Exact unresolved goal or API problem:
- Approaches already tried:
- Proposed bounded next task:
- Changes requiring a contract decision:
- Suggested reviewer focus:

Do not substitute a theorem count, grep result, screenshot, or successful compilation of one umbrella file with incomplete imports for the evidence above.
