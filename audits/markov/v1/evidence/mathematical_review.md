# Independent mathematical review: Markov v1

Source reviewed: `audit_markov/submitted/formal-science`, source commit reported as
`4795b8b6dc6ec7a831b9158affe3ee199f60e01e`.

## Recommendation

Accept the mathematics, subject to the root auditor's fresh Lean and package
verification. No blocking or nonblocking mathematical correction was found. No
additional theorem is required to complete this assignment. This review is source
and contract inspection; it does not independently claim an executed build.

Read in full: `FormalScience/OpenSystems/FiniteMarkovBridge.lean`, the frozen
`audits/convergence/v1/NEXT_FABLE_TASK.md`, the appended Markov section of
`Audit/Contracts.lean`, and D019. Read relevant accepted dissipator and two-state
stationary definitions and proofs, handoff mappings, and the recorded declaration
inventory. No submitted source was modified.

## Definition and contract audit

| Requirement | Finding |
| --- | --- |
| Generic finite state set | Every generic declaration has an arbitrary type `n`, with `Fintype n` and `DecidableEq n`; no `Nonempty`, positive-cardinality, or two-state hypothesis is smuggled in. |
| Destination-first rates | `q i j` is consistently the rate from source `j` to destination `i`. Exit rates sum the source column. |
| Ignored supplied diagonal | `exitRate` and `markovGenerator` use the literal `if i = j then 0 else q i j`; `rateMatrix` replaces the supplied diagonal by the negative exit rate. |
| Independent classical action | `rateMatrix` is defined directly from rates, not retrospectively from the quantum output. `Matrix.mulVec` is the column-vector action. |
| Bundled quantum generator | A nested finite sum of complex scalar multiples of the accepted `dissipatorLinearMap`; the scalar is the cast of the masked real rate. This is genuinely complex linear. |
| A: classical algebra | Correct entry formulas, zero column sums, inflow minus outflow, and zero total infinitesimal mass. Algebraic statements have arbitrary signed real rates and arbitrary real vectors. |
| A: physical certificates | Rate nonnegativity is required only for the two conclusions that need it: nonnegative exit rates and nonnegative off-diagonal entries of the rate matrix. |
| B: matrix-unit algebra | The public matrix-unit dissipator identity is correct for every `i,j`, including `i = j`. It consumes existing `Matrix.single` multiplication lemmas and the accepted dissipator definition. |
| B: full quantum entries | Population formula is inflow minus outflow. Off-diagonal coefficient is exactly `-(r_i + r_j)/2`. Both apply to every complex matrix, without Hermiticity, PSD, or trace premises. |
| B: structural laws | Trace annihilation uses accepted dissipator trace annihilation. Hermiticity preservation uses the accepted law and reality of each scalar. No nonnegativity is needed. |
| C: intertwining | `L_q(diag(C p)) = diag(C (Q.mulVec p))` is proved from entries for arbitrary real `p`. All casts are explicit. |
| C: stationarity | The iff is a consequence of the bridge, diagonal injectivity at zero, and injectivity of the real-to-complex cast. It classifies stationarity of diagonal inputs only. |
| D: probability embedding | Entrywise nonnegative real vectors of total mass one give Mathlib PSD diagonal matrices and complex trace one. No generic density hierarchy is substituted. |
| D: stationary density | The previous probability embedding and `Qp = 0` imply a stationary density. Rate nonnegativity would be redundant and is correctly absent. |
| E: zero/diagonal rates | Both zero rates and arbitrary diagonal-only rates give zero rate matrix and zero quantum generator. Generator conclusions are bundled-map equalities. |
| E: pilot recovery | Explicit `q = [[0,b],[a,0]]` gives `Q = [[-a,b],[a,-b]]` and equality with the actual accepted `generator a b`, not a newly invented lookalike. |

## Mathematical cross-checks

