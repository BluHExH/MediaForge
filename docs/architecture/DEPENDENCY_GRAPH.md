# Dependency Graph

Verified against upstream library layout and typical link order (libavutil is the foundation; higher libraries depend downward).

```mermaid
flowchart BT
  util[libavutil]
  codec[libavcodec]
  format[libavformat]
  filter[libavfilter]
  device[libavdevice]
  scale[libswscale]
  resample[libswresample]
  tools[fftools]

  codec --> util
  format --> codec
  format --> util
  filter --> util
  filter --> codec
  filter --> scale
  filter --> resample
  device --> format
  device --> util
  scale --> util
  resample --> util
  tools --> format
  tools --> codec
  tools --> filter
  tools --> device
  tools --> scale
  tools --> resample
  tools --> util
```

## Rules of thumb

| Library | May depend on |
|---------|----------------|
| libavutil | (none of the other FFmpeg libs) |
| libavcodec | libavutil |
| libavformat | libavutil, libavcodec |
| libavfilter | libavutil, libavcodec; optionally libswscale, libswresample |
| libavdevice | libavutil, libavformat |
| libswscale | libavutil |
| libswresample | libavutil |
| fftools | all of the above as needed |

Architecture-specific code (x86/, arm/, aarch64/, neon, SSE, AVX, etc.) lives *inside* the libraries that need it and is selected at configure/build time.

*Source: FFmpeg tree layout and public headers.*
