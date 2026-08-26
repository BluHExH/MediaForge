# Changelog

MediaForge-specific changes only. Upstream FFmpeg history lives in the FFmpeg project.

## [Unreleased]

### Added

- **Source transition (Stage 1–3 infra)**: SOURCE_INTEGRATION_PLAN, vendor-ffmpeg.sh, CI prefers vendor/ffmpeg
- **Cycle 02**: Pin FFmpeg baseline to n7.1.5 via config/upstream.env; CI/release provenance
- **Cycle 01**: `inspect --json` (schema v1), preflight checks, output validation, clearer errors
- **Phase 10**: Compatibility/release docs, VERSION file, release.yml packaging
- **Phase 9**: Project identity, docs index, SECURITY/CONTRIBUTING, brand assets
- **Phase 8**: Testing documentation suite, regression aggregate, optional FATE workflow (not full FATE)
- **Phase 7**: Hardware docs, `mediaforge hwinfo`, capability-aware hardware smoke tests (skip without GPU)
- **Phase 6**: Media processing helpers on `scripts/mediaforge`:
  - `inspect` — human-readable media summary via ffprobe  
  - `thumbnail` — extract a single frame to an image file  
  - `extract-audio` — audio-only extraction  
- `docs/media/` inventory, roadmap, design, report  
- `docs/UPSTREAM_STRATEGY.md`  
- `tests/media/smoke.sh`  

### Prior phases (summary)

- **Phase 5**: CLI docs, optional helper base, CLI smoke tests  
- **Phase 4**: Benchmark infrastructure and performance docs  
- **Phase 3**: Security baseline docs and ASan malformed smokes  
- **Phase 2**: Architecture documentation  
- **Phase 1**: Multi-platform CI  
- **Phase 0**: Repository baseline  

Format inspired by [Keep a Changelog](https://keepachangelog.com/).
