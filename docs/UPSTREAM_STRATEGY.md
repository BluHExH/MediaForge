# Upstream Strategy

MediaForge is derived from [FFmpeg](https://ffmpeg.org/). Until a full source tree is vendored, CI clones upstream (`FFMPEG_REF` in `.github/workflows/ci.yml`).

## Principles

1. **Track upstream** security and bugfix commits when pinning versions.  
2. **Prefer upstream implementations** over divergent MediaForge rewrites.  
3. **MediaForge-specific code** (docs, CI, helpers, future patches) stays clearly separated.  
4. **Never silent merge**: configure, build, smoke, sanitizers, MediaForge tests.  

## Pinning

| Phase | Practice |
|-------|----------|
| Early (current) | `FFMPEG_REF: master` acceptable for CI foundation |
| Before release engineering | Pin to tag or immutable SHA; record in BASELINE/CHANGELOG |

## Incorporating security fixes

1. Identify upstream commit / CVE discussion.  
2. Confirm presence in pinned revision.  
3. If vendoring patches: minimal diff, regression test, sanitizer run.  
4. Log in `docs/security/SECURITY_AUDIT.md` when relevant.  

## MediaForge patches (future)

| Practice | Detail |
|----------|--------|
| Patch series | One logical change per commit |
| Prefix | Clear commit messages (`mediaforge:` or area tag) |
| Rebase | Prefer rebase onto new upstream pins over long-lived diverged branches |
| Conflicts | Resolve with tests; do not drop upstream security fixes |

## What we do not do

- Copy proprietary codecs  
- Strip upstream attribution/licenses  
- Claim upstream work as MediaForge-original features  
