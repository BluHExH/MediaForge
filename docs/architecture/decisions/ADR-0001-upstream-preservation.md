# ADR-0001: Upstream Preservation

## Status

Accepted (Phase 0–2)

## Context

MediaForge is based on the official FFmpeg codebase. Casual rewrites of mature subsystems would destroy compatibility and trust.

## Decision

Preserve upstream architecture, public APIs, and build system. Prefer minimal, tested changes. Do not replace configure/Makefile or core codec/format designs without an explicit, documented decision and migration plan.

## Consequences

- Slower feature velocity in core paths  
- Higher compatibility with existing tools and bindings  
- Clear attribution and license continuity  
