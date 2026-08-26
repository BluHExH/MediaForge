# Versioning & Releases

## Current status

**Pre-release / development.** There is no stable MediaForge product version number claimed beyond git commits on `main`.

## Strategy

| Item | Policy |
|------|--------|
| Development | Track `main`; identify builds by git SHA |
| Future releases | Semantic versioning when a release gate exists (Phase 10) |
| Upstream FFmpeg | Pin `FFMPEG_REF` for reproducible release builds |
| Security | Prefer upstream fixes; document MediaForge-only issues in SECURITY.md |
| Notes | CHANGELOG.md lists MediaForge-specific changes only |

## Compatibility expectations

CLI compatibility with upstream `ffmpeg`/`ffprobe` is a hard goal. Helpers are optional and must not break standard FFmpeg invocation.
