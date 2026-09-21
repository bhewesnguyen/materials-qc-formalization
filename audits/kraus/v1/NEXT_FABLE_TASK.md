# Active assignment: quantitative two-state convergence

Milestone key: `convergence`. First implementation round: `v1`.

This assignment follows the accepted Kraus milestone at source commit
`6431c9cd411a3a804d2a86ae733e23f393fe9361`, tag `kraus-milestone-v1`.
Preserve that accepted tag and every earlier accepted tag. The later receipt
commit records packaging and is not the source under audit.

Implement one bounded checkpoint: the explicit Frobenius error estimate and
long-time limit for the accepted two-state evolution, together with physical
density consumers and meaningful rate boundaries. This completes the remaining
convergence endpoint of the original two-state pilot. Keep the pinned Lean
4.34.0 and Mathlib dependencies. The contracts below are the new assignment,
not already verified release results. Do not stop after planning.

## Integrate the accepted audit

1. Integrate the Kraus audit return using its repository-relative paths and
   `RETURN_README.md`. Verify the archive's exact payload against
   `audits/kraus/v1/RETURN_MANIFEST.json`: every non-directory entry except the
   manifest must have exactly one matching path, byte count, and SHA-256; require
   no extra or missing entries. Keys are relative to the repository/ZIP root.
   Extract to a temporary location, then copy paths without flattening or
   nesting the whole return inside its own audit directory. Compare any existing
   destination before replacing it. The manifest defines the immutable payload
   set; later repository additions are not automatically part of that payload.
2. Preserve `audits/kraus/v1/NEXT_FABLE_TASK.md` exactly as issued. Activate an
   editable copy at the repository root. Earlier issued assignments remain
   immutable provenance; only the root `NEXT_FABLE_TASK.md` is active.
3. Record acceptance in `TURNS.md`, `README.md`, `AGENTS.md`, and current status:
   there are now five accepted local increments, including all-finite-ancilla
   positivity of the physical two-state evolution. Convergence is the active
   checkpoint. No broad inventory area is closed by this model-specific result.
4. Add D015 to `DECISIONS.md` for acceptance and these three nonblocking prose
   nits. They require no proof-repair round. The contracts commentary says `Kf`
   where the actual family notation is `Kev`. D014's zero-left discussion uses
   b>0, which is the requested physical boundary and is sufficient; b!=0 would
   already suffice for that algebraic family identity. D014's phrase about
   off-diagonal entries closing by `simp` alone describes completeness, not the
   Kraus-map off-diagonal formulas, whose proofs also use scalar identities.
   Clarify the two historical D014 descriptions in D015, without rewriting D014
   or the submitted handoff. Do not strengthen the accepted boundary theorem
   merely to remove an unnecessary physical assumption. The `Kf` comment typo
   may be corrected after baseline reproduction, with the changed file hash
   recorded. No accepted definition, theorem signature, or proof needs changing.

Read `README.md`, `AGENTS.md`, `DECISIONS.md`, the Kraus audit,
`AUDIT_HANDOFF_TEMPLATE.md`, and this assignment. The broader portfolio roadmap
supplies context; its older kickoff instructions do not enlarge this task.

## Reproduce the baseline first

Before modifying accepted Lean source or `Audit/Contracts.lean`, or adding the
new release module, reproduce the accepted 158-export / 139-contract baseline
with both verification scripts. Store fresh reproduction evidence under
`evidence/convergence/v1/reproduction/`, with its own gate-test subdirectory.
Match the accepted Kraus source hashes and preserve every earlier evidence tree.

Resolve ordinary setup issues autonomously. Do not update pins, weaken
contracts, relax the accepted axiom policy, or alter proofs to force baseline
reproduction through. If a new import requires cache modules, extend the cache
at the same pin and record the exact scope. No external quantum dependency is
needed for this checkpoint.

## Representation and scope

Use a small release module:

```text
FormalScience/OpenSystems/TwoStateConvergence.lean
```

Reuse the existing `QubitMatrix`, `IsDensity`, `rhoStar`, `evolution`, and accepted
Kraus density theorem. Do not create another flow or another stationary state.
The basis remains 0,1; a is the 0-to-1 jump rate; b is the 1-to-0 jump rate;
the Hamiltonian remains zero. Write gamma=a+b.

