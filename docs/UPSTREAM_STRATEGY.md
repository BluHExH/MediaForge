# Upstream Strategy

MediaForge is derived from [FFmpeg](https://ffmpeg.org/). CI and release packaging clone upstream using a **pinned release tag**.

## Source of truth

[`config/upstream.env`](../config/upstream.env):

| Variable | Role |
|----------|------|
| `FFMPEG_REPOSITORY` | Official git URL |
| `FFMPEG_REF` | Release tag (e.g. `n7.1.5`) — **not** `master` |
| `FFMPEG_COMMIT` | Immutable 40-char SHA for that tag |

Validate: `bash scripts/check-upstream-baseline.sh`

## Update process

See [continuous/UPSTREAM_UPDATE.md](continuous/UPSTREAM_UPDATE.md).

## Principles

1. Track **pinned** releases for deterministic CI.  
2. Prefer upstream implementations over divergent rewrites.  
3. MediaForge-specific code stays clearly separated.  
4. Never silent merge: build, smoke, sanitizers, MediaForge tests.

## Optional master tip

An informational workflow may build upstream `master` with `continue-on-error` — it does **not** gate releases.
