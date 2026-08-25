# ADR-0002: CI-First Development

## Status

Accepted (Phase 1)

## Context

The interactive development workspace has severe RAM limits (~1.2 GiB). Full FFmpeg builds are impractical locally.

## Decision

Treat GitHub Actions as the primary build and validation environment. Local work focuses on documentation, small patches, and smoke checks. CI covers Linux (GCC/Clang/ASan), Windows (MSYS2), and macOS with reproducible logs.

## Consequences

- Reliable multi-platform signal  
- Dependence on Actions availability and minutes  
- Need to keep CI matrix modest and purposeful  
