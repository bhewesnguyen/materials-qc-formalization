# Formal-science portfolio status after Markov v1

Date: 21 September 2026. Source under review: `4795b8b6dc6ec7a831b9158affe3ee199f60e01e`, tag `markov-milestone-v1`. The accepted-work totals below apply with the acceptance decision in the accompanying Markov audit. This ledger reconciles the recorded research plan with local results; it is not a fresh global search or a claim of mathematical novelty.

## Current tally

The two-state pilot is complete in **six accepted bounded increments**. The selected finite Markov generator bridge adds **one accepted Stage 4 extension**, making **seven accepted mathematical increments** overall. The public surface is **8 release modules, 216 exports, 193 theorem exports with consumer contracts, and 23 definitions or abbreviations**. Markov adds 29 exports: 26 theorems and 3 definitions. These are API coverage counts, not comparable units of mathematical difficulty.

The original portfolio contains **39 areas**, not 39 individual proofs. Its corrected reconnaissance remains:

| Branch | Areas | Identified Mathlib endpoint | Candidate or narrower source evidence | Unresolved full endpoint or partial-only evidence |
| --- | ---: | ---: | ---: | ---: |
| Quantum algorithms, #1-5 | 5 | 0 | 5 | 0 |
| Materials/open systems, #6-12 | 7 | 0 | 3 | 4 |
| Quantum information, #13-26 | 14 | 0 | 12 | 2 |
| Operations research, #27-39 | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

