# Contributor Getting Started

1. **Clone** `https://github.com/BluHExH/MediaForge.git`
2. **Read** [PROJECT_OVERVIEW.md](../PROJECT_OVERVIEW.md) and [architecture/README.md](../architecture/README.md)
3. **Build upstream FFmpeg** as needed — [build/BUILDING.md](../build/BUILDING.md) (CI clones FFmpeg; local full trees need RAM)
4. **Smoke tests** (needs `ffmpeg`/`ffprobe`):
   ```bash
   bash tests/regression/run.sh
   ```
5. **Sanitizers** — see CI `linux-asan` job and [security/SECURITY_TESTING.md](../security/SECURITY_TESTING.md)
6. **Benchmarks** — `bash benchmarks/scripts/run_smoke_benchmarks.sh`
7. **Docs** — edit under `docs/`; keep links accurate
8. **Change** — small commits; tests for behavior changes
9. **Validate** — regression + relevant docs-check paths
10. **PR** — use the pull request template

Philosophy: **measure → implement → test → review → document → push**.
