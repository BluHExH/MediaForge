# Codec Architecture

## Registration and discovery

Codecs are registered at library init. Applications discover them with:

- `avcodec_find_decoder(id)` / `avcodec_find_encoder(id)`
- `avcodec_find_decoder_by_name` / `avcodec_find_encoder_by_name`
- Iteration helpers for listing

Each `AVCodec` describes capabilities (delay, hardware, threading, variable frame size, etc.).

## Context lifecycle

1. Allocate `AVCodecContext` (`avcodec_alloc_context3`)
2. Set parameters (or copy from `AVCodecParameters`)
3. Optional: attach `hw_device_ctx` for hardware
4. `avcodec_open2`
5. Send/receive loop
6. `avcodec_free_context`

## Packet ↔ frame

- **Decode**: compressed `AVPacket` in → raw `AVFrame` out  
- **Encode**: raw `AVFrame` in → compressed `AVPacket` out  

The send/receive API allows 0..N outputs per input and requires draining at EOS (NULL input).

## Parsers and BSFs

- **Parsers** (`AVCodecParserContext`): recover frame boundaries from continuous elementary streams.
- **Bitstream filters**: modify packet payloads without full decode (e.g. h264_mp4toannexb).

## Threading (codec level)

- **Frame threading**: multiple frames in flight (good for many modern codecs).
- **Slice threading**: parallel slices within a frame.  
Selected via `AVCodecContext.thread_type` / `thread_count`. Not all codecs support both.

## Hardware codecs

Contexts may reference `AVHWDeviceContext`. Decoders can output hardware frames (`AV_PIX_FMT_*` HW formats); encoders accept them when supported. Transfer to system memory uses `av_hwframe_transfer_data`.

## Real decode sketch (software)

```
pkt = demuxed packet for stream i
avcodec_send_packet(dec_ctx, pkt)
while (avcodec_receive_frame(dec_ctx, frame) == 0)
    process(frame)
```

## Real encode sketch (software)

```
avcodec_send_frame(enc_ctx, frame)
while (avcodec_receive_packet(enc_ctx, pkt) == 0)
    av_interleaved_write_frame(fmt_ctx, pkt)
```

*Verified against avcodec.h send/receive overview.*
