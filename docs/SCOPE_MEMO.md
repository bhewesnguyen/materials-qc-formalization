# Scope memo: how far the formalization program has come

Personal planning note for Jett Sturges. Written 20 September 2026 after
the kraus handoff, refreshed after the kraus acceptance and again on
21 September 2026 after the convergence acceptance, incorporating the
auditor's review `audits/convergence/v1/SCOPE_MEMO_REVIEW.md`. Tracked in
the repository from round 6 onward as `docs/SCOPE_MEMO.md` so that it
travels with the deliverables. It is not a release artifact: it claims no
theorem, it is not covered by the verification gate, and nothing in it is
audited fact unless it cites an audit or a verification record. Where it
goes beyond the records (tiering, effort scenarios, projected contribution
columns) it says so.

Sources: `TURNS.md`, `exports.json`, the six accepted audits under
`audits/`, the auditor's ledger `audits/convergence/v1/PORTFOLIO_STATUS.md`,
and the stage gates in `docs/PORTFOLIO_ROADMAP.md`.

## 1. The short answer

There are two different questions hiding in "how far are we from completing
the formalism", and they have very different answers.

The two-state pilot (the Lindblad benchmark the plan chose as the first
integration target) is complete: six bounded increments are accepted
(Stage 0, dissipator, stationary, evolution, kraus, convergence). What
follows is not part of that pilot. The selected Stage 4 extension, the
finite Markov generator bridge, is implemented and under audit (29 exports
submitted), and Stage 5 release work is separate again. Earlier versions of this memo counted "seven
checkpoints" by adding one extension to the pilot; that was a program
counter of my own choosing, not a completion fraction defined by the
roadmap, and it is dropped here.

The 39-area portfolio is not something that will ever read "100 percent".
It is a heterogeneous backlog. The defensible tally, in the auditor's
convention: one existing Mathlib endpoint identified for reuse (Hall), four
broad rows advanced locally (10, 11, 13, 15), 34 rows without local
implementation, and no broad row newly completed by this project. About six
of the untouched rows are research projects in their own right, not
formalization tasks. A single percentage would be misleading; Section 5
gives three usable definitions of "complete" instead.

One line you can quote: two-state pilot, six increments accepted; Stage 4
extension (markov) implemented and under audit; Stage 5 release later.
Portfolio: 1 Mathlib reuse endpoint identified, 4 rows advanced locally,
34 without local implementation, 0 newly completed.

## 2. The pilot ladder against the roadmap's stage gates

| Roadmap stage | Roadmap deliverable | Our milestone | Status | Exports added |
| --- | --- | --- | --- | ---: |
| 0. Reconnaissance | Pinned inventory, representation decision, dependency route, API probe | `stage0` (built by the auditor) | Accepted | 15 |
| 1. Finite core | State, adjoint, trace, positivity, and Kraus lemmas the pilot needs | Folded into `stage0` and `dissipator` | Accepted | 27 |
| 2. Stationary pilot | Component equations, valid `rho_*`, stationarity, uniqueness, degenerate rates | `stationary` | Accepted | 30 |
| 3. Dynamics pilot | Explicit Kraus channel, semigroup and derivative identities, quantitative convergence | Split by the audits into `evolution`, `kraus`, `convergence` | All three accepted | 43 + 43 + 29 |
| 4. One extension | Markov bridge, or finite CAR/Hubbard, or a verified downstream repair | `markov` (H = 0 finite Markov generator bridge) | Implemented; under audit | 29 (submitted) |
| 5. Release / upstream | Stable downstream release, selected foundational contributions | | Not started; separate from Stage 4 | |

Accepted public surface after the convergence audit: 7 release modules, 187
exports (167 theorem contracts, 20 definitions or abbreviations), all on
the axiom set `{propext, Classical.choice, Quot.sound}`. These became
accepted coverage counts with the sixth audit; before it they were
submission counts. They measure how much audited API exists, not how much
mathematics of the portfolio is done.

