# ADR-0006: Hardware optional; tests skip when devices missing

## Status

Accepted (Phase 7)

## Context

FFmpeg already provides HW device/frame abstractions. GitHub-hosted CI and many developer environments lack GPUs. Making GPU mandatory would break MediaForge’s core mission.

## Decision

1. Do **not** introduce a parallel GPU abstraction.  
2. GPU features are **optional**; software remains default.  
3. Capability detection uses ffmpeg CLI / upstream APIs, not fragile scraping of `/proc` alone.  
4. Automated tests **SKIP** (exit 0 with message) when hardware is absent; they do not FAIL.  
5. Never publish fabricated HW benchmark numbers.  
6. Auto-selection of HW backends, if added later, must be **opt-in** and deterministic.

## Consequences

- Honest documentation (“untested” vs “verified”).  
- Stable CI on CPU-only runners.  
- Helpers like `hwinfo` never break basic media inspect.
