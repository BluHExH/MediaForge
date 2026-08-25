# Attack Surface Map

Untrusted input boundaries for MediaForge / upstream FFmpeg pipelines.

## Trust boundary (summary)

```
Untrusted media / network / user options
        │
        ▼
┌───────────────────┐
│ Protocol / AVIO   │  file, pipe, http, rtmp, … (config-dependent)
└─────────┬─────────┘
          ▼
┌───────────────────┐
│ Demuxer           │  container structure, indexes, metadata
└─────────┬─────────┘
          ▼
┌───────────────────┐
│ Parser / BSF      │  elementary stream framing, annex-B, etc.
└─────────┬─────────┘
          ▼
┌───────────────────┐
│ Decoder           │  compressed → raw (AVFrame)
└─────────┬─────────┘
          ▼
┌───────────────────┐
│ Filters           │  graph options + frame data
└─────────┬─────────┘
          ▼
┌───────────────────┐
│ Encoder / Muxer   │  often less attacker-driven, still need valid sizes
└───────────────────┘
```

CLI (`ffmpeg`, `ffprobe`) multiplies surface: option strings, filtergraphs, map specs, metadata edits.

## Entry points by subsystem

### libavformat — protocols & demuxers

| Input | Handled by | Risk notes |
|-------|------------|------------|
| File / URL bytes | `AVIOContext`, protocol handlers | Path traversal and SSRF are **application** concerns; lavf focuses on byte parsing |
| Container headers | Demuxers (`AVInputFormat`) | Truncation, absurd lengths, cyclic indexes |
| Stream metadata | Demuxers | Huge tags, invalid UTF-8, nested structures |
| Timestamps / durations | Demuxers | Extreme pts/dts, bad time bases |
| Stream counts | Demuxers | Excessive streams → allocation pressure |

### libavcodec — parsers, BSFs, codecs

| Input | Handled by | Risk notes |
|-------|------------|------------|
| Packet payloads | Decoders | Bitstream errors, invalid dimensions in headers |
| Extradata | Codec init | SPS/PPS, codec private data |
| Codec parameters | `AVCodecParameters` / context | Width, height, sample rate, channel layout |
| Bitstream filters | BSF chain | In-place packet transforms |
| Subtitle bitstreams | Subtitle decoders | Text + control sequences |
| Image codecs | Image decoders | Often dense historical bug class |

### libavfilter

| Input | Handled by | Risk notes |
|-------|------------|------------|
| Filtergraph string | Graph parser | Complex expressions, huge graphs |
| Per-filter options | `AVOption` | Type confusion if mis-set by apps |
| Frame dimensions / formats | Negotiation + filter code | Must reject impossible formats |

### libavdevice

Device capture/playback is mostly local hardware; still can feed pathological frames into the pipeline. Lower priority for pure file-based threat models.

### libswscale / libswresample

Primarily transform libraries. Hostile dimensions or formats from a compromised demux/decode path matter; direct untrusted byte parsing is limited.

### fftools (CLI)

| Input | Risk notes |
|-------|------------|
| Command-line options | Parsing bugs, path handling |
| `-filter_complex` | Graph size / complexity |
| Output patterns | Application-level path safety |

## High-sensitivity data fields

These values often drive allocations or loop bounds:

- Frame **width**, **height**, **stride**
- **Packet size**, **nb_samples**, **channels**
- **Extradata size**
- **Metadata** entry sizes and counts
- **Sample rate**, **frame rate** (rational)
- **Side data** sizes
- **Huffman / table** sizes inside bitstreams

Any path that multiplies these without overflow-safe helpers is high priority for review when MediaForge owns patches.

## Surfaces intentionally reduced in MediaForge CI (minimal configs)

- Network protocols disabled
- Most demuxers/decoders disabled
- Docs and many external libs disabled

This shrinks CI attack surface and build time; it does **not** remove those surfaces from full builds users may enable.

## Application vs library responsibility

| Concern | Primarily |
|---------|-----------|
| Opening untrusted paths / URLs | Application |
| Resource limits (CPU, memory, time) | Application + library guards |
| Parsing hostile bytes inside containers/codecs | Library |
| Sandboxing the process | Operator / OS |

MediaForge documentation emphasizes library robustness; deployers must still sandbox untrusted media processing.
