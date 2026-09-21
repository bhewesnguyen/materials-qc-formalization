# Release-readiness v1: bounded documentation corrections

All findings are low severity and nonblocking. The exact candidate is accepted.
Close these while integrating the audit, keeping the accepted Lean, contracts,
exports, scripts, pins and examples unchanged. No new candidate tag or audit
round is requested.

## R1: API names and assumptions

In `docs/API_GUIDE.md`:

- `FormalScience.OpenSystems.rhoStar_zero_left` is unconditional, even at
  `b = 0`. Replace its listed `b ≠ 0` premise with none. The zero-right and
  same-rate identities retain `a ≠ 0` and `r ≠ 0` respectively.
- Use full declaration names and full import paths. Expand suffix shorthand.
  Module names are not automatically declaration namespaces.
- Generic Kraus names are under `FormalScience.Quantum`, which the displayed
  setup does not open. Qualify those uses or add the appropriate opening.
  The fully qualified names include `FormalScience.Quantum.krausMap_posSemidef`,
  `FormalScience.Quantum.amplify`, `FormalScience.Quantum.amplify_krausMap`, and
  `FormalScience.Quantum.amplify_kronecker`.
- State `i ≠ j` explicitly for the selected off-diagonal entries in
  `FormalScience.OpenSystems.markovGenerator_apply_of_ne` and
  `FormalScience.OpenSystems.rateMatrix_nonneg_of_ne`.
- Distinguish direct consumer contracts for public theorems from the formula
  consumers that anchor public definitions. Do not say every definition has
  its own theorem-contract entry.

The returned `evidence/DocsConsumerProbe.lean` confirms the namespace issue
with an expected-error guard and consumes the unconditional boundary identity.
The canonical `examples/Usage.lean` already compiles correctly.

## R2: authorship and review wording

Replace the readiness Section 4 phrase about human-written contracts with:

> The contract statements are written explicitly and were semantically reviewed
> by the implementation and independent audit agents. The textual check alone
> does not validate their meaning. No human semantic review is recorded.

In `docs/PROVENANCE_AND_LICENSES.md`, narrow the claim that every later document
was produced by the implementation agent to implementation-authored files.
Preserve the separately identified auditor reports, issued tasks, evidence and
pre-repository planning origins. Keep the existing AI-assistance disclosure and
the recorded Apache-2.0 owner decision; this correction does not change licensing.

## R3: current contribution table and history

In `docs/SCOPE_MEMO.md`, Section 4, advance the source link and column heading
from the convergence ledger to the accepted Markov contribution ledger. Update
only the already established additions:

- Row 10: arbitrary finite `H = 0` matrix-unit generator and diagonal bridge.
- Row 11: diagonal stationary iff `Qp = 0`; stationary probabilities give
  stationary densities, without generic uniqueness or mixing.
- Row 13: finite probability vectors give complex PSD trace-one diagonals.
- Row 15 remains unchanged. Four rows remain partly advanced; no broad row closes.

In `CHANGELOG.md`, Kraus entry, replace the evolution docstring change's `(E1)`
reference with `optional copy edit recorded in D013`. E1 concerned README scope.

M1 and all seven M2 wording corrections are closed. Preserve historical audits,
handoffs, decisions and source tags. These changes belong only in live records.