Separate the assumptions by purpose:

- Exact centered formulas and the squared identity: gamma!=0, arbitrary real
  time and arbitrary real individual rates.
- Quantitative decay: gamma>0 and t>=0, arbitrary real individual rates and
  arbitrary complex input matrices.
- Limit at positive infinity: gamma>0, arbitrary complex input matrices.
- Physical density consumers: a>=0, b>=0, gamma>0, input density, and t>=0 where
  a time-specific preservation or estimate statement is made.

In particular, neither individual-rate positivity nor PSD is necessary for the
algebraic decay estimate. The signed-rate estimate does not assert positivity
of the flow or physical validity of its stationary candidate.

## Required contract A: identify the exact norm

Define a named real-valued Frobenius norm, for example:

```lean
noncomputable def qubitFrobeniusNorm (X : QubitMatrix) : ℝ :=
  Real.sqrt (∑ i, ∑ j, ‖X i j‖ ^ 2)
```

The norms inside the finite sums are the ordinary complex norm. Expose the
explicit finite-sum formula and prove a bridge to Mathlib's named Frobenius
instance, using `open scoped Matrix.Norms.Frobenius` for that bridge. An
independent contract must check the bridge with the scope explicitly selected.
Do not substitute the default supremum matrix norm or rely on an unproved
statement that all norms are equivalent. The quantitative constant depends on
which norm is used.

It is enough to specialize the named norm to `QubitMatrix`. A small finite-index
definition is acceptable if it makes the implementation simpler, but do not
build a new generic norm hierarchy. Keep finite-sum expansion, nonnegativity,
and the norm-square identity private unless they have a clear public consumer.
The existing derivative theorem needs no modification or norm parameter.

## Required contract B: exact centered evolution

For an arbitrary complex matrix X, define locally in statements or proof text:

```text
tau = Matrix.trace X
Y = X - tau • rhoStar a b.
```

There is no need for a new bundled projection definition. Under gamma!=0, prove
all four centered entries, or one transparent matrix identity that implies them:

```text
(Phi_t X - tau • rhoStar)_00 = (exp(-gamma*t)   : Complex) * Y_00
(Phi_t X - tau • rhoStar)_11 = (exp(-gamma*t)   : Complex) * Y_11
(Phi_t X - tau • rhoStar)_01 = (exp(-gamma*t/2) : Complex) * Y_01
(Phi_t X - tau • rhoStar)_10 = (exp(-gamma*t/2) : Complex) * Y_10.
```

Here `Phi_t` is the already accepted `evolution a b t`. Scalar notation may use
`expFactor` and `halfExpFactor`, but consumer contracts must expose `Real.exp`.
The `tau` factor is mandatory on arbitrary X. Do not replace it by one, assume
Hermiticity or diagonality, or state that every matrix converges to `rhoStar`.

From these entries prove the exact squared Frobenius error identity:

```text
F(Phi_t X - tau • rhoStar)^2
  = exp(-gamma*t)^2 * (norm(Y_00)^2 + norm(Y_11)^2)
  + exp(-gamma*t/2)^2 * (norm(Y_01)^2 + norm(Y_10)^2).
```

F is the named Frobenius norm, and the four entry norms are complex norms. This
identity holds for every real t and every nonzero gamma. Its diagonal energy
has exponential rate 2*gamma, while its coherence energy has rate gamma.
Keep the displayed exponential squares if that avoids needless rewriting.

## Required contract C: the quantitative estimate

With only gamma>0 and t>=0, prove for every complex qubit matrix X:

```text
F(Phi_t X - (trace X) • rhoStar a b)
  <= exp(-gamma*t/2) * F(X - (trace X) • rhoStar a b).
```

No PSD, Hermiticity, trace-one, diagonality, or individual-rate nonnegativity
premises belong on this theorem. The estimate measures error from the stationary
projection in X's own trace fiber. It is not a claim that `Phi_t` contracts the
Frobenius norm of every uncentered matrix.

Use the squared identity and the accepted scalar facts. For gamma>0 and t>=0,
let c=halfExpFactor gamma t. Then 0<c<=1 and expFactor gamma t=c^2, so the
squared diagonal coefficient is at most c^2. Multiply by nonnegative diagonal
energy, add the coherence energy, and compare nonnegative square roots.

