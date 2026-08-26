# Benchmark Results Log

Only real measurements. Empty cells mean not measured.

## Run: workspace-2026-08-26 (script `run_smoke_benchmarks.sh`)

| Field | Value |
|-------|--------|
| MediaForge commit | df23727 (Phase 3 tip at measure time) |
| Binary | system ffmpeg 6.1.1-3ubuntu5 |
| Host CPU | Intel Xeon Platinum 8481C @ 2.70 GHz (2 threads) |
| RAM | 1255348 kB |
| Method | best of 3 wall times via `/usr/bin/time` |
| Result file | `benchmarks/results/smoke_20260826T075023Z.txt` |

| Workload | Best wall (s) | Max RSS (kB) |
|----------|---------------|--------------|
| startup_version | 0.03 | 46304 |
| decode_null_testsrc_640x360_3s | 0.06 | 49084 |
| scale_640x360_to_320x180_3s | 0.07 | 51040 |
| encode_x264_ultrafast_640x360_3s | 0.10 | 56228 |
| transcode_scale_x264_640x360_3s | 0.09 | 53592 |
| audio_aresample_48k_to_44k_5s | 0.05 | 49668 |

### Before / after (MediaForge source optimizations)

| Change | Workload | Before | After | Delta |
|--------|----------|--------|-------|-------|
| *(none in Phase 4)* | — | — | — | — |

## Future runs

Append new tables; do not overwrite historical rows. Prefer same script versions for comparison.
