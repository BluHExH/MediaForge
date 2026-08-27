# Stage 4 Final Report (4D)

## Source acquisition

| Item | Value |
|------|--------|
| Archive | `vendor/ffmpeg-n7.1.5.tar.gz` |
| Size | ~16 MiB |
| Entries | 8677 |
| gzip | PASS |
| Layout decision | **Option B** — archive + deterministic extract ([FFMPEG_SOURCE_LAYOUT.md](../architecture/FFMPEG_SOURCE_LAYOUT.md)) |

## Extraction

`scripts/vendor-ffmpeg.sh` → `vendor/ffmpeg/` (workspace, not committed).  
Verify: `scripts/verify-vendored-ffmpeg.sh` (fail-closed).

## Provenance

- FFmpeg **n7.1.5**
- Commit **3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587**
- `config/upstream.env`

## Build

Compiler: gcc 13 (Ubuntu)  
Parallelism: `-j2`  
Script: `scripts/configure-mediaforge-ffmpeg.sh`

Key enables beyond minimal: `--enable-indev=lavfi`, `--enable-zlib`, `wrapped_avframe`, png/mjpeg, matroska/wav.

| Step | Result |
|------|--------|
| configure | PASS |
| make | PASS |
| `ffmpeg -version` | **7.1.5** (path under extract tree, not `/usr/bin/ffmpeg`) |
| `ffprobe -version` | **7.1.5** |

## Functional validation

| Suite | Result |
|-------|--------|
| CLI | **14 PASS / 0 FAIL** |
| Media | **7 PASS / 0 FAIL** |
| Hardware | **3 PASS / 1 SKIP** (no GPU) |
| Regression aggregate | **PASS** |

Lavfi failures from Stage 4C ultra-minimal build fixed by enabling **`lavfi` indev** + **`wrapped_avframe`** encoder + zlib/png.

## Sanitizers

Not re-run full ASan/UBSan matrix in this session (resource/time). Prior project CI retains ASan job on MediaForge helpers / clone path. Documented as **baseline deferred for in-tree binary** — no claim of full sanitizer coverage on this configure.

## FATE

Supported subset only (project policy). Full FATE **not** claimed. L0 lavfi-style checks covered by CLI/media smokes.

## Performance (indicative)

Startup `ffmpeg -version`: wall ≈ 0.00 s, RSS ≈ 3.4 MiB (this environment).  
Not an optimization study — baseline only; no FFmpeg source changes.

## Source-layout decision

**Archive + extract** (Option B). Expanded tree intentionally not committed.

## Native modifications

**NONE**

## Stage 5 status

**CLOSED** until this report is pushed and remotely verified. After that, Stage 5 (native audit) may open — still no speculative FFmpeg patches.
