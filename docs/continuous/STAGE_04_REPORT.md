# Stage 4 Report — Complete FFmpeg Source Import

**Date**: 2026-08-26  
**Repository commit before stage**: `8d22fb1`

## Outcome

**Stage 4 import did not complete in the agent execution environment.**

| Goal | Result |
|------|--------|
| Full `vendor/ffmpeg/` tree | **Not imported** |
| In-tree configure/build | **Not run** (no complete tree) |
| CI prefers vendor | Already implemented (falls back to pin clone) |
| MediaForge helper tests | Unchanged; still use system/PATH ffmpeg |

## Evidence of blockage

Multiple retrieval attempts failed:

1. `git clone --depth 1 --branch n7.1.5` — checkout stalled at a few hundred files of ~8568; processes died; tree incomplete (e.g. missing `libavutil/avutil.h`).
2. GitHub / ffmpeg.org tarball downloads — **0 bytes** received within tool timeouts (`curl` max-time / sandbox limits).

Incomplete trees were **deleted** and **not committed** (per project rules: no partial FFmpeg source).

## FFmpeg baseline (unchanged)

| Field | Value |
|-------|--------|
| Tag | `n7.1.5` |
| Commit | `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` |
| Config | `config/upstream.env` |

## Completeness gate (new)

`scripts/verify-vendored-ffmpeg.sh` **fails** unless:

- required dirs/headers exist  
- **≥ 5000** source files  
- provenance matches pin  
- no nested `.git`

Do not commit `vendor/ffmpeg` until this script exits 0.

## How to complete Stage 4 on a normal machine

```bash
bash scripts/vendor-ffmpeg.sh
bash scripts/verify-vendored-ffmpeg.sh
# optional local build:
# cd vendor/ffmpeg && ./configure --disable-network --enable-ffmpeg --enable-ffprobe --disable-doc && make -j$(nproc)
git add vendor/ffmpeg
git commit -m "vendor: import pinned FFmpeg n7.1.5 (3a0867c2)"
git push
```

CI will then log `Using in-tree vendor/ffmpeg` instead of cloning.

## Modifications inside vendor/ffmpeg

None (no tree committed).

## Tests this session

MediaForge regression aggregate remains the validity check for helpers (not an in-tree FFmpeg binary test).

## Next step

1. Run vendor + verify + commit on a network-capable host (or GitHub Actions workflow job that produces a committed PR).  
2. Then Stage 5: measured native engineering audit — only after in-tree build is proven.
