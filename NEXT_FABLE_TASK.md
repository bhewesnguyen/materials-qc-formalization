# Active assignment: two-state stationary pilot

> Status (20 September 2026): implemented in
> `FormalScience/OpenSystems/TwoStateStationary.lean` and handed off in
> `deliverables/stationary/v1/HANDOFF.md`. The assignment text below is
> preserved as received from the dissipator audit for the auditor to compare
> against. Do not start a further milestone until the audit selects one.

Milestone key: `stationary`. First implementation round: `v1`.

This assignment follows the accepted finite dissipator milestone at submitted
commit `be2ad90088b3c407d2aa18aafe3a2e806db35011`. It selects the next
mathematical milestone only. No stationary-state proof is claimed by this
specification. Keep the pinned Lean 4.34.0 / Mathlib base.

## First record the audit and close the small process findings

1. Store the returned audit files as received under `audits/dissipator/v1/`.
   Record the accepted dissipator decision in `TURNS.md`. Keep the v1
   submission, tag, and evidence immutable. Replace the root active assignment
   with this file; do not create a competing second active task document.
2. Correct the handoff sequence in `AGENTS.md` and D008: finish source,
   evidence, and docs; stage intended files; generate the manifest over the
   intended staged path set and its final bytes, excluding the manifest;
   stage the manifest; confirm packaged working/staged bytes agree; commit;
   tag; create `git archive` from that tag; verify archive paths, byte counts,
   and hashes; stop. Replace the assertion that matching is automatic with
   the requirement to verify the completed archive. The implementer commits
   and tags; the user pushes. Do not retag the accepted dissipator snapshot.
3. Version new evidence paths by milestone and round. For this task use
   `evidence/stationary/v1/`, with separate `reproduction/`, `verification/`,
   `gate-tests/`, and environment information. Later rounds use new paths.
   Preserve `evidence/stage0/` and `evidence/dissipator/` exactly as received.
4. Acknowledge the explanatory erratum in the audit: `basisProjector_zero_ne_one`
   distinguishes E_00 from E_11, not E_00 from the identity. Non-unitarity of
   the jumps is nevertheless true, by inspecting the other diagonal entry
   of their adjoint products. No new theorem or rewrite of the historical
   handoff is required.
5. Correct future dependency-license summaries: the pinned `Cli` package
   has a top-level MIT license, while the other eight pinned packages have
   top-level Apache 2.0 licenses. The v1 handoff's blanket Apache 2.0 claim
   is inaccurate. Record this audit correction without rewriting the
   historical handoff. No dependency or proof change is needed.

Read `README.md`, `AGENTS.md`, `DECISIONS.md`, the returned dissipator audit,
`AUDIT_HANDOFF_TEMPLATE.md`, and this assignment. The portfolio roadmap is
context; its old kickoff instructions do not override the active assignment.

## Reproduce before extending

Reproduce the accepted 42-export baseline using the README setup and both
verification scripts. Save fresh logs under this round's reproduction path.
Preserve all previous theorem signatures and the current density semantics.
If reproduction fails, report the exact failure and resolve ordinary local
setup issues without changing dependency pins, theorem contracts, or the
accepted axiom policy to obtain a passing result.

## Mathematical scope and conventions

Use one new module, for example
`FormalScience/OpenSystems/TwoStateStationary.lean`. Reuse the existing
qubit matrices, basis projectors, diagonal states, and dissipator laws.
Avoid representation changes and unrelated namespace reorganizations.

- Basis order is 0,1; the Hamiltonian is zero.
- Real rate `a` carries the jump `jumpZeroToOne = E_10`.
- Real rate `b` carries the jump `jumpOneToZero = E_01`.
- `gamma` abbreviates `a+b`; it is not an unrelated free parameter.
- `diagonalState q = diag(1-q,q)` uses the population of state 1.

Define the weighted generator as a complex-linear map using
`dissipatorLinearMap`, or as one explicit function with a thin bundled form:

```text
L[a,b](X) = (a : Complex) *scalar D[E_10](X)
         + (b : Complex) *scalar D[E_01](X).
```

Here `*scalar` means Lean scalar multiplication. Keep a direct formula
theorem exposing the exact weighted expression. Do not absorb rates into
square roots of jump matrices in this milestone.

## Required generator contracts

For arbitrary real `a,b` and arbitrary complex qubit matrix `X`, prove:

```text
L[a,b](X)[0,0] = -(a : Complex) * X[0,0] + (b : Complex) * X[1,1]
L[a,b](X)[1,1] =  (a : Complex) * X[0,0] - (b : Complex) * X[1,1]
L[a,b](X)[0,1] = -(((a+b : Real) : Complex) / 2) * X[0,1]
L[a,b](X)[1,0] = -(((a+b : Real) : Complex) / 2) * X[1,0]
trace(L[a,b](X)) = 0
```

