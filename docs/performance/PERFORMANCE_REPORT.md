# Phase 4 Performance Report

**Date**: 2026-08-26  
**MediaForge**: documentation + CI repository; builds upstream FFmpeg in GitHub Actions  

## Methodology

1. Read project baseline, architecture, security constraints.
2. Create `benchmarks/` scripts and `docs/performance/` documentation.
3. Measure system `ffmpeg` on the development workspace with generated lavfi inputs.
4. Classify costs; refuse speculative FFmpeg source edits.

## Environment

See [PERFORMANCE_BASELINE.md](PERFORMANCE_BASELINE.md) and `benchmarks/results/env_workspace.txt`.

## Baseline summary

Short 640×360 generated workloads complete in well under one second on a 2-vCPU, 1.2 GiB VM. Encode (libx264 ultrafast) dominates pure filter/null paths slightly. Peak RSS for these jobs stayed under ~60 MB.

## Hotspots

| Hotspot | Status |
|---------|--------|
| MediaForge-owned codec/filter code | **None exists** |
| Upstream encode (libx264) | External library; not patched here |
| CI build performance | Separate concern (compile times); not media throughput |

## Optimizations implemented

**None** in FFmpeg source.

Rationale: Phase 4 rule — optimize only with evidence on code MediaForge owns or deliberately patches. Infrastructure and measurement come first.

## Evaluated opportunities (not implemented)

| Opportunity | Why deferred |
|-------------|--------------|
| Custom SIMD | Upstream already has extensive asm; duplication risk |
| Threading changes | Need MediaForge patches + multi-core evidence |
| Avoid copies in filters | Requires owning filter code + correctness tests |
| Faster probing/startup | Sub-100 ms on tiny jobs; low priority |

## CI performance strategy

- Optional workflow `.github/workflows/performance.yml`: `workflow_dispatch` + weekly; non-blocking.
- Runs `benchmarks/scripts/run_smoke_benchmarks.sh` against CI-built ffmpeg when practical.
- Artifacts: text results only.
- Does not fail PRs on timing noise (see REGRESSION_POLICY.md).

## Regressions

None introduced (no performance-critical code changes).

## Limitations

- Local numbers use **system** ffmpeg, not CI-built binary.
- No 4K / long-form / GPU measurements.
- No flamegraphs committed.

## Future work

1. Pin `FFMPEG_REF` and publish CI benchmark artifacts for the **same** binary users care about.
2. When MediaForge carries patches, require ADR + before/after tables.
3. Expand workloads carefully (real short H.264 samples under license, thread scaling).

## Conclusion

Phase 4 delivers **measurement infrastructure**, a **documented baseline**, and an explicit decision **not** to ship speculative optimizations. That is the correct outcome when the repository does not yet own media-processing source code.
