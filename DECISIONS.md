# Stage 0 architecture decisions

## D001: Mathlib-only mathematical dependency

Selected Mathlib 4.34.0 at commit
`5ed2965256430c3649e86755f9576b54eca72435`, with matching Lean 4.34.0.
This stable release supplies the matrix, trace, PSD, and complex-order APIs
needed for the bounded probe. We are not claiming it is the best version for
every future quantum-information development.

QICLean was inspected at `af5430a1bb7050b86e7520035eccfa7e1e3249d6`.
Its density predicate agrees with the selected semantics, and its finite
Kraus trace-preservation theorem is a useful comparison. It is not imported.
Its Lean/Mathlib 4.35.0-rc1 pin and additional package requirements are
unnecessary for the first probe. Those package requirements were not thereby
established as proof dependencies of its small trace theorem.

Reconsider this decision when a concrete later contract needs generic GKSL,
entropy, or another substantial API. A general reason to avoid downstream
libraries is not being asserted.

## D002: explicit, unbundled density predicate

`IsDensity ρ := ρ.PosSemidef ∧ Matrix.trace ρ = 1` for 2 by 2 complex matrices.
This adds no new mathematical positivity definition. A later bundled state can
be introduced if a concrete consumer needs it; the current probe does not
justify another broad quantum framework.

Independent contract checks use the underlying Mathlib predicate and trace
directly. Defining an easier local density predicate would not satisfy those
checks unless the original mathematical conclusions still followed.

## D003: population and basis convention

Basis order is 0,1. `diagonalState populationOne` means
`diag(1-populationOne,populationOne)`.
In the planned model `a` is 0->1 and `b` is 1->0, so the stationary candidate
is `diagonalState (a/(a+b))` under nonnegative rates and positive total rate.
The later four-Kraus formula instead uses a parameter `populationZero=b/(a+b)`.
Keep these names distinct.

## D004: trace preservation is separate from CP

The current `krausMap` is an unnormalized finite matrix sum. The trace theorem
assumes completeness explicitly and works for every matrix. No CP predicate,
channel structure, ancilla theorem, or continuous-time dynamics is defined in
the baseline. Later claims must discharge these obligations separately.

## D005: ordinary proof trust plus independent signature checks

Release declarations may use only `propext`, `Classical.choice`, and
`Quot.sound`, or a subset. The export manifest includes definitions as well as
theorems for transitive-axiom reporting. Separate consumer signatures fix the
ten theorem contracts. Missing modules, missing declarations, unexpected
axioms, and failed contracts reject the gate.

This is not malicious-code hardening. A reviewer still needs to inspect
definitions, all changes to the audit scripts, and the correspondence between
formal statements and the intended mathematics.

## D006: next milestone refined after reconnaissance

Before solving the stationary system, Fable should prove the finite dissipator
trace and Hermiticity laws, with only the matrix-unit facts they require. This
is a bounded implementation checkpoint between the initial API probe and the
stationary-state release. It does not authorize the dynamics or OR branches.

