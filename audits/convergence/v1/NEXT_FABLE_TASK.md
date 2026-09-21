# Active assignment: finite Markov generator bridge

Milestone key: `markov`. First implementation round: `v1`.

This assignment follows acceptance of convergence at source commit
`a3cbac0692b4c106a89e80c91d18b0c2de4988cd`, tag
`convergence-milestone-v1`. Preserve that tag and every earlier accepted tag.
The receipt commit is packaging provenance, not the source under audit.

Implement one bounded Stage 4 extension: a finite classical rate matrix and
its diagonal embedding into a weighted matrix-unit dissipator generator.
The Hamiltonian is zero. The two-state mathematical pilot is complete; this
extension is a new reusable finite-dimensional result. Keep Lean 4.34.0 and
the accepted Mathlib pin. The contracts below are an assignment, not already
verified release results. Do not stop after planning.

## Integrate the accepted audit

1. Integrate the convergence return using `RETURN_README.md` and its original
   repository-relative paths. Verify the exact payload against
   `audits/convergence/v1/RETURN_MANIFEST.json`: every non-directory archive
   entry except the manifest must appear exactly once with matching byte
   count and SHA-256, with no extra or missing paths. Extract to a temporary
   location first, then copy without flattening or nesting the whole return
   inside its own audit directory. Compare existing destinations before any
   replacement. The manifest defines the immutable payload set; later
   repository additions do not retroactively become part of that set.
2. Preserve `audits/convergence/v1/NEXT_FABLE_TASK.md` exactly as issued.
   Activate an editable copy at the repository root. Earlier issued tasks
   remain immutable. Only root `NEXT_FABLE_TASK.md` is active.
3. Record acceptance in `TURNS.md`, `README.md`, `AGENTS.md`, and current
   status. There are six accepted local increments, completing the planned
   two-state mathematical benchmark. The finite Markov bridge is the selected
   Stage 4 extension. Stage 5 downstream release work remains separate. No
   broad portfolio row is newly closed merely by completing the pilot.
4. Add D017 for acceptance and the nonblocking documentation corrections C1
   and C2. After baseline reproduction, correct the convergence module's
   opening prose: the scalar error tends to zero, while the matrix tends to
   `(trace X) • rhoStar`. A fixed stationary direction rules out a strict
   full-space contraction factor below one, not nonexpansiveness by itself.
   Say that the proved estimate is centered in a trace fiber and does not
   assert an unconditional uncentered Frobenius contraction. Record the
   corresponding clarification of D016 as an erratum in D017 rather than
   rewriting historical D016 or the submitted handoff. Correct the stale
   README sentence that still denies convergence. No accepted definition,
   theorem type, or proof needs repair. Record any comment-only source hash
   change explicitly.

The separate personal scope memo is context, not an authoritative repository
artifact or an instruction to expand this assignment. Do not modify, track,
or commit it. The scope review in the audit explains its optional wording and
counting corrections.

Read the current project instructions, the accepted convergence audit,
`AUDIT_HANDOFF_TEMPLATE.md`, and this task. The broader roadmap supplies
context; its older kickoff text does not enlarge the active scope.

## Reproduce before source edits

Before changing any accepted Lean source or `Audit/Contracts.lean`, or adding
the new release module, reproduce the accepted 187-export / 167-contract
baseline with both verification scripts. Store fresh evidence under
`evidence/markov/v1/reproduction/`, with its own gate-test subdirectory. Match
the accepted source hashes and preserve every earlier evidence tree.

Resolve ordinary setup issues autonomously. Do not change pins, weaken
contracts, relax the axiom policy, or change a proof to force reproduction.
If an import needs additional cache modules, use the same pin and record the
exact extension. No external quantum or Markov dependency is required.

## Representation and dependency decision

Use one small release module:

```text
FormalScience/OpenSystems/FiniteMarkovBridge.lean
```

Search the pinned Mathlib and accepted local source before adding helpers.
Record the matching matrix-unit, finite-sum, diagonal, trace, and positivity
lemmas, and which ones are reused. Record a bounded dependency budget in the
next decision entry: the accepted dissipator layer, ordinary finite-matrix
algebra, and the two-state generator only for its specialization consumer.
Do not introduce a new process framework, norm hierarchy, or downstream
dependency. Check exact statement overlap in the available pinned sources;
record the scope and result of that comparison. This known correspondence
is not a claim of mathematical novelty or of absence from all Lean projects.
Preserve provenance for any adopted external proof text.

A bounded auditor search at the accepted pin found these direct routes:

- `Matrix.single_mul_mul_single` and `Matrix.single_mul_single_same` in
  `Mathlib/Data/Matrix/Basis.lean`.
- `Matrix.mulVec_apply_eq_sum` and the diagonal/vector multiplication lemmas
  in `Mathlib/Data/Matrix/Mul.lean`.
- `Matrix.diagonal_injective` in `Mathlib/Data/Matrix/Diagonal.lean`.
- `Matrix.trace_diagonal` and `Matrix.PosSemidef.diagonal` in the existing
  trace and PSD modules.
