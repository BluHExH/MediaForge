# Phase 5 CLI Report

**Date**: 2026-08-26  
**Scope**: CLI developer experience without incompatible rewrites  

## Baseline

Upstream FFmpeg CLI is mature: rich options, logging levels, `ffprobe` structured writers, `-progress`, explicit `-y`/`-n`. MediaForge does not yet vendor `fftools/`; Phase 5 therefore prioritizes **documentation, tests, and an optional helper**, not a parser rewrite.

## Problems addressed

| Issue | Action |
|-------|--------|
| Discoverability for common tasks | EXAMPLES.md + `scripts/mediaforge` recipes |
| Exit codes poorly documented for scripts | EXIT_CODES.md + tests |
| No project CLI test smoke | `tests/cli/smoke.sh` + CI hook |
| Risk of incompatible “new CLI” | ADR-0005 compatibility strategy |

## Implemented

1. `docs/cli/*` documentation suite  
2. Principles and exit-code guidance  
3. Tested example catalog  
4. Optional `scripts/mediaforge` help/recipes/probe/ffmpeg passthrough  
5. CLI smoke tests  
6. ADR-0005  

## Not implemented (intentional)

| Item | Reason |
|------|--------|
| Rewrite of `fftools/ffmpeg` diagnostics | No vendored source; high regression risk |
| New default progress UI | Upstream adequate; avoid surprise |
| New structured error protocol | Would need wide adoption design |
| Forced high-level subcommands replacing ffmpeg | Compatibility violation |

## Compatibility

All documented `ffmpeg`/`ffprobe` examples use standard upstream syntax. The helper never changes FFmpeg defaults; it only prints guidance or exec’s through.

## Performance / security

- No change to media hot paths  
- Helper is shell text only  
- Tests use lavfi / null / tiny outputs  
- Phase 3 malformed posture unchanged  

## Future ideas (post–source vendor)

- Contextual hints on selected error paths in `fftools` (opt-in)  
- Stable MediaForge man pages  
- Richer `mediaforge convert` only if ADR updated and tests exist  

## Conclusion

Phase 5 improves **developer experience around** the FFmpeg CLI without alienating existing users or rewriting fftools.
