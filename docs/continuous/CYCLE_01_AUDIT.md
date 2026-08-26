# Continuous Cycle 01 — Repository Audit

**Date**: 2026-08-26  
**Base commit**: `b79dfc6`  
**VERSION**: `0.1.0-dev`

## What MediaForge owns

| Area | Status |
|------|--------|
| Docs, CI, tests, branding, release packaging | Strong foundation |
| `scripts/mediaforge` helpers | Real but thin UX layer |
| libav* / fftools source patches | **None** |

## Strongest capabilities

- Honest testing/FATE/security claims  
- Cross-platform CI smoke  
- Clear FFmpeg attribution  
- Helper surface: inspect, thumbnail, extract-audio, hwinfo  

## Weakest areas (evidence-based)

| Issue | Evidence |
|-------|----------|
| `inspect` is human-only | No stable JSON for scripts/CI |
| Fail-late on missing inputs | ffprobe/ffmpeg errors only; weak guidance |
| No post-write validation | Success possible with empty/missing output in edge cases |
| Batch/recipes DSL | Not justified yet (maintenance cost) |

## Priority ranking

| ID | Candidate | Priority | Verdict |
|----|-----------|----------|---------|
| A | `inspect --json` stable schema | **P1** | **Selected** |
| B | Preflight path checks + clearer errors | **P1** | **Selected** (same change set) |
| C | Post-output validation for thumbnail/extract-audio | **P1** | **Selected** |
| D | Full batch processor | P2 | Deferred — scheduler scope |
| E | Recipe DSL | P3 | Deferred — recipes text exists |
| F | Core FFmpeg patches | P3 | No measured need |

## Selected improvement

**Structured inspect (`--json`) + early validation + actionable errors + output checks** on MediaForge-owned helpers.

### Why MediaForge owns this

Upstream `ffprobe -print_format json` is low-level and verbose. MediaForge can offer a **stable, smaller schema**, fail-early UX, and validated helper pipelines without forking libav*.

### Testing strategy

CLI/media smokes: JSON keys, missing file exit, thumbnail validation failure path.

### Compatibility

Default `inspect` remains human text. `--json` is opt-in.
