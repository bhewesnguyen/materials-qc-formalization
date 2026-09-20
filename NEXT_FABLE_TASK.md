# Fable implementation turn 1: finite dissipator algebra

> Status (20 September 2026): implemented in
> `FormalScience/OpenSystems/Dissipator.lean` and handed off in
> `deliverables/dissipator/v1/HANDOFF.md`. The assignment text below is preserved as
> written for the auditor to compare against. Do not start a further
> milestone until the audit selects one.

The project now has a Stage 0 source baseline. Read README.md, AGENTS.md,
DECISIONS.md, and the accompanying Stage 0 audit report before changing code.

## First reproduce

Run the pinned setup and both validation scripts on the user's Ubuntu/Cursor
environment. Preserve the existing evidence and place new logs in the default
latest directories. If reproduction fails, report exact diagnostics before
changing dependencies or theorem contracts.

## Then implement this bounded milestone

Use complex finite matrices, initially the existing qubit representation.
Create one clearly named module under `FormalScience/OpenSystems/` for the
dissipator

```text
D[V](X) = V X V* - (V* V X + X V* V)/2.
```

State scalar multiplication by `(1/2 : ℂ)` explicitly. Reuse Mathlib matrix
units and adjoint identities rather than adding a second matrix representation.

Required results:

1. Additivity and complex homogeneity in X, or a bundled complex-linear map
   with the same defining formula. Pick the simplest representation that will
   support the upcoming weighted two-jump generator.
2. `trace(D[V](X)) = 0` for every V and X. Do not require X to be a density.
3. If X is Hermitian, then D[V](X) is Hermitian, for every V.
4. Show the basis-jump specializations V=E_10 and V=E_01 consume these results.
   Supply any needed matrix-unit multiplication/adjoint lemmas by direct reuse
   or a thin checked adapter.

Forbidden assumption: do not require V itself to be Hermitian or unitary.
The jump matrices E_10 and E_01 are neither. Do not claim that D[V] is a
positive or completely positive map.

## Preserve the contracts

Keep the existing ten theorem signatures and density semantics. Add new
release modules and declarations to exports.json, imports to FormalScience.lean,
and direct consumer signatures to Audit/Contracts.lean. Audit definitions as
well as theorems. Use only the accepted foundational axioms.

Do not silently replace the validation scripts, suppress a failing check, or
weaken a conclusion to obtain a passing build. Explain proposed API changes
in DECISIONS.md and the handoff.

## Stop boundary

Do not yet implement the full stationary-state system, generic GKSL,
Perron-Frobenius, time evolution, convergence, entropy, circuit syntax, or OR.
Do not assume a new module belongs in Mathlib merely because it compiles.

Return the source diff or complete source archive, dependency pins, updated
export/contracts files, full verification and self-test output, exact new
statements, scope changes, and unresolved questions. The next turn is an
independent audit before selecting the stationary-state milestone.
