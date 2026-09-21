# Formal-science portfolio status after Kraus v1

Date: 21 September 2026. This ledger accompanies the Kraus audit for source commit `6431c9cd411a3a804d2a86ae733e23f393fe9361`. It is a reconciliation of the recorded portfolio with the accepted local work, not a fresh global search or a claim of novel mathematics.

## Accurate high-level tally

The inventory contains **39 areas**, not 39 individual theorem contracts. They split into 5 quantum-algorithm areas, 7 materials/open-system areas, 14 quantum-information areas, and 13 operations-research areas.

The original inventory's missing-everywhere labels must not be repeated as current findings. The corrected portfolio identifies Hall (#28) in Mathlib. That item is a reuse/reference item, leaving **38 areas in the assess/reuse/extend backlog**, not 38 established formalization gaps.

For a mutually exclusive planning tally, the recorded reconnaissance can be grouped as follows:

| Branch | Total areas | Already resolved by the identified Mathlib target | Relevant source, reported candidate, or narrower source candidate | No matching full endpoint established, including partial-only cases |
| --- | ---: | ---: | ---: | ---: |
| Quantum algorithms, #1-5 | 5 | 0 | 5 | 0 |
| Materials/open systems, #6-12 | 7 | 0 | 3 | 4 |
| Quantum information, #13-26 | 14 | 0 | 12 | 2 |
| Operations research, #27-39 | 13 | 1 | 8 | 4 |
| Total | 39 | 1 | 28 | 10 |

The 28-candidate column is not an assertion that those 28 broad targets are complete. In particular, the finite Bloch seed is much narrower than continuum Bloch theory, a QEC distance certificate is not every correctability theorem, and a shortest-path proof does not settle min-cost flow. The ten unresolved or partial-only areas are #6, #8, #9, #12, #21, #25, #31, #36, #38, and #39. These have **no matching full endpoint established in the recorded search scope**, not a proof that no formalization exists.

## Row-level reconciliation

Legend: M = identified Mathlib endpoint; C = relevant source/reported candidate or narrower source candidate, still requiring exact reuse audit; U/P = unresolved full target or partial-only evidence. Local progress is narrower than the inventory label.

