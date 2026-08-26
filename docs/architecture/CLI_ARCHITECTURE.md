# CLI Architecture (fftools)

## Tools

| Tool | Role |
|------|------|
| **ffmpeg** | Transcode, filter, remux — main pipeline driver |
| **ffprobe** | Inspect containers, streams, frames, packets |
| **ffplay** | Simple SDL-based player (optional build) |

Sources live under `fftools/`.

## ffmpeg (conceptual flow)

1. Parse options → build input/output sets  
2. Open inputs (`avformat_open_input`), find streams  
3. Configure filters if `-filter_complex` / `-vf` / `-af`  
4. Open encoders / copy mode  
5. Open outputs, write header  
6. Loop: demux → [decode → filter → encode] → mux  
7. Trailers, cleanup  

Options map to library calls (e.g. `-c:v libx264` → encoder selection; `-vf scale=…` → filter graph string).

## ffprobe

Uses demux and optional decode to print metadata, packets, or frames in text/JSON/XML/CSV writers.

## MediaForge relevance

CLI UX improvements (clearer errors, progress, machine-readable output) are medium risk and high user value if compatibility is preserved. See Phase 5 roadmap.

*Verified against fftools presence in tree and standard CLI behavior.*

## Phase 5 notes (MediaForge)

- Full CLI baseline and examples: `docs/cli/`
- Optional helper: `scripts/mediaforge` (help/recipes/passthrough only)
- Compatibility policy: ADR-0005 — do not break upstream option semantics
- Core `fftools/` source is still upstream until MediaForge vendors a tree
