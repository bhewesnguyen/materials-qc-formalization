# Review of the personal scope memo

Input: `upload/SCOPE_MEMO_2026-09-20.md`, refreshed after the convergence handoff. This is personal planning context, explicitly untracked and outside the submission. None of the points below invalidates a release theorem or requires modifying or committing the memo. Preserve its status as a personal note.

## What it gets right

The memo correctly separates local API counts from progress across heterogeneous research areas. It describes the convergence target as trace(X) times rhoStar and the quantitative estimate as a Frobenius estimate in a trace fiber. It correctly excludes generic GKSL, Perron-Frobenius, trace norm, diamond norm, representation equivalences, and mathematical novelty. Its reuse/porting cautions and the distinction between a mathematical pilot and a downstream release are sound. Choosing the finite Markov bridge next follows the original roadmap and reuses real accepted algebra.

## Corrections and qualifications

1. **The seven-checkpoint label combines different scopes.** The mathematical two-state pilot has six accepted increments after convergence acceptance: stage0, dissipator, stationary, evolution, kraus, convergence. The Stage 4 extension is beyond that pilot. Stage 5 release work is separate again. Thus "pilot 5 of 7, one pending, one remaining" is an internally chosen program counter, not the original pilot's completion fraction. Prefer "two-state pilot: six increments accepted; selected Stage 4 extension next; Stage 5 release later." Before acceptance, say five accepted and one under audit.

2. **An arbitrary Hamiltonian does not preserve diagonal inputs.** Section 6 drops the roadmap's diagonal-Hamiltonian restriction when displaying L(X)=-i[H,X]+sum q_ij D[E_ij](X) and L(diag p)=diag(Qp). Take H=[[0,1],[1,0]], p=(1,0), and all q=0. Then -i[H,diag p]=[[0,i],[-i,0]], while diag(Qp)=0. The bridge requires H=0, diagonal H, or a commutation hypothesis for the particular input. The selected first bridge milestone uses H=0. The generic Kraus positivity layer is useful for later evolution work, but it does not itself construct a CPTP semigroup for this finite generator.

3. **The tier counts overlap and do not justify a lower bound.** Tier A's 28 rows include rows 7 and 27, whose finite/exact alternatives also appear in Tier B. The explicitly listed B set has six rows: 8,9,36,39,7,27. It is not a disjoint additional block. The 28+6+6+1 tier tally double-counts exactly those two A/B rows. A session estimate multiplied by an overlapping set is not a lower bound, even before accounting for shared infrastructure, partial source coverage, and the uncertain meaning of a session. Replace the "near 40 sessions lower bound" with scenario budgets for a small selected subset after exact contracts are fixed. The 3-7 rounds to a program release is also a planning scenario, not a validated forecast.

4. **Candidate status does not mean a full row is already reported proved.** C means relevant source or a reported candidate, potentially narrower than the row. It is too strong to say that all 28 A rows already report the result. The roadmap explicitly records partial state infrastructure, finite Bloch seeds, and narrower coding/optimization endpoints. A reuse audit can discover substantial remaining implementation work. Conversely, a U/P row can contain existing partial work, so B does not certify novelty.

5. **Keep submission counts separate from accepted counts.** At submission, 187 exports and 167 contracts are the proposed surface; the accepted surface is 158 and 139 until this audit accepts the increment. Calling the former "how much audited API exists" is premature in the pre-audit memo. After acceptance, the former become correct accepted coverage counts. The equation 187=167+20 is sound.

6. **The row tally needs a clear closure convention.** "1 row resolved, zero fully closed" can appear contradictory. Use "one existing Mathlib endpoint identified for reuse; four rows advanced locally; 34 rows without local implementation; no broad row newly completed by this project." Identification of Hall in Mathlib is not a claim that the local project has reproduced a new Hall release. A 39-row inventory could become complete after exact finite endpoints are frozen; the present broad descriptions simply do not define a meaningful universal completion percentage.

7. **Do not erase the work of specification or generic layers when describing velocity.** The pilot had generic finite dissipator and Kraus results as well as qubit calculations. Contracts were written and audited before implementation; that work happened in the workflow even when it was not Fable's coding turn. Export counts and a short calendar interval are not throughput evidence for unrelated mathematical areas. The final caveat's "four rounds" is also stale against the five previously accepted increments.

## Scope that the next assignment should enforce

The finite Markov bridge should expose signed-rate algebra, the destination-first column convention, physical off-diagonal nonnegativity, the exact diagonal intertwining identity, and diagonal stationary states. It should establish mass conservation for the generator, not probability preservation for an unconstructed flow. It should not claim classical or quantum convergence, positivity of the generator, complete positivity of Id+tL, or a generic quantum stationary-state classification. Real diagonal Hamiltonians, finite dynamics, and any combination with classical mixing remain separate work.

