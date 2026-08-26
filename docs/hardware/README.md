# Hardware Acceleration (MediaForge)

MediaForge uses **upstream FFmpeg** hardware abstractions (`AVHWDeviceContext`, `AVHWFramesContext`, hw codecs). There is no parallel GPU stack.

| Document | Purpose |
|----------|---------|
| [HARDWARE_BASELINE.md](HARDWARE_BASELINE.md) | Backends and what was verified |
| [REQUIREMENTS.md](REQUIREMENTS.md) | Build-time vs runtime |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Common failure modes |
| [HARDWARE_REPORT.md](HARDWARE_REPORT.md) | Phase 7 report |
| [decisions/](decisions/) | ADRs |

**CLI**: `mediaforge hwinfo` — lists hwaccels/encoders/decoders from the ffmpeg binary; probes runtime devices without failing media inspect.

**Rule**: Software paths remain first-class. GPU is never mandatory.