Also prove Hermiticity preservation with only the hypothesis that `X` is
Hermitian. Reuse the dissipator trace and Hermiticity theorems, and derive
the component identities from its existing jump closed forms where practical.
The rates are real, so their casts are self-adjoint; nonnegativity is not
required for these algebraic results. Complex linearity can be supplied by
the bundled map; duplicate linearity wrappers are optional.

## Required stationary contracts

Define the transparent candidate:

```text
rhoStar(a,b) := diagonalState (a/(a+b)).
```

Public Lean names are your choice; record their mapping to these contracts.
Under only `a+b != 0`, prove the explicit diagonal presentation
`diag(b/(a+b),a/(a+b))`, stationarity, and the stronger algebraic uniqueness
statement:

```text
trace(X) = 1 -> (L[a,b](X) = 0 <-> X = rhoStar(a,b)).
```

Here `X` is any complex qubit matrix. Do not assume it is diagonal,
Hermitian, or positive semidefinite. The off-diagonal component equations
must force its coherences to vanish. The diagonal balance equation and
trace one then determine both diagonal entries.

For the physical hypotheses `0 <= a`, `0 <= b`, `0 < a+b`, prove:

```text
IsDensity (rhoStar(a,b))
L[a,b](rhoStar(a,b)) = 0
IsDensity rho -> (L[a,b](rho) = 0 <-> rho = rhoStar(a,b))
exists exactly one rho such that IsDensity rho and L[a,b](rho) = 0
```

The existence/uniqueness endpoint should be a direct consequence of the
candidate's density validity and algebraic uniqueness. Use
`diagonalState_isDensity` after proving `0 <= a/(a+b) <= 1`. Keep
nonnegative rates on the density theorem, not on every algebraic helper.

Lean's division is total, so the candidate definition has a value even when
`a+b=0`. Its name does not prove the displayed diagonal-ratio identity or
unique stationarity at that point. Keep the necessary hypotheses explicit.

## Required boundary cases

1. `a=0`, `b>0`: the candidate is `basisProjector 0`; specialize the general
   uniqueness endpoint to identify the unique stationary density.
2. `a>0`, `b=0`: the candidate is `basisProjector 1`; specialize uniqueness.
3. `a=b=0`: the generator is zero on every matrix. Every density is
   stationary. Use the existing two distinct basis densities to prove that
   the unique-existence statement is false.
4. `a=b=r`, `r>0`: the candidate is `diagonalState (1/2)` and the general
   uniqueness theorem applies. Do not introduce an `a != b` premise.

For signed rates, `a+b=0` need not mean both rates vanish. For example,
`a=1,b=-1` gives `L(X)[0,0]=-trace(X)`, hence no trace-one stationary
matrix. Record this as a specification warning; a formal theorem about
signed cancellation is not required.

## Validation and handoff

Keep every existing export and consumer contract. Add the new module to the
umbrella and `exports.json`; list every new public definition and theorem.
Add direct consumer signatures for every new public theorem in
`Audit/Contracts.lean`. Expose the weighted formula, explicit entries,
Mathlib PSD and trace conditions, and exact rate hypotheses. At least one
consumer must apply uniqueness to an arbitrary trace-one matrix.

Run both validation scripts against the final source. Preserve deliberately
invalid fixtures. Accept only `propext`, `Classical.choice`, and `Quot.sound`,
or a subset. No `sorry`, `admit`, custom axioms, weakened statements, or
validation bypasses. If adding a new gate control, save its input fixture
alongside its output. No new validation framework is requested.

Fill `deliverables/stationary/v1/HANDOFF.md`, record its pointer and the
versioned evidence paths, refresh the source manifest, and package the exact
tested source. Use tag `stationary-milestone-v1`. Verify the completed ZIP.
Record a concrete archive SHA-256 and `git rev-parse <tag>^{commit}` in an
external receipt or the delivery message after packaging; do not attempt to
embed a containing archive's hash inside itself.

Return the handoff, source archive, full digest, exact commit, raw evidence,
statement mapping, deviations, and remaining blockers. Use no em dashes in
documentation or code comments. Execute the bounded task without routine
confirmation, and stop for the next audit when it is complete.

## Stop boundary

This milestone ends at stationary density existence, uniqueness, and the
specified boundary cases. Do not implement dynamics, matrix exponentials,
semigroups, derivatives, convergence, norm estimates, channels, complete
positivity, generic GKSL, the Markov bridge, entropy, circuits, or OR.

A full kernel classification, positive definiteness/faithfulness theorem,
rank-one theorem, and square-root jump representation are optional future
refinements, not requirements for this turn. In particular, faithfulness
must not become a premise for uniqueness: the one-zero-rate states are
included in the required result.
