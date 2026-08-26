# MediaForge CLI Documentation

Compatibility-first CLI guidance for MediaForge (FFmpeg-based tools).

| Document | Purpose |
|----------|---------|
| [CLI_BASELINE.md](CLI_BASELINE.md) | Current capabilities and constraints |
| [PRINCIPLES.md](PRINCIPLES.md) | Design principles |
| [EXIT_CODES.md](EXIT_CODES.md) | Success/failure signaling |
| [EXAMPLES.md](EXAMPLES.md) | Tested common workflows |
| [CLI_REPORT.md](CLI_REPORT.md) | Phase 5 report |
| [INSPECT_JSON.md](INSPECT_JSON.md) | inspect --json schema v1 |
| [decisions/](decisions/) | CLI ADRs |

Related: [architecture/CLI_ARCHITECTURE.md](../architecture/CLI_ARCHITECTURE.md)

**Tools**: upstream `ffmpeg`, `ffprobe`, optional `ffplay`. Optional MediaForge helper: `scripts/mediaforge` (task-oriented help; delegates to FFmpeg).