For `E_ij`, the first dissipator term has only entry `(i,i)`, with value
`X_jj`. The adjoint product is `E_jj`, so the anticommutator removes one half
of row `j` and one half of column `j`. Summing with weight `q i j` over
`i != j` therefore gives the stated population balance and coherence
coefficient. In particular the coherence term depends on the two source exit
rates, not on incoming rates. The implementation's index placement is correct.

Although `D[E_jj]` need not vanish on a general matrix, its coefficient is
identically zero in this generator. Consequently arbitrary supplied `q j j`
cannot introduce unadvertised dephasing. The real scalar mask under a single
complex cast is equivalent to the allowed excluded summation and is a sound
implementation choice.

When the input is `diag(C p)`, all off-diagonal inputs vanish, so the coherence
formula makes all off-diagonal outputs zero. The diagonal entries agree with
the independently defined real `Q.mulVec p` after coercion. Thus the bridge
establishes diagonal invariance without assuming its conclusion and without a
transpose error.

On two states, source 0 has exit rate `a` and source 1 has exit rate `b`.
The resulting populations are `-a X00 + b X11` and `a X00 - b X11`, and
both coherences have coefficient `-(a+b)/2`. The proof compares these entries
to the accepted two-state entry theorems and yields bundled linear-map
equality. The additional pointwise independent contract compares the result
against the previously spelled-out weighted matrix-unit formula `Lw`.

## Boundary and hypothesis review

- Empty type: all algebraic sums, functions, and matrix equalities are valid.
  No vector can satisfy the probability normalization premise because the
  empty sum is zero. This is the intended domain boundary, not accidental
  vacuity in the algebraic bridge.
- Singleton: every supplied rate is diagonal and therefore ignored. The zero
  generator and rate-matrix identities specialize correctly, and a probability
  vector gives the ordinary one-dimensional stationary density.
- Signed rates: column sums, trace, Hermiticity, entries, bridge, and stationary
  equivalence remain valid. No theorem silently interprets a signed generator
  as a physical evolution.
- Zero Hamiltonian: no commutator is present. The source and assignment both
  explicitly restrict the bridge to this case.
- No flow claim: nothing asserts that `L_q X` is PSD, that `Id + t L_q` is
  positive, or that a generic finite-state CPTP semigroup has been built.
- No generic uniqueness: a stationary probability vector is mapped to a
  stationary density, but existence, uniqueness, irreducibility, or the entire
  quantum kernel are not asserted.

## Independent consumer quality and inventory

The contract notations expose the exit-rate sum and classical rate matrix,
including the self-jump exclusion. The matrix-unit dissipator and generator
sum are expanded into actual multiplication, adjoint, scalar multiplication,
and subtraction. PSD and trace are Mathlib predicates. The bridge and its iff
make the real-to-complex coercion explicit. Using the name `Lq` in later
consumers is appropriate because a preceding consumer pins its exact formula.
The `quotPrecheck` setting only accommodates local notation parsing and does
not weaken theorem checking.

A direct declaration scan confirms three public definitions, 26 public
theorems, and one private theorem. Every new public declaration is present in
`exports.json`, and each public theorem has a concrete independent consumer.
There are 27 new example blocks because `markovGenerator_two` is consumed once
as a bundled equality and once pointwise; the reported 26 contract exports
counts distinct consumed public theorems, which is correct.

The public `dissipator_single` is a useful reusable identity with immediate
consumers in both generator entry proofs. Exporting it is within the assignment.
`Matrix.of ![![...]]` is ordinary explicit matrix syntax and changes no
mathematical convention.

## Findings and limitations

No mathematical fix is requested, and no stylistic nit is being promoted into
another proof round. The task's bounded endpoint is reached. The intentionally
excluded finite-state semigroup, mixing, and kernel-classification work remains
future work rather than a defect in this milestone.

Fresh compilation, accepted transitive axioms, exact archive identity, preservation
of earlier audited payloads, and the tracked scope memo's provenance are handled
by the root and package auditors. This review does not infer those checks from
Fable's report alone.