What the pilot establishes for the two-state model: an explicit generator
with its component equations; the unique stationary density with the
degenerate-rate cases; an explicit complex-linear flow on all matrices with
the all-real semigroup law and the matrix-valued derivative
`d/dt Phi_t X = L(Phi_t X)`; a four-operator Kraus representation for
nonnegative rates and time; trace preservation, density preservation, and
complete positivity in explicit all-ancilla form; and, for positive total
rate, the exact Frobenius error split, the centered estimate
`F(Phi_t X - trace X rho_*) <= exp(-gamma t / 2) F(X - trace X rho_*)` on
every matrix, and convergence of every trajectory to `trace X rho_*`, with
the degenerate rates handled. That is a complete CPTP semigroup with a
quantitative approach to equilibrium for one model, checked end to end. It
is exactly the "explicit two-state dynamics as an independent benchmark"
the plan set out under portfolio row 10, and nothing more than that.

## 3. Observed velocity, and why it will not transfer

| Round | Milestone | Date | Exports | Audit outcome |
| --- | --- | --- | ---: | --- |
| 0 | stage0 | 2026-09-20 | 15 | Accepted |
| 1 | dissipator | 2026-09-20 | 27 | Accepted; F1 to F4, all low, process |
| 2 | stationary | 2026-09-20 | 30 | Accepted; S1 to S3, all low, records and wording |
| 3 | evolution | 2026-09-20 to 21 | 43 | Accepted; E1, E2, both low, documentation |
| 4 | kraus | 2026-09-21 | 43 | Accepted; no findings, three optional prose cleanups |
| 5 | convergence | 2026-09-21 | 29 | Accepted; C1, C2, both low, documentation |
| 6 | markov | 2026-09-21 | 29 | Under audit |

Six implementation rounds and six accepted audits in roughly one working
day, with no proof revision ever requested. Three cautions before
extrapolating. First, the export counts and the short calendar interval
measure only the coding turns; every milestone arrived with a contract
written and audited beforehand, and that specification work was part of
the cost even when it was not the implementer's turn. Second, the pilot
was not only qubit algebra: it included generic finite dissipator and
Kraus layers, and the hard part of the remaining portfolio rows is writing
their contracts, which is exactly what did not have to happen here. Third,
the plan's own framing applies: budgets are planning budgets, not delivery
promises, and each session should end with an accepted lemma, an exact
failed goal, or a documented dependency decision. None of this is
throughput evidence for unrelated mathematical areas.

## 4. The 39-row ledger, with a local contribution column

Dispositions are the auditor's (`M` Mathlib endpoint identified; `C`
relevant source or reported candidate, possibly narrower than the row and
still needing an exact reuse audit; `U/P` unresolved or partial only). The
contribution column follows the accepted ledger
`audits/convergence/v1/PORTFOLIO_STATUS.md`. The tier column is my planning
classification, defined below the table.

