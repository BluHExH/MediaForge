# Test Report (Phase 8)

## Executed locally (workspace)

| Suite | Result |
|-------|--------|
| tests/cli/smoke.sh | PASS (expanded) |
| tests/media/smoke.sh | PASS |
| tests/hardware/smoke.sh | PASS + SKIP (no GPU) |
| tests/regression/run.sh | PASS |
| Full upstream FATE | **NOT RUN** |
| Continuous fuzz campaign | **NOT RUN** |
| GPU runtime tests | **SKIP / NOT RUN** |

## CI (design)

| Workflow | Role |
|----------|------|
| ci.yml | Build matrix, ASan+malformed, MediaForge smokes |
| fate.yml | Optional manual/weekly — documents FATE attempt constraints |
| performance.yml | Informational benchmarks |

Exact CI run outcomes appear on GitHub Actions for each commit; this file does not invent pass counts for unrun jobs.
