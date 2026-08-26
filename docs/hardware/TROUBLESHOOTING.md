# Hardware Troubleshooting

## General approach

1. Confirm **software** pipeline works (`ffmpeg` without `-hwaccel`).  
2. List binary capabilities: `ffmpeg -hwaccels`, `ffmpeg -encoders`, `mediaforge hwinfo`.  
3. Confirm **device** visibility (`ls /dev/dri`, `nvidia-smi`, Device Manager, etc.).  
4. Try the simplest HW command for your backend; read the full error line.  
5. Fall back to software; fix drivers/permissions before chasing MediaForge bugs.

## Common classes

| Symptom | Likely cause | What to try |
|---------|--------------|-------------|
| `No device available` / init fail | Missing driver or device node | Install drivers; check `/dev/dri`; groups |
| Encoder not found | Build without that encoder | Use full build or software encoder |
| Unsupported pixel format | Need hw download/upload or hw filter | Insert `hwdownload`/`hwupload` or use hw scale |
| Works on desktop, fails in container | Devices not passed through | Map `/dev/dri` or NVIDIA container toolkit |
| Slow despite GPU | Transfer-heavy pipeline / tiny job | Keep frames on GPU; measure with Phase 4 scripts |
| Permission denied | udev / group | Add user to `render`/`video`; restart session |

## MediaForge-specific

- `mediaforge hwinfo` failing entirely → ffmpeg/ffprobe missing from PATH.  
- `mediaforge inspect` must still work without GPU (hardware section is optional).  
- CI jobs without GPUs **skip** HW runtime tests; that is success, not a product defect.

## What not to claim

Do not report a backend as “verified” on MediaForge unless a machine with that device ran a successful encode/decode and the result was recorded in HARDWARE_REPORT.md.
