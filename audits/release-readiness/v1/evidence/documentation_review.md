# Release-readiness documentation and usage review

Reviewed the submitted archive at `audit_release_readiness/submitted/formal-science` against the frozen assignment `audits/markov/v1/NEXT_FABLE_TASK.md`, the prior `SCOPE_MEMO_REVIEW.md`, and the accepted source definitions and theorem signatures. No submitted source was edited. This review is limited to semantics and documentation; root independently checks archive identity, freeze, runtime, provenance, and licenses.

## Conclusion

The release guide broadly represents the accepted mathematics correctly. The three usage examples meet the assignment exactly, and no new named declaration or import framework is introduced. No mathematical defect was found. The previous M1 and seven M2 wording corrections are closed. A small documentation correction pass is warranted for inaccurate API assumptions, namespace usability, one incorrect human-authorship phrase, and the stale portfolio contribution table. These do not require proof changes, new exports, or a repeated mathematical milestone.

## Concrete findings

### R1. API guide is not yet exact about names and assumptions

`docs/API_GUIDE.md:82` says that `rhoStar_zero_left`, `rhoStar_zero_right`, and `rhoStar_same` require `b ≠ 0`, `a ≠ 0`, and `r ≠ 0`, respectively. The first condition is incorrect: `FormalScience.OpenSystems.rhoStar_zero_left (b : ℝ)` is unconditional, as its source and docstring explicitly state (`TwoStateStationary.lean:220-224`). It applies even at both rates zero. Replace the first condition with "none" or split the grouped row. Do not alter the accepted theorem.

The guide uses short names and abbreviated suffixes even though the assignment explicitly asks for full Lean theorem names. More concretely, its setup at lines 13-17 opens `FormalScience.Stage0` and `FormalScience.OpenSystems`, but not `FormalScience.Quantum`. Consequently, `krausMap_posSemidef`, `amplify`, `amplify_krausMap`, and `amplify_kronecker` in its generic Kraus table are unresolved under that setup. Module names are not declaration namespaces: e.g. `FormalScience.OpenSystems.Dissipator.dissipator_trace` is not the declaration; `FormalScience.OpenSystems.dissipator_trace` is. Use fully qualified declaration names as requested, expand suffix abbreviations, and either qualify quantum uses or add `open FormalScience.Quantum` to the setup. Full import paths would similarly make the import list immediately usable.

The accepted off-diagonal theorems `markovGenerator_apply_of_ne` and `rateMatrix_nonneg_of_ne` additionally carry the selected-index premise `i ≠ j`; the prose says "coherences" / "off-diagonal", so it does not claim a false formula when read as a whole, but the guide promises actual assumptions. Add `i ≠ j` explicitly to those assumption entries. Change the introduction from "Every declaration ... has a fully spelled-out consumer" to distinguish theorem contracts from definitions anchored by their formula consumers.

The isolated `work/DocsConsumerProbe.lean` confirms the namespace failure with an expected-error guard and confirms the fully qualified names and unconditional boundary consumers at the pinned runtime. It exits 0. Its output is retained beside the probe. It is audit evidence, not project release API.

### R2. Readiness record incorrectly calls the contracts human-written

`docs/RELEASE_READINESS.md:89-90` says "the contract statements are human-written and were read by the implementer and the auditor". This conflicts with D021 and the nearby explicit disclosure that implementation and independent audit were AI-agent work without human semantic review. Replace with: "The contract statements are written explicitly and were semantically reviewed by the implementation and audit agents; the textual check alone does not validate their meaning. No human semantic review is recorded."

This is a localized provenance misstatement, not evidence that the project conceals AI involvement: NOTICE, D021, README, handoff, and readiness Section 5 all state the distinction clearly.

### R3. Memo table is still the convergence-era contribution ledger

`docs/SCOPE_MEMO.md:119-123` still cites `audits/convergence/v1/PORTFOLIO_STATUS.md` and labels the column "Local contribution after convergence". Rows 10, 11, and 13 consequently omit the accepted finite Markov generator, diagonal stationary equivalence, and arbitrary-finite probability-vector density construction. The introduction and totals have advanced to Markov acceptance, and Section 6 knows that extension is accepted.

Update this table's source link and epoch to the accepted Markov ledger, and add its existing partial contributions to rows 10, 11, and 13. Keep all four partial-row statuses, 34 locally untouched rows, and zero broad-row closures unchanged. This repairs internal currency; it should not trigger another general scope-memo rewrite.

## Small historical reference correction

`CHANGELOG.md`, Kraus entry, labels the evolution-module docstring-only correction as "(E1)". E1 was the README scope correction. The evolution audit called the module docstring change an optional copy edit, recorded under D013. Replace the parenthetical with "optional copy edit recorded in D013". This is a record correction and can be bundled with R3 rather than given another formal finding.

## What was checked and is correct

- M1: README now explicitly includes the generic finite Markov bridge; general finite-state dynamics and convergence remain excluded. Naming the per-module scope paragraphs as authoritative is sensible.
- M2: all seven requested corrections were applied: positive total rate in row 13; no unsupported impossible-completion claim; research-scale formalization wording; no one-round forecast; Hall and CAR/Hubbard reuse caveats; shipped planning-document status; updated accepted counts. The remaining R3 issue concerns the table's epoch and contribution content, not failure to apply those seven corrections.
- Guide conventions correctly state destination-first rates, ignored diagonal rates, zero Hamiltonian, signed algebraic hypotheses, physical nonnegative rates/time, positive total rate for attraction, trace-scaled equilibrium for general inputs, centered Frobenius norm, arbitrary finite ancillas, and generator identities rather than a generic semigroup.
- `examples/Usage.lean` imports only the public umbrella. There are exactly three anonymous examples and no named theorem/definition: density preservation; density convergence with positive total rate and the target-density conjunction; a `Fin 3` signed-rate diagonal bridge with explicit real-to-complex embedding.
- Example proofs directly apply the corresponding accepted theorems. Their assumptions match the export signatures, and the zero-total-rate exception is explained nearby.
- The guide points to the compiled examples instead of maintaining divergent snippets.
- README, handoff, and readiness distinguish mathematical acceptance, candidate packaging/reproduction, human review, publication, and novelty. No public release or upstream claim is asserted.
- D021 is an explicit recorded owner selection and the issued task allows applying an existing owner license decision. Treat it as recorded authorization, not a new permission blocker. Licensing scope and external-source facts are left to root's separate review.
- Counts are consistent at 8 modules, 216 exports, 193 distinct theorem contracts, 23 definitions/abbreviations, seven mathematical increments.
- Reviewed live documents and example comments contain no em dashes.

## Evidence files

- `work/docs_checks.json`: reviewed paths, namespace map, example/import scan, no-em-dash scan, and probe result.
- `work/DocsConsumerProbe.lean`, `.stdout.log`, `.stderr.log`: targeted pinned-toolchain consumer evidence. The stderr log is empty.

Recommended audit disposition: mathematical surface and requested consumers accepted; technical candidate acceptance can remain distinct from these bounded documentation corrections and from any later publication decision. Avoid new proof work or a broad project redesign to close these findings.
