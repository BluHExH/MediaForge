# libavformat

**Purpose**: Demuxing and muxing of containers, protocol I/O, probing, and stream-level metadata.

## Important concepts

- **AVFormatContext** — central demux or mux session (streams, metadata, IO).
- **AVStream** — one elementary stream inside a format (codecpar, time_base, disposition).
- **AVIOContext** — buffered byte I/O abstraction (file, network, custom callbacks).
- **AVInputFormat / AVOutputFormat** — demuxer / muxer implementations.
- **Probing** — score-based detection of format from buffer content.
- **Timestamps** — stream `time_base`; packets carry pts/dts in that base; `AV_NOPTS_VALUE` when unknown.

## Container vs codec vs stream vs packet vs frame

| Term | Layer | Meaning |
|------|--------|---------|
| Container | format | File/stream structure (MP4, MKV, MPEG-TS, …) |
| Stream | format | One logical media track inside a container |
| Codec | codec | Compression algorithm (H.264, AAC, …) |
| Packet | codec/format | Compressed unit (often one access unit) |
| Frame | codec | Uncompressed picture or audio block |

Demuxers emit packets; decoders turn packets into frames. Muxers take packets (from encoders or remux paths).

## Typical demux flow

1. `avformat_open_input` (or custom AVIO + `avformat_open_input`)
2. `avformat_find_stream_info`
3. Loop `av_read_frame` → AVPacket
4. `avformat_close_input`

## Typical mux flow

1. `avformat_alloc_output_context2`
2. Add streams, set codecpar / time_base
3. `avio_open` / set pb
4. `avformat_write_header`
5. `av_interleaved_write_frame` / `av_write_frame`
6. `av_write_trailer`
7. Close

## Dependencies

libavutil, libavcodec (for codec parameters and sometimes bitstream filters).

## MediaForge relevance

Medium risk for new demuxers/muxers or protocol helpers. Timestamp and interleaving logic is high risk.

*Verified against FFmpeg library overview in avutil.h and standard libavformat APIs.*
