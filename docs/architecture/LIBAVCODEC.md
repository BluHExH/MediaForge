# libavcodec

**Purpose**: Encoding and decoding of audio, video, and subtitles. Also parsers and bitstream filters (BSFs).

## Important concepts

- **AVCodec** — codec implementation descriptor (id, capabilities, callbacks).
- **AVCodecContext** — per-instance state and options for one codec.
- **AVCodecParameters** — stream-level codec parameters (extradata, dimensions, sample rate, etc.) used by demux/mux without a full context.
- **AVPacket** — compressed data unit (`packet.h`).
- **Send/receive API** — `avcodec_send_packet` / `avcodec_receive_frame` (decode) and `avcodec_send_frame` / `avcodec_receive_packet` (encode). Decouples input from output; supports draining with NULL.
- **Parsers** — split elementary streams into packets when containers do not.
- **Bitstream filters** — transform packets without full decode (e.g. annex B ↔ AVCC).
- **Hardware codecs** — integrated via `hw_device_ctx` / `hw_frames_ctx` on the context.

## Typical decode flow

1. Find codec: `avcodec_find_decoder` / `avcodec_find_decoder_by_name`
2. Alloc context: `avcodec_alloc_context3`
3. Copy parameters if needed: `avcodec_parameters_to_context`
4. Open: `avcodec_open2`
5. Loop: `avcodec_send_packet` → loop `avcodec_receive_frame` until EAGAIN/EOF
6. Flush: send NULL packet, drain frames; optional `avcodec_flush_buffers`
7. Free: `avcodec_free_context`

## Typical encode flow

1. Find encoder → alloc context → set parameters (width, pix_fmt, time_base, …)
2. `avcodec_open2`
3. Loop: `avcodec_send_frame` → loop `avcodec_receive_packet`
4. Drain with NULL frame
5. Free context

## Dependencies

libavutil. Uses pixel/sample formats, frames, packets, hardware contexts from util.

## MediaForge relevance

High-risk for core codec changes. Safer: new BSFs, better diagnostics around send/receive errors, test coverage for edge cases.

*Verified against `libavcodec/avcodec.h` send/receive documentation and includes.*
