# Stage 5 — Native FFmpeg Engineering Audit

**Date**: 2026-08-27  
**Baseline commit (MediaForge)**: `76c2f47`  
**FFmpeg**: n7.1.5 / `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587`  
**Layout**: Option B (archive + extract)  
**FFmpeg C modifications applied**: **NONE**

## 1. Subsystem map (n7.1.5 extract)

| Subsystem | Approx. `.c` files | Role |
|-----------|-------------------|------|
| libavutil | 184 | buffers, frames, math, hwcontext, logging |
| libavcodec | 1570 | codecs, parsers, bitstream |
| libavformat | 578 | mux/demux, I/O, protocols |
| libavfilter | 570 | filter graphs, scale/resample wrappers |
| libavdevice | 53 | devices; **lavfi indev** |
| libswscale | 52 | pixel format / resolution scaling |
| libswresample | 26 | audio sample rate/format |
| fftools | 18 | ffmpeg/ffprobe CLI pipeline |

Hardware backends present in tree: CUDA, VAAPI, QSV, D3D11/12, Vulkan, VideoToolbox, DRM, OpenCL, MediaCodec, VDPAU (availability is runtime/build-time).

Threading: `libavcodec/pthread.c` + frame/slice threads (`FF_THREAD_FRAME` / `FF_THREAD_SLICE`).

Memory: `AVBufferRef` / `AVBufferPool` in `libavutil/buffer.c`; frames in `frame.c`.

## 2. MediaForge workload matrix

| ID | Workload | Command pattern |
|----|----------|-----------------|
| A | Video → null | `testsrc2` → `-f null` |
| B | Scale | `640×360` → `320×180` (or 1280→640) |
| C | Encode | `mpeg4` (available in MediaForge minimal config) |
| D | Transcode | decode/generate → scale → encode |
| E | Aresample | 48 kHz → 44.1 kHz (`sine` + `aresample`) |
| F | Thumbnail | single frame PNG |
| G | Inspect | `ffprobe` JSON on lavfi |

Inputs: deterministic **lavfi** (reproducible, no media fixtures required).

## 3. Baseline measurements

Environment: Linux, gcc 13, MediaForge configure (`scripts/configure-mediaforge-ffmpeg.sh`), `-j2` build.  
Binary: `/tmp/.../FFmpeg-n7.1.5/ffmpeg` **7.1.5** (not `/usr/bin/ffmpeg`).

### Short runs

| Workload | wall (s) | RSS (KB) |
|----------|----------|----------|
| A_null | 0.01 | ~5400 |
| B_scale | 0.06 | ~12040 |
| C_encode | 0.02 | ~10432 |
| D_transcode | 0.07 | ~14912 |
| E_aresample | 0.00 | ~4748 |
| F_thumb | 0.02 | ~12560 |
| G_probe | 0.00 | ~3968 |

### Longer runs (3 trials, 1280×720)

| Workload | wall (s) | RSS (KB) approx |
|----------|----------|-----------------|
| A_long 5s@30fps → null | **0.09–0.10** | 8–18k |
| B_scale_long → 640×360 | **0.51–0.52** | ~32k |
| D_xcode_long 3s scale+mpeg4 | **0.36–0.45** | ~40k |

**Observation**: Scaling costs ~**5×** wall time vs null for the same generated source (0.52 vs 0.10). Encode-only is cheap relative to scale on this config.

## 4. Profiling

Tools available: `gprof`, `/usr/bin/time`.  
`perf` not available in this environment.

**No function-level samples** were collected in this session (no instrumented rebuild). Hotspot ranking below is **workload-level**, not symbol-level.

## 5. Static / architecture notes (not claimed bugs)

- **swscale** initializes arch-specific paths (`ff_sws_init_swscale_x86`, etc.); MediaForge minimal build uses `--disable-x86asm` → scalar/C paths more often — expected, not a MediaForge defect.
- **Buffer pools** exist and are mature; do not change ownership without deep tests.
- **Frame/slice threading** is codec-driven; MediaForge should not invent a parallel thread model.
- **CLI** (`fftools/ffmpeg_*.c`) is modular (dec/demux/enc/filter/mux/sched); rewrite is out of scope.
- **HW**: full backend surface area in tree; this environment has no GPU — no HW performance claims.

## 6. Opportunity ranking

| ID | Pri | Area | Summary | Evidence | In-tree FFmpeg patch? |
|----|-----|------|---------|----------|------------------------|
| MF-S5-01 | **P1** | Helper pipeline | Skip redundant scale/re-encode when inspect shows target already matches | Scale ≫ null cost | **No** — MediaForge helper |
| MF-S5-02 | P1 | Helper | Cache probe/JSON results for repeated inspect of same path | G_probe cheap but repeated in batch | No |
| MF-S5-03 | P2 | Diagnostics | Clearer “pipeline plan” log (what conversions will run) | DX | No |
| MF-S5-04 | P2 | Config | Optional fuller configure profile for real-media codecs | Minimal build limits real files | No |
| MF-S5-05 | P3 | libswscale | Only after `perf` on real 1080p files with asm enabled | Insufficient symbol evidence | **Not yet** |
| MF-S5-06 | P3 | HW routing | Capability-based device pick | Phase 7 docs; no GPU here | Not yet |

## 7. Recommended first improvement (evidence-based)

**MF-S5-01 — Smart skip of unnecessary scale/transcode in MediaForge helpers** (not a libav* patch).

See: `docs/engineering/MF-S5-01_SMART_PIPELINE.md`

**No Stage 5 FFmpeg C patch is justified** until symbol-level profiling on a non-crippled (`x86asm`) build with real inputs.

## 8. What was deliberately not done

- No edits under extracted FFmpeg sources committed
- No `vendor/patches/*.patch` content
- No fabricated % speedups
- No security CVE claims
