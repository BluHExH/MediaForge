# Native Patch Policy

## When FFmpeg C may be patched

1. Measured bottleneck (workload + numbers)
2. Hypothesis written
3. Minimal diff designed
4. Patch file under `vendor/patches/`
5. Reproducible: extract archive → apply patches → build
6. Same benchmark before/after
7. Full MediaForge regression green
8. Prefer upstreamable changes when possible

## When not to patch

- Code “looks slow” without numbers
- Style-only refactors
- Large subsystem rewrites
- Changing defaults users rely on
- Claiming GPU wins without hardware

## Pipeline

```
vendor/ffmpeg-n7.1.5.tar.gz
  → scripts/vendor-ffmpeg.sh
  → vendor/patches/*.patch
  → scripts/configure-mediaforge-ffmpeg.sh
  → make
  → tests + benchmarks
```

## First patch size

Prefer one function or one path. Easy review and rollback.
