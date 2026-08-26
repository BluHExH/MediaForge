# Packaging Strategy

## Near term (maintainable)

1. **GitHub source + scripts** — primary distribution  
2. **GitHub Release source archives** — when tagging RC/release  
3. **SHA256SUMS** alongside archives  

## Deferred until stable demand

| Ecosystem | Status |
|-----------|--------|
| Homebrew / winget / Scoop / distro packages | Not submitted |
| Language crates/wheels shipping ffmpeg | Out of scope |
| Docker official image | Evaluated; optional later ([below](#containers)) |

## Containers

**No official image in Phase 10.** Rationale: base-image CVEs and FFmpeg version drift need a maintainer. Users may containerize themselves with pinned digests.
