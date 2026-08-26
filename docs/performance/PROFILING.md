# Profiling Guide

## When to profile

Only after a reproducible benchmark shows a workload worth improving. Profile the **same command** used in the benchmark.

## Tools (availability varies)

| Tool | Use | Notes |
|------|-----|--------|
| `/usr/bin/time -v` | Wall, user, sys, max RSS | Always available in Linux CI images |
| `ffmpeg -benchmark` | FFmpeg internal utime/realtime | Built into ffmpeg CLI |
| `perf record` / `perf report` | CPU hotspots | Needs kernel permissions; may be restricted in containers |
| `hyperfine` | Multi-run statistics | Optional install; not required |
| ASan/UBSan builds | Correctness, not speed | Never use for performance claims |

## Recommended workflow

```bash
# 1. Time baseline
/usr/bin/time -f 'elapsed=%e user=%U sys=%S maxrss_kb=%M' \
  ffmpeg -hide_banner -nostats ... -f null -

# 2. Optional FFmpeg self-report
ffmpeg -benchmark -hide_banner -nostats ... -f null -

# 3. If root/perf allowed:
# perf record -g -- ffmpeg ...
# perf report
```

## Interpreting hotspots

| Class | Typical symbols / areas | Action |
|-------|-------------------------|--------|
| CPU-bound codec | `libx264`, decoder DSP, SIMD | Prefer upstream asm; avoid naive C rewrites |
| Scale/convert | `libswscale`, format filters | Check existing SIMD paths |
| Alloc / copy | `av_malloc`, memcpy, frame get_buffer | Buffer reuse; do not break refcounting |
| Sync | locks, frame threading | Measure 1 vs N threads |
| Startup | probe, option parse | Rarely worth micro-optimizing in library core |

## Limitations (MediaForge Phase 4)

- Workspace ~1.2 GiB RAM: full instrumented builds are constrained.
- No MediaForge-owned codec source yet: profiling targets **upstream** binaries or system packages for methodology only.
- Container `perf` may lack CAP_SYS_ADMIN / paranoid settings.
- Do not commit large `perf.data` or flamegraph binaries to git.

## Phase 4 outcome

Methodology documented. No MediaForge source hotspots identified for patching because MediaForge does not yet carry functional FFmpeg patches. Future patches must attach profiling notes in an ADR under `docs/performance/decisions/`.
