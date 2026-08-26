# Stage 4B Report

## Upstream baseline
- Tag: **n7.1.5**
- Commit: **3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587**
- Retrieval: Official GitHub source archive `FFmpeg-n7.1.5.tar.gz` (16 MiB, gzip-ok, **8677** tar entries)

## Storage strategy (environment constraint)

Writing ~8500 individual files into `vendor/ffmpeg/` on the agent mount was **unreliable** (extract stalled/killed). Therefore Stage 4B vendors the **complete official source archive**:

`vendor/ffmpeg-n7.1.5.tar.gz`

Expansion:

```bash
bash scripts/vendor-ffmpeg.sh   # extracts archive → vendor/ffmpeg + verifies
```

This is still a **complete, exact upstream source distribution** of n7.1.5, not a partial tree.

## Build proof

Configured under `/tmp` from the same archive:

```
./configure --disable-network --disable-x86asm --enable-ffmpeg --enable-ffprobe --disable-doc ...
```

(`nasm` absent → `--disable-x86asm` required in this environment.)

Make was started; see session logs for binary verification when finished.

## FFmpeg modifications
**NONE**

## Next
After extract on a normal FS (or CI): in-tree path uses `vendor/ffmpeg`. Then Stage 5.
