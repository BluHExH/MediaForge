# Audio Architecture

## Representation

- **Sample format**: `AVSampleFormat` (u8, s16, s32, flt, dbl, planar variants).  
- **Channel layout**: `AVChannelLayout` (replaces older channel masks).  
- **Sample rate**: integer Hz on context/frame.  
- **AVFrame** for audio: `nb_samples`, `ch_layout`, `format`, data planes.

## Pipeline

```
Demux → decode → [aresample / aformat / filters] → encode → mux
```

libswresample performs rate, format, and layout conversion when needed. Many graphs insert `aresample=async=1` style filters for drift handling.

## Timestamps

Audio frames carry `pts` in the stream time base. Duration is often derived from `nb_samples` and sample rate. Encoders may require fixed frame sizes (`AV_CODEC_CAP_VARIABLE_FRAME_SIZE` vs fixed).

## MediaForge relevance

Filter and conversion paths are safer change areas than core codec DSP.

*Verified against samplefmt.h / channel_layout.h roles and avutil overview.*
