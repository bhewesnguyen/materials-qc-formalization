# Next design: finite Markov generator bridge

Recommendation: choose roadmap Stage 4, bridge release A, as one bounded `markov` milestone. Use H=0. The generic finite dissipator already supplies the quantum algebra, so no new Hamiltonian, semigroup, or probability-process framework is needed.

For a finite type n with decidable equality, take q : Matrix n n R. The entry q i j is the jump rate from j to i. Ignore q j j. Let r j be the sum of q i j over i != j and let Q have off-diagonal entries q i j and diagonal entries -r j. Let L be the complex-linear sum of q i j times the accepted dissipator at Matrix.single i j 1, again omitting i=j.

Required results are the zero column sums of Q, its real-vector conservation law, nonnegative off-diagonals and exits under the physical rate premise, the full entry formula for L, trace annihilation and Hermiticity preservation, and the diagonal intertwiner L(diag(C p)) = diag(C (Q.mulVec p)). The full entry formula records population inflow minus outflow on the diagonal and coherence coefficient -(r i+r j)/2 off the diagonal. All algebraic statements hold at signed rates. Rate nonnegativity belongs only on its own classical rate certificate and physical interpretation.

Require the diagonal stationary equivalence L(diag(C p))=0 iff Q.mulVec p=0. A nonnegative real vector with sum one gives a PSD trace-one diagonal matrix, and a stationary such vector gives a stationary density. State PSD and trace directly in the generic theorem, since the accepted IsDensity predicate is specialized to qubits. Do not expand that predicate's accepted signature or create an unnecessary generic density hierarchy.

Require a Fin 2 consumer with q = [[0,b],[a,0]], proving Q = [[-a,b],[a,-b]] and L = the accepted generator a b, preferably as bundled-map equality. This fixes the sign, transpose, and basis convention and shows the finite bridge genuinely consumes accepted pilot code.

No cardinality lower bound is needed. Empty and singleton index types satisfy the algebraic laws; a probability-vector premise handles nonemptiness where necessary. The zero-rate family must yield zero Q and zero L. There is no transition at i=j, even if a caller supplies nonzero diagonal q values.

Exclude matrix exponentials, classical or quantum semigroup construction, preservation of probabilities under evolution, generic CPTP, irreducibility, Perron-Frobenius, mixing rates, detailed balance, stationary uniqueness, diagonal Hamiltonians, and a general kernel classification. The stationary equivalence concerns diagonal states only. A later diagonal Hamiltonian may be added because it commutes with diagonal inputs; arbitrary Hamiltonians invalidate the bridge.

Before implementing, search the pinned Mathlib and local accepted source for the exact finite-sum and matrix-unit interfaces, recording matches and reuse. Record a small dependency budget and provenance for adopted external text. This is a known mathematical correspondence and a reusable local interface, not an absence or novelty claim. No new downstream library or pin change is justified by this milestone.

The implementation gate must retain source-level human review of all public declarations. The current verifier checks release-module coverage and listed contract coverage but does not discover all omitted declarations. Do not enlarge the verification framework to hide that explicit review obligation.

