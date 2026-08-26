# ADR-0004: Measurement-first; no speculative performance patches

## Status

Accepted (Phase 4)

## Context

MediaForge builds upstream FFmpeg in CI and does not yet vendor functional source patches. Phase 4 requires evidence before optimization.

## Decision

1. Establish benchmarks, reproducibility rules, and profiling docs first.
2. Record real timings (even if on system ffmpeg) with clear labeling.
3. **Do not** modify upstream performance-critical code in Phase 4.
4. Any future optimization requires: benchmark ID, before/after, correctness checks, and an ADR when significant.

## Consequences

- Phase 4 may ship zero speedups in media throughput — acceptable.
- Avoids silent correctness or portability regressions.
- Sets a durable standard for later phases.
