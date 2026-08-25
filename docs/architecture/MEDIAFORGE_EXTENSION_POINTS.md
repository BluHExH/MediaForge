# MediaForge Extension Points

Categorized by risk for future work. **Do not implement features here** — this is a map only.

## Low risk

| Area | Notes | Testing |
|------|-------|---------|
| Documentation | Architecture, man pages, examples | Review |
| CI / build scripts | Matrices, sanitizers, caching | CI green |
| FATE harness / smoke tests | More cases without changing codecs | FATE / CI |
| Logging / diagnostics helpers | Clearer messages via existing `av_log` | Unit / manual |
| Tooling scripts | Reproduce builds, collect logs | Manual |

## Medium risk

| Area | Notes | Testing |
|------|-------|---------|
| New libavfilter filters | Follow existing filter templates | FATE graphs + ASan |
| CLI UX (ffmpeg/ffprobe) | Progress, errors, JSON fields | Compatibility suite |
| Bitstream filters | Packet-level transforms | FATE + sample files |
| Metadata / side-data utilities | Non-invasive helpers | Unit + remux tests |
| Protocol helpers | Careful with network edge cases | Integration |

## High risk

| Area | Notes | Testing |
|------|-------|---------|
| Codec DSP / bitstream parsers | Easy to break streams | Full FATE, fuzz |
| Timestamp / interleaving core | Subtle A/V sync bugs | Multi-stream samples |
| Threading models | Races, deadlocks | Stress + TSan |
| Public API / ABI | Breaks downstream | Version policy + CI |
| Memory / buffer pools | Use-after-free, leaks | ASan/MSan + fuzz |
| Hardware pipelines | Device-specific, transfer bugs | Real HW + fallback tests |

## Compatibility rules

1. Prefer additive changes.  
2. Keep public headers stable within major versions.  
3. Never weaken tests to pass CI.  
4. Document tradeoffs in ADRs when high-risk work is approved.

*Phase 2 output — informs Phases 3–8.*