A separate local-work tally is **1 Mathlib reuse/reference row (#28), 4 partly advanced rows (#10, #11, #13, #15), and 34 rows without local implementation**. The 34 comprise 24 further candidate-bearing rows and 10 unresolved/partial-only rows. **No broad inventory row has been fully closed by this project.** These two tallies measure different things; they must not be added together.

The 28 candidates are not 28 verified full endpoints. The ten unresolved/partial-only rows are #6, #8, #9, #12, #21, #25, #31, #36, #38, and #39. Their status means no matching full endpoint was established within the recorded search scope, not that no formalization exists. A completion percentage requires decomposing the broad rows into explicit theorem contracts first.

## What Markov adds to the four locally advanced areas

| Broad inventory row | Accepted local contribution after this round | Remaining broader scope |
| --- | --- | --- |
| #10 GKSL characterization | Complete explicit two-state benchmark, including physical CPTP evolution and quantitative relaxation; now a generator built from matrix-unit dissipators on an arbitrary finite index type, with exact population/coherence equations and the diagonal classical bridge | No generic GKSL characterization; no arbitrary finite-state evolution or CPTP semigroup has been constructed |
| #11 Quantum Perron-Frobenius | Two-state stationary uniqueness and attraction under the appropriate rate hypotheses, both-zero non-attraction; now exact equivalence between real diagonal quantum stationarity and classical `Qp = 0`, with stationary probability vectors giving stationary densities | No generic irreducibility, primitivity, stationary uniqueness, spectral-gap, or mixing theorem |
| #13 States, partial trace, purification | Qubit density examples and physical density evolution; convergence to the stationary density for positive total rate; now PSD and trace-one diagonals from arbitrary finite probability vectors | No partial-trace or purification layer; no generic density dynamics from the new Markov generator |
| #15 Kraus/Choi/Stinespring equivalences | Existing finite Kraus trace/positivity laws, all-finite-ancilla amplification, and the explicit normalized four-Kraus representation for the physical two-state evolution | No new channel result this round; representation equivalences remain outside the implementation |

In the Markov extension, `q i j` is the rate from source `j` to destination `i`, and self-jumps are excluded explicitly. Its central identity is `L_q(diag p) = diag(Qp)` for real `p`, with the real-to-complex coercion exposed. The generator has `H = 0`. Algebraic identities allow signed real rates; the rate interpretation and nonnegativity certificates use nonnegative off-diagonal rates. A stationary probability vector produces a stationary density without a rate-sign premise because that conclusion follows from the stated algebraic stationarity and probability hypotheses.

The two-state positivity/channel conclusions continue to require nonnegative rates and nonnegative time. Attraction requires positive total rate. At both zero rates the flow is the identity and there is no common attractor for all densities. The Frobenius estimate is centered in a trace fiber; it is not an uncentered Frobenius, trace-norm, or diamond-norm contraction theorem.

## The 39-row ledger

M = identified Mathlib endpoint; C = relevant source, reported candidate, or narrower candidate still requiring an exact reuse audit; U/P = unresolved full target or partial-only evidence. Labels abbreviate the original inventory without changing its row identity.

| ID | Area | Recorded disposition | Local status |
| ---: | --- | --- | --- |
| 1 | Register and circuits | C | Untouched |
| 2 | QFT unitarity | C | Untouched |
| 3 | Phase-estimation bounds | C | Untouched |
| 4 | Grover / amplitude amplification | C | Untouched |
| 5 | Shor chain | C | Untouched |
| 6 | Hohenberg-Kohn I / II | U/P | Untouched |
| 7 | Bloch theorem | C: finite seed only | Untouched; continuum target separate |
| 8 | Fermionic Fock / CAR | U/P | Untouched |
| 9 | Tight-binding / Hubbard | U/P | Untouched |
| 10 | GKSL characterization | C | Partly advanced; see scope above |
| 11 | Quantum Perron-Frobenius | C | Partly advanced; see scope above |
| 12 | Lieb-Robinson bounds | U/P | Untouched |
| 13 | State layer, partial trace, purification | C | Partly advanced; see scope above |
| 14 | POVMs / Born rule | C | Untouched |
| 15 | Kraus / Choi / Stinespring | C | Partly advanced; see scope above |
| 16 | Entropy inequalities | C | Untouched |
| 17 | No-go suite | C | Untouched |
| 18 | State discrimination | C | Untouched; general discrimination exceeds binary Helstrom candidates |
| 19 | Protocol verification | C | Untouched |
| 20 | Entanglement criteria | C | Untouched |
| 21 | Accessible-information Holevo bound | U/P | Untouched; dimension bounds do not settle this target |
| 22 | HSW | C | Untouched |
| 23 | Quantum error correction | C | Untouched; distance certificates do not settle every correctability target |
| 24 | Fidelity toolbox | C | Untouched |
| 25 | Quantum de Finetti | U/P | Untouched |
| 26 | Petz / approximate recovery | C | Untouched; quantitative Fawzi-Renner recovery remains separate |
| 27 | LP duality / complementary slackness | C | Untouched |
| 28 | Hall's marriage theorem | M | Reuse/reference row; not a local release result |
| 29 | Finite minimax | C | Untouched |
| 30 | Max-flow min-cut | C | Untouched |
| 31 | Verified simplex | U/P | Untouched |
| 32 | KKT | C | Untouched |
| 33 | Konig / Dilworth / Menger | C | Untouched; exact variants require separate contracts |
| 34 | Shortest paths / min-cost flow | C: shortest-path source | Untouched; min-cost flow separate |
| 35 | Matroid greedy optimality | C | Untouched |
| 36 | Bellman / MDPs | U/P | Untouched; partial discounted infrastructure does not settle full control |
| 37 | General-sum Nash existence | C | Untouched |
| 38 | Integer programming | U/P | Untouched |
| 39 | M/M/1 queueing | U/P | Untouched |

Hall's identified Mathlib declaration is `Finset.all_card_le_biUnion_card_iff_exists_injective`, as recorded in the corrected roadmap. The historical inventory's original missing-everywhere labels are not adopted here.

## Accepted sequence and next checkpoint

| Increment | Bounded deliverable | Cumulative exports | Theorem contracts |
| --- | --- | ---: | ---: |
| Stage 0 | Pinned baseline, qubit densities, finite Kraus trace laws | 15 | 10 |
| Dissipator | Generic finite dissipator algebra and qubit jumps | 42 | 33 |
| Stationary | Two-state stationary state, uniqueness, and rate boundaries | 72 | 61 |
| Evolution | Explicit flow, semigroup and derivative, trace/Hermiticity laws | 115 | 100 |
| Kraus | Four-Kraus physical flow, positivity and all-finite-ancilla CP | 158 | 139 |
| Convergence | Exact Frobenius split, centered estimate, limits, and boundaries | 187 | 167 |
| Markov | Arbitrary finite `H = 0` generator, diagonal bridge, stationary densities, and two-state recovery | 216 | 193 |

The **selected bounded Stage 4 generator bridge is complete** with this acceptance. The roadmap's wider diagonal-Hamiltonian and dynamical developments remain possible future contracts; they are not needed to accept this issued milestone and are not automatically the next assignment.

The next task is **Stage 5 release-readiness preparation**: preserve the accepted mathematics, integrate the audit and small wording fixes, prepare intelligible release documentation/provenance, and demonstrate fresh reproduction and downstream use from the verified archive. It introduces no new mathematical exports and does not publish a release or make an upstream submission. Owner decisions on project licensing and any final public-release/human-review gate remain distinct from completing a reviewable candidate. No round-count or elapsed-time forecast is implied.

## Evidence and record interpretation

This ledger uses `docs/PORTFOLIO_ROADMAP.md` for corrected reconnaissance, `docs/planning/MISSING_PROOFS_INVENTORY.md` for historical row identities, `audits/convergence/v1/PORTFOLIO_STATUS.md` for the previous accepted local ledger, and the current source, `exports.json`, handoff, and `evidence/markov/v1/inventory/declaration_inventory.json` for this increment. The accompanying independent audit supplies the acceptance decision and verification limits.

`docs/SCOPE_MEMO.md` is tracked planning documentation shipped in the archive. Its tiering and effort scenarios are not checked Lean results. Its pre-audit counts correctly separate six accepted pilot increments from the submitted extension; after integration those counts should reflect seven accepted increments overall. Its row #13 must retain the positive-total-rate condition for convergence. Broad claims that the portfolio can never be complete, or that six rows are research rather than formalization, should be replaced by the narrower observation that exact endpoints, prerequisites, and budgets remain unspecified. A demanding known theorem can still be a formalization task.

The candidate classifications above preserve the earlier reconnaissance, including its weaker reported and partial evidence. Before activating another row, inspect the exact statement, compatible pinned dependency closure, and provenance again. Nothing in this ledger upgrades a downstream candidate to a locally verified theorem.
