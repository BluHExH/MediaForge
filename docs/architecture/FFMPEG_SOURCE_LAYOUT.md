# FFmpeg Source Layout Decision

**Status**: Adopted (Stage 4D)  
**Decision**: **Option B — pinned source archive + deterministic extraction**

## Options compared

| Criterion | A: Expanded `vendor/ffmpeg/` in Git | B: Archive + extract workspace |
|-----------|--------------------------------------|--------------------------------|
| Repo size | Large (~tens of MB as ~8500 blobs) | Small (~16 MiB one blob) |
| Clone/checkout | Slow, many objects | Fast |
| CI | Tree always present | Extract once per job (~seconds) |
| Reproducibility | Commit SHA of tree | Archive + `config/upstream.env` SHA |
| Provenance | Git history noise | Clear pin tag + commit |
| Review of upstream | Diffs huge on re-vendor | Archive swap is atomic |
| MediaForge patches | In-tree commits | **`vendor/patches/`** applied after extract |
| GitHub UX | Heavy PRs | Light |
| Agent/constrained FS | Unreliable | Proven |

## Recommendation

**Adopt Option B.**

- Canonical source distribution: `vendor/ffmpeg-n7.1.5.tar.gz` (official GitHub tag archive for `n7.1.5`).
- Pin metadata: `config/upstream.env` (`FFMPEG_REF`, `FFMPEG_COMMIT`).
- Workspace tree: `vendor/ffmpeg/` is **generated**, not committed.
- Populate: `bash scripts/vendor-ffmpeg.sh` (verify archive → clean extract → verify tree).
- CI: extract before configure/build; never clone `master`.

## Why not expanded tree

Committing ~8500 upstream files is possible on a normal developer machine, but:

1. Does not improve reproducibility beyond a verified archive + SHA.
2. Hurts clone and PR review for pure upstream re-vendors.
3. Patch series under `vendor/patches/` is a clearer MediaForge vs upstream boundary.

Optional later: commit expanded tree if a release process requires it; not required for Stage 4/5 engineering.

## Patch workflow (Stage 5+)

See [UPSTREAM_PATCH_MODEL.md](UPSTREAM_PATCH_MODEL.md).

```
archive → extract → apply vendor/patches/*.patch → configure → build → test
```

## Non-committed paths

```
vendor/ffmpeg/          # extracted workspace (gitignored content except README)
vendor/ffmpeg/**/*.o
vendor/ffmpeg/ffmpeg
vendor/ffmpeg/ffprobe
```
