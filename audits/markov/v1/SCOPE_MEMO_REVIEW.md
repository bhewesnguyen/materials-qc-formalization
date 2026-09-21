# Scope memo and live documentation review after the Markov submission

## Status and authority

D018 records the user's choice to track `docs/SCOPE_MEMO.md`. That choice supersedes the older assignment sentence prohibiting it. Accept the move; do not remove the memo or request permission again. The memo is a shipped planning document outside the Lean export and proof gate. The current text correctly separates the six-increment two-state benchmark, the Stage 4 extension, and Stage 5. Its current under-audit labels and 187/167 accepted counts are accurate for its pre-Markov-acceptance date and should advance when acceptance is recorded.

The revised Hamiltonian restriction, non-CP Euler warning, centered Frobenius interpretation, disjoint tier counts, withdrawal of the 40-session estimate, source-candidate caveats, and recognition of specification effort are sound improvements. None of the remaining items changes a Lean theorem or invalidates the milestone.

## Corrections for the release-readiness turn

1. **README, opening scope exclusion.** It says the release proves nothing in general finite dimension beyond the generic Kraus and dissipator layers. The submitted Markov bridge is itself a general finite-dimensional generator result. Replace with: "Beyond the generic finite Kraus and dissipator laws and the finite Markov generator bridge, the dynamical and convergence results concern the explicit two-state model. General finite-state CPTP dynamics and convergence are not established here."

2. **Memo row 13, convergence qualification.** "Convergence of every density to the stationary density" omits positive total rate. Replace with "convergence of every density to the stationary density for nonnegative rates with positive total rate; the both-zero case has no common attractor." The more detailed surrounding paragraphs have the right condition, but the table should remain correct when quoted alone.

3. **Memo Section 1, impossible-completion claim.** "The 39-area portfolio is not something that will ever read 100 percent" is stronger than the record supports. Replace with "The current 39-area inventory does not yet define a meaningful single completion percentage. Each area needs explicit, bounded endpoints before a completion target can be assessed." Section 5 already makes this more defensible point.

4. **Memo Section 1, research versus formalization.** "About six ... are research projects ... not formalization tasks" creates a false separation. These are mathematical/formalization research programs whose contracts and dependencies remain insufficiently specified. The tiering is a planning judgment, not evidence that their mathematics is unproved or that they cannot be formalized.

5. **Memo Tier B effort language.** "One audit round each" has no basis for finite CAR, Hubbard, MDP, or queueing endpoints. Replace with "one bounded contract at a time; audit rounds and dependency effort remain to be determined." The memo's warning against transferring pilot velocity should apply here as well.

6. **Memo Section 6, reuse shortcuts.** Replace "Hall: nothing to do beyond citing" with "an existing Mathlib endpoint is identified; a concrete application still needs a statement and assumption match, import and consumer check at the pin." Replace "CAR/Hubbard: no dependency decision required" with "a finite target may reuse the current pin, subject to source comparison and a bounded representation/dependency decision." No new branch is authorized.

7. **Terminology for the tracked memo.** "Not a release artifact" is ambiguous when the file is in the release archive and its manifest. Prefer "a shipped planning document, outside the Lean export inventory and proof gate." This is descriptive clarification, not a need to add it to `exports.json`.

## Tally on acceptance

Seven accepted mathematical increments comprise the six-increment two-state benchmark and the finite Markov generator bridge extension: eight modules, 216 exports, 193 theorem contracts, 23 definitions/abbreviations. The 39-area ledger remains 1 identified Mathlib reuse endpoint, 4 broadly advanced rows (10, 11, 13, 15), and 34 without local implementation; zero broad rows newly completed. The new bridge strengthens partial contributions to rows 10, 11, and 13 but does not turn them into generic GKSL, Perron-Frobenius, or a complete quantum state library.

Stage 5 release readiness is the appropriate next bounded checkpoint. Its completion is separate from choosing the next research branch, public publication, owner human review, and upstream acceptance.
