# mediaforge inspect --json (schema v1)

Opt-in machine-readable inspect output.

```json
{
  "tool": "mediaforge",
  "schema_version": 1,
  "version": "0.1.0-dev",
  "input": "path",
  "format": { "format_name", "duration", "size", "bit_rate" },
  "streams": [ { "index", "codec_type", "codec_name", "width", "height", ... } ],
  "warnings": []
}
```

- Default `inspect` (no `--json`) remains human text (compatibility).
- Full ffprobe JSON remains available via `ffprobe -print_format json ...`.
- Schema bumps increment `schema_version` and are noted in CHANGELOG.
