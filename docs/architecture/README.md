# MediaForge Architecture Documentation

This directory documents the architecture of the FFmpeg codebase that MediaForge is based on. All descriptions are derived from upstream source structure and public headers (verified against FFmpeg master).

**Purpose**: Give MediaForge engineers an accurate map of subsystems, data flow, dependencies, and safe extension points so future changes stay correct and compatible.

## Documents

| Document | Content |
|----------|---------|
| [DEPENDENCY_GRAPH.md](DEPENDENCY_GRAPH.md) | Library dependency relationships |
| [LIBAVUTIL.md](LIBAVUTIL.md) | Core utilities |
| [LIBAVCODEC.md](LIBAVCODEC.md) | Codecs (encode/decode) |
| [LIBAVFORMAT.md](LIBAVFORMAT.md) | Containers, protocols, I/O |
| [LIBAVFILTER.md](LIBAVFILTER.md) | Filtergraph |
| [LIBAVDEVICE.md](LIBAVDEVICE.md) | Capture/playback devices |
| [LIBSWSCALE.md](LIBSWSCALE.md) | Scaling / colorspace |
| [LIBSWRESAMPLE.md](LIBSWRESAMPLE.md) | Audio resample / convert |
| [CODEC_ARCHITECTURE.md](CODEC_ARCHITECTURE.md) | Codec pipeline detail |
| [FORMAT_ARCHITECTURE.md](FORMAT_ARCHITECTURE.md) | Container / stream / packet model |
| [FILTER_ARCHITECTURE.md](FILTER_ARCHITECTURE.md) | Filter graph execution |
| [AUDIO_ARCHITECTURE.md](AUDIO_ARCHITECTURE.md) | Audio path |
| [VIDEO_ARCHITECTURE.md](VIDEO_ARCHITECTURE.md) | Pixel formats / video path |
| [HARDWARE_ACCELERATION.md](HARDWARE_ACCELERATION.md) | HW device / frames |
| [THREADING.md](THREADING.md) | Parallelism models |
| [CLI_ARCHITECTURE.md](CLI_ARCHITECTURE.md) | ffmpeg / ffprobe / ffplay |
| [BUILD_ARCHITECTURE.md](BUILD_ARCHITECTURE.md) | configure → make |
| [MEDIAFORGE_EXTENSION_POINTS.md](MEDIAFORGE_EXTENSION_POINTS.md) | Safe change areas |
| [decisions/](decisions/) | Architecture Decision Records |

## High-level data flow

```
Input (file/URL/device)
  → Protocol / AVIOContext
  → Demuxer (libavformat)
  → AVPacket (compressed)
  → [optional Parser / BSF]
  → Decoder (libavcodec)
  → AVFrame (raw)
  → [Filter graph (libavfilter)]
  → Encoder (libavcodec)
  → AVPacket
  → Muxer (libavformat)
  → Output
```

Hardware paths insert `AVHWDeviceContext` / `AVHWFramesContext` around decode, filter, or encode stages.

## Design principles (upstream)

- **Modular libraries** with clear public APIs and versioned ABIs.
- **Refcounted** `AVBuffer` / `AVFrame` / `AVPacket` for zero-copy where possible.
- **Send/receive** codec API (`avcodec_send_*` / `avcodec_receive_*`) decouples input from output.
- **Configure-time** feature selection; runtime probing for formats and codecs.

## MediaForge stance

Preserve these invariants. Prefer extension at filter, CLI, test, and documentation layers before touching core codec/format internals. See [MEDIAFORGE_EXTENSION_POINTS.md](MEDIAFORGE_EXTENSION_POINTS.md) and the ADRs.

*Phase 2 — Architecture Documentation*
