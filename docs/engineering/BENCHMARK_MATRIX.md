# Benchmark Matrix (Stage 5)

## Environment

| Field | Value |
|-------|--------|
| FFmpeg | 7.1.5 (pinned archive build) |
| Configure | `scripts/configure-mediaforge-ffmpeg.sh` |
| Note | `--disable-x86asm` in this environment |

## Workloads

| ID | Description | Typical options |
|----|-------------|-----------------|
| A | Generate → null | `testsrc2=s=WxH:d=T:r=30 -f null -` |
| B | Scale | `… -vf scale=W2:H2 -f null -` |
| C | Encode | `… -c:v mpeg4 -q:v 5 -f null -` |
| D | Scale + encode | combine B+C |
| E | Aresample | `sine … -af aresample=44100` |
| F | Thumbnail | `-frames:v 1` image |
| G | Probe | `ffprobe -print_format json` |

## Recorded fields

- wall time (`/usr/bin/time -f %e`)
- max RSS KB (`%M`)
- binary path (must not be system ffmpeg when testing pin)

## Baseline (2026-08-27)

See STAGE_05_AUDIT.md §3. Scale dominates short video pipelines on this build.
