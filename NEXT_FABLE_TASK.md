# Active assignment: four-Kraus certification of two-state evolution

> Status (21 September 2026): implemented in
> `FormalScience/Quantum/FiniteKraus.lean` and
> `FormalScience/OpenSystems/TwoStateKraus.lean`, handed off in
> `deliverables/kraus/v1/HANDOFF.md`. The assignment text below is preserved
> as issued (frozen copy: `audits/evolution/v1/NEXT_FABLE_TASK.md`). Do not
> start a further milestone until the audit selects one.

Milestone key: `kraus`. First implementation round: `v1`.

This assignment follows the accepted evolution milestone at source commit
`a60a92b6064b4dde33a98d3c79be195c77595873`, tag
`evolution-milestone-v1`. Preserve that accepted tag and the earlier tags.
The later receipt commit records packaging and is not the source under audit.

Implement one bounded checkpoint: certify the existing two-state evolution as
a trace-preserving finite Kraus map for nonnegative rates and nonnegative time,
and prove its positivity after every finite ancilla extension. Keep the pinned
Lean 4.34.0 and Mathlib dependencies. The mathematical contracts below are the
new assignment, not already verified release results. Do not stop after planning.

## Integrate the accepted audit

1. Integrate the evolution audit return using its repository-relative paths and
   `RETURN_README.md`. The return manifest defines the payload set. Verify each
   supplied file against it; do not infer the payload from every file later added
   to an audit directory.
2. Preserve the exact issued assignment at
   `audits/evolution/v1/NEXT_FABLE_TASK.md`, then activate its editable copy at the
   repository root. Prior issued assignments remain immutable provenance.
3. Update `TURNS.md`, `README.md`, and current project status to record evolution
   acceptance and the new `kraus` checkpoint. Correct E1: the README introduction
   must no longer deny the semigroup and time evolution that are now proved.
   Positivity, complete positivity, and convergence were outside that accepted
   milestone; this task implements the first two, with convergence still pending.
4. Record D013 in `DECISIONS.md` for the evolution audit and its errata. Correct E2:
   at the pin, `HasDerivAt` uses the target's canonical topological vector-space
   structure, not a target norm parameter. The auditor's direct derivative
   consumer compiled without enabling the local matrix norm instances. The
   existing derivative is accepted. Do not claim that a norm-equivalence theorem
   was required or proved, and do not change its signature to introduce a norm.
5. Preserve submitted handoffs and evidence as historical records. If clarifying
   the derivative helper's source docstring, make only a comment change after
   baseline reproduction and record the before/after source hashes. No accepted
   proof, definition, or theorem-signature change is requested.

Read `README.md`, `AGENTS.md`, `DECISIONS.md`, the evolution audit,
`AUDIT_HANDOFF_TEMPLATE.md`, and this assignment. The portfolio roadmap supplies
context; its earlier kickoff instructions do not override this bounded task.

## Reproduce the baseline first

Before changing accepted Lean source or adding the new modules, reproduce the
accepted 115-export / 100-contract baseline with both verification scripts.
Store fresh reproduction evidence under `evidence/kraus/v1/reproduction/`, with
its own gate-test subdirectory. Match the accepted evolution source hashes and
preserve all earlier evidence trees.

Resolve ordinary setup issues autonomously. Do not update pins, weaken contracts,
relax the accepted axiom policy, or edit proofs to force reproduction through.
If an additional Mathlib import needs cache files, extend the cache at the same
pin and record the import/cache scope. Do not add an external quantum dependency.

## Representation and module scope

Use two small modules, or one module if the same separation stays clear:

```text
FormalScience/Quantum/FiniteKraus.lean
FormalScience/OpenSystems/TwoStateKraus.lean
```

Reuse `Stage0.krausMap`, `QubitMatrix`, `IsDensity`, the matrix units/jump
operators, and the accepted `evolution`. Preserve the accepted Stage 0,
dissipator, stationary, and evolution APIs. Do not create a second flow.

Rate `a` is the 0-to-1 jump `E_10`; rate `b` is the 1-to-0 jump `E_01`.
The basis order is 0,1. The Hamiltonian remains zero. Products and adjoints
are ordinary complex matrix multiplication and conjugate transpose.

The physical certification hypotheses are exactly:

```text
0 <= a, 0 <= b, 0 <= t.
```

Do not require both rates positive or their sum positive. The both-zero case is
part of this task. Arbitrary signed rates and negative times remain valid inputs
to the earlier linear flow, but are not covered by this channel certification.

## Exact four-Kraus family

For real a,b,t write:

```text
gamma = a+b
p = b/gamma
c = halfExpFactor gamma t = exp(-(gamma*t)/2)
d = Real.sqrt (1-c^2).
```

Use ordinary Lean real division, so p=0 when gamma=0. Do not silently replace
`p` by `a/gamma`, which reverses the jump convention. Scalar square roots are
real square roots, followed by the displayed coercion to Complex.

Define a transparent family `evolutionKraus a b t : Fin 4 -> QubitMatrix`
equivalent to:

