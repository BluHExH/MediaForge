# Performance Regression Policy

## Principles

1. **Correctness and security outrank speed.**
2. CI must not fail on noise from shared runners.
3. Performance jobs are **informational** unless a metric is proven stable.

## Noise sources

- GitHub-hosted runner CPU contention
- Different runner instance types over time
- Cold cache vs warm cache
- Background load

## Policy (Phase 4)

| Check | Blocking on PR? | Notes |
|-------|-----------------|-------|
| Functional smoke / ASan | Yes | Existing CI |
| Tiny benchmark micro-delta (&lt;10–15%) | **No** | Record only |
| Large regression (&gt;30%) on same workload/script after MediaForge owns patches | Investigate | Manual review; optional scheduled job |
| Fabricated or single-run claims | Rejected | Require methodology |

## Recommended future CI job

- Workflow: `.github/workflows/performance.yml` (optional, `workflow_dispatch` + weekly schedule)
- Build **non-sanitizer** minimal or standard FFmpeg
- Run `benchmarks/scripts/run_smoke_benchmarks.sh`
- Upload `benchmarks/results/*.txt` as artifacts
- Do **not** fail the job on timing variance in Phase 4

## When MediaForge has source patches

1. Require before/after on the **same** machine/runner label when claiming a win.
2. Add an ADR for any intentional performance change.
3. Keep a short “known variance” note in BENCHMARKS.md.
