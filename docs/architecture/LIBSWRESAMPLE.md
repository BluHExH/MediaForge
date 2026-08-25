# libswresample

**Purpose**: Audio sample rate conversion, sample format conversion, and channel mixing/rematrixing.

## Role

Analogous to libswscale for audio. Used by filters (e.g. `aresample`) and by applications that need explicit conversion between decoder and encoder formats.

## Dependencies

libavutil (sample formats, channel layouts, frames).

## MediaForge relevance

Same as swscale: measure first; avoid casual changes to core conversion kernels.

*Verified against library overview in avutil.h.*
