<p align="center">
  <img src="assets/branding/logo.svg" width="96" alt="MediaForge mark"/>
</p>

# MediaForge

**Multimedia engineering on the FFmpeg foundation.**

MediaForge is a **pre-release** open-source project that builds on the [FFmpeg](https://ffmpeg.org/) multimedia framework. Upstream FFmpeg provides the codecs, containers, filters, and core tools. MediaForge adds **CI, testing discipline, security/performance process, documentation, and optional helpers**—not a claim that MediaForge authored FFmpeg.

[Documentation index](docs/README.md) · [Quickstart](docs/quickstart/README.md) · [Project overview](docs/PROJECT_OVERVIEW.md) · [Changelog](CHANGELOG.md)

## Why it exists

FFmpeg is mature and powerful. MediaForge organizes long-term engineering around it: reproducible builds, honest testing claims, security baseline, performance measurement, and small usability helpers—without incompatible CLI rewrites.

## What you get today

| Area | MediaForge-specific | Upstream FFmpeg |
|------|---------------------|-----------------|
| Codecs / formats / filters | — | Yes |
| `ffmpeg` / `ffprobe` | Passthrough via helper | Primary CLI |
| Inspect / thumbnail / extract-audio / hwinfo | `scripts/mediaforge` | Implemented via ffprobe/ffmpeg |
| CI (Linux/Windows/macOS, ASan) | Yes | Built in CI |
| Architecture, security, performance, testing docs | Yes | See also ffmpeg.org |

## Relationship to FFmpeg

```
Your workflow → ffmpeg / ffprobe (upstream)
              → scripts/mediaforge (optional MediaForge helper)
              → docs + tests + CI (MediaForge)
```

FFmpeg is not affiliated with or endorsed by this project. License obligations of FFmpeg builds still apply (LGPL/GPL and component licenses depending on configure).

## Quick examples

```bash
bash scripts/mediaforge inspect input.mp4
bash scripts/mediaforge thumbnail input.mp4 thumb.jpg --time 00:00:05
bash scripts/mediaforge extract-audio input.mp4 audio.wav
bash scripts/mediaforge hwinfo
ffmpeg -i input.mp4 -c:v libx264 -c:a aac out.mp4
```

## Build and platforms

See [docs/build/BUILDING.md](docs/build/BUILDING.md). CI targets Linux (GCC/Clang/ASan), Windows (MSYS2), and macOS. Hardware acceleration is **optional** and environment-dependent ([docs/hardware/](docs/hardware/)).

## Testing and security

- Regression aggregate: `bash tests/regression/run.sh`
- Testing policy: [docs/testing/](docs/testing/) — full FATE is **not** claimed on every commit
- Security policy: [SECURITY.md](SECURITY.md)
- Security baseline: [docs/security/](docs/security/)

## Development status

Phases **0–9** complete on `main` (discovery through branding). Next: release engineering (Phase 10). See [docs/ROADMAP.md](docs/ROADMAP.md).

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md)

## License and attribution

Upstream FFmpeg licensing is defined by the FFmpeg project (`LICENSE.md`, `COPYING.*` in the FFmpeg tree). MediaForge documentation and scripts in this repository are provided for use with that ecosystem; do not assume a single simplified license covers every linked FFmpeg component in every build.

---

*MediaForge maintainers — 2026*
