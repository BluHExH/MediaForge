# Format / Container Architecture

## Core objects

- **AVFormatContext** — demux or mux session  
- **AVStream** — one track; holds `codecpar`, `time_base`, disposition, metadata  
- **AVIOContext** — byte I/O (read/write/seek callbacks)  
- **AVInputFormat / AVOutputFormat** — format plugins  

## Probing

`av_probe_input_format` / related helpers score buffers against registered demuxers. `avformat_open_input` combines open + probe unless format is forced.

## Timestamps

- Each stream has a `time_base` (`AVRational`).  
- Packet `pts`/`dts` are in that stream time base.  
- `AV_NOPTS_VALUE` means “unknown”.  
- Muxers often require monotonic DTS; interleaving helpers exist.

## Stream selection

Applications choose streams by index, disposition (default, forced), or language metadata. `av_find_best_stream` is a common helper.

## Remux path

Packets can move demux → mux without decode when codecs and containers are compatible (possibly with a BSF). This is the efficient path for “copy” mode in the ffmpeg CLI.

*Verified against libavformat role and standard APIs.*
