# Test Baseline (Phase 8)

| Category | Location | CI | Limitations |
|----------|----------|-----|-------------|
| Docs/structure | `docs-check` job | Yes | Presence only |
| CLI smoke | `tests/cli/smoke.sh` | Yes | Needs system/CI ffmpeg |
| Media helper smoke | `tests/media/smoke.sh` | Yes | Generated fixtures |
| Hardware smoke | `tests/hardware/smoke.sh` | Yes | GPU **SKIP** if no device |
| Regression runner | `tests/regression/run.sh` | Yes (Phase 8) | Thin orchestration |
| Sanitizers | `linux-asan` in ci.yml | Yes | Minimal feature set + malformed |
| Benchmarks | `benchmarks/scripts/` | Optional perf workflow | Not correctness gates |
| FATE | Upstream `tests/` in FFmpeg | Optional `fate.yml` | Full suite **not** run in Phase 8 default CI |
| Fuzzing | Upstream `tools/target_*_fuzzer.c` | Documented | No continuous OSS-Fuzz in MediaForge CI |
| Unit tests (libav*) | Upstream | Via FATE when enabled | No MediaForge-owned lib unit tests yet |

## MediaForge-owned executable tests (Phase 8)

All are shell smoke/regression against `ffmpeg`/`ffprobe` + helpers. They do **not** replace upstream FATE.