| ID | Area | Disp. | Local contribution after convergence | Tier |
| ---: | --- | --- | --- | --- |
| 1 | Register and circuits | C | None | A |
| 2 | QFT unitarity | C | None | A |
| 3 | Phase-estimation bounds | C | None | A |
| 4 | Grover / amplitude amplification | C | None | A |
| 5 | Shor chain | C | None | A |
| 6 | Hohenberg-Kohn I / II | U/P | None | C |
| 7 | Bloch theorem | C (finite seed only) | None; a finite periodic-lattice surrogate would be new work | A/B |
| 8 | Fermionic Fock / CAR | U/P | None | B |
| 9 | Tight-binding / Hubbard | U/P | None | B |
| 10 | GKSL characterization | C | Complete explicit two-state benchmark: dissipator, generator, CPTP semigroup for nonnegative rates and time, four-Kraus formula on all matrices, ODE identity, quantitative Frobenius relaxation; no generic GKSL | A for the generic theorem; the benchmark is done |
| 11 | Quantum Perron-Frobenius | C | Two-state stationary uniqueness, exponential Frobenius attraction at positive total rate, and the both-zero no-common-attractor proof; no generic PF, spectral gap, or irreducibility theory | A |
| 12 | Lieb-Robinson bounds | U/P | None | C |
| 13 | State layer, partial trace, purification | C | Qubit density predicate, basis and diagonal densities, density preservation by the physical flow, convergence of every density to the stationary density; no partial trace or purification | A |
| 14 | POVMs / Born rule | C | None | A |
| 15 | Kraus / Choi / Stinespring | C | Finite Kraus trace and positivity laws, blockwise ancilla amplification, lifted-Kraus identity, and CP for one channel family; no representation equivalences | A |
| 16 | Entropy inequalities | C | None | A |
| 17 | No-go suite | C | None | A |
| 18 | Discrimination | C | None | A |
| 19 | Protocol verification | C | None | A |
| 20 | Entanglement criteria | C | None | A |
| 21 | Holevo bound (accessible information) | U/P | None | C |
| 22 | HSW | C | None | A |
| 23 | Quantum error correction | C | None | A |
| 24 | Fidelity toolbox | C | None | A |
| 25 | Quantum de Finetti | U/P | None | C |
| 26 | Petz / approximate recovery | C | None | A |
| 27 | LP duality / slackness | C | None; an exact rational certificate checker would be new work | A/B |
| 28 | Hall | M | Existing Mathlib declaration identified for reuse; not a local release result | reuse |
| 29 | Finite minimax | C | None | A |
| 30 | Max-flow min-cut | C | None | A |
| 31 | Verified simplex | U/P | None | C |
| 32 | KKT | C | None | A |
| 33 | Konig / Dilworth / Menger | C | None | A |
| 34 | Shortest paths / min-cost flow | C | None | A |
| 35 | Matroid greedy | C | None | A |
| 36 | Bellman / MDPs | U/P | None; discounted contraction is Tier B | B |
| 37 | General-sum Nash existence | C | None | A |
| 38 | Integer programming | U/P | None | C |
| 39 | M/M/1 | U/P | None; the balance-equation part is Tier B | B |

Tiers, defined by what the next unit of work actually is. The rows split
disjointly as 26 A-only, 2 A/B (7 and 27), 4 B-only (8, 9, 36, 39), 6 C,
and 1 reuse; an earlier version of this memo counted the two A/B rows in
both tiers.

- Tier A, verified reuse audit (28 rows, including the two A/B rows). A
  downstream library or paper reports a candidate for the row, which may
  cover a narrower endpoint than the row itself; the roadmap records
  partial state infrastructure, finite Bloch seeds, and narrower coding and
  optimization endpoints. The deliverable is the plan's "verified reuse
  audit": exact statement, compatible pin, transitive axiom report,
  semantic review, and the audit may find substantial implementation
  remaining. The binding constraint is toolchain drift: the inspected
  snapshots sit at Lean 4.30 (Lean-QIT), 4.33 (csd-lean4), 4.34 (physlib),
  and 4.35-rc1 (QICLean) against our 4.34.0 pin, so each reuse either waits
  for a compatible revision, ports a small attributed slice, or forces a
  pin decision.
- Tier B, new finite formalization in this project's style (the 4 B-only
  rows, plus the finite or exact variants of the 2 A/B rows). These look
  like the pilot: finite index types, explicit contracts, entrywise or
  algebraic proofs, one audit round each. A `U/P` disposition does not
  certify novelty; partial work may exist elsewhere.
- Tier C, research-level (6 rows: 6, 12, 21, 25, 31, 38). Each needs a
  domain-expert review of the informal theorem contract before any Lean is
  written, and the plan's go/no-go rule applies: pursue only after a bounded
  first publishable milestone has been identified. No budget is defensible
  today.

## 5. Distance to "complete", under three definitions

Definition 1: the two-state pilot is complete. Met: convergence accepted on
21 September 2026 (Stage 3 exit). Optional refinements the audits listed
(full kernel classification, faithfulness, rank-one theorem, square-root
jump representation) remain available but are not needed for the gate.

