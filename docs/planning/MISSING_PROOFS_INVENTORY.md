> Provenance note (added 20 September 2026): verbatim copy of the original
> gap inventory supplied as `updated list (1).md`, prepared 2026-09-19 before
> the research plan. Context only. Several of its "missing" statuses were
> corrected by `docs/PORTFOLIO_ROADMAP.md` (for example Hall's theorem is in
> Mathlib); consult that plan, not this list, for current status.

# Missing Lean/Mathlib proofs: materials science + quantum algorithms + quantum information theory + operations research

Inventory for Jake — what is missing from Mathlib (and, where noted, from Lean
entirely) that relates to materials science, quantum algorithms, quantum
information theory, and operations research. Every item below is pure
mathematics: all of it can be written and machine-checked now, no quantum
computer required.

Status key: **[Mathlib]** = missing from Mathlib itself (may exist in a
downstream library — noted where so). **[Lean]** = not formalized anywhere in
Lean as far as we can determine (Sept 2026).

## Background: what exists downstream (not in Mathlib)

- **QICLean** (lionsr/qiclean): finite-dimensional quantum information —
  density matrices, POVMs, Schmidt decomposition, purification, Wigner's
  theorem, channels in Kraus/Choi/Stinespring form, Kadison–Schwarz, quantum
  Perron–Frobenius, GKSL semigroups, entanglement theory, entropy. Some files
  still carry `sorry`s or axioms.
- **physlib** (leanprover-community/physlib): `QuantumInfo/` tree under
  construction — states, density matrices, von Neumann entropy, strong
  subadditivity, data-processing inequality, operator convexity.
- **csd-lean4** (zblore): quantum algorithms — Deutsch–Jozsa, Simon,
  Bernstein–Vazirani, swap/Hadamard tests, Grover, QFT, and Shor's algorithm
  end to end (order-finding by phase estimation, period recovery, factoring),
  adversarially audited.

Mathlib proper has the analytical ingredients (spectral theorem, roots of
unity, trig bounds, geometric sums, tensor products) but essentially no
quantum-native or materials-native content.

## Quantum algorithms — missing from Mathlib

1. **[Mathlib] n-qubit register + circuit model.** Definitions: the register as
   a tensor power of ℂ², unitary gates (H, CNOT, Toffoli, controlled-U),
   measurement in the computational basis with the Born rule
   (prob = ‖·‖²). The infrastructure everything else hangs off.
2. **[Mathlib] QFT unitarity.** The quantum Fourier transform as a Mathlib
   definition; unitarity via roots-of-unity orthogonality; action on
   computational basis states.
3. **[Mathlib] Phase estimation bounds.** Success/error bounds for phase
   estimation (ideal case plus the general Dirichlet-kernel ≥ 4/π² bound).
   Exists downstream in csd-lean4; not in Mathlib.
4. **[Mathlib] Grover / amplitude amplification.** The sin²((2k+1)θ) rotation
   analysis and the O(√N) query-complexity bound. Exists downstream; not in
   Mathlib.
5. **[Mathlib] Shor's chain.** Order-finding → continued-fraction period
   recovery → factoring from a nontrivial square root of 1, with the random-`a`
   success bound. The real cost is the classical number-theory tail (continued
   fractions), not the quantum core. Done end to end downstream in csd-lean4;
   not in Mathlib.

## Materials science — missing everywhere in Lean

6. **[Lean] Hohenberg–Kohn theorems I & II.** The foundation of density
   functional theory: the ground-state density determines the external
   potential (up to a constant), and the variational principle for the
   universal functional. Pure functional analysis + a variational argument.
   The crown jewel on this list.
7. **[Lean] Bloch's theorem.** Periodic Schrödinger operators: eigenstates can
   be chosen as Bloch waves, giving band structure. Needs spectral theory of
   periodic operators / Floquet theory.
8. **[Lean] Fermionic Fock space + CAR.** The canonical anticommutation
   relations and the fermionic Fock-space construction. Prerequisite for 9.
   (Mathlib has exterior algebra; the CAR/Fock layer is not there.)
9. **[Lean] Tight-binding / Hubbard model basics.** Second-quantized lattice
   Hamiltonians stated and shown well-defined; elementary spectral properties.
