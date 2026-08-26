# MediaForge Long-Term Roadmap

This roadmap is living and will be updated as phases complete and new opportunities are identified.

## Guiding Principles

- Correctness and stability first
- Security as a continuous practice
- Measurable performance improvements only
- Preserve compatibility unless there is a compelling technical reason
- Documentation and reproducibility
- Open-source best practices (clear commits, CI, attribution)

## Phases

| Phase | Title | Status | Notes |
|-------|-------|--------|-------|
| 0 | Repository Discovery | **Complete** | Baseline report, structure, licensing, name assessment |
| 1 | Build and CI Foundation | **Complete** | Reproducible builds, GitHub Actions (Linux/Windows/macOS), sanitizers, warning hygiene |
| 2 | Architecture Documentation | **Complete** | Deep docs under `docs/architecture/` covering demux/decode/encode/mux/filter/hwaccel relationships |
| 3 | Security Audit | **Complete** | Baseline docs, attack surface, threat model, fuzz notes, ASan malformed smokes |
| 4 | Performance Engineering | **Complete** | Baseline + benchmarks infra; no speculative source opts (ADR-0004) |
| 5 | Modern CLI / Developer Experience | **Complete** | CLI docs, examples, helper, smoke tests; no incompatible rewrite |
| 6 | Media Processing Improvements | **Complete** | Inventory, inspect/thumbnail/extract-audio helpers, media tests |
| 7 | Hardware Acceleration | Planned | Improve graceful fallback, coverage, documentation of CUDA/VA-API/Vulkan/VideoToolbox/etc. |
| 8 | Testing and Fuzzing | Planned | Strengthen FATE, unit/integration, malformed input, continuous fuzzing |
| 9 | Documentation and Branding | Planned | Final name decision, README, logo concept, consistent terminology, attribution |
| 10 | Compatibility and Release Engineering | Planned | Release gates, artifacts, notes, matrix |
| ∞ | Continuous Engineering Loop | Ongoing after 10 | AUDIT → PLAN → IMPLEMENT → TEST → BENCHMARK → SECURITY → DOCUMENT → COMMIT → PUSH |

## Near-Term Priorities (after Phase 6)

1. Pin `FFMPEG_REF` to a specific upstream commit/tag for reproducibility.
2. When environment permits, introduce a MediaForge source tree or submodule for real patches.
3. Media processing improvements (Phase 6) only with real use-cases + tests.
4. Keep CLI compatibility tests green when fftools is eventually vendored.

## Out of Scope (initially)

- Complete rewrite of core subsystems
- Breaking public API without strong justification and migration path
- Adding large new features solely for marketing value

## Success Metrics (high level)

- Clean CI on major platforms
- No regressions in FATE / existing tests
- Documented security improvements with regression tests
- Measurable performance gains with correctness verification
- Clear, professional documentation and attribution

---

*Last updated: Phase 6 completion, 2026-08-26*
