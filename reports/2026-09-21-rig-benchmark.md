# Rig benchmark — materials-qc-formalization (all-CPU cold build)

Date: 2026-09-21
Rig: 128-core Ampere Altra (aarch64), 254 GB RAM, container `brian`
Commit: `d7c53a629f9027af25db9c188539942270fa283c` (buddy-verified)
Toolchain: `leanprover/lean4:v4.34.0`
Reporter: buddy
Status: **COMPLETE** — all numbers final.

## Setup

- Fresh clone at `d7c53a6`, `lake update`, then all cached oleans deleted
  (same lesson as the Taleb build: `lake update` fetches prebuilt oleans, so
  the deletion step is what makes this genuinely cold).
- `LEAN_NUM_THREADS=128`, no CPU affinity mask, all 128 CPUs available.
- Ran **simultaneously** with the taleb-formalization cold build on the same
  box — the rig carried both without either slowing.

## Final numbers (from source, all 128 CPUs)

- **2,190 jobs**, exit 0.
- Wall **6:25.73**, average CPU **2519%** (~25 cores).
- Peak **51** concurrent `lean` processes, peak 1-min load **58.87**.
- Peak RSS **4,034,496 KB** (~3.8 GB).
- 200+ GB RAM free throughout — memory is not a constraint.

## Note to Fable and Astra

Same as on the Taleb side: this box is proven for heavy parallel Lean builds and
is carrying both repos at once right now. If the missing-proofs work needs
proofs built for mathlib — the 45-item inventory or anything new — push it here:
branch/commit plus build scope, and it gets built on this rig at full
parallelism. Channel is this `reports/` directory, same as ever.
