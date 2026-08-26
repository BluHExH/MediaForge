# Performance Baseline

**Phase**: 4  
**Date**: 2026-08-26  

This baseline records what was **actually measured** and what remains unmeasured.

## Binary under test (local workspace)

| Field | Value |
|-------|--------|
| Source | **System package** (not MediaForge CI build) |
| Version string | ffmpeg version 6.1.1-3ubuntu5 |
| Host | Linux 6.12.8+ x86_64 |
| CPU | Intel Xeon Platinum 8481C @ 2.70 GHz |
| CPUs visible | 2 |
| RAM | ~1.2 GiB |
| MediaForge commit at measurement | `df23727` (docs/CI only; no media patches) |

These numbers establish **methodology and order-of-magnitude** expectations for a constrained VM. They are **not** claims about a MediaForge-optimized fork.

## Measurement method

- Tool: `/usr/bin/time -f '%e %M'` (wall seconds, max RSS kB)
- Each workload: 3 runs; **best** wall time reported
- Inputs: lavfi-generated (no large fixtures)
- Output: null mux where applicable (`-f null -`)
- Script: `benchmarks/scripts/run_smoke_benchmarks.sh`

## Results (workspace, 2026-08-26)

| Workload ID | Best wall (s) | Max RSS (kB) | Notes |
|-------------|---------------|--------------|-------|
| `startup_version` | 0.03 | 45976 | `ffmpeg -version` |
| `decode_null_testsrc_640x360_3s` | 0.06 | 49304 | testsrc2 → null (generate+discard) |
| `scale_640x360_to_320x180_3s` | 0.06 | 50604 | scale filter |
| `encode_x264_ultrafast_640x360_3s` | 0.10 | 56900 | libx264 ultrafast CRF 28 → null |
| `transcode_scale_x264_640x360_3s` | 0.09 | 53564 | scale + x264 |
| `audio_aresample_48k_to_44k_5s` | 0.05 | 49580 | sine → aresample |

Raw env log: `benchmarks/results/env_workspace.txt`

## Not measured in Phase 4 (explicit)

| Item | Reason |
|------|--------|
| MediaForge-built ffmpeg binary timings | No vendored build in workspace; CI does not yet export benchmark artifacts |
| H.264/HEVC **file** decode of real bitstreams | Would need sample files; deferred to generated+optional FATE later |
| 4K workloads | RAM/CPU limits of workspace |
| Multi-thread scaling curves (1/2/4/8) | Only 2 CPUs visible; partial only |
| `perf` flamegraphs | Not committed; environment may restrict perf |
| Upstream vs MediaForge delta | No MediaForge codec patches to compare |

## Classification of observed cost (order-of-magnitude)

On this host, short 640×360 lavfi workloads complete in **&lt;0.2 s** wall time. Dominant cost for encode path is **libx264** (CPU-bound), not MediaForge-owned code (none yet).

## Hotspot identification (Phase 4)

| Finding | Evidence | Action |
|---------|----------|--------|
| No MediaForge-owned media hot path | Tree is docs + CI | **No source optimization** |
| Encode path cost is external libx264 | Timing: encode &gt; pure lavfi null | Optimize only if MediaForge patches that path later |
| Memory ~45–57 MB RSS for tiny jobs | maxrss from time | No leak investigation indicated |

**Decision**: Document infrastructure and baseline only. Do not modify upstream performance-critical C/asm without a MediaForge-owned patch and before/after proof.
