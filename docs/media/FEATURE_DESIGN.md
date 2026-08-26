# Feature Design (Phase 6)

## Design constraints

- No changes to upstream libav* C APIs in this phase (tree not vendored).
- Prefer **shell helpers** that exec `ffprobe`/`ffmpeg` with fixed, tested argument patterns.
- Propagate child exit codes; never claim success on failure.
- Generated lavfi inputs for tests; no huge fixtures.

---

## F1 — `mediaforge inspect`

| Field | Detail |
|-------|--------|
| Use case | Quick human summary of a file or lavfi source |
| Library | None (CLI orchestration) |
| Implementation | `ffprobe -v error -show_entries ... -of default=noprint_wrappers=1` |
| Security | Path passed as argv; user-responsible for untrusted paths |
| Compatibility | Does not alter ffprobe |
| Tests | JSON/key presence on lavfi sine; non-zero on missing file |

---

## F2 — `mediaforge thumbnail`

| Field | Detail |
|-------|--------|
| Use case | Extract one image frame at a timestamp |
| Implementation | `ffmpeg -ss TS -i INPUT -frames:v 1 -y OUTPUT` (output image by extension) |
| Defaults | `TS=00:00:01` if unspecified; document that short files may need `00:00:00` |
| Security | Malformed input → ffmpeg failure; timeout recommended in services |
| Tests | lavfi color → png non-empty; missing input fails |

**Limitation**: Seek accuracy depends on codec/container; not a “best frame” AI selector.

---

## F3 — `mediaforge extract-audio`

| Field | Detail |
|-------|--------|
| Use case | Demux/re-encode audio only |
| Implementation | `ffmpeg -i INPUT -vn ... OUTPUT` |
| Modes | `-c:a copy` when output container allows; else encode (e.g. mp3/aac by extension heuristic) |
| Tests | lavfi sine → wav/mp3 path works or skip if encoder missing |

---

## Non-goals

- Public C API additions  
- ABI changes  
- Hardware device auto-magic without user flags  
