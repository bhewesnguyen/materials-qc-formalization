# Independent Stage 0 specification and validation review

Date: 2026-09-20. Scope: review of the existing theorem contracts and initial probe, not an implementation or a build certification.

## Recommendation

Proceed with a Mathlib-only `Fin 2` complex-matrix probe. The mathematics below is sufficient to validate the selected finite-state representation and the trace route. A successful probe gives a sound starting point for Stage 1. It does not yet establish the Lindblad stationary-state pilot, complete positivity, a CPTP semigroup, or convergence.

The existing handoff properly separates source inspection, compilation, transitive axiom inspection, semantic review, and novelty. Preserve those separate statuses in the resulting report.

## Minimal mathematical surface

Use `M2 := Matrix (Fin 2) (Fin 2) ℂ` and the transparent predicate

```text
IsDensity(rho) := Matrix.PosSemidef(rho) AND Matrix.trace(rho) = 1.
basisProjector(i) := Matrix.single i i 1.
diagonalState(q) := Matrix.diagonal [1-q, q], with real entries explicitly cast to complex.
krausMap(K, X) := sum_j K_j X K_j*.
```

`Matrix.PosSemidef` already includes Hermiticity. Do not replace it with entrywise nonnegativity, the positivity of the diagonal alone, or a predicate that is satisfied by construction without proving its mathematical fields. A predicate is sufficient at this stage; a bundled state type can wait until an actual caller justifies it.

Suggested exact public statements, with Lean identifiers chosen only after compiling against the selected pin:

1. For every `i : Fin 2`, `IsDensity (basisProjector i)`.
2. For every `q : ℝ`, if `0 ≤ q` and `q ≤ 1`, then `IsDensity (diagonalState q)`.
3. `basisProjector 0 ≠ basisProjector 1`.
4. For every finite Kraus index type `J`, every `K : J → M2`, and every `X : M2`,
   `trace(krausMap(K,X)) = trace((sum_j K_j* K_j) X)`.
5. Under `sum_j K_j* K_j = I`, for every matrix `X`, `trace(krausMap(K,X)) = trace(X)`.
6. The one-element family with operator `I` satisfies the normalization condition and its map is the identity.

Endpoint equalities `diagonalState 0 = basisProjector 0` and `diagonalState 1 = basisProjector 1` are useful small additions for the basis ordering. They also make the zero/one population convention explicit. They are not prerequisites for a large general framework.

There is no reason to assume `X` is a density or Hermitian in statements 4 and 5. The identities hold for all complex matrices. There is likewise no need to require a nonempty Kraus index type in the abstract identity. The normalization witness prevents relying solely on a vacuous conditional theorem. The underlying state index type is already explicitly nonempty.

The proof of statement 4 is finite-sum linearity plus cyclic trace invariance. It should not use or assume a full quantum-channel theorem. A stronger rectangular version is valid, but not necessary to resolve this pilot's immediate dependency question.

## Probability convention

Use `q`, `populationOne`, or similarly explicit naming for the Stage 0 diagonal-state parameter. C00 uses the second entry as its parameter, whereas C06 calls the first stationary population `p = b/(a+b)`. These are compatible, but easy to confuse. With the C00 convention, the later stationary state is `diagonalState(a/(a+b))`.

## What the validation gate should establish

- One fixed Lean toolchain and Mathlib revision, with a committed manifest or equivalent exact lock record.
- All selected release modules actually compiled from the delivered sources; a default target alone is not evidence unless its coverage is verified.
- Every required release declaration exists, is included in the audit, and has an independently checked intended type.
- Every transitive axiom is in the exact allowed set `{propext, Classical.choice, Quot.sound}`. A whitelist subset is fine.
- The density definition, diagonal entries, matrix multiplication, and adjoint conventions have been read and semantically checked.
- The density type has at least two distinct witnesses, and the Kraus normalization premise has a concrete witness.

`#print axioms` supplies useful evidence but is not itself an enforcement mechanism. Printing an unwanted axiom does not make Lean compilation fail. The release script must parse or programmatically inspect the result, compare exact names, require one result for every intended export, and fail closed on malformed output or a missing declaration. Prefer Lean's declaration environment APIs or a structured output format over fragile human-output regular expressions.

For stronger statement protection, maintain a small independent contract module containing exact expected type ascriptions of the release exports. This catches a common regression that is invisible to an axiom whitelist: a theorem with the same name but an extra `False` hypothesis. Elaborated type snapshots also help human review, but a snapshot generated from the changed source cannot alone enforce the previous contract.

The authoritative public export list must have a declared relationship to internal helpers. Either enforce that every public theorem in the release namespace appears in it, or keep unlisted helpers private and document the intended public API. Do not permit a release to advertise unlisted theorems as covered by the gate.

## Minimal adversarial checks

Run these in a temporary fixture, without weakening the real release source or the gate itself:

| Mutation | Required outcome | Failure mode addressed |
| --- | --- | --- |
| Add a nonexistent required export | Nonzero gate exit | Silent incomplete audit |
| Export a theorem using a direct custom axiom | Nonzero gate exit | Unapproved proof assumption |
| Export a theorem using a helper that uses a custom axiom | Nonzero gate exit | Shallow dependency scan |
| Export a theorem proved with `sorry` | Nonzero gate exit | Placeholder escaping build success |
| Add a `False` premise to an existing export | Independent contract check fails | Axiom-clean semantic weakening |
| Keep a genuine allowed theorem unchanged | Gate succeeds | Harness rejecting everything |

If native evaluation is permitted in development, a separate rejected fixture should demonstrate that its actual pinned-version axiom name is rejected. Do not invent a supposed native axiom name and claim to have tested that mechanism. Exact set membership, not substring matching, must determine allowed axiom names.

Compilation of an umbrella import plus a declaration manifest does not by itself prove that every file in a directory was compiled. This matters only for files being claimed as release modules. Excluded sketches must remain clearly outside the release and its claims.

## What a successful result would not establish

The result would not establish: correctness of every theorem in Mathlib or a downstream quantum library; the absence of all implementation/compiler vulnerabilities; the absence of hidden semantic assumptions in definitions; physical applicability to a concrete experimental system; novelty of the proved elementary lemmas; complete positivity; stationarity or uniqueness of the selected Lindblad model; dynamics or relaxation rates.

This distinction need not obstruct the handoff. It defines a precise, useful success criterion for Fable to reproduce and extend.

## API reconnaissance, not pin verification

The official Mathlib documentation retrieved during this review describes `Matrix.PosSemidef`, `Matrix.PosSemidef.diagonal`, and `Matrix.posSemidef_diagonal_iff`, together with `Matrix.trace_sum`, `Matrix.trace_mul_comm`, and `Matrix.trace_mul_cycle`. These confirm a plausible Mathlib-only route. Their exact signatures must still be checked in the chosen source revision because the public documentation follows a moving revision.

Primary URLs:

- https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/PosDef.html
- https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/Trace.html

Existing local downstream source also defines a Kraus map and trace-duality infrastructure, for example `research_quantum/repo0/QIT/Core/Map.lean`. This source inspection is not evidence that those downstream declarations compile or satisfy the release axiom policy. The root investigation should retain that distinction.