```text
K0 = (sqrt(p) : Complex) • Matrix.diagonal [1, (c : Complex)]
K1 = (sqrt(p)*d : Complex) • E_01
K2 = (sqrt(1-p) : Complex) • Matrix.diagonal [(c : Complex), 1]
K3 = (sqrt(1-p)*d : Complex) • E_10.
```

The displays are mathematical pseudocode; use ordinary Lean matrix-vector
notation. Reuse `jumpOneToZero` for E_01 and `jumpZeroToOne` for E_10. Expose
four direct formula theorems or an equivalent transparent formula theorem that
the independent contract file can check. Keep one public family.

Prove or reuse the scalar facts needed by the matrix calculations:

```text
0 <= p, p <= 1, 0 < c, c <= 1,
c^2 = expFactor gamma t,
(Real.sqrt p)^2 = p,
(Real.sqrt (1-p))^2 = 1-p,
d^2 = 1-c^2.
```

Use the physical hypotheses for inequalities. Algebraic identities may have
weaker assumptions. Prefer private helpers when no independent reuse is
intended; this assignment has no target theorem count.

The zero-total-rate reasoning must be explicit: if a,b >= 0 and a+b=0, then
a=b=0. Here p=0, c=1, d=0, K2=I, and the other three operators are zero.
At signed cancellation a=-b != 0 this family need not represent the earlier
flow. Do not extend the physical conclusion by using division by zero.

## Required finite-Kraus contracts

Under only the physical rate/time hypotheses, prove:

```text
sum j : Fin 4, (Kj)^H * Kj = I
evolution a b t X = krausMap (evolutionKraus a b t) X
```

The representation holds for every complex qubit matrix X, without density,
trace, Hermiticity, or PSD premises. Its entries simplify to:

```text
00 = (p+(1-p)*c^2)*X00 + p*(1-c^2)*X11
11 = (1-p)*(1-c^2)*X00 + ((1-p)+p*c^2)*X11
01 = c*X01
10 = c*X10.
```

At gamma != 0, compare these with the accepted all-matrix population formulas
using `trace X = X00 + X11`. At gamma=0 use the physical both-zero reduction
and `evolution_zero_zero`. Do not drop the trace factor from an intermediate
all-matrix formula or verify the equality only on density inputs.

Reuse `krausMap_trace_preserving` to obtain a direct consumer of completeness:

```text
trace (krausMap (evolutionKraus a b t) X) = trace X.
```

The existing unconditional `evolution_trace` remains available and unchanged.

Establish the generic finite rectangular Kraus positivity lemma, reusing the
existing map definition:

```text
X.PosSemidef -> (krausMap K X).PosSemidef.
```

It needs no normalization hypothesis. Mathlib already provides PSD preservation
by B*X*B^H and PSD of finite sums. From representation and trace preservation,
export:

```text
X.PosSemidef -> (evolution a b t X).PosSemidef
IsDensity X -> IsDensity (evolution a b t X).
```

Do not call these two endpoints complete positivity by themselves.

## Required all-ancilla positivity bridge

Fix ancilla-first product order `Fin m × Fin 2`. Independently define a small
blockwise amplification operation, parameterized by m and a matrix map Phi:

```text
amplify m Phi Y (r,i) (s,j)
  = Phi (fun u v => Y (r,u) (s,v)) i j.
```

It is fine to define this for arbitrary finite input/output system indices if
that is simpler; do not build a generic channel ecosystem. The operation may
take an unbundled function, with linearity supplied by the existing bundled
`evolution` when used. Expose its exact blockwise formula in a consumer contract.

For every natural number m and every complex matrix Y indexed by
`Fin m × Fin 2`, prove the actual amplification identity:

```text
amplify m (evolution a b t) Y
  = krausMap (fun j => (I_m kronecker Kj)) Y.
```

Here `Matrix.kronecker` has entry `(A kronecker B)(r,i)(s,j)=A(r,s)*B(i,j)`.
The assumptions are a,b,t >= 0. Prove this identity for arbitrary Y, including
entangled and non-PSD inputs. A generic finite-Kraus lifting identity followed
by the evolution representation is a short route.

Then export complete positivity in explicit finite-matrix form:

```text
for every m : Nat and every Y : Matrix (Fin m × Fin 2) (Fin m × Fin 2) Complex,
  Y.PosSemidef -> (amplify m (evolution a b t) Y).PosSemidef.
```

Do not replace all m by m=1 or m=2. Do not define the amplifier only as the
lifted Kraus sum and omit its equality with the independently block-defined
extension of the accepted flow. Positivity on product states alone is also
insufficient.

Include a transparency check for every complex ancilla matrix A and every X:

```text
amplify m (evolution a b t) (A kronecker X)
  = A kronecker (evolution a b t X).
```

This follows from linearity and is valid for arbitrary real rates and times.
It may be proved generically for any complex-linear Phi and consumed for the
evolution. It checks product ordering and the identity action on the ancilla;
it does not replace the all-Y lifting identity.

