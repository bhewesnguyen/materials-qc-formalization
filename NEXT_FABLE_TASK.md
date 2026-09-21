# Active assignment: explicit two-state evolution

> Status (20 September 2026): implemented in
> `FormalScience/OpenSystems/TwoStateEvolution.lean` and handed off in
> `deliverables/evolution/v1/HANDOFF.md`. The assignment text below is
> preserved as issued (frozen copy: `audits/stationary/v1/NEXT_FABLE_TASK.md`).
> Do not start a further milestone until the audit selects one.

Milestone key: `evolution`. First implementation round: `v1`.

This assignment follows the accepted stationary milestone at submitted commit
`a5347ca77a2b5e6678f514decb0ab4eee7b62943`, tag
`stationary-milestone-v1`. Preserve that accepted tag. Its later receipt
commit records packaging and is not a replacement for the source under audit.

Implement one bounded mathematical checkpoint: an explicit complex-linear
evolution on all complex qubit matrices, with semigroup, derivative, and
rate-boundary identities. Keep the pinned Lean 4.34.0 / Mathlib dependencies.
The formulas below are the new theorem contract, not already verified Lean
results. Do not stop after proposing an implementation plan.

## Record the audit and repair the small documentation gaps

1. Integrate the return's repository-relative paths according to
   `audits/stationary/v1/RETURN_README.md`; do not flatten the archive into
   one folder. Preserve this exact issued assignment at
   `audits/stationary/v1/NEXT_FABLE_TASK.md` before copying it to the mutable
   root `NEXT_FABLE_TASK.md`. The root is the single active assignment slot;
   immutable issued assignments in prior audit folders are provenance.
2. Restore the exact previously issued stationary assignment at
   `audits/dissipator/v1/NEXT_FABLE_TASK.md` from the restoration included in
   this return. Use the preserved bytes, not the root copy with implementation
   status added. Check it against the earlier auditor's manifest. Preserve
   all other prior audit artifacts and evidence. If those exact bytes cannot
   be recovered from the supplied return, record the missing artifact rather
   than reconstructing a supposedly exact historical file from memory.
3. Update current `README.md`, `AGENTS.md`, and `TURNS.md` to record the
   stationary acceptance and this new active checkpoint. Remove the stale
   claim that the stationary system still needs implementation. New evidence
   uses `evidence/<milestone>/v<k>/`; the older Stage 0 and dissipator evidence
   paths remain frozen exceptions. Use `git rev-parse <tag>^{commit}` for a
   tagged commit, and remove obsolete prose claiming commit hashes cannot be
   recorded in the turn index when that table already contains historical
   hashes.
4. Add D011 to `DECISIONS.md` with the stationary audit's documentation and
   provenance errata. Clarify in future prose that generator Hermiticity
   preservation assumes a Hermitian input, even though entry and trace
   identities hold for arbitrary complex matrices. The two coherence
   equations are valid for arbitrary real rates; decay is a physical
   nonnegative-rate interpretation, not a statement about all signed rates.
   Record the correct stationary signature and axiom log names as
   `26-export-signatures.stdout.log` and `27-axiom-audit.stdout.log` under
   `evidence/stationary/v1/verification/`. Replace the blanket zero-total-rate
   disclaimer in future prose: unconditional entry identities and the
   explicit both-zero results do apply there, while the general stationary
   uniqueness theorem requires nonzero total rate and does not cover
   nonzero signed cancellation.
5. Preserve the submitted stationary handoff and its raw evidence as
   historical records. Do not rewrite them to erase an erratum. Keep all
   prior theorem signatures and definitions. The redundant density-specific
   zero-generator wrapper is accepted and need not be removed.

Any clarification to Lean source docstrings must occur **after** the untouched
baseline reproduction below, and be recorded as a comment-only change.
Do not edit the accepted `Stage0.lean` or `Dissipator.lean` files.

Read `README.md`, `AGENTS.md`, `DECISIONS.md`, the stationary audit,
`AUDIT_HANDOFF_TEMPLATE.md`, and this assignment. The portfolio roadmap and
returned `PORTFOLIO_STATUS.md` supply context; their historical kickoff
instructions do not override this assignment.

## Reproduce the accepted baseline before changing proof source

Reproduce the accepted 72-export / 61-contract baseline with both verification
scripts. Record fresh logs and environment information under
`evidence/evolution/v1/reproduction/` and its dedicated gate-test subdirectory.
Confirm the baseline source hashes match the accepted stationary snapshot.
Preserve the previous evidence trees unchanged.

Resolve ordinary setup problems autonomously. Do not update dependency pins,
relax the axiom policy, weaken a theorem, or edit the accepted proof source to
make reproduction succeed. If a substantive block remains, report the exact
diagnostics and narrow intervention required.

## Mathematical conventions and representation

Use one new module:
`FormalScience/OpenSystems/TwoStateEvolution.lean`.

