# Source Integration Plan — FFmpeg in MediaForge

**Status**: Stage 1–3 in progress (Cycle strategic transition)  
**Upstream pin**: `n7.1.5` / `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` (`config/upstream.env`)

## 1. Current architecture

MediaForge owns docs, CI, helpers (`scripts/mediaforge`), tests, and packaging. FFmpeg was **cloned in CI** from a pinned tag (Cycle 02). Helpers still use system or CI-built `ffmpeg` binaries. **No in-tree libav\*** until vendoring completes.

## 2. Target architecture

```
MediaForge/
├── vendor/ffmpeg/          # Full upstream tree at pinned tag (+ future MF patches)
├── scripts/                # mediaforge helper, vendor/bootstrap tools
├── tests/ benchmarks/ docs/
├── config/upstream.env     # Provenance (tag + SHA)
└── .github/workflows/      # Build from vendor/ffmpeg when present
```

Long-term: optional `mediaforge/` native code linking against built libs — only with measured need.

## 3. Source strategy — **vendored snapshot (Option D)**

| Option | Decision |
|--------|----------|
| A Full commit of tree | **Yes** — tree lives under `vendor/ffmpeg/` |
| B Git subtree | Optional later for history merge; not required initially |
| C Submodule | **Rejected** for primary UX (extra clone step, easy to miss) |
| D Automated vendoring | **Primary**: `scripts/vendor-ffmpeg.sh` + committed tree |
| E Other | CI may refresh from pin if tree missing (fallback) |

**Rationale**: Contributors get a complete tree on `git clone` without submodule init. Provenance remains in `config/upstream.env` + `vendor/ffmpeg/VERSION` / git metadata inside vendor if retained.

## 4. Upstream provenance

| Artifact | Content |
|----------|---------|
| `config/upstream.env` | `FFMPEG_REF`, `FFMPEG_COMMIT`, repository URL |
| `vendor/ffmpeg/` | Source matching that commit |
| `docs/architecture/UPSTREAM_PATCH_MODEL.md` | How MF changes are recorded |

## 5. Patch model

See [UPSTREAM_PATCH_MODEL.md](UPSTREAM_PATCH_MODEL.md): commits on top of imported baseline; MediaForge commits prefixed `mediaforge:`; prefer minimal diffs; re-vendor + replay on upstream bumps.

## 6. Build model

```bash
# Preferred (in-tree)
cd vendor/ffmpeg && ./configure ... && make -j$(nproc)

# Bootstrap if tree absent
bash scripts/vendor-ffmpeg.sh
```

MediaForge helpers discover `./vendor/ffmpeg/ffmpeg` when present (PATH override).

## 7. CI migration

1. Prefer `vendor/ffmpeg` if `configure` exists  
2. Else run `vendor-ffmpeg.sh` or clone pin (legacy safety)  
3. Build + existing smoke matrix  
4. Remove remote-only clone only after green history  

## 8. Licensing

Retain all upstream `LICENSE.md`, `COPYING.*`, `CREDITS` under `vendor/ffmpeg/`. MediaForge docs/scripts remain separately described. No claim of a single simplified license for the whole tree.

## 9. Repository size

Full FFmpeg tree is large (~tens of MB source). Acceptable for a source-based multimedia project. `.gitignore` excludes object files, binaries, `ffbuild` outputs under vendor.

## 10. Security

Owning the tree means tracking upstream security tags on the pin line and re-vendoring promptly. Fuzzing/ASan remain on the in-tree build.

## 11. Performance

No native optimization until baseline in-tree builds and Phase-4-style benchmarks compare upstream pin vs MediaForge patches.

## 12. Migration stages

| Stage | Goal | Status |
|-------|------|--------|
| 1 | Plan + patch model | This document |
| 2 | Import exact baseline into `vendor/ffmpeg` | In progress |
| 3 | Build from repository path | Scripts + CI prefer vendor |
| 4 | CI source-based only | After Stage 2/3 proven |
| 5 | All MediaForge tests on in-tree binary | Follows |
| 6 | First measured native change | Later, evidence-driven |
| 7 | Upstream vs MF benchmarks | Later |
| 8 | Expand MF core | Later |

## 13. Rollback

Remove or reset `vendor/ffmpeg` to last known good pin; CI fallback clone remains until Stage 4 completes.

## 14. Unresolved

- GitHub file count / LFS needs for very large assets (none required for source)  
- Whether to drop nested `.git` inside vendor after import (favor clean tree + upstream.env SHA only)
