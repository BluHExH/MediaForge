# Reproducible Builds

## Realistic goal (Phase 10)

| Level | Status |
|-------|--------|
| Source SHA known | Yes (`git rev-parse`) |
| Upstream FFmpeg SHA known | Yes when CI records `FFMPEG_COMMIT` |
| Same configure flags | Document in workflow / release notes |
| Bit-for-bit identical tarballs | **Not claimed** (timestamps, archive tools, runner OS differ) |

## Practices

1. Pin `FFMPEG_REF` for release candidates.  
2. Record compiler version in release notes.  
3. Prefer `SOURCE_DATE_EPOCH` in future packaging scripts if bit-repro is pursued.  
4. Publish SHA-256 of release artifacts always.

Do not advertise “reproducible” without a verified second-builder match.
