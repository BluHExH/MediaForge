# Stage 4 Final Report

## Source

| Item | Status |
|------|--------|
| Complete official archive | **YES** — `vendor/ffmpeg-n7.1.5.tar.gz` (16 MiB, 8677 entries) |
| Expanded `vendor/ffmpeg/` committed | **NO** — agent filesystem cannot reliably hold ~8500 files |
| Expansion mechanism | `scripts/vendor-ffmpeg.sh` (local archive first); CI should extract |

## Upstream

- **n7.1.5** / `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587`

## Build proof (same archive, extract under /tmp)

Minimal configure + `make -j2`: **PASS**

Binary reports: **ffmpeg version 7.1.5**

Path: built under `/tmp/mf-ffsrc/FFmpeg-n7.1.5/ffmpeg` (session-local; not system `/usr/bin/ffmpeg`)

## MediaForge CLI with in-tree binary

11 PASS / 3 FAIL (lavfi gaps in ultra-minimal configure)

## FFmpeg source modifications

**NONE**

## Stage 5

**Not open** until expanded tree is in git or project formally accepts archive+CI-extract as the source-of-truth layout.