Reuse `QubitMatrix`, `basisProjector`, `diagonalState`, `generator`, and
`rhoStar`. Basis order remains 0,1. The Hamiltonian remains zero. Real rate
`a` weights `E_10`, the transition 0 to 1; real rate `b` weights `E_01`, the
transition 1 to 0. Write `gamma = a+b`; gamma is not a free independent rate.

Use **one** complex-linear map representation:

```text
evolution (a b t : Real) : QubitMatrix ->_linear[Complex] QubitMatrix.
```

This display is mathematical pseudocode. The Lean type is
`QubitMatrix →ₗ[ℂ] QubitMatrix`. A small private unbundled function used to
construct it is fine, but do not maintain two independent evolution APIs.

The public map must accept every complex matrix, without density, trace,
Hermiticity, or positivity premises. Its coefficients are real functions
cast into Complex where multiplied with matrix entries.

## Exact scalar and map definitions

Define transparent real scalar functions equivalent to:

```text
e(gamma,t) = exp(-gamma*t)
f(gamma,t) = exp(-(gamma*t)/2)
k(gamma,t) = if gamma = 0 then t else (1-exp(-gamma*t))/gamma.
```

Use ordinary real exponential. Keep the zero branch visible in the
definition or in a direct formula theorem. The zero-total-rate branch is
essential: signed cancellation `a=-b != 0` does not make the generator zero.

Define the map by the following entries, for arbitrary real `a,b,t` and
arbitrary `X : QubitMatrix`:

```text
evolution(a,b,t)(X)[0,0] = X[0,0] + (k(gamma,t) : Complex) *
                                    (-(a : Complex)*X[0,0] + (b : Complex)*X[1,1])
evolution(a,b,t)(X)[1,1] = X[1,1] + (k(gamma,t) : Complex) *
                                    ((a : Complex)*X[0,0] - (b : Complex)*X[1,1])
evolution(a,b,t)(X)[0,1] = (f(gamma,t) : Complex)*X[0,1]
evolution(a,b,t)(X)[1,0] = (f(gamma,t) : Complex)*X[1,0].
```

Expose all four equations as public theorems. Search pinned Mathlib for
exponential, derivative, finite-function, and linear-map facts before
writing helpers. There is no need for a generic matrix exponential, ODE
solver, new norm, or new quantum dependency.

## Required evolution contracts

Public names may vary; provide their exact mapping in the handoff.
Except where stated otherwise, all rates and times are arbitrary real
numbers, and `X` is an arbitrary complex qubit matrix.

### Initial condition and semigroup

Prove equality of bundled complex-linear maps:

```text
evolution a b 0 = LinearMap.id
evolution a b (t+u) = (evolution a b t).comp (evolution a b u).
```

Do not add nonnegative-time, nonnegative-rate, trace-one, or nonzero-gamma
premises to these statements. The chosen formula makes them valid on the
entire real line, including signed cancellation.

### Trace and Hermiticity

Prove:

```text
trace(evolution a b t X) = trace(X)
X.IsHermitian -> (evolution a b t X).IsHermitian.
```

Hermiticity has the displayed input premise. Trace preservation is
unconditional in X. Linearity comes from the bundled map; duplicate public
additivity/homogeneity wrappers are optional.

### Matrix-valued derivative

The final derivative endpoint must have this type, modulo public names:

```lean
HasDerivAt (fun s : ℝ => evolution a b s X)
  (generator a b (evolution a b t X)) t
```

Prove it for all real `a,b,t` and all `X`. Entrywise differentiation followed
by the finite-function derivative bridge is a good proof route, but the
final exported endpoint must be matrix valued. Do not replace it by only
four scalar derivative theorems. The real-line extension supplies a proper
two-sided derivative at zero and can later be restricted to physical time.

### Fixed stationary state and trace-linear formula

Under only `a+b != 0`, prove:

```text
evolution a b t (rhoStar a b) = rhoStar a b.
```

For the same rate hypothesis and arbitrary X, expose the two equivalent
diagonal-entry formulas:

```text
evolution(a,b,t)(X)[0,0] = (e(gamma,t) : Complex)*X[0,0]
  + ((1-e(gamma,t))*(b/gamma) : Complex)*trace(X)
evolution(a,b,t)(X)[1,1] = (e(gamma,t) : Complex)*X[1,1]
  + ((1-e(gamma,t))*(a/gamma) : Complex)*trace(X).
```

The trace factors are mandatory. Dropping them gives an affine formula
valid only after fixing trace one, not the required linear map on all
matrices. These formulas should be proved from the primary definition;
do not create a competing density-only evolution definition.

### Required zero-rate and sign checks

1. Under `a+b = 0`, prove the bundled-map equality

   ```text
   evolution a b t = LinearMap.id + (t : Complex) *scalar generator a b.
   ```

   Here `*scalar` denotes Lean scalar multiplication of linear maps.
