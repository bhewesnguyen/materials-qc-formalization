# Active assignment: Stage 5 release-readiness candidate

> Status (21 September 2026): prepared and handed off in
> `deliverables/release-readiness/v1/HANDOFF.md`. The assignment text below
> is preserved as issued (frozen copy: `audits/markov/v1/NEXT_FABLE_TASK.md`).
> Do not start a further milestone until the audit selects one.

Milestone key: `release-readiness`. First round: `v1`.

This assignment follows acceptance of the finite Markov bridge at commit
`4795b8b6dc6ec7a831b9158affe3ee199f60e01e`, tag `markov-milestone-v1`.
Preserve that tag and every earlier accepted tag. Prepare one downstream
release candidate from the accepted mathematics. This is a documentation,
provenance, consumer-reproduction, and packaging checkpoint, not a new
mathematical milestone. Execute the task rather than stopping after planning.

The accepted surface is eight release modules, 216 exports, 193 theorem
contracts, and 23 definitions or abbreviations. The six-increment two-state
benchmark and the seventh increment, the finite Markov generator bridge,
are mathematically accepted. A release candidate does not certify public
publication, owner human review, novelty, or upstream acceptance.

## 1. Integrate the audit and reproduce the baseline

Read `AGENTS.md`, the Markov audit, its `RETURN_README.md`, this task, and
`AUDIT_HANDOFF_TEMPLATE.md`. Verify the audit return before integration:
CRC, safe relative paths, exact payload set, byte counts, and SHA-256 values
against `audits/markov/v1/RETURN_MANIFEST.json`. Extract temporarily first,
then copy using the original repository-relative paths. Compare existing
files before replacement. Do not flatten paths or nest the return in a
second audit folder. The manifest defines the immutable returned payload.

Keep `audits/markov/v1/NEXT_FABLE_TASK.md` unchanged. Activate an editable
copy at root `NEXT_FABLE_TASK.md`. Record acceptance in `TURNS.md`, README,
AGENTS, and a new DECISIONS entry. Use the audit's actual finding IDs. The
tracked `docs/SCOPE_MEMO.md` remains tracked, per the user's decision in
D018; do not restore the superseded instruction to exclude it.

Run both existing verification scripts on the untouched accepted source.
Store baseline evidence in `evidence/release-readiness/v1/reproduction/`,
with its gate-test results. Match the accepted hashes for all eight release
modules, `Audit/Contracts.lean`, umbrella import, exports, scripts, and
pins. Do not change Lean 4.34.0 or Mathlib
`5ed2965256430c3649e86755f9576b54eca72435`, and do not run a broad dependency
update. Ordinary environment repair is authorized; report a real blocker
rather than weakening a gate.

## 2. Freeze the mathematical surface

Keep every release Lean file, `Audit/Contracts.lean`, `FormalScience.lean`,
`exports.json`, `scripts/verify.py`, `scripts/test_verify.py`,
`lean-toolchain`, `lake-manifest.json`, and dependency pins byte-identical
to the accepted Markov snapshot. Keep the current package version unless
an existing project decision already directs otherwise; this checkpoint's
tag names an audit candidate, not a public semantic-version release.

Add no public definition or theorem, import framework, algebraic
strengthening, matrix exponential, generic dynamics, norm, abstraction,
proof cleanup, or API rename. Preserve all historical evidence and issued
audits/tasks. New documentation consumers must be anonymous `example`s
outside `FormalScience/` and outside `exports.json`.

## 3. Make the release understandable

Update live status consistently. Apply M1: correct the stale README statement that
excludes all general finite-dimensional results beyond the Kraus and
dissipator layers: the finite Markov generator bridge is now accepted too.
General finite-state dynamics and convergence remain unproved here.

Apply M2 and the accompanying SCOPE_MEMO_REVIEW.md wording corrections. In particular,
qualify density convergence by positive total rate; describe the 39-area
inventory as lacking a defined completion percentage rather than being
impossible to complete; describe the difficult rows as research-scale
formalization work with unspecified contracts; remove the unsupported
one-audit-round forecast for other branches. Identify the memo as a shipped
planning document outside the Lean proof gate, instead of saying it is not
an artifact while it is included in the archive. Advance the accepted
counts and source links without rewriting historical submitted handoffs.

Add these concise documents:

- `CHANGELOG.md`: the seven accepted increments, exact source tags/commits,
  resulting capabilities, and this candidate's documentation-only changes.
  Do not invent release dates or claim a public release occurred.
- `docs/API_GUIDE.md`: imports and a short theorem map for states,
  dissipators, the two-state flow, finite-ancilla CP, centered convergence,
  and the finite Markov generator bridge. Include full Lean theorem names
  and their assumptions, not just prose labels.
- `docs/RELEASE_READINESS.md`: the exact candidate scope, verified facts,
  evidence pointers, known gate limitations, and outstanding owner or
  publication decisions. Separate mathematical acceptance from candidate
  reproduction and public-release status.
- `docs/PROVENANCE_AND_LICENSES.md`: the factual source and license inventory
  described below.

The guide must state: destination-first rates; diagonal q entries ignored;
zero Hamiltonian for the Markov bridge; signed rates on algebraic laws;
nonnegative rates/time for the physical two-state flow; positive total rate
for attraction; trace-scaled equilibrium on arbitrary matrices; Frobenius
rather than trace or diamond norm; arbitrary finite ancillas for CP; and
Markov generator identities rather than a generic transition semigroup.
No broad portfolio row is declared complete. No novelty is claimed.

## 4. Add a small, compiled usage file

Create `examples/Usage.lean`, importing the public umbrella `FormalScience`.
Use only anonymous examples that directly consume accepted theorems:

