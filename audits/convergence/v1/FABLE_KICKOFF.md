# Fable kickoff: finite Markov generator bridge

Copy and paste the following into Cursor after placing the convergence audit
return ZIP at the repository root.

```text
The convergence milestone is accepted at a3cbac0692b4c106a89e80c91d18b0c2de4988cd, tag convergence-milestone-v1. Implement the next bounded markov milestone from the attached audit return.

Read AGENTS.md and the return README. First verify the return's exact payload against its manifest, including paths, sizes, and SHA-256 hashes. Integrate its repository-relative paths without flattening or nesting them inside a second audit directory. Preserve the issued task at audits/convergence/v1/NEXT_FABLE_TASK.md, and activate a copy at root NEXT_FABLE_TASK.md. Record acceptance and the planned C1/C2 corrections; apply source-comment corrections only after baseline reproduction. The personal scope memo is context only; do not modify or commit it.

Reproduce the accepted 187-export / 167-contract baseline with both verification scripts before editing accepted Lean source or contracts. Preserve the fresh evidence and accepted source hashes. Then implement the active assignment in FormalScience/OpenSystems/FiniteMarkovBridge.lean, keeping the existing Lean and Mathlib pins.

The bounded goal is the H=0 finite Markov generator bridge: destination-first real rates q i j for j-to-i jumps, ignored diagonal q entries, zero-column-sum classical Q, the explicit dissipator sum, population and coherence entry formulas, trace/Hermiticity, the real-vector diagonal intertwiner and stationary iff, probability-to-density consumers, and recovery of the accepted two-state generator. Keep physical nonnegativity off algebraic helpers. Do not construct a general semigroup, matrix exponential, CPTP theorem, stationary uniqueness or convergence theory, or Hamiltonian extension.

Read and execute the full active task, including its source-overlap search, dependency budget, independent contracts, manual declaration coverage review, gate controls, and packaging protocol. Do not stop after planning. Resolve routine implementation details autonomously, and record any proposed theorem change instead of silently weakening the task. No implementation needs to change merely to repair the two accepted documentation findings.

Finish source, evidence, and docs; verify the tested tree; commit and tag markov-milestone-v1; derive and path-by-path verify the handoff archive; record its actual digest and source commit in an external post-tag receipt. Preserve all accepted tags and audit records. You commit and tag; I push. Stop at the audit boundary and return the package, exact source commit, full digest, evidence, and any unresolved issue.
```
