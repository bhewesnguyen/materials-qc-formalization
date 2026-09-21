# Derivative API probe

The direct consumer `TopologyConsumer.lean` imports the accepted evolution module
and applies both public matrix derivative theorems without enabling any local
matrix norm instances or norm scope. It compiles with exit code 0; the exact
command, source hash, and empty output streams are recorded in `invocation.json`.

At the pinned Mathlib revision 5ed2965256430c3649e86755f9576b54eca72435,
`Mathlib/Analysis/Calculus/Deriv/Basic.lean` defines `HasDerivAt` in its TVS
section with target additive group, module, topology, and continuous scalar
multiplication. It has no target norm argument. The exported explicit signature
in `verification/27-export-signatures.stdout.log` uses `instTopologicalSpaceMatrix`.
The supplied local Matrix norm structures are ordinary compatible structures and
do not add an axiom or restrict the theorem to a new physical assumption.

The accepted theorem gives the derivative in the canonical matrix product topology.
The proof's use of sup-norm/Pi infrastructure is harmless. This probe corrects the
narrative requirement in D012; it does not request a norm-independence theorem or
change any accepted Lean source. Quantitative convergence remains a later task
with an explicitly named norm.