| ID | Area | Recorded portfolio disposition | Current local contribution |
| ---: | --- | --- | --- |
| 1 | Register and circuits | C: downstream state/circuit infrastructure | None; no circuit model in the pilot |
| 2 | QFT unitarity | C: Mathlib Fourier ingredients and downstream endpoint | None |
| 3 | Phase-estimation bounds | C: downstream candidates | None |
| 4 | Grover/amplitude amplification | C: downstream candidates | None |
| 5 | Shor chain | C: substantial downstream development | None |
| 6 | Hohenberg-Kohn I/II | U/P: full endpoint not established | None |
| 7 | Bloch theorem | C: reported finite circulant seed only | None; continuum target unresolved |
| 8 | Fermionic Fock/CAR | U/P: finite-mode contract needed | None |
| 9 | Tight-binding/Hubbard | U/P: model contract needed | None |
| 10 | GKSL characterization | C: QICLean finite-dimensional iff source candidate | Explicit dissipator, two-state generator, and CPTP semigroup for nonnegative rates and time, with a four-Kraus formula on all matrices and matrix-valued ODE identities; no generic GKSL characterization |
| 11 | Quantum Perron-Frobenius | C: positive-map/irreducibility/primitivity machinery | Specific two-state stationary uniqueness and an explicit CPTP flow fixing stationary matrices; no convergence/attractivity or generic PF theorem yet |
| 12 | Lieb-Robinson bounds | U/P: endpoint not established | None |
| 13 | State layer, partial trace, purification | C: several downstream implementations | Qubit density predicate, basis densities, diagonal-state validity, and density preservation by the physical two-state flow; no partial trace/purification |
| 14 | POVMs/Born rule | C: downstream infrastructure | None |
| 15 | Kraus/Choi/Stinespring equivalences | C: downstream candidates | Finite Kraus trace/positivity laws, amplification over every finite ancilla dimension, and a normalized four-Kraus certificate for the evolution; no Kraus/Choi/Stinespring representation equivalences |
| 16 | Entropy inequalities | C: downstream infrastructure/endpoints | None |
| 17 | No-go suite | C: downstream candidates | None |
| 18 | Discrimination | C: binary Helstrom candidates | None; unambiguous discrimination separate |
| 19 | Protocol verification | C: teleportation/coding candidates | None |
| 20 | Entanglement criteria | C: downstream candidates | None |
| 21 | Accessible-information Holevo bound | U/P: inspected dimension bounds do not settle target | None |
| 22 | HSW | C: operational-capacity equality source and paper | None |
| 23 | Quantum error correction | C: reported stabilizer/CSS/distance coverage | None; general correctability target separate |
| 24 | Fidelity toolbox | C: Uhlmann and Fuchs-van de Graaf source | None |
| 25 | Quantum de Finetti | U/P: inspected symmetry source stops short of full theorem | None |
| 26 | Petz/approximate recovery | C: Petz and equality candidates | None; quantitative Fawzi-Renner separate |
| 27 | LP duality/slackness | C: downstream source and formal literature | None |
| 28 | Hall | M: explicit Mathlib4 declaration | Reuse/reference item; removed from missing-theorem queue |
| 29 | Finite minimax | C: EconCSLib source | None |
| 30 | Max-flow min-cut | C: CLRS-Lean candidate | None |
| 31 | Verified simplex | U/P: tactic oracle is not algorithm correctness | None |
| 32 | KKT | C: Optlib and primary formalization paper | None |
| 33 | Konig/Dilworth/Menger | C: source/reported variants | None |
| 34 | Shortest paths/min-cost flow | C: shortest-path source | None; min-cost flow separate |
| 35 | Matroid greedy | C: Mathlib foundations and reported greedy endpoint | None |
| 36 | Bellman/MDPs | U/P: discounted infrastructure, full control endpoint not established | None |
| 37 | General-sum Nash existence | C: EconCSLib endpoint | None |
| 38 | Integer programming | U/P: split cuts, branch-and-bound, certificates, TU | None |
| 39 | M/M/1 | U/P: full matching endpoint not established | None |

After acceptance of the Kraus milestone, project progress is **five accepted bounded increments** (Stage 0, dissipator, stationary, evolution, Kraus), involving six release modules and 158 exports: 139 theorem consumer contracts and 19 definitions/abbreviations. The Kraus increment adds 43 exports: 39 theorems and four definitions. These counts are verification coverage, not mathematical novelty or percentage of the portfolio complete. None of #10, #11, #13, or #15 is closed at its full inventory scope by this pilot.

## What is complete locally

| Milestone | Accepted deliverable | Evidence scope |
| --- | --- | --- |
| Stage 0 | Pinned Lean/Mathlib baseline, qubit density examples, finite Kraus trace identities | 15 exports and 10 theorem consumer contracts at that milestone |
| Dissipator | Finite dissipator algebra, trace annihilation, Hermiticity preservation, qubit jump specializations | 42 cumulative exports and 33 theorem consumer contracts |
| Stationary | Weighted two-state generator, component equations, stationary density, algebraic uniqueness, physical and degenerate-rate cases | 72 cumulative exports and 61 theorem consumer contracts |
| Evolution | Explicit complex-linear flow on every complex qubit matrix, all-real semigroup and matrix-valued derivative, trace/Hermiticity laws, fixed states, and correct signed zero-total-rate flow | 115 cumulative exports and 100 theorem consumer contracts |
| Kraus | Normalized four-Kraus certificate equal to the physical evolution on every matrix; positive-semidefinite and density preservation; complete positivity for every finite ancilla dimension, including arbitrary correlated positive inputs | 158 cumulative exports and 139 theorem consumer contracts |

