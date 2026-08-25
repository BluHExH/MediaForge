# ADR-0003: Compatibility Strategy

## Status

Accepted (Phase 2)

## Context

Downstream projects depend on FFmpeg CLI behavior and libav* ABIs. MediaForge aims to improve without unnecessary breaks.

## Decision

1. Maintain CLI compatibility by default; document any intentional changes.  
2. Follow FFmpeg-style versioning for libraries (major = breaking).  
3. Prefer extension points classified as low/medium risk (filters, tests, CLI diagnostics) before high-risk core changes.  
4. Require tests and release notes for any user-visible behavior change.

## Consequences

- Constrains redesigns  
- Builds user and packager trust  
- Aligns with upstream compatibility guarantees described in libavutil docs  
