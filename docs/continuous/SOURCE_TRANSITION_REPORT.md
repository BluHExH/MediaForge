# Source Transition Report

**Date**: 2026-08-26  
**Base commit before work**: `f373d76`

## Current state

| Stage | Status |
|-------|--------|
| 1 Architecture plan | **Done** — `SOURCE_INTEGRATION_PLAN.md` |
| 2 Import full tree into `vendor/ffmpeg` | **Not completed in this environment** (clone/tarball interrupted by timeouts) |
| 3 Build from repo path | **Scripts + CI prefer vendor when present** |
| 4 CI source-only | Deferred until Stage 2 lands |
| 5–8 Native patches / benchmarks | Not started |

## FFmpeg baseline

| Field | Value |
|-------|--------|
| Tag | `n7.1.5` |
| Commit | `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` |
| Config | `config/upstream.env` |

## Source strategy

**Vendored snapshot** under `vendor/ffmpeg/` (not submodule). Bootstrap: `scripts/vendor-ffmpeg.sh`. Nested `.git` removed after vendor so MediaForge git owns the tree.

## Build / CI

- If `vendor/ffmpeg/configure` exists → CI uses it  
- Else → clone pinned tag (deterministic fallback)  
- Helpers still accept system `ffmpeg` for MediaForge smoke tests  

## Provenance

`config/upstream.env` + `.mediaforge-upstream-*` files after successful vendor.

## Tests (MediaForge layer)

Regression aggregate must remain green (helpers/docs independent of vendored tree presence).

## Native changes

None.

## Limitations

Full multi-thousand-file FFmpeg import could not be finished in the agent environment due to **network/IO timeouts**. Architecture and automation are in place so Stage 2 can complete on a normal developer or CI machine:

```bash
bash scripts/vendor-ffmpeg.sh
git add vendor/ffmpeg
git commit -m "vendor: ffmpeg n7.1.5 (3a0867c2)"
```

## Next step

1. Complete `vendor-ffmpeg.sh` on a reliable network  
2. Commit the tree  
3. Confirm CI log line `Using in-tree vendor/ffmpeg`  
4. Only then consider measured in-tree patches  
