# Hardware Requirements

## Build-time

| Backend | Typical configure / package needs |
|---------|-----------------------------------|
| General | Working C toolchain; FFmpeg `./configure` auto-detect or explicit `--enable-*` |
| NVENC | Often enabled when headers/libs found; runtime driver still required |
| VAAPI | `libva` development packages |
| QSV | oneVPL / Media SDK dev packages |
| Vulkan | Vulkan headers/loader |
| VideoToolbox | Apple SDKs (macOS builds) |

Minimal MediaForge CI configs intentionally `--disable-autodetect` and enable a small set of features — **do not expect NVENC in those binaries**.

## Runtime

| Need | Notes |
|------|--------|
| Kernel driver + user-mode driver | Vendor-specific |
| Device nodes | e.g. `/dev/dri/renderD*` (VAAPI), NVIDIA device files |
| Permissions | User in `video`/`render` groups on Linux |
| Matching encoder/decoder | Binary must include the hw encoder; GPU must support the codec profile |
| Display-less servers | VAAPI/DRM still need render nodes; some stacks need extra config |

## Software fallback

If any runtime requirement fails, use software decode/encode (`libx264`, native decoders, etc.). MediaForge helpers must not require GPU for default workflows (`inspect`, `thumbnail`, `extract-audio`).
