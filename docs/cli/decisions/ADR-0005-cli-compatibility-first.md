# ADR-0005: CLI compatibility first

## Status

Accepted (Phase 5)

## Context

FFmpeg’s CLI is a de facto standard in scripts and documentation worldwide. MediaForge aims for better DX without breaking that ecosystem. MediaForge does not yet vendor `fftools/`.

## Decision

1. Preserve upstream `ffmpeg` / `ffprobe` / `ffplay` interfaces.  
2. Ship documentation and tests as the primary Phase 5 deliverable.  
3. Allow an **optional** helper (`scripts/mediaforge`) that only adds discoverability and explicit passthrough.  
4. Defer invasive `fftools` changes until a vendored tree exists and each change has tests.

## Consequences

- Faster, safer Phase 5 delivery.  
- High-level “magic” commands are recipes/docs, not a forced new language.  
- Future diagnostic patches in fftools remain possible under separate ADRs.