Definition 2: program version 1 is complete. Exit gate: pilot plus one
Stage 4 extension plus a Stage 5 downstream release (clean reproduction,
changelog, citations, human review; upstreaming is a separate gate that
depends on Mathlib reviewers). The Stage 4 extension is the H = 0 finite
Markov bridge, implemented and under audit; the auditor notes it may take
more than one accepted increment. Planning scenario, not a forecast: 1 to 3
rounds for the extension, 1 to 2 for release packaging.

Definition 3: the portfolio is complete. This is not a well-defined target
and I recommend not treating it as one. The defensible reframing is to
track each row's disposition transitions: `U/P` to "contract specified",
to `C`, to `V` (locally verified), and to count rows in each state. Today:
`V` for 0 full rows, partial `V` for 4 rows (10, 11, 13, 15), `M` for 1 row
(28), `C` for 24 further rows with no local work, `U/P` for 10 rows. An
earlier version of this memo multiplied per-row session guesses across
overlapping tiers to get a "lower bound near 40 sessions"; that arithmetic
double-counted rows, treated candidates as finished results, and assumed a
session means the same thing across unrelated areas, so it is withdrawn.
The usable approach is to budget one precisely contracted target at a
time and re-estimate from its actual dependency work. The inventory can
acquire a meaningful completion criterion only after its rows are split
into explicit finite endpoints.

## 6. What the pilot has made cheap

These are the rows where the next unit of work can reuse audited API rather
than start from Mathlib.

- The Markov bridge (roadmap Stage 4, first option; implemented, under
  audit). With zero
  Hamiltonian, the general-index `dissipator` and the two-state
  entry-equation style transfer directly to
  `L_q(X) = sum_{i != j} q_ij D[E_ij](X)` on a finite state set, with the
  diagonal intertwining identity `L_q(diag p) = diag(Qp)`. The Hamiltonian
  restriction is essential: for `H = [[0,1],[1,0]]` and `p = (1,0)`,
  `-i[H, diag p] = [[0,i],[-i,0]]` is not diagonal, so an arbitrary
  Hamiltonian breaks the bridge. A real diagonal `H`, or a commutation
  premise for a particular input, is a valid later extension. The generic
  Kraus positivity layer will matter for later evolution work, but it does
  not by itself construct a CPTP semigroup for this generator. This
  advances rows 10 and 11 toward their generic versions.
- Finite CAR (row 8), then finite Hubbard (row 9). Independent of the
  quantum core; the plan's materials ladder A. Tier B, no dependency
  decision required.
- Hall (row 28). Nothing to do beyond citing the Mathlib declaration.
- QIT state and channel layers (rows 13, 15) via QICLean. Real reuse value,
  but it forces the first pin decision (QICLean is at 4.35-rc1). Do not
  combine downstream libraries; the plan is explicit about that.

## 7. Caveats worth keeping in view

- Nothing in the release is claimed to be mathematically novel, and nothing
  has been proposed upstream. The value so far is a checked representation,
  explicit contracts, and an audit process that has held up across six
  accepted increments.
- The markov round is under audit. If its audit requests a proof revision
  it would be the first.
- The convergence estimate is in the Frobenius norm, centered in a trace
  fiber. It is not a trace-norm or diamond-norm contraction, it is not an
  uncentered Frobenius contraction (for `a = 1`, `b = 0`, and `X = I`, the
  flow gives `diag(e, 2 - e)`, whose squared norm exceeds `F(I)^2 = 2` for
  `t > 0`), and it says nothing about the sharpness of the rate among
  densities; the saturating witness is the non-density matrix unit `E_01`.
  Anyone quoting "exponential convergence" from this release should quote
  the norm and the centering.
- Every count in this memo will be stale after the next audit return. The
  authoritative records remain `TURNS.md`, `exports.json`, and whatever
  `PORTFOLIO_STATUS.md` the auditor returns with each round.