2. Prove `evolution 0 0 t = LinearMap.id` for every real t.
3. Prove the signed-rate witness, for every real t:

   ```text
   evolution 1 (-1) t (basisProjector 0) = diagonalState t.
   ```

   This guards against incorrectly making every zero-total-rate map the
   identity. It is an algebraic equality, not a density claim for all t.
4. Include small consumers covering the one-zero-rate fixed states:
   `evolution 0 b t (basisProjector 0) = basisProjector 0` and
   `evolution a 0 t (basisProjector 1) = basisProjector 1`.
5. Include the equal-rate fixed state:
   `evolution r r t (diagonalState (1/2)) = diagonalState (1/2)`.

The last two items may use arbitrary real remaining rates; the formulas
are valid even at zero. They should follow from the general development
and existing stationary boundary lemmas rather than duplicate its algebra.

## Suggested proof decomposition

The following scalar identities isolate the only division branch and
support short entry calculations:

```text
k(gamma,0) = 0
gamma*k(gamma,t) = 1-exp(-gamma*t)
k(gamma,t+u) = k(gamma,t) + exp(-gamma*t)*k(gamma,u)
HasDerivAt (fun s => k(gamma,s)) (exp(-gamma*t)) t.
```

Use `gamma=0` and `gamma!=0` branches explicitly. The derivative is with
respect to t, holding gamma fixed. Prove or reuse the corresponding
exponential multiplication and derivative facts. Then establish the map
contracts by entries and reuse the existing generator entry equations.

This is a suggested proof route, not a requirement to export each helper.
Prefer private helpers when no independent reuse is intended. The audit
requires the meaningful mathematical endpoints, not a target theorem count.

## Meaning and stop boundary

The map on all real times is a mathematical extension. The physical
interpretation later restricts to `0<=a`, `0<=b`, and `0<=t`. Negative time
is not being asserted to be a quantum channel. Trace and Hermiticity
preservation do not prove positivity or complete positivity.

Do not implement or claim density preservation, finite Kraus certification,
complete positivity, Choi/Stinespring equivalence, norm contraction,
convergence, a generic ODE uniqueness theorem, generic GKSL, Perron-Frobenius,
the Markov bridge, entropy, circuits, or operations research in this turn.
Those remain later checkpoints. Do not add a general matrix-exponential
framework to solve this explicit model.

## Validation and evidence

Keep the current release theorem signatures and all existing consumer
contracts. Add the new module to `FormalScience.lean` and `exports.json`.
Record every new public definition and theorem in the export manifest.
Add direct independent consumer signatures for the new theorem contracts
in `Audit/Contracts.lean`, spelling out the entry formulas, time/rate
quantifiers, generator formula where useful, and the exact matrix-valued
derivative type. Preserve the no-extra-premise signature checks.

The consumer layer must include the full all-matrix trace-linear formula,
the zero-total-rate `Id+tL` identity, and the signed witness. It must not
specialize every check to density inputs or positive rates.

Run both verification scripts on the final source. Save commands, exit
codes, raw output, source hashes, and transitive axiom reports under:

```text
evidence/evolution/v1/verification/
evidence/evolution/v1/gate-tests/
```

Keep the accepted axiom policy: only `propext`, `Classical.choice`, and
`Quot.sound`, or a subset. No release `sorry`, `admit`, custom axioms,
native-evaluation assumptions, or validation bypasses. Preserve deliberately
invalid test fixtures. No new verification framework or broad dependency
upgrade is requested. If a focused API problem blocks completion, report
its exact target and options without weakening the required statements.

## Package the exact tested result

Fill `deliverables/evolution/v1/HANDOFF.md` from the template. Include an
exact statement/assumption mapping, proof design, source provenance,
commands, axioms, rate-boundary checks, and deviations. Record evidence
paths and the accepted stationary diff base in `POINTER.json`.

Follow the current `AGENTS.md` packaging sequence:

1. Finish source, evidence, and documents.
2. Stage exactly the intended files and confirm staged bytes equal final
   working-tree bytes.
3. Generate `SOURCE_MANIFEST.json` over that intended staged path set and
   its final bytes, excluding the manifest itself; stage the manifest.
4. Commit, then tag `evolution-milestone-v1`.
5. Create `git archive` from that tag into the ignored
   `deliverables/evolution/v1/` archive location.
6. Verify every archive path, byte count, and hash against the manifest,
   with no missing entries, extra entries, or nested archives.
7. Record the actual archive SHA-256 and
   `git rev-parse evolution-milestone-v1^{commit}` in an external
   `RECEIPT.json` committed after the tag, and in the delivery message.
   Do not attempt to embed the containing archive's own digest inside it.

The implementer commits and tags; the user pushes. Never move an accepted
tag. Return the source archive, handoff, pointer, receipt, full digest,
exact source commit, fresh evidence, and unresolved issues. Use no em dashes
in documentation or code comments. Stop for audit after this checkpoint.
