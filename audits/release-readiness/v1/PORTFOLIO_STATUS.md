# Formal-science portfolio status after release-readiness v1

Date: 21 September 2026. Source under review: `2a258df6654d1b3553d3affebd7e94405bb4e989`, tag `release-readiness-milestone-v1`. This ledger applies with the acceptance decision in the accompanying release-readiness audit. The mathematical source remains byte-identical to the accepted Markov snapshot. This is a record of local work, not a fresh global source search or a claim of novelty.

## Current tally

The two-state pilot is complete in **six accepted bounded increments**. The selected finite Markov generator bridge adds **one accepted Stage 4 extension**, making **seven accepted mathematical increments** overall. The public surface is **8 release modules, 216 exports, 193 theorem exports with consumer contracts, and 23 definitions or abbreviations**. Markov added 29 exports: 26 theorems and 3 definitions. Release readiness adds zero public exports and three anonymous usage examples outside the export inventory. The resulting tally is **seven accepted mathematical increments plus one release-readiness checkpoint**, not eight mathematical increments. API coverage counts are not comparable units of mathematical difficulty.

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

## Accepted mathematics in the four locally advanced areas

| Broad inventory row | Accepted local contribution, unchanged this round | Remaining broader scope |
| --- | --- | --- |
| #10 GKSL characterization | Complete explicit two-state benchmark, including physical CPTP evolution and quantitative relaxation; now a generator built from matrix-unit dissipators on an arbitrary finite index type, with exact population/coherence equations and the diagonal classical bridge | No generic GKSL characterization; no arbitrary finite-state evolution or CPTP semigroup has been constructed |
| #11 Quantum Perron-Frobenius | Two-state stationary uniqueness and attraction under the appropriate rate hypotheses, both-zero non-attraction; now exact equivalence between real diagonal quantum stationarity and classical `Qp = 0`, with stationary probability vectors giving stationary densities | No generic irreducibility, primitivity, stationary uniqueness, spectral-gap, or mixing theorem |
| #13 States, partial trace, purification | Qubit density examples and physical density evolution; convergence to the stationary density for positive total rate; now PSD and trace-one diagonals from arbitrary finite probability vectors | No partial-trace or purification layer; no generic density dynamics from the new Markov generator |
| #15 Kraus/Choi/Stinespring equivalences | Existing finite Kraus trace/positivity laws, all-finite-ancilla amplification, and the explicit normalized four-Kraus representation for the physical two-state evolution | Representation equivalences remain outside the implementation |

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

## Accepted sequence and checkpoint status

| Increment | Bounded deliverable | Cumulative exports | Theorem contracts |
| --- | --- | ---: | ---: |
| Stage 0 | Pinned baseline, qubit densities, finite Kraus trace laws | 15 | 10 |
| Dissipator | Generic finite dissipator algebra and qubit jumps | 42 | 33 |
| Stationary | Two-state stationary state, uniqueness, and rate boundaries | 72 | 61 |
| Evolution | Explicit flow, semigroup and derivative, trace/Hermiticity laws | 115 | 100 |
| Kraus | Four-Kraus physical flow, positivity and all-finite-ancilla CP | 158 | 139 |
| Convergence | Exact Frobenius split, centered estimate, limits, and boundaries | 187 | 167 |
| Markov | Arbitrary finite `H = 0` generator, diagonal bridge, stationary densities, and two-state recovery | 216 | 193 |
| Release readiness, a packaging checkpoint | Frozen API, owner-selected license and provenance, documentation, three usage consumers, reproduction of the exact source archive | 216, unchanged | 193, unchanged |

The **selected bounded Stage 4 generator bridge is complete**. The roadmap's wider diagonal-Hamiltonian and dynamical developments remain possible future contracts; they are not automatically active assignments.

The **bounded Stage 5 release-readiness candidate is accepted** with the accompanying audit. It preserves the accepted mathematics, supplies documentation and provenance, applies the owner-selected Apache-2.0 license to project material, compiles three existing-theorem consumers, and demonstrates recipient use of the delivered source archive. It does not establish a full Mathlib source rebuild, human semantic review, publication, novelty, or upstream acceptance.

The original roadmap's wider Stage 5 gate includes a stable downstream release and human review. This candidate's acceptance does not declare that broader gate, or "program version 1", fully complete. Applying the existing license decision does not imply publishing a release.

The immediate task is one ordinary audit-integration and documentation-closure commit. No new milestone tag, handoff archive, mathematical export, or repeated proof run is needed when the proof and consumer inputs remain unchanged. After that commit, no new mathematical implementation is active. The owner can separately choose human review/publication, a further bounded open-systems contract, or another portfolio branch. A new branch begins with a precise contract and a dependency/reuse probe, not an automatic expansion of this accepted candidate.

## Evidence and record interpretation

This ledger carries forward the corrected reconnaissance in `docs/PORTFOLIO_ROADMAP.md`, the historical row identities in `docs/planning/MISSING_PROOFS_INVENTORY.md`, and the accepted local status in `audits/markov/v1/PORTFOLIO_STATUS.md`. The current source freeze, export list, usage consumers, source/companion archives, and independent audit support the release-readiness status. Counts have not advanced because no mathematical source changed.

`docs/SCOPE_MEMO.md` is tracked planning documentation shipped with the source. Its tiering, effort scenarios, and reuse projections are not Lean results. The current audit's documentation corrections update its stale after-convergence contribution table to the Markov additions and keep candidate completion separate from human review/publication. No new completion percentage is inferred.

The candidate classifications above preserve earlier reconnaissance, including reported and partial evidence. Before activating another area, inspect its exact theorem statement, compatible pinned dependency closure, provenance, and current reuse evidence. Nothing in this ledger upgrades a downstream candidate to a locally verified theorem.
