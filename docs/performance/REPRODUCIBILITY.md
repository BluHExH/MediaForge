# Benchmark Reproducibility

Two results are comparable only when environments are sufficiently similar.

## Required metadata (every result)

| Field | Example |
|-------|---------|
| MediaForge commit | `git rev-parse HEAD` |
| Upstream FFmpeg commit (if built from source) | SHA from CI clone |
| Binary source | system package **or** MediaForge CI build |
| OS | `uname -srm` |
| CPU model | `/proc/cpuinfo` model name |
| CPU count | `nproc` |
| Memory | MemTotal |
| Compiler | `gcc --version` / `clang --version` (when building) |
| Configure flags | full `./configure` line when building |
| Workload name | stable ID from `benchmarks/scripts` |
| Command | exact argv |
| Threads | `OMP_NUM_THREADS` / `-threads N` if set |
| Date (UTC) | ISO-8601 |

## Rules

1. Prefer **generated** inputs (`lavfi` testsrc2, sine) over large binary fixtures.
2. Run each workload at least **3 times**; report best or median wall time (document which).
3. Do not compare ASan builds to release builds as “performance wins.”
4. Do not compare different CPUs without labeling both.
5. Pin upstream `FFMPEG_REF` when claiming MediaForge vs upstream deltas.

## Result storage

- Human-readable summaries: `docs/performance/BENCHMARKS.md`
- Machine-oriented logs: `benchmarks/results/` (small text only; no large media)
