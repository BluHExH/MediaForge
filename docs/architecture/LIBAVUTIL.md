# libavutil

**Purpose**: Shared foundation for all FFmpeg libraries. Memory, logging, mathematics, pixel/sample formats, dictionaries, hardware context types, and many small utilities.

## Important concepts

- **AVBuffer / AVBufferRef** — refcounted memory (`buffer.h`).
- **AVFrame** — raw audio/video frame with planes, side data, timestamps (`frame.h`).
- **AVDictionary** — key/value metadata (`dict.h`).
- **AVRational** — exact rational numbers for time bases (`rational.h`).
- **AVMediaType** — VIDEO, AUDIO, SUBTITLE, DATA, ATTACHMENT (`avutil.h`).
- **Pixel formats** — `AVPixelFormat` enum and descriptors (`pixfmt.h`, `pixdesc.h`).
- **Sample formats** — `AVSampleFormat` (`samplefmt.h`).
- **Channel layouts** — modern `AVChannelLayout` (`channel_layout.h`).
- **Hardware** — `AVHWDeviceContext`, `AVHWFramesContext` (`hwcontext.h` and backends).
- **Logging** — `av_log` hierarchy (`log.h`).
- **Options** — `AVClass` / `AVOption` system (`opt.h`).

## Major public APIs (examples)

- `av_malloc` / `av_free` / `av_realloc` family
- `av_frame_alloc` / `av_frame_ref` / `av_frame_unref` / `av_frame_free`
- `av_buffer_ref` / `av_buffer_unref`
- `av_dict_set` / `av_dict_get` / `av_dict_free`
- `av_rescale_q`, `av_compare_ts`
- `av_log`
- `av_hwdevice_ctx_create`, `av_hwframe_transfer_data`

## Dependencies

None of the other FFmpeg libraries. Architecture subdirs: `x86/`, `arm/`, `aarch64/`, `riscv/`, etc.

## MediaForge relevance

Safe place for small utility helpers and diagnostics. Changes here affect *every* library — treat as high impact on ABI.

*Verified against `libavutil/avutil.h`, `frame.h`, `hwcontext.h`, tree listing.*