- The accepted `dissipatorLinearMap`, `dissipator_trace`, and
  `dissipator_isHermitian` are already generic over finite indices.

The bounded pinned-source keyword search for dissipator, Lindblad, GKSL,
Markov-generator, and rateMatrix found no matching named endpoint in
Mathlib. This is a search result, not proof of absence under other names or
in downstream projects. The source-level API list is not a newly compiled
bridge probe. Inspect the exact types and search semantically nearby source
as needed before adding a duplicate helper.

Work over an arbitrary finite index type `n`, with `Fintype n` and
`DecidableEq n` as needed. No cardinality lower bound belongs on the
algebraic results. Use real input rates `q : Matrix n n ℝ` and fix the
destination-first convention:

```text
q i j = rate from j to i, for i != j.
r j   = sum over i != j of q i j.
Q i j = q i j, if i != j; Q j j = -r j.
```

The supplied diagonal entries `q j j` are ignored in both Q and the quantum
generator. They do not denote physical self-jumps. There is no need to
require `q j j = 0`; make the omission explicit in the definitions and
independent contracts.

Use `Matrix.mulVec` for the classical column-vector action `Qp`. Define a
bundled complex-linear map with this exact underlying function:

```text
L_q(X) = sum over j, sum over i != j of
           (q i j : Complex) • dissipator (Matrix.single i j 1) X.
```

Reuse `dissipatorLinearMap`. A nested sum using `if i = j then 0 else ...`
or an equivalent filtered finite sum is acceptable. Export direct formula
theorems for the definitions so their interpretation is visible. Suggested
names are `exitRate`, `rateMatrix`, and `markovGenerator`; avoid collision
with the accepted two-state `generator`.

Keep arbitrary signed real rates on algebraic laws. Physical rate validity
is the separate premise `∀ i j, i ≠ j → 0 ≤ q i j`. No assertion here says
that a generator output is PSD or a probability vector.

## Required contract A: the classical rate matrix

Prove the diagonal and off-diagonal entry formulas for Q, then:

```text
For every j: sum_i Q i j = 0.
For every real vector p: sum_i (Q.mulVec p) i = 0.
(Q.mulVec p) i = sum over j != i of q i j * p j - r i * p i.
```

These identities need no nonnegativity, normalization, or nonemptiness
hypothesis. Under the physical rate premise, prove nonnegativity of each
exit rate and each off-diagonal Q entry. This makes the classical rate
interpretation an explicit checked consumer of the representation.

Mass conservation here is the identity for the infinitesimal vector Qp. It
is not a theorem about an unconstructed transition semigroup, nor a claim
that Qp itself is nonnegative.

## Required contract B: the quantum generator entries

For arbitrary complex matrices X and arbitrary signed real q, prove:

```text
(L_q X) i i = sum over j != i of (q i j : Complex) * X j j
              - (r i : Complex) * X i i.

For i != j:
(L_q X) i j = -(((r i + r j) / 2 : Real) : Complex) * X i j.
```

The second identity is a generator coefficient, not an already constructed
coherence-decay trajectory. It exposes how exit rates control off-diagonal
entries and confirms the one-half convention. Do not assume Hermiticity,
diagonality, PSD, or trace one for either formula.

Also prove `trace (L_q X) = 0` for every X and Hermiticity preservation for
Hermitian X. Reuse the accepted generic dissipator laws. Real rates are
enough for Hermiticity; rate nonnegativity is unnecessary.

Matrix-unit identities may be private helpers or public reusable lemmas
when they have a clear consumer. Prefer the existing `Matrix.single`
algebra over proving a second basis representation.

## Required contract C: the diagonal bridge

For a real vector `p : n → ℝ`, write the diagonal embedding explicitly as

```lean
Matrix.diagonal (fun i => (p i : ℂ))
```

Prove, for every q and every real p:

```text
L_q(diag(C p)) = diag(C (Q.mulVec p)).
L_q(diag(C p)) = 0  iff  Q.mulVec p = 0.
```

Here C means entrywise real-to-complex coercion. No positivity or
normalization premise belongs on these algebraic statements. A stronger
complex-vector bridge is acceptable if convenient, but include a direct
real-vector contract with the cast explicit. Do not replace the rate
matrix by its transpose or define Q retrospectively from the quantum
output. The independent classical and dissipator definitions must meet in
the proved identity.

This stationary equivalence concerns diagonal inputs. It is not a
classification of every stationary quantum matrix or a uniqueness theorem.

## Required contract D: probability and stationary density consumers

For a real vector p with `∀ i, 0 ≤ p i` and `∑ i, p i = 1`, prove that its
diagonal embedding is PSD and has complex trace one. State the conjunction
directly for generic n; the accepted `IsDensity` is qubit-specific and its
signature must remain unchanged. No new generic density hierarchy is needed.

