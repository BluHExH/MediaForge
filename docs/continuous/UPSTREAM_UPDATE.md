# Updating the FFmpeg upstream baseline

## Process

1. Identify candidate official tag (`git ls-remote --tags https://github.com/FFmpeg/FFmpeg.git 'n*'`).  
2. Resolve immutable commit: `git rev-parse tags/<tag>^{commit}` (or ls-remote peeled SHA).  
3. Edit `config/upstream.env` (`FFMPEG_REF`, `FFMPEG_COMMIT`).  
4. Run `bash scripts/check-upstream-baseline.sh`.  
5. CI: full matrix + MediaForge regression.  
6. Optional: informational master tip job (non-blocking).  
7. Note security/changelog delta from previous pin.  
8. Benchmark smoke if relevant.  
9. Update CHANGELOG + CYCLE notes; commit; push; verify.

## Forbidden

- Setting `FFMPEG_REF=master` in `config/upstream.env`  
- Divergent pins between CI and release workflows  
