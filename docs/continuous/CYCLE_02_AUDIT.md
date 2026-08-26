# Continuous Cycle 02 — Audit

**Date**: 2026-08-26  
**Base**: `53a692c`

## Previous upstream tracking

| Location | Value |
|----------|--------|
| `.github/workflows/ci.yml` | `FFMPEG_REF: master` |
| `fate.yml`, `performance.yml` | `FFMPEG_REF: master` |
| Docs | Multiple references to master as temporary |

**Risk**: CI results drift as upstream `master` moves; releases could not name a fixed FFmpeg source.

## Selected pin

| Field | Value |
|-------|--------|
| Tag | **`n7.1.5`** |
| Repository | `https://github.com/FFmpeg/FFmpeg.git` |
| Resolved commit | `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` |

### Rationale

- Official release tag (not `master` / `*-dev`)  
- 7.1.x is a maintained release line with patch-level updates  
- Newer than workspace system 6.1.1; still conservative vs bleeding `n8.2-dev`  
- Verified via `git ls-remote --tags` on upstream  

Alternatives considered: `n8.1.2` (newer major line — fine later), `n6.1.6` (older).

## Authoritative file

`config/upstream.env` — single source of truth; CI sources it; `scripts/check-upstream-baseline.sh` rejects `master`.
