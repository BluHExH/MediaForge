# MediaForge

**Working name** for a long-term, production-quality open-source multimedia framework based on the official [FFmpeg](https://ffmpeg.org/) source repository.

MediaForge aims to progressively improve correctness, security, performance, maintainability, and developer experience while preserving FFmpeg’s proven capabilities and compatibility wherever practical.

> **This is not a casual fork.**  
> Changes are made methodically, with tests, documentation, and respect for upstream architecture and licensing.

## Status

**Phases 0–6 complete** (through Media Processing helpers & inventory).

See:

- [docs/BASELINE.md](docs/BASELINE.md) — upstream structure, build, licensing, known constraints
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) — development journal
- [docs/ROADMAP.md](docs/ROADMAP.md) — long-term roadmap
- [docs/build/BUILDING.md](docs/build/BUILDING.md) — developer build guide and CI description
- [docs/architecture/](docs/architecture/) — architecture map and extension points
- [docs/security/](docs/security/) — security baseline, threat model, audit log
- [docs/performance/](docs/performance/) — benchmarks, baseline, regression policy
- [docs/cli/](docs/cli/) — CLI baseline, examples, exit codes
- [docs/media/](docs/media/) — media feature inventory and helpers
- [CHANGELOG.md](CHANGELOG.md) — MediaForge-specific changes
- [benchmarks/](benchmarks/) — reproducible smoke benchmark scripts
- [scripts/mediaforge](scripts/mediaforge) — optional task-oriented helper

CI (GitHub Actions) builds upstream FFmpeg on Linux (GCC/Clang + ASan), Windows (MSYS2), and macOS with smoke tests. No functional MediaForge source patches yet.

## Upstream

MediaForge is derived from the official FFmpeg project:

- Website: https://ffmpeg.org/
- Source: https://github.com/FFmpeg/FFmpeg
- License: primarily LGPL 2.1+ / GPL (see upstream `LICENSE.md` and `COPYING.*` files)

All required attribution, license notices, and source-availability obligations will be preserved.

## Name Note

“MediaForge” is used as a working project name. Multiple smaller projects and tools already use similar names. A final branding decision will be made in Phase 9 after further evaluation.

## Building

See [docs/build/BUILDING.md](docs/build/BUILDING.md) for prerequisites, configure examples, platform notes, sanitizer builds, and CI details.

CI currently clones and builds upstream FFmpeg. MediaForge-specific patches will appear in later phases.

## License

See upstream licensing files. MediaForge modifications will be clearly documented and released under compatible terms.

---

*MediaForge maintainers — 2026*
