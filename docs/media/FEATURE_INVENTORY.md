# Feature Inventory

Status labels: **Mature** · **Improvable (UX/docs)** · **Missing (in MediaForge helpers)** · **Upstream-dependent** · **Experimental**

Based on upstream FFmpeg architecture and workspace system ffmpeg 6.1.1 verification. MediaForge does not yet vendor a modified libav* tree.

## Video

| Capability | Status | Notes |
|------------|--------|-------|
| H.264/HEVC/VP9/AV1 decode/encode | Mature / Upstream-dependent | Build flags + external libs |
| Containers MP4/MKV/WebM/MPEG-TS | Mature | libavformat |
| Scaling / fps / crop / format | Mature | libavfilter + libswscale |
| Pixel formats / color | Mature | Extensive; complex |
| HW accel (NVENC, VAAPI, VT, …) | Upstream-dependent | Configure + runtime device |
| Thumbnail / frame extract | Mature (CLI) / **Improvable UX** | `-ss` + `-frames:v 1`; helper added Phase 6 |

## Audio

| Capability | Status | Notes |
|------------|--------|-------|
| AAC/MP3/Opus/FLAC/… | Mature / Upstream-dependent | |
| Resample / channel layout | Mature | libswresample + filters |
| Extract audio | Mature / **Improvable UX** | `-vn`; helper Phase 6 |
| Loudness / afade / etc. | Mature | Existing filters |

## Subtitles

| Capability | Status | Notes |
|------------|--------|-------|
| SRT/ASS/WebVTT demux/mux | Mature | |
| Soft mux / burn-in | Mature | `subtitles` filter / bitstream |
| Malformed subtitle robustness | Upstream-dependent | Security-sensitive; no custom engine |

## Metadata

| Capability | Status | Notes |
|------------|--------|-------|
| Read (ffprobe) | Mature | JSON/XML/CSV |
| Map/copy (`-map_metadata`) | Mature | |
| Friendly inspect summary | **Missing** → helper | Phase 6 `mediaforge inspect` |

## Images / GIF

| Capability | Status | Notes |
|------------|--------|-------|
| Image2 / sequences | Mature | |
| GIF encode | Mature | palettegen/paletteuse recipes |
| Thumbnails | Improvable UX | Helper |

## Streaming

| Capability | Status | Notes |
|------------|--------|-------|
| file/http/rtmp/srt/… | Upstream-dependent | Disabled in minimal CI |
| Reconnect / timeouts | Upstream-dependent | Document; don’t reimplement stack |

## Processing workflows

| Capability | Status | Notes |
|------------|--------|-------|
| Remux (`-c copy`) | Mature | Prefer over re-encode |
| Transcode | Mature | |
| Concat demuxer/filter | Mature | |
| Batch | Scripting | Documented in CLI examples |

## MediaForge-owned (as of Phase 6)

| Item | Status |
|------|--------|
| Codecs/filters in C | None (upstream only) |
| Helper workflows | inspect, thumbnail, extract-audio |
| Tests | `tests/media/`, `tests/cli/` |
