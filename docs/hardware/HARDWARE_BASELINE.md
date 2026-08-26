# Hardware Baseline

**Phase**: 7  
**Date**: 2026-08-26  

## Core FFmpeg abstractions (always the foundation)

| Concept | Role |
|---------|------|
| `AVHWDeviceContext` | Connection to a device (CUDA, VAAPI, QSV, D3D, VideoToolbox, Vulkan, …) |
| `AVHWFramesContext` | Pool of frames on a device / HW pixel format |
| HW pixel formats | e.g. `cuda`, `vaapi`, `qsv`, `videotoolbox_vld` |
| `av_hwframe_transfer_data` | GPU ↔ CPU copies |
| `-hwaccel` / `-init_hw_device` / `-filter_hw_device` | CLI device setup |

See also: [architecture/HARDWARE_ACCELERATION.md](../architecture/HARDWARE_ACCELERATION.md).

## Backend inventory

| Backend | Typical OS | Build deps (examples) | Runtime needs | MediaForge verification |
|---------|------------|----------------------|---------------|-------------------------|
| CUDA / NVDEC / NVENC | Linux/Windows | CUDA toolkit headers at build for some paths | NVIDIA driver, GPU | **Build list only** on Phase 7 workspace (no `nvidia-smi`, no device) |
| VAAPI | Linux | libva | `/dev/dri`, i915/AMD stack | **No `/dev/dri`** in Phase 7 workspace |
| QSV | Linux/Windows | oneVPL / Media SDK | Intel GPU + runtime | Untested runtime here |
| AMF | Windows (mainly) | AMF SDK | AMD drivers | Untested |
| VideoToolbox | macOS/iOS | system frameworks | Apple GPU | Untested in Linux CI |
| Vulkan | multi | vulkan headers | ICD + GPU | Listed in `-hwaccels` on sample binary; runtime untested |
| D3D11VA / D3D12VA | Windows | Windows SDK | GPU drivers | Untested (no Windows GPU runner in standard CI) |
| OpenCL | multi | OpenCL | runtime | Not a full codec path by itself |
| drm | Linux | libdrm | render nodes | No DRI nodes here |

## Workspace probe (Phase 7 environment)

| Check | Result |
|-------|--------|
| `ffmpeg -hwaccels` | Reports: vdpau, cuda, vaapi, qsv, drm, opencl, vulkan |
| HW encoder names in `-encoders` | Present in binary (nvenc, qsv, vaapi, …) |
| `/dev/dri` | **Absent** |
| `nvidia-smi` | **Not found** |
| Actual HW transcode | **Not executed** (no device) |

**Conclusion**: This environment demonstrates **compile/list-time** capability of a full-featured distro ffmpeg, **not** verified GPU encode/decode throughput.

## CI reality

GitHub-hosted standard runners typically lack vendor GPUs. MediaForge CI must:

- Compile/link with whatever the job enables (often minimal → few HW options)
- Run **software** tests always
- **SKIP** runtime HW tests when devices are missing (not FAIL)
