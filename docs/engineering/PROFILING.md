# Profiling Guidance

## Available here

- `/usr/bin/time` — wall + RSS
- `gprof` — requires `-pg` rebuild (not default)

## Preferred on developer machines

```bash
perf record -g -- ./ffmpeg ... 
perf report
```

## Rules

1. Profile the **same** command used in the baseline matrix.
2. Enable realistic assembly (`without` `--disable-x86asm`) when measuring production-like CPU.
3. Prefer real media samples for encode/decode hotspots; lavfi is for reproducibility of MediaForge automation paths.
4. Do not optimize from a single short sample alone.

## Stage 5 session

Function-level profiling was **not** completed (no `perf`, no `-pg` rebuild). Workload-level timing only.