Also export a trace-one specialization with target `rhoStar a b`, using only
`Matrix.trace X = 1` together with the rate/time assumptions. This keeps the
mathematical strength visible independently of density positivity.

As a short linearity consumer, require pairwise contraction on equal-trace
inputs under the same gamma>0 and t>=0 assumptions:

```text
trace X = trace Z ->
F(Phi_t X - Phi_t Z) <= exp(-gamma*t/2) * F(X-Z).
```

Apply the all-matrix estimate to X-Z, whose trace is zero. No positivity premise
is needed. The equal-trace condition must remain visible in its contract.

## Required contract D: actual long-time limits

Under only gamma>0 and for every complex matrix X, prove both endpoints:

```lean
Tendsto
  (fun t : ℝ => qubitFrobeniusNorm
    (evolution a b t X - (Matrix.trace X) • rhoStar a b))
  atTop (𝓝 0)

Tendsto (fun t : ℝ => evolution a b t X)
  atTop (𝓝 ((Matrix.trace X) • rhoStar a b))
```

Use the actual definition name if a different clear name is chosen. The first
statement is a scalar error limit. The second is the matrix-valued endpoint in
the canonical matrix topology; neither replaces the other. Give a trace-one
specialization with matrix limit `rhoStar a b`.

The scalar error limit follows by a squeeze with eventually nonnegative times.
For the matrix endpoint, entrywise assembly with `tendsto_pi_nhds` twice and the
accepted population formulas is a direct route. No proof of norm equivalence
is required. A different valid route is fine, provided the elaborated target
topology and the named quantitative norm remain unambiguous.

## Required contract E: physical consumers and boundaries

Under a>=0, b>=0, gamma>0, and `IsDensity rho`, provide an explicit consumer
that uses the accepted `evolution_isDensity` and the new estimate, for t>=0:

```text
IsDensity (Phi_t rho)
and
F(Phi_t rho - rhoStar a b)
  <= exp(-gamma*t/2) * F(rho - rhoStar a b).
```

A conjunction theorem is convenient; separate direct consumer theorems are
acceptable if the connection is explicit. The trace-one limit gives the density
limit. Reuse the accepted `rhoStar_isDensity` wherever the physical target's
validity is displayed; do not reprove the stationary milestone.

Include direct limit consumers for all three positive-total-rate boundaries:

1. a=0, b>0: every density tends to `basisProjector 0`.
2. a>0, b=0: every density tends to `basisProjector 1`.
3. a=b=r>0: every density tends to `diagonalState (1/2)`.

Stronger trace-one consumers are welcome instead of unnecessary PSD premises.
Use the accepted `rhoStar_zero_left`, `rhoStar_zero_right`, and `rhoStar_same`.
The general estimate already applies in these cases; avoid duplicate proofs.

At a=b=0, reuse the accepted identity flow and prove that there is no single
matrix attracting every density:

```lean
¬ ∃ σ : QubitMatrix, ∀ ρ : QubitMatrix,
  IsDensity ρ →
  Tendsto (fun t : ℝ => evolution 0 0 t ρ) atTop (𝓝 σ)
```

The two distinct basis densities and uniqueness of limits prove this. Do not
claim that individual constant trajectories fail to converge. Signed
cancellation a=-b!=0 retains its earlier affine-in-time flow and is outside
this positive-total-rate convergence result.

## Optional bounded witness

If short, add the coherence matrix-unit identity for E_01 (`jumpOneToZero`):

```text
Phi_t(E_01) = (exp(-gamma*t/2) : Complex) • E_01
F(E_01) = 1
F(Phi_t(E_01)) = exp(-gamma*t/2).
```

These hold for all real rates and times. The witness saturates the centered
all-matrix estimate at positive gamma and nonnegative time, checking the
coherence exponent and prefactor. E_01 is not a density; do not advertise this
as a density sharpness witness. This optional item must not delay the required
contracts or expand into an optimal-rate theory. Diagonal-only faster-rate corollaries are optional,
not a new milestone.

## Pinned proof routes and scope boundary

Search the pinned source before adding helpers. Relevant APIs include:

- `Matrix.frobenius_norm_def` and scoped instances
  `Matrix.Norms.Frobenius`, in `Mathlib.Analysis.Matrix.Normed`.
