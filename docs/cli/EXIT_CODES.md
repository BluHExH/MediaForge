# Exit Codes (CLI)

Observed with system FFmpeg 6.1.1 on Linux (workspace). Upstream may use additional codes; scripts should treat **any non-zero as failure** unless a specific code is documented for a workflow.

## Practical table

| Situation | Typical exit | Notes |
|-----------|--------------|--------|
| Success | `0` | Encode/probe completed |
| Unknown / invalid option | `8` | e.g. `ffmpeg -nonexistent_option` |
| Missing / unreadable input | non-zero (e.g. `254`) | Path errors |
| Interrupted (SIGINT) | non-zero | Scripts should handle signals |
| Encode/filter failure | non-zero | Check logs |

## Scripting guidance

```bash
ffmpeg -y -i in.mp4 -c:v libx264 out.mp4
status=$?
if [ "$status" -ne 0 ]; then
  echo "ffmpeg failed with exit $status" >&2
  exit "$status"
fi
```

```bash
ffprobe -v error -print_format json -show_format -show_streams "$FILE" > meta.json
```

## MediaForge policy

- Helpers must propagate the underlying `ffmpeg`/`ffprobe` exit status.
- Do not map all failures to `1` if the child status is available.
- Document any MediaForge-specific codes if introduced later (none in Phase 5).