The four broad areas touched locally (#10, #11, #13, #15) overlap through shared foundations. Do not add them to obtain a separate completion count. There is no defensible percentage complete for an inventory whose rows have not yet been decomposed into comparable theorem contracts.

## Next checkpoint

The next bounded task is `convergence`: define an explicit Frobenius norm and prove quantitative relaxation of the accepted flow toward `trace(X) • rhoStar(a,b)` for every complex qubit matrix X, under `gamma=a+b>0` and `t>=0`. The assignment includes trace-one and density specializations, explicit population/coherence decay, and convergence in the canonical matrix topology. Physical density conclusions retain the nonnegative-rate assumptions.

The both-zero-rate boundary must distinguish identity evolution from attraction: every initial matrix remains fixed, so there is no common stationary state attracting all density inputs. This does not mean those constant trajectories fail to converge to their own initial states.

The current assignment is issued with this audit as `NEXT_FABLE_TASK.md`; the root copy becomes the mutable active slot after the immutable issued copy is stored under `audits/kraus/v1/`. The original roadmap grouped explicit evolution, channels, and convergence under Stage 3; the channel checkpoint is now accepted and quantitative convergence remains outstanding.

The accepted complete-positivity result applies to nonnegative rates and nonnegative time and quantifies over every finite ancilla dimension and arbitrary positive-semidefinite joint input. It is stronger than positivity on qubit inputs or product states alone. The underlying real-line evolution remains available for signed rates and negative time as a mathematical extension; no channel interpretation is asserted there. No convergence result is credited in this ledger yet.

## Repository evidence and provenance

All paths below are relative to the submitted `formal-science` repository root.

- `docs/PORTFOLIO_ROADMAP.md`, sections "Evidence levels and reproducible provenance" and "Inventory 1-5" through "Inventory 34-39": authoritative corrected reconnaissance used for the 1/28/10 classification. Its M/S/R/P/U statuses record different evidence strengths; a candidate is not an audited dependency.
- `docs/planning/MISSING_PROOFS_INVENTORY.md`: original 39-item inventory, retained as historical input. Its provenance note directs readers to the corrected roadmap. Its original missing-everywhere labels are not adopted here.
- `FormalScience/Stage0.lean`: implemented density and finite Kraus scope.
- `FormalScience/OpenSystems/Dissipator.lean`: implemented finite dissipator scope.
- `FormalScience/OpenSystems/TwoStateStationary.lean`: implemented two-state stationary scope.
- `FormalScience/OpenSystems/TwoStateEvolution.lean`: implemented explicit flow, semigroup, matrix-valued derivative, trace/Hermiticity preservation, fixed states, and signed-rate boundary behavior.
- `FormalScience/Quantum/FiniteKraus.lean`: finite Kraus positivity, independently defined block amplification, equality with the lifted Kraus map, and positivity for every finite ancilla dimension.
- `FormalScience/OpenSystems/TwoStateKraus.lean`: normalized four-Kraus family, equality with evolution on arbitrary matrices for physical rates/time, density preservation, and all-finite-ancilla positivity with the tensor-order bridge.
- `exports.json` and `Audit/Contracts.lean`: cumulative release/export coverage and independently stated theorem consumer types.
- `evidence/kraus/v1/verification/`: submitted final Kraus verification records. Earlier milestone evidence remains preserved at its recorded paths.
- `audits/stage0/v1/`, `audits/dissipator/v1/`, `audits/stationary/v1/`, `audits/evolution/v1/`, and this returned `audits/kraus/v1/` report: audit decisions and their stated limits.

The 28 candidate-bearing rows and ten unresolved/partial-only rows preserve the scope of the earlier reconnaissance. Recheck exact source statements and dependency closure when activating a row. No statement here upgrades an external source candidate to a locally verified theorem.