Then, with the additional premise `Q.mulVec p = 0`, prove that the same
matrix is PSD, trace one, and annihilated by L_q. Reuse the diagonal bridge
and the probability-density lemma. Rate nonnegativity is unnecessary for
this implication; the vector premises and the stationary equation already
supply exactly what its conclusion requires. The result applies in
particular to a physical nonnegative-rate matrix.

The empty index type satisfies the algebraic laws, but cannot satisfy the
probability normalization premise. Do not add an unrelated nonempty or
two-state restriction to avoid that harmless boundary.

## Required contract E: conventions, zero rates, and pilot recovery

For the all-zero rate family, prove Q=0 and L_q=0, with the latter preferably
an equality of bundled linear maps. Diagonal q entries are visibly ignored
by definition; an optional diagonal-only rate corollary may document that
convention if it is immediate.

On `Fin 2`, take the explicit real matrix

```text
q = [[0,b], [a,0]].
```

Prove for arbitrary real a,b:

```text
Q = [[-a,b], [a,-b]].
L_q = the accepted generator a b.
```

Use bundled-map equality for the second endpoint, or a pointwise theorem on
every complex qubit matrix plus a direct map-equality consumer. This is the
required reuse witness: a is the 0-to-1 rate, b is the 1-to-0 rate, and the
finite bridge specializes to the actual accepted generator. There is no
need to reprove its stationary density or dynamics.

## Scope boundary

Stop after these generator identities and their consumers. Do not construct
matrix exponentials, classical or quantum transition semigroups, probability
preservation over time, generic CPTP evolution, generic irreducibility,
Perron-Frobenius, classical mixing, spectral gaps, detailed balance, a
stationary uniqueness theory, or a full quantum kernel classification.

The Hamiltonian is zero in this milestone. A real diagonal Hamiltonian can
be considered later because it commutes with diagonal matrices. An
arbitrary Hamiltonian does not preserve the diagonal subspace. Do not
quietly add a general commutator term to the bridge statement.

Do not infer CP or positivity of `Id + t • L_q` from its generator form.
The two-state Kraus construction proves a particular accepted flow and does
not furnish a generic finite-state semigroup theorem. Do not begin CAR,
Hubbard, circuits, entropy, or OR work in parallel with this milestone.

## Validation and evidence

Preserve all accepted signatures and consumer contracts. Add the new module
to `FormalScience.lean` and `exports.json`. List every new public definition
and theorem. Prefer private arithmetic helpers unless there is an intended
public consumer. There is no target declaration count.

Add independent contracts that expose the destination-first rate convention,
the exclusion of self-jumps, zero column sums, the real Q.mulVec action, the
explicit dissipator sum, the two quantum entry cases, the exact diagonal
coercion identity, the stationary iff, PSD and trace-one consumers, zero
rates, and the Fin 2 identification. An opaque consumer that merely repeats
an implementation name does not establish the intended mathematics.

Perform and record a manual source-to-export and theorem-to-contract review
of every intended public declaration. The verifier deliberately does not
discover a declaration omitted from both lists. Preserve that limitation
honestly; do not turn this round into verification-framework expansion.

Run both verification scripts on final source, retaining commands, exit
codes, raw output, source hashes, elaborated types, and transitive axioms in

```text
evidence/markov/v1/verification/
evidence/markov/v1/gate-tests/
```

Retain a missing-module coverage fixture and its rejecting run. Retain the
listed-export-without-consumer fixture and its rejecting run, adapted to the
new module where appropriate. These controls must exercise properties the
gate actually enforces, with input fixtures retained. Preserve earlier
evidence and the ordinary 15 gate cases. Do not add tests that merely mirror
definitions or expand testing without a concrete validation need.

Accepted export axioms are `propext`, `Classical.choice`, `Quot.sound`, or a
subset. No `sorry`, `admit`, custom axioms, native-evaluation assumptions,
contract weakening, or verification bypasses belong in the release.

## Package the exact tested result

Complete `deliverables/markov/v1/HANDOFF.md` from the template. Include the
definition and theorem mapping, signed versus physical hypotheses, the
column convention, real-to-complex bridge, stationary scope, consumers,
source-overlap search, dependency budget, evidence, axioms, and deviations.
Record the accepted convergence diff base and evidence paths in
`POINTER.json`.

Follow `AGENTS.md`: finish files; stage intended paths; check staged bytes;
generate and stage `SOURCE_MANIFEST.json` over the final intended files,
excluding itself; commit; tag `markov-milestone-v1`; derive the ignored ZIP
from that tag; verify every archive path, byte count, and digest; then record
the archive digest and peeled tag commit in an external `RECEIPT.json`
committed after the tag. Do not embed the containing archive's own digest
inside it. Preserve all accepted tags and historical evidence.

The implementer commits and tags; the user pushes. Return the archive,
handoff, pointer, receipt, full digest, exact source commit, fresh evidence,
and unresolved issues. Use no em dashes in documentation or code comments.
Stop for audit after this single milestone.