10. **[Lean] GKSL characterization theorem, sorry-free.** The complete
    characterization of generators of completely-positive trace-preserving
    semigroups (Lindblad form). QICLean has GKSL semigroups with gaps; a
    gap-free Mathlib version is open. Directly serves the wells-as-qubits v2
    line: asymmetric jump operators and stationary states of Lindbladians are
    exactly this machinery (v2's Lean formalization is queued behind review).
11. **[Lean] Quantum Perron–Frobenius.** Uniqueness (and attractivity) of the
    stationary state for irreducible/primitive Lindbladians. Partial coverage
    in QICLean (irreducibility, primitivity, peripheral spectrum); the full
    uniqueness theorem in Mathlib is open.
12. **[Lean] Lieb–Robinson bounds.** Finite propagation speed for information in
    quantum lattice systems. Core many-body result, no Lean formalization known.

## Quantum information theory

Downstream coverage is strongest here, so the list splits into "port into
Mathlib" vs "prove from scratch".

### Exists downstream, missing from Mathlib proper

13. **[Mathlib] State layer.** Density matrices (PSD, trace 1), the partial
    trace, and purification — every mixed state as the reduction of a pure
    state. In QICLean; density-matrix evolution/measurements/distinguishability
    on physlib's roadmap.
14. **[Mathlib] POVMs + Born rule.** General measurements as positive
    operator-valued measures; outcome probabilities via the Born rule.
15. **[Mathlib] Quantum channels.** CPTP maps in Kraus, Choi, and Stinespring
    representations, with the equivalences between them. In QICLean and
    csd-lean4; not in Mathlib.
16. **[Mathlib] Entropy core.** Von Neumann entropy and quantum relative
    entropy; strong subadditivity and the data-processing inequality (both
    proved in physlib, the latter via the operator-convexity stratum ported
    from the Hayata group); Klein's inequality, subadditivity, Araki–Lieb.
17. **[Mathlib] No-go suite.** No-cloning, no-broadcasting, no-deleting,
    no-communication theorems. In csd-lean4; not in Mathlib.
18. **[Mathlib] State discrimination.** Helstrom minimum-error measurement,
    unambiguous state discrimination.
19. **[Mathlib] Protocols verified.** Teleportation and superdense coding as
    machine-checked protocols. In csd-lean4; not in Mathlib.
20. **[Mathlib] Entanglement criteria.** PPT and reduction criteria,
    entanglement witnesses, Schmidt number, separability. In QICLean; not in
    Mathlib.

### Missing everywhere in Lean (to our knowledge)

21. **[Lean] Holevo bound.** Upper bound on accessible information from a
    quantum ensemble. The single most-cited missing QIT theorem.
22. **[Lean] HSW theorem.** Classical capacity of a quantum channel
    (Holevo–Schumacher–Westmoreland coding theorem).
23. **[Lean] Quantum error correction.** Knill–Laflamme conditions for
    correctability; the stabilizer formalism. (One repo has stubs ending in
    `sorry`; no completed formalization known.)
24. **[Lean] Fidelity toolbox.** Uhlmann fidelity, Fuchs–van de Graaf
    inequalities relating fidelity and trace distance.
25. **[Lean] Quantum de Finetti theorem.** Symmetric states approximated by
    mixtures of product states. Workhorse of QKD security proofs.
26. **[Lean] Petz recovery / approximate recoverability.** Reversibility of
    channels on states saturating the data-processing inequality
    (Fawzi–Renner bounds).

Note: items 10–11 (GKSL characterization, quantum Perron–Frobenius) sit in
both worlds — open quantum systems *is* quantum information theory.

## Operations research

Downstream Lean work clusters around linear programming and game theory; the
combinatorial-optimization and stochastic sides are nearly empty.

### Exists downstream, missing from Mathlib proper

27. **[Mathlib] LP strong duality + complementary slackness.** Weak/strong
    duality and strict complementary pairs, sorry-free in EconCSLib
    (gametheoryinlean/econcslib); Farkas' lemma in several forms via
    Fourier–Motzkin in jmoy/farkas_lean; LP duality over extended ordered
    fields in arXiv:2409.08119. None of it is in Mathlib itself.
28. **[Mathlib] Hall's marriage theorem.** Formalized against Lean 3 mathlib
    (arXiv:2101.00127); Mathlib4 port status unclear — verify before claiming
    the gap.
29. **[Mathlib] von Neumann minimax.** Minimax theorem for finite matrix games
    via the LP bridge (EconCSLib has the bridge layer); their open item is a
    *callable verified solver* producing a certified Nash equilibrium
    (issue #17), not just the existence theorem.

### Missing everywhere in Lean (to our knowledge)

30. **[Lean] Max-flow min-cut theorem.** The central theorem of network
    optimization — no Lean formalization known, despite textbooks deriving
    Hall, König, and Dilworth from it.
31. **[Lean] Verified simplex algorithm.** Mathlib's `linarith` ships an
    *unverified* simplex oracle (no correctness theorem); Coq-Polyhedra has a
    verified simplex with no Lean port. A 2026 repo attempts a verified
    homogeneous self-dual interior-point method (completeness unclear).
32. **[Lean] KKT conditions.** First-order optimality for constrained convex
    problems. (Sufficiency follows from Farkas; necessity wants minimax —
    items 27/29 are the on-ramp.)
33. **[Lean] König / Dilworth / Menger.** Matching–covering duality beyond
    Hall; Menger's disjoint-paths theorems.
34. **[Lean] Shortest paths + min-cost flow.** Dijkstra correctness,
    potentials, min-cost flow optimality.
35. **[Lean] Matroid greedy optimality.** Mathlib has a matroid library; the
    theorem that the greedy algorithm optimizes linear weights over a matroid
    is the missing payoff.
36. **[Lean] Bellman optimality / MDPs.** The optimality principle for finite
    Markov decision processes — the foundation dynamic programming rests on.
37. **[Lean] Nash existence, general-sum.** Beyond zero-sum/minimax: existence
    of mixed Nash equilibria via fixed-point arguments.
38. **[Lean] Integer programming.** Branch-and-bound correctness,
    cutting-plane validity, total unimodularity.
39. **[Lean] Queueing basics.** M/M/1 steady-state distribution — the entry
    point of applied stochastic OR.

## Suggested attack order

- Fastest Mathlib wins: 1 → 2 → 3 → 4 (each unlocks the next; downstream
  libraries show the statements are formalizable).
- Materials flagship: 6 (Hohenberg–Kohn) — self-contained, high prestige, no
  dependency on the algorithm track.
- Serves our own line: 10 → 11 (GKSL + quantum Perron–Frobenius back the v2
  well-qubit math: symmetry-breaking jump operators, stationary-state
  uniqueness).
- QIT: port 13 → 16 → 15 first (state layer, entropy core, channels — the
  dependency spine everything else hangs off); then prove 21 (Holevo bound)
  from scratch as the flagship.
- OR: port 27 (LP duality is sorry-free downstream — cheapest win on the
  list); then prove 30 (max-flow min-cut) from scratch — it unlocks 28/33/34
  the way textbooks say it should.

Prepared 2026-09-19. Statuses are "to our knowledge" — downstream repos move
fast; verify against current sources before claiming a gap in review.
