# Phase 7 Hardware Report

**Date**: 2026-08-26  
**Environment**: Linux workspace without `/dev/dri` or NVIDIA tools  

## Evaluated

- Upstream HW architecture (`AVHWDeviceContext` / frames / transfer)  
- Distro ffmpeg binary capability lists (`-hwaccels`, hw encoders/decoders)  
- CI constraints for GPU-less runners  
- Fallback and diagnostics policy  

## Implemented

1. `docs/hardware/*` baseline, requirements, troubleshooting, report  
2. ADR-0006: optional HW, skip-not-fail tests, no parallel GPU API  
3. `mediaforge hwinfo` — capability listing + best-effort runtime probe  
4. `tests/hardware/smoke.sh` — always-run software checks; HW runtime **SKIP** if no device  
5. Architecture doc touch-up  

## Verified vs untested

| Item | Status |
|------|--------|
| Software inspect/thumbnail/extract-audio | Verified (Phase 6/7 tests) |
| Listing hwaccels from ffmpeg binary | Verified in workspace |
| CUDA/VAAPI/QSV/VideoToolbox **runtime** transcode | **Untested** (no device) |
| Zero-copy filter graphs | Untested here |
| Multi-GPU selection | Documented only |

## Benchmarks

No hardware throughput numbers published. Publishing GPU fps without a device would violate project rules. Use `benchmarks/` software scripts; add `benchmarks/hardware/` results only when a real GPU run exists.

## Security / resources

- No new unsafe parsers  
- HW paths still subject to upstream demux/decode robustness  
- Resource lifetime remains upstream’s `AVBufferRef` model; MediaForge does not own device contexts in helpers  

## Future work

- Optional self-hosted GPU workflow  
- Record first verified NVENC/VAAPI/VideoToolbox runs in this report when available  
- Pin `FFMPEG_REF` and document which HW options the CI binary actually contains  
