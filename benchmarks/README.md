# MediaForge Benchmarks

Lightweight, reproducible media benchmarks. **No large binary fixtures in git.**

```
benchmarks/
├── README.md
├── scripts/          # runnable drivers
├── fixtures/         # optional tiny generated files (usually empty)
└── results/          # text logs (env, timings)
```

## Quick start

```bash
# Uses ffmpeg on PATH (system or freshly built)
./benchmarks/scripts/run_smoke_benchmarks.sh

# Point at a specific binary
FFMPEG=/path/to/ffmpeg ./benchmarks/scripts/run_smoke_benchmarks.sh
```

Results append under `benchmarks/results/`.

## Design rules

- Prefer `lavfi` sources (`testsrc2`, `sine`) 
- Bound runtime (short durations)
- Record environment every run
- Compare only like-with-like (see `docs/performance/REPRODUCIBILITY.md`)