- `Real.sqrt_eq_rpow`, `Real.rpow_two`, `Real.sq_sqrt`, and `Real.sqrt_sq`.
- `Real.tendsto_exp_atBot`; `tendsto_id.const_mul_atTop_of_neg`; normalize
  composition using `Function.comp_def` when needed.
- `tendsto_pi_nhds` for the matrix limit and `tendsto_nhds_unique` for the
  both-zero no-common-attractor result.
- The accepted `halfExpFactor_sq`, `halfExpFactor_pos`,
  `halfExpFactor_le_one`, trace-linear population identities, and density API.

Expand finite sums with `Fin.sum_univ_two`; use `norm_mul`, real-to-complex norm
facts, positivity of exponentials, and ordinary ring algebra for the exact
energy identity. Prefer the existing coordinate representation to introducing
an inner-product-space wrapper solely for this two-dimensional calculation.

The return includes optional API feasibility source at
`audits/kraus/v1/reference/ConvergenceApiProbe.lean`, with its execution record.
It checks the named Frobenius bridge and scalar exponential limits only. It is
outside the accepted release and proves neither the evolution error estimate
nor its convergence. Any adopted statements must enter the ordinary release
exports, independent contracts, axiom reports, and verification gates; the
probe's namespace and names are not a required API.

Stop after these explicit norm and convergence results. Do not implement trace
norm or diamond norm contraction, general spectral gaps, generic irreducibility
or Perron-Frobenius, a GKSL characterization, Hamiltonian extensions, Markov
bridges, Choi/Stinespring equivalences, entropy, circuits, CAR/Hubbard, or OR.
A successful result completes the planned two-state benchmark endpoint; it is
not closure of a broad portfolio inventory area or a novelty claim.

## Validation and evidence

Preserve all accepted release signatures and consumer contracts. Add the new
module to `FormalScience.lean` and `exports.json`; list every new public
definition and theorem. Prefer private arithmetic or coordinate helpers where
no external API is intended. There is no target export count.

Add direct independent contracts in `Audit/Contracts.lean` for the named norm
formula and its named-instance bridge, centered entries, exact squared split,
all-matrix bound, trace-one bound, equal-trace pair bound, both limits, physical
density consumer, and
all boundary consumers. Spell out `Real.exp`, the `trace X` factor, nonzero or
positive total-rate assumptions as appropriate, and the explicit finite sum or
four-entry formula behind the norm. A consumer that applies an opaque name
without exposing the norm or the intended asymptotic target is insufficient.

Run both verification scripts on final source. Retain exact commands, exit
codes, raw output, source hashes, elaborated signatures, and transitive axiom
reports under:

```text
evidence/convergence/v1/verification/
evidence/convergence/v1/gate-tests/
```

Keep the accepted axiom policy: `propext`, `Classical.choice`, `Quot.sound`, or
a subset. No release `sorry`, `admit`, custom axioms, native-evaluation
assumptions, weakened contracts, or verification bypasses. Preserve deliberate
invalid fixtures. Retain a missing-module coverage control and its fixture.
Do not expand the verification framework or repeat checks without a concrete
remaining validation need.

## Package the exact tested result

Complete `deliverables/convergence/v1/HANDOFF.md` from the template, including
exact statement mappings, assumptions, norm identification, decay exponents,
target trace scaling, topology-level limit, physical consumers, rate boundaries,
proof design, commands, axioms, and deviations. Record the accepted Kraus diff
base and evidence paths in `POINTER.json`.

Follow `AGENTS.md`: finish files; stage intended paths; check staged bytes;
generate and stage `SOURCE_MANIFEST.json` over those final intended files,
excluding itself; commit; tag `convergence-milestone-v1`; create the ignored
archive with `git archive`; verify every archive path, byte count, and digest;
then record the actual archive digest and peeled tag commit in an external
`RECEIPT.json` committed after the tag. Do not embed a containing archive's own
digest inside itself. Preserve earlier tags and evidence.

The implementer commits and tags; the user pushes. Return the archive, handoff,
pointer, receipt, full digest, exact source commit, fresh evidence, and any
unresolved issue. Use no em dashes in documentation or code comments. Stop for
audit after this milestone.
