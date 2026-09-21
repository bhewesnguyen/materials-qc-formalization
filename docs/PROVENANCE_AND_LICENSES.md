# Provenance and licenses

A factual inventory of where the material in this repository comes from and
under which terms. It records what the repository contains and what the
project has checked; it does not make legal determinations beyond stating
the license texts present. Hash checks are recorded in
`evidence/release-readiness/v1/provenance/dependency_license_check.json`.

## The project's own material

License: Apache License, Version 2.0, by owner decision (D021, 21 September
2026). The canonical text is `LICENSE` (SHA-256
`cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30`, 11358
bytes, byte-identical to `https://www.apache.org/licenses/LICENSE-2.0.txt`
as fetched on 21 September 2026). `NOTICE` carries the copyright line
`Copyright 2026 Jett Sturges` and the authorship disclosure.

Scope: the Lean release modules under `FormalScience/`, `FormalScience.lean`,
`Audit/Contracts.lean`, `examples/`, `scripts/`, `exports.json`, the
`lakefile.toml`, and the decisions, handoffs, evidence, and planning
documents authored in this repository. Nothing else is relicensed.

Origin and authorship:

- `FormalScience/Stage0.lean`, `scripts/verify.py`, `scripts/test_verify.py`,
  `exports.json` (initial form), `Audit/Contracts.lean` (initial form),
  `AGENTS.md`, `AUDIT_HANDOFF_TEMPLATE.md`, and the initial `README.md` and
  `DECISIONS.md` were produced by the independent audit agent as the Stage 0
  baseline and imported as commit `cd7e6c6` (`audits/stage0/v1/`).
- Every later release module, contract, document, and evidence tree was
  produced by the implementation agent in rounds 1 to 7, under the owner's
  direction (`TURNS.md`, `DECISIONS.md`).
- Two release modules adapt short in-project reference probes written by
  the audit agent for this project, with the adaptations recorded at the
  time: `FormalScience/Quantum/FiniteKraus.lean` follows
  `audits/evolution/v1/reference/KrausProbe.lean` (SHA-256
  `cb9ebbc1442bb0b61cd9d9696c286adf42451ecf19bab15cf69de5dc22c2721e`; D014),
  and the scalar-limit and bridge shapes in
  `FormalScience/OpenSystems/TwoStateConvergence.lean` follow
  `audits/kraus/v1/reference/ConvergenceApiProbe.lean` (SHA-256
  `46b92179fa34e877f0dc99bf11ee6f3357bd9f6df29117a604ee8b59c9a0a178`;
  D016). No other external proof text was copied or adapted; everything
  else uses Mathlib declarations through ordinary imports.
- The auditor's reports, receipts, evidence, ledgers, reviews, and issued
  assignments under `audits/<key>/v1/` were produced by the independent
  audit agent for this project and are stored exactly as received, with
  their return manifests. They are part of the repository record.
- `docs/PORTFOLIO_ROADMAP.md` and the files under `docs/planning/` are the
  planning documents that preceded the repository; `docs/SCOPE_MEMO.md` is
  the owner's planning memo (D018). They are shipped planning documents
  outside the Lean export inventory and proof gate.

Human involvement: the owner directed the work, made the recorded
decisions (representation, layout, tracking of the memo, license), and
pushed the commits. No human semantic review of the proofs has taken place
as of this candidate; see `docs/RELEASE_READINESS.md`.

## Use of Mathlib versus copied text

The release modules import Mathlib and apply its declarations (matrix
algebra, positive semidefiniteness, traces, Kronecker products, real
exponentials, limits, the Frobenius norm instance, finite sums). No Mathlib
source text is copied into this repository. The dependency packages are not
vendored; they are fetched at the locked revisions below by `lake` and are
excluded from the source archive by construction (`.lake/` is ignored).

## Pinned dependencies

Locked in `lake-manifest.json` and confirmed on 21 September 2026 against
the checked-out dependency trees: every checked-out HEAD equals its locked
revision, and every top-level `LICENSE` file hashes to the value recorded
in the audited round-1 inventory
`audits/dissipator/v1/evidence/dependency_license_inventory.json`. Eight
packages are under the Apache License 2.0 and one (`Cli`) under the MIT
License. Seven of the Apache-2.0 files are the common 11357-byte text with
`[]` placeholders; Mathlib's uses `{}` placeholders. Neither differs from
the canonical text in any operative term.

| Package | Upstream repository | Locked revision | License file | SHA-256 |
| --- | --- | --- | --- | --- |
| `mathlib` | `https://github.com/leanprover-community/mathlib4.git` | `5ed2965256430c3649e86755f9576b54eca72435` | `LICENSE`, Apache-2.0 | `b40930bbcf80744c86c46a12bc9da056641d722716c378f5659b9e555ef833e1` |
| `batteries` | `https://github.com/leanprover-community/batteries` | `f2effa3d803fda822b1f97b806c47cf2adfbcbc2` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `aesop` | `https://github.com/leanprover-community/aesop` | `355695d523e41d0554926416cba2a2b3544fbbc9` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `Qq` | `https://github.com/leanprover-community/quote4` | `6a489d9af5d0c47e5b259e2e8bcdfc1811b5a259` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `proofwidgets` | `https://github.com/leanprover-community/ProofWidgets4` | `106ff4fafc74ef4ac99d81dbf3ab399118f497a5` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `importGraph` | `https://github.com/leanprover-community/import-graph` | `e928b72544873815af278d38681b31c0293588e3` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `LeanSearchClient` | `https://github.com/leanprover-community/LeanSearchClient` | `ddf04cf3949fa556442341e87d47f9f6e6074707` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `plausible` | `https://github.com/leanprover-community/plausible` | `118aa17ee84656b8bd727fef7c458ee8c833385c` | `LICENSE`, Apache-2.0 | `c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4` |
| `Cli` | `https://github.com/leanprover/lean4-cli` | `e92c9f15fdfacc8536f31cfb3b7ad26c3c8cd204` | `LICENSE`, MIT | `f7e95706807e931782b6efd9a9d2789508a52423ad67b56ee7e5e324362d4aac` |

Toolchain: `leanprover/lean4:v4.34.0` (compiler commit
`293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`), obtained through `elan`; the
release archive checksum measured by the auditor is
`caaa98356098c85dc0fcbbd28e1ec66f39eb6551829972b752ff20e1286b646b`. Lean
itself is Apache-2.0 licensed upstream; it is not distributed here.

## Known gaps

- The Apache-2.0 boilerplate header is not added to individual Lean source
  files; the license applies through `LICENSE` and `NOTICE` at the root.
  Adding per-file headers would change accepted source bytes and is left to
  a later decision.
- Public availability, upstream contribution, and third-party redistribution
  are separate decisions not made by this candidate. The AI-disclosure
  policies applicable to any upstream target must be checked at that time
  (`AGENTS.md`).
