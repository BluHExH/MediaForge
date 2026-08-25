# Hardware Acceleration Architecture

## Core abstractions (libavutil)

- **AVHWDeviceContext** — connection to a device (CUDA, VAAPI, QSV, D3D11VA, D3D12VA, VideoToolbox, Vulkan, OpenCL, AMF, DRM, MediaCodec, …).  
- **AVHWFramesContext** — pool of frames on that device with a specific HW pixel format.  
- Backends: `hwcontext_*.c` / `hwcontext_*.h` under libavutil (presence verified in tree).

## Decode

1. Create device context (`av_hwdevice_ctx_create` or derived).  
2. Set `AVCodecContext.hw_device_ctx`.  
3. Optionally constrain pixel formats via `get_format` callback.  
4. Receive frames with HW pixel formats; transfer if CPU access needed.

## Encode

Attach device / frames context so the encoder accepts HW frames when supported (NVENC, QSV, VAAPI encode, VideoToolbox, etc., depending on build).

## Filtering

Some filters operate on HW frames (scale_cuda, overlay_cuda, etc.). Negotiation must keep HW format through the subgraph or insert downloads/uploads.

## CPU ↔ GPU

`av_hwframe_transfer_data` copies between system and hardware frames. Expensive; pipelines should minimize transfers.

## MediaForge stance

Do not claim support for a backend unless it is present in the tree and enabled at configure time. Always provide software fallback paths.

*Verified against libavutil hwcontext*.h listing and avutil.h library list.*
