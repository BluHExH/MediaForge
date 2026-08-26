# Versioning & Releases

See also [compatibility/VERSIONING.md](compatibility/VERSIONING.md) and [compatibility/RELEASE_STATUS.md](compatibility/RELEASE_STATUS.md).

## Current status

**Pre-release.** Authoritative version: root [`VERSION`](../VERSION) file (`0.1.0-dev` on development `main`).

## Channels

| Channel | Meaning |
|---------|---------|
| Development | `main` branch |
| Preview / RC | git tags `v*.*.*-rc.*` when maintainers choose |
| Stable | Only after explicit non-dev VERSION + checklist |

Phase 10 establishes packaging automation; it does **not** by itself create a stable release.

## Promotion path

1. Development on `main`
2. Optional RC tag → `release.yml` packages sources + SHA256
3. Validation checklist
4. Stable tag only when ready

## Compatibility

Upstream `ffmpeg`/`ffprobe` behavior is preserved. MediaForge helpers follow [compatibility/DEPRECATION.md](compatibility/DEPRECATION.md).
