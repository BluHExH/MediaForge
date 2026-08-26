# Phase 6 Media Processing Report

**Date**: 2026-08-26

## Evaluated

Full inventory of video/audio/subtitle/metadata/image/streaming workflows against upstream FFmpeg maturity.

## Implemented (MediaForge)

1. **inspect** — human-oriented ffprobe summary  
2. **thumbnail** — single-frame extraction helper  
3. **extract-audio** — audio-only extraction helper  
4. Documentation suite under `docs/media/`  
5. `tests/media/smoke.sh`  
6. `docs/UPSTREAM_STRATEGY.md`  
7. `CHANGELOG.md` (MediaForge-specific)

## Intentionally rejected

| Idea | Reason |
|------|--------|
| New codecs / containers in C | Upstream; no vendored tree |
| Custom subtitle engine | Security + duplication |
| Automatic “best” thumbnail heuristics | Ambiguous quality; document limitation instead |
| Network stack changes | Out of scope |

## Architecture

Helpers live in `scripts/mediaforge` (Phase 5 base). No libav* patches.

## Tests

- `tests/media/smoke.sh` — inspect, thumbnail, extract-audio, failure paths  
- Existing `tests/cli/smoke.sh` still required  

## Performance

Helpers add negligible process overhead (one ffprobe/ffmpeg exec). No Phase 4 regression claimed or required.

## Security

- No new parsers of subtitle/binary formats in MediaForge code  
- Rely on upstream failure paths for malformed media  
- Document that services must apply timeouts/resource limits  

## Compatibility

- `ffmpeg`/`ffprobe` CLIs unchanged  
- Helper is optional  

## Future work

Vendor FFmpeg tree → consider in-tree tools or thin C helpers only with ADRs and FATE-style tests.
