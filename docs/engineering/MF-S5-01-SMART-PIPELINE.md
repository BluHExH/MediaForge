# MF-S5-01 — Smart Pipeline (implemented)

## Problem

Unnecessary scale/transcode is expensive relative to stream-copy when the source already matches the target.

Stage 5 measurement (synthetic 720p): scale path ~5× null path.

## Implementation

**Location**: `scripts/mediaforge` command `process` (helper only).  
**FFmpeg C / `vendor/patches`**: unchanged / empty.

### CLI

```bash
mediaforge process INPUT -o OUTPUT [--smart] [--plan] [--json] \
  [--width N] [--height N] [--video-codec NAME] [--audio-codec NAME]
```

- **Default (no `--smart`)**: always `PROCESS` for requested targets (e.g. always scale if `--width`/`--height` set).
- **`--smart`**: if requested properties already match input → `STREAM_COPY` (`ffmpeg -c copy`); else `PROCESS` with only required scale/codecs.
- **`--plan`**: print plan only (no write).
- **`--json`**: plan schema v1 (separate from inspect schema v1).

### Decisions

| Decision | Meaning |
|----------|---------|
| `STREAM_COPY` | Properties satisfied; remux with `-c copy` |
| `PROCESS` | Scale and/or codec conversion required (or smart off) |

Unspecified targets are **not** treated as requirements. Fail closed when video stream missing but dimensions requested.

### Tests

`tests/cli/process_smart.sh` — 8 PASS (plan match/mismatch, exec no-scale log, exec scale, errors).

### Benchmark (this environment, 640×360 2s mpeg4)

| Path | wall (s) | notes |
|------|----------|--------|
| `--smart` match → stream_copy | **0.21** | includes probe + plan + remux |
| no `--smart` same dims + force scale | **0.29** | unnecessary scale |
| `--smart` mismatch → scale | **0.26** | required work |

Smart mode adds inspection cost; it helps when it **avoids** expensive work. Not guaranteed faster for every tiny file.

## Compatibility

Existing commands unchanged. `process` is new and opt-in for smart behavior.