An explicit universally quantified PSD theorem is the required CP endpoint.
A project-local CP predicate is optional and must unfold to exactly that
condition. No adapter to Mathlib's bundled C*-algebra CP hierarchy is required.
Do not claim that hierarchy is absent: the pin contains
`Mathlib.Analysis.CStarAlgebra.CompletelyPositiveMap`.

## Required boundary consumers

Keep the family, representation, and completeness valid at the physical
boundaries. Include direct family identities, grouped if convenient:

1. At a=b=0, K2=I and K0=K1=K3=0. The represented map is the identity.
2. At t=0 with physical rates, K0=sqrt(p) I, K2=sqrt(1-p) I,
   K1=K3=0. The represented map is the identity. Do not incorrectly require
   each nonzero Kraus operator individually to equal I.
3. At a=0 and b>0, K0=diag(1,c), K1=d E_01, K2=K3=0.
4. At b=0 and a>=0, K0=K1=0, K2=diag(c,1), K3=d E_10.
   This includes a=0 consistently.

Use t>=0 in physical consumers; stronger unconditional family identities are
fine when correct. Supply at least one density-preservation consumer in each
one-zero-rate direction by specializing the general density theorem. The
general certification must cover both-zero rates without an extra positive
total-rate assumption.

## Pinned proof routes and scope boundary

Search the pinned source before adding helpers. Relevant APIs include:

- `Matrix.PosSemidef.mul_mul_conjTranspose_same` and
  `Matrix.posSemidef_sum` in `Mathlib.LinearAlgebra.Matrix.PosDef`.
- `Matrix.kronecker`, `kronecker_apply`, `conjTranspose_kronecker`, and
  `mul_kronecker_mul` in `Mathlib.LinearAlgebra.Matrix.Kronecker`.
- `Real.sq_sqrt`, `Real.mul_self_sqrt`, `Real.sqrt_zero`, and `Real.sqrt_one`
  in `Mathlib.Analysis.Real.Sqrt`.
- The accepted Stage 0 trace/completeness API and evolution entry identities.

The ancilla bridge can be proved by matrix extensionality, finite product sums,
and the identity matrix's Kronecker deltas. PSD then follows from the generic
Kraus lemma. No norm or derivative development is needed for this checkpoint.

The return includes optional feasibility code at
`audits/evolution/v1/reference/KrausProbe.lean` and its compilation record.
This auditor probe is outside the accepted 115-export release and does not
certify the new four-Kraus family. Reuse it if helpful, but any adopted code
must be integrated into release modules, exports, consumer contracts, axiom
reports, and the ordinary verification gates. Its scratch namespace and
file placement are not a required public API.

Stop after this finite Kraus and all-ancilla certification. Do not implement
norm contraction, convergence, spectral gaps, faithfulness, Choi or Stinespring
equivalence, a general GKSL theorem, Perron-Frobenius, the Markov bridge,
Hamiltonian extensions, entropy, circuits, or operations research. The pilot
still does not close an entire broad portfolio inventory area.

## Validation and evidence

Keep all existing release signatures and consumer contracts. Add each new
release module to `FormalScience.lean` and `exports.json`. List every new public
definition and theorem in the export manifest. Add direct independent consumer
signatures in `Audit/Contracts.lean` for the required endpoints.

The contracts must expose the four matrices with real square roots, the
normalization, all-matrix representation, physical hypotheses, both-zero
coverage, blockwise amplifier, actual lifted-Kraus identity, all-m universal
PSD conclusion, and the tensor-action convention. A consumer that only applies
a project-local CP label without exposing its definition is insufficient.

Run both verification scripts on the final source. Record commands, return
codes, raw output, hashes, exact signatures, and transitive axioms under:

```text
evidence/kraus/v1/verification/
evidence/kraus/v1/gate-tests/
```

Keep the accepted axiom policy: `propext`, `Classical.choice`, `Quot.sound`,
or a subset. No release `sorry`, `admit`, custom axioms, native-evaluation
assumptions, weakened contracts, or validation bypasses. Preserve deliberate
invalid fixtures. Retain a coverage-control fixture showing that omitting a
new release module is rejected. Do not expand the verification framework.

## Package the exact tested result

Complete `deliverables/kraus/v1/HANDOFF.md` from the template, with exact
statement mappings, assumptions, scalar conventions, proof design, source
provenance, commands, axioms, boundary checks, and deviations. Record evidence
paths and the accepted evolution diff base in `POINTER.json`.

Follow `AGENTS.md`: finish files; stage intended paths; check staged bytes;
generate and stage `SOURCE_MANIFEST.json` over those final intended files,
excluding itself; commit; tag `kraus-milestone-v1`; create the ignored archive
with `git archive`; verify every archive path, byte count, and digest; then
record the actual archive digest and peeled tag commit in an external
`RECEIPT.json` committed after the tag. Do not embed a containing archive's own
digest inside itself. Preserve earlier tags and evidence.

The implementer commits and tags; the user pushes. Return the archive, handoff,
pointer, receipt, full digest, exact source commit, fresh evidence, and any
unresolved issue. Use no em dashes in documentation or code comments. Stop for
audit after this milestone.
