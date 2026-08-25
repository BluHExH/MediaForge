# MediaForge Security Baseline

**Date**: 2026-08-26  
**Phase**: 3 — Security Audit & Hardening  
**Scope**: Process, tooling, and upstream FFmpeg surfaces used by MediaForge  

This document describes **current** security testing capabilities. It is **not** a certification that MediaForge or upstream FFmpeg is free of vulnerabilities.

## Project posture

| Fact | Implication |
|------|-------------|
| MediaForge currently builds **upstream FFmpeg** in CI | No MediaForge-owned codec/demuxer source to patch yet |
| Full local FFmpeg tree is impractical in the constrained workspace | Deep source audits and long fuzz runs run in CI / external hosts |
| Phase 1 provides multi-platform smoke builds + ASan/UBSan job | Memory/UB hygiene on a minimal feature set only |
| Full FATE and continuous fuzzing deferred (Phase 8 / ongoing) | Coverage is partial by design |

## Available sanitizers

| Sanitizer | Status in MediaForge CI | Notes |
|-----------|-------------------------|--------|
| AddressSanitizer (ASan) | Enabled on `linux-asan` job | Minimal configure; leak detection off for speed |
| UndefinedBehaviorSanitizer (UBSan) | Combined with ASan on same job | `halt_on_error=1` |
| MemorySanitizer (MSan) | Not in CI | Requires instrumented libc; deferred |
| ThreadSanitizer (TSan) | Not in CI | Valuable for threading bugs; expensive |
| Hardware-assisted (HWASan) | Not used | ARM-focused; not primary CI arch |

Configure pattern (see `.github/workflows/ci.yml`):

```text
--extra-cflags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer"
--extra-ldflags="-fsanitize=address,undefined"
```

## Current CI coverage (security-relevant)

- Linux minimal / standard / Clang builds (smoke)
- Linux ASan+UBSan minimal build + short smoke (lavfi → null)
- Windows MSYS2 and macOS smoke builds
- Docs/structure check
- **Not yet**: FATE, OSS-Fuzz replay, systematic malformed corpus, MSan/TSan

## Upstream FFmpeg security mechanisms (inherited)

When building upstream:

- `av_malloc` / `av_realloc` family and size helpers in `libavutil/mem.h`
- Assertions via `av_assert*` (`libavutil/avassert.h`)
- Many demuxers/decoders use explicit bounds checks and early returns on invalid sizes
- Refcounted `AVBuffer` / `AVFrame` / `AVPacket` reduce some lifetime classes of bugs when used correctly
- libFuzzer harnesses under `tools/` (see [FUZZING.md](FUZZING.md))
- Historical integration with **OSS-Fuzz** (Google continuous fuzzing of FFmpeg)

MediaForge does not weaken these mechanisms.

## Known limitations

1. **No MediaForge source patches** — security findings must either be upstream issues or process/tooling gaps.
2. **Minimal ASan feature set** — many demuxers/codecs are disabled; sanitizer coverage is narrow.
3. **No continuous fuzzing in MediaForge CI** — resource and time bounds; recommend scheduled/external runs.
4. **Workspace RAM** — cannot fully clone/build FFmpeg locally for interactive audit in the default environment.
5. **Network disabled in minimal CI configs** — protocol surface not exercised in those jobs.

## Areas requiring deeper analysis (priority)

| Priority | Area | Why |
|----------|------|-----|
| High | Demuxers & parsers for common containers | First contact with untrusted bytes |
| High | Image and subtitle parsers | Historically high bug density industry-wide |
| High | Integer size calculations (w×h×bpp, packet sizes) | Overflow → under-allocation |
| Medium | Bitstream filters and extradata handling | Easy to miss edge cases |
| Medium | Filter graph option parsing | User-controlled strings |
| Medium | Timestamp / duration arithmetic | Edge cases, overflow |
| Lower (for now) | Hardware acceleration paths | Device-specific; needs real HW |
| Lower (for now) | Network protocols | Disabled in minimal CI; enable carefully |

## What this baseline is not

- Not a penetration test
- Not a complete CVE audit of all FFmpeg history
- Not a guarantee of crash-free behavior on hostile input
- Not permission to skip regression tests when patches appear

## Related documents

- [ATTACK_SURFACE.md](ATTACK_SURFACE.md)
- [THREAT_MODEL.md](THREAT_MODEL.md)
- [FUZZING.md](FUZZING.md)
- [SECURITY_TESTING.md](SECURITY_TESTING.md)
- [SECURITY_AUDIT.md](SECURITY_AUDIT.md)
