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
| 1 | Build and CI Foundation | Planned | Reproducible builds, GitHub Actions (Linux/Windows/macOS), sanitizers, warning hygiene |
| 2 | Architecture Documentation | Planned | Deep docs under `docs/architecture/` covering demux/decode/encode/mux/filter/hwaccel relationships |
| 3 | Security Audit | Planned | Memory safety, integer issues, parser robustness, sanitizer + fuzzing integration |
| 4 | Performance Engineering | Planned | Establish `docs/BENCHMARKS.md`, profile, optimize only after measurement |
| 5 | Modern CLI / Developer Experience | Planned | Diagnostics, progress, machine-readable output, safer defaults (compat-preserving) |
| 6 | Media Processing Improvements | Planned | Filters, metadata, subtitles, pipelines — only with real use-cases + tests |
| 7 | Hardware Acceleration | Planned | Improve graceful fallback, coverage, documentation of CUDA/VA-API/Vulkan/VideoToolbox/etc. |
| 8 | Testing and Fuzzing | Planned | Strengthen FATE, unit/integration, malformed input, continuous fuzzing |
| 9 | Documentation and Branding | Planned | Final name decision, README, logo concept, consistent terminology, attribution |
| 10 | Compatibility and Release Engineering | Planned | Release gates, artifacts, notes, matrix |
| ∞ | Continuous Engineering Loop | Ongoing after 10 | AUDIT → PLAN → IMPLEMENT → TEST → BENCHMARK → SECURITY → DOCUMENT → COMMIT → PUSH |

## Near-Term Priorities (after Phase 0)

1. Obtain a usable full source tree (CI runners or improved workspace).
2. Establish clean baseline builds and automated CI.
3. Document architecture without changing behavior.
4. Begin defensive security review of high-risk parsers.

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

*Last updated: Phase 0 completion, 2026-08-25*
