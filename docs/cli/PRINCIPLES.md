# MediaForge CLI Principles

1. **Compatibility first** — Existing FFmpeg commands and options keep working. No silent renames or semantic changes.
2. **Explicit over magical** — Prefer clear flags over hidden automatic behavior.
3. **Script-friendly** — Stable machine-readable modes (`ffprobe -print_format json`, logging levels) remain usable.
4. **Safe defaults** — Do not make overwrite or destructive behavior more aggressive than upstream.
5. **Useful errors** — Prefer actionable messages; do not leak secrets; do not break parseable modes unexpectedly.
6. **Composability** — Tools remain usable in pipelines, CI, and containers.
7. **Opt-in conveniences** — Higher-level helpers (e.g. `scripts/mediaforge`) must not replace or shadow the standard CLI by force.
