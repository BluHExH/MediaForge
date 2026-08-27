# Upstream Patch Model

## Baseline

Pinned official archive + `config/upstream.env`:

| Field | Example |
|-------|---------|
| Archive | `vendor/ffmpeg-n7.1.5.tar.gz` |
| Tag | `n7.1.5` |
| Commit | `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` |

## Layout (Option B)

```
vendor/ffmpeg-n7.1.5.tar.gz   # committed, immutable pin
vendor/patches/                 # MediaForge patches (committed when Stage 5 starts)
vendor/ffmpeg/                  # NOT committed — extract + apply patches
```

## Apply order

```bash
bash scripts/vendor-ffmpeg.sh          # extract + verify
# future:
# for p in vendor/patches/*.patch; do patch -p1 -d vendor/ffmpeg < "$p"; done
cd vendor/ffmpeg
bash ../../scripts/configure-mediaforge-ffmpeg.sh
make -j2
```

## Rules

1. Prefer MediaForge code **outside** the FFmpeg tree when possible.
2. In-tree patches must be minimal, tested, and named `NNNN-short-description.patch`.
3. On upstream bump: replace archive, update `upstream.env`, rebase/retest patches.
4. Never claim a patch is an “optimization” without measurements.

## Stage 5

No MediaForge FFmpeg patches exist yet. This document only defines the mechanism.
