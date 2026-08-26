# Versioning

## Scheme

**SemVer-inspired pre-release**: `MAJOR.MINOR.PATCH[-prerelease]`

| Component | Meaning for MediaForge |
|-----------|------------------------|
| MAJOR | Breaking helper/CLI *MediaForge* contracts (not upstream FFmpeg renames) |
| MINOR | Backward-compatible MediaForge features |
| PATCH | Fixes, docs, CI without breaking helpers |
| `-dev` / `-rc.N` | Pre-release; not “stable” |

**Source of truth**: repository root [`VERSION`](../../VERSION) file.

Development builds on `main` may remain `0.1.0-dev` until a tag sets a release candidate or release version.

## Reporting

```bash
bash scripts/mediaforge version
# MediaForge 0.1.0-dev (commit …)
# ffmpeg …
# ffprobe …
```

## Upstream FFmpeg

MediaForge version ≠ FFmpeg version. Always report `FFMPEG_REF` / built `ffmpeg -version` separately ([UPSTREAM_STRATEGY.md](../UPSTREAM_STRATEGY.md)).
