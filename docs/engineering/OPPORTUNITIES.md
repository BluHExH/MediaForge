# Opportunities (Stage 5)

## P1

### MF-S5-01 — Avoid unnecessary scale/transcode (helpers) — DONE (5B)

- Implemented: `mediaforge process --smart`
- Evidence + results: `docs/engineering/MF-S5-01-SMART-PIPELINE.md`

### MF-S5-02 — Probe/result caching for batch inspect

- Repeated `inspect` of same file in batch workflows
- Helper-level; careful invalidation by mtime/size

## P2

- Pipeline plan logging (diagnostics)
- Richer default configure profile for real-world codecs (CI optional job)

## P3 / deferred

- libswscale / codec micro-opts — need `perf` + x86asm build
- HW auto-routing — needs GPU lab
