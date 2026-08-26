# Compatibility Baseline

**Phase**: 10  
**Date**: 2026-08-26  
**Project maturity**: pre-release (`VERSION` = `0.1.0-dev`)

## Layers

| Layer | Surface | Guarantee today |
|-------|---------|-----------------|
| L1 Upstream FFmpeg | `ffmpeg`, `ffprobe`, libraries when built | Upstream semantics; MediaForge does not rewrite options |
| L2 Helpers | `scripts/mediaforge` subcommands | Best-effort; exit codes propagate from children; may gain subcommands in minor versions |
| L3 Docs / process | Documented workflows, CI | Descriptive; not a binary ABI |
| L4 Future APIs | None shipped as stable C API | Experimental only if introduced later |

## Current helper surface

| Command | Compatibility notes |
|---------|---------------------|
| `help`, `recipes`, `version` | Stable intent for 0.x |
| `inspect`, `thumbnail`, `extract-audio`, `hwinfo` | May refine flags; document in CHANGELOG |
| `probe`, `ffmpeg`, `run` | Thin exec passthrough |

## Explicit non-guarantees

- Bit-identical archives across machines  
- GPU feature availability  
- Full FATE on every commit  
- SemVer “stable” until a non-`dev` tag is published under Phase 10 gates  
