# CLI Baseline

**Phase**: 5  
**Reference binary (workspace verification)**: system `ffmpeg` / `ffprobe` 6.1.1-3ubuntu5  
**MediaForge source status**: No vendored `fftools/` tree yet; CI builds upstream FFmpeg.

## Tools

| Tool | Role | Notes |
|------|------|--------|
| `ffmpeg` | Transcode, filter, remux | Primary pipeline |
| `ffprobe` | Inspect media | JSON/XML/CSV/default writers |
| `ffplay` | Preview | Optional; not required in minimal CI |

Architecture overview: [CLI_ARCHITECTURE.md](../architecture/CLI_ARCHITECTURE.md).

## Verified capabilities (upstream)

| Area | Status | Notes |
|------|--------|--------|
| Help | Strong | `-h`, `-h full`, `-h type=name` |
| Logging | Strong | `-loglevel` / `-v` quiet…trace |
| Progress | Present | human progress lines; `-progress url` for machine updates |
| Overwrite | Explicit | `-y` overwrite, `-n` no overwrite |
| Probe structured | Strong | `ffprobe -print_format json -show_format -show_streams` |
| Filters | Strong | `-vf` / `-af` / `-filter_complex` |
| HW accel | Config-dependent | `-hwaccel` family when built |

## Usability observations (not automatic “bugs”)

| Observation | Severity | MediaForge approach |
|-------------|----------|---------------------|
| Option surface is huge; discoverability is hard for newcomers | Medium UX | Document workflows in EXAMPLES; optional `mediaforge` help map |
| Invalid option messages are short | Low | Document; core message text owned by upstream `fftools` until vendored |
| Exit codes are useful but not widely documented for scripts | Medium | [EXIT_CODES.md](EXIT_CODES.md) |
| ETA in progress can be misleading on VBR / filters | Informational | Do not invent fake ETAs in helpers |
| Full help is very long | Low | Point users to topic help and EXAMPLES |

## Compatibility constraints

- Do **not** rename or remove FFmpeg options.
- Do **not** change default overwrite behavior.
- Do **not** change JSON schema of `ffprobe` writers.
- Any MediaForge wrapper must **delegate** to `ffmpeg`/`ffprobe` for real work.

## Automation limitations (current)

- No MediaForge-specific structured error JSON (upstream logs are text).
- Progress parsing requires stable `-progress` / log conventions.
- CI builds may disable many encoders/demuxers (minimal configs).

## Improvement areas justified in Phase 5

1. Project documentation (this directory).  
2. Tested examples.  
3. Exit-code documentation.  
4. Optional task-oriented helper script (`scripts/mediaforge`).  
5. Lightweight CLI regression tests in CI.  

**Not** in Phase 5: rewrite of `fftools/ffmpeg.c` option parser (requires vendored source + high regression risk).
