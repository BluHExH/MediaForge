# Testing (MediaForge)

Central entry for validation: smoke → regression → sanitizers → FATE → fuzzing.

| Document | Purpose |
|----------|---------|
| [TEST_BASELINE.md](TEST_BASELINE.md) | What exists today |
| [TESTING_ARCHITECTURE.md](TESTING_ARCHITECTURE.md) | Layers and what they catch |
| [FATE.md](FATE.md) | Upstream FATE; what we run vs not |
| [FIXTURES.md](FIXTURES.md) | Fixture policy |
| [FUZZING_ARCHITECTURE.md](FUZZING_ARCHITECTURE.md) | Fuzz design |
| [CORPUS.md](CORPUS.md) | Corpus size/seed policy |
| [CRASH_TRIAGE.md](CRASH_TRIAGE.md) | Crash handling |
| [TEST_POLICY.md](TEST_POLICY.md) | PASS/FAIL/SKIP rules |
| [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) | Pre-release gates |
| [TEST_REPORT.md](TEST_REPORT.md) / [PHASE_8_REPORT.md](PHASE_8_REPORT.md) | Phase 8 results |

## Quick local commands

```bash
bash tests/cli/smoke.sh
bash tests/media/smoke.sh
bash tests/hardware/smoke.sh   # skips GPU if absent
bash tests/regression/run.sh
```

CI: `.github/workflows/ci.yml` (every PR/push).  
Optional: `performance.yml`, `fate.yml` (scheduled / manual; see FATE.md).