1. Physical two-state evolution preserves a density for nonnegative rates
   and time, using `evolution_isDensity`.
2. A density converges to `rhoStar` under nonnegative rates and positive
   total rate, using `tendsto_evolution_of_isDensity`. Keep every premise
   explicit and explain the both-zero exception nearby in the guide.
3. Specialize the accepted diagonal Markov bridge to `Fin 3`, with arbitrary
   signed real rates and a real vector. Show the explicit real-to-complex
   diagonal embedding and `rateMatrix q` action in the example statement.
   Consume the existing bridge theorem instead of expanding a new proof.

Use the exact declaration names and types found in the accepted source.
These are documentation consumers, not additions to the 216-export API.
Compile with `lake env lean examples/Usage.lean` and retain the command,
exit code, and raw diagnostics. Keep the guide snippets identical to the
compiled file, or link to that file instead of duplicating them. No GUI,
notebook, numerical simulation, benchmark, or extra test framework is needed.

## 5. Record provenance and license status accurately

Inspect the existing repository decisions, source headers, audit reference
probes, and the pinned dependency license files. Reuse the audited inventory
at `audits/dissipator/v1/evidence/dependency_license_inventory.json`, then
confirm its revisions and file hashes against the current pinned sources.
It records eight Apache-2.0 packages and `Cli` under MIT. Record exact
upstream repository, revision, license path and hash, and any relevant
existing notice. Do not label every dependency Apache-2.0.

Distinguish use of a Mathlib API from copied or adapted proof text. Preserve
existing provenance, including the attributed auditor-probe adaptations.
Identify the origin of the local source, auditor reports/reference probes,
planning documents, and imported material. Record factual attribution or
license gaps without inventing authorship, copyright ownership, permission,
or a new legal conclusion. Do not vendor whole dependencies into this
candidate merely to duplicate their license files.

The accepted snapshot has no top-level project license. Check whether the
user has already selected one in the current repository/session history.
If so, apply that actual decision with its intended scope. If not, finish
all other work and record "original project license selection pending
owner decision" in the readiness document and handoff. Do not silently
choose a license, infer a project-wide grant from Mathlib's license, or
claim open-source distribution readiness. This does not block preparing
the private audit candidate. Return the concrete unresolved choice only
after the candidate and evidence are reviewable.

## 6. Validate and package the exact candidate

Record a byte-for-byte comparison with accepted mathematical source,
contracts, scripts, exports, and pins. Review the existing manual public
inventory against the unchanged source: 216 exports, 193 distinct consumed public theorems, eight
modules. Reuse the Markov inventory with explicit source-hash linkage; do
not pretend that the gate discovers a declaration omitted from both lists.
Retain the prior two negative-control fixtures. Do not expand the verifier.

Run final verification and the 15 ordinary gate cases, storing evidence
under `evidence/release-readiness/v1/verification/` and `gate-tests/`.
The allowed axioms remain `propext`, `Classical.choice`, `Quot.sound`, or a
subset. Compile the anonymous usage file and retain its output separately.

Complete `deliverables/release-readiness/v1/HANDOFF.md` and `POINTER.json`.
Identify this as a release-readiness candidate, with Markov as the accepted
diff base. Follow the existing staged-manifest protocol: finish files;
stage intended bytes; verify staged/working equality; regenerate and stage
`SOURCE_MANIFEST.json`; commit; tag `release-readiness-milestone-v1`; create
`Formal_Science_Release_Readiness_Handoff.zip` from that tag; verify exact
paths, bytes, hashes, no nested archives, and CRC. Never embed the containing
archive's own hash inside it, and never move an accepted tag.

## 7. Prove that a recipient can use the delivered archive

After creating the actual tagged archive, extract it into a fresh temporary
directory. Verify that extraction against the archived manifest. Do not
copy the original project's `.lake/build` or other local compiled project
outputs into it. Install/use the pinned Lean toolchain and materialize
exactly the locked dependencies. Reusing the pinned Mathlib dependency
cache is allowed and should be stated honestly: this is fresh local-source
re-elaboration, not a complete Mathlib source rebuild.

From that extracted package, run both verification scripts and compile
`examples/Usage.lean` using only the documented setup. Store raw commands,
outputs, exit codes, source hashes, environment, pin checks, axiom output,
and gate results under a new archive-consumer evidence directory outside
the immutable extracted payload. Record the exact input archive digest.
Confirm the same 216/193/eight-module surface and passing consumer examples.
This check must exercise the archive a recipient will receive.

Keep post-archive consumer evidence in
`evidence/release-readiness/v1/archive-consumer/` in the working repository,
and commit it after the tag with the external `RECEIPT.json`. Provide a
small companion `Formal_Science_Release_Readiness_Consumer_Evidence.zip`
containing that evidence, the post-tag receipt, and its own path/hash/size
manifest. The receipt inside this companion records the source archive digest;
record the companion ZIP digest externally in the delivery message to avoid
self-reference. The companion manifest excludes itself. Its entries retain repository-relative paths. Verify it before
handoff. Do not recreate the tagged source archive merely to include its
own subsequent consumer evidence. The final delivery message identifies
the source archive and the companion evidence archive separately, with
full hashes and exact tagged source commit. If the check fails, retain the
failure and repair the concrete packaging/documentation problem before
calling the candidate complete; do not weaken the check.

## Stop boundary

You commit and tag; the user pushes. Do not publish a GitHub Release, submit
an upstream PR, contact maintainers, assert that human review occurred, or
start a new mathematical branch. Return both archives, handoff, pointer,
receipt, evidence, unchanged API counts, and any concrete remaining owner
choice. All documentation and code comments use no em dashes. Stop for the
independent release-readiness audit.
