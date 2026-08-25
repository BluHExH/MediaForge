# Security Testing Guide

Reproducible, **bounded**, defensive procedures for MediaForge.

## 1. Sanitizer build (Linux)

Match the CI `linux-asan` job spirit:

```bash
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
./configure \
  --disable-everything \
  --disable-network \
  --disable-autodetect \
  --enable-protocol=file \
  --enable-demuxer=rawvideo,image2 \
  --enable-muxer=rawvideo,null,image2 \
  --enable-decoder=rawvideo \
  --enable-encoder=rawvideo \
  --enable-filter=null,scale,anull \
  --enable-ffmpeg --enable-ffprobe --disable-doc \
  --extra-cflags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" \
  --extra-ldflags="-fsanitize=address,undefined"
make -j"$(nproc)"
```

Run:

```bash
export ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
export UBSAN_OPTIONS=halt_on_error=1
./ffmpeg -version
./ffmpeg -f lavfi -i "color=c=red:s=32x32:d=0.1" -f null -
```

Expand demuxers/decoders only when you need them and can afford longer builds.

## 2. Malformed-input smoke (safe)

Goals: process exits cleanly (non-zero is OK); **no** sanitizer fault; **no** multi-minute hang.

Examples (create tiny fixtures; do not use exploit packs):

```bash
# Empty file
: > /tmp/empty.bin
./ffmpeg -v error -i /tmp/empty.bin -f null - ; echo exit:$?

# Truncated / random short blob
dd if=/dev/urandom of=/tmp/rnd.bin bs=64 count=1 status=none
./ffmpeg -v error -i /tmp/rnd.bin -f null - ; echo exit:$?

# Invalid image-like name with tiny payload
printf 'not-a-png' > /tmp/bad.png
./ffmpeg -v error -i /tmp/bad.png -f null - ; echo exit:$?
```

Acceptable outcomes: error message + non-zero exit. Unacceptable: ASan/UBSan report, segfault without sanitizer, or unbounded runtime (use `timeout 10` in automation).

## 3. Resource bounds in automation

Always wrap exploratory decode with:

```bash
timeout 15s ./ffmpeg ...
```

Cap resolution in tests (e.g. refuse to test 100000×100000 as a “unit test”). Application-level limits belong in products embedding MediaForge.

## 4. Fuzzing (bounded)

See [FUZZING.md](FUZZING.md). Prefer:

- `-max_total_time=60` … `300` for experiments
- Small `max_len`
- ASan builds
- Separate machines from interactive work

## 5. Static analysis (optional)

Practical options without ceremony:

| Tool | Use |
|------|-----|
| Compiler warnings | Keep `-Wall` hygiene on MediaForge-owned code |
| Clang Static Analyzer | `scan-build` on MediaForge patches when they exist |
| `clang-tidy` | Only with a short, documented check list |

Do not add CI tools that only produce noise.

## 6. Regression tests for real fixes

When a genuine bug is fixed:

1. Minimal input that previously failed (crash or sanitizer).
2. Script or FATE-style test asserting clean failure or correct behavior.
3. Keep assets tiny.
4. Run under ASan in CI when feasible.

## 7. Crash triage checklist

- [ ] Reproducible with sanitizers?
- [ ] Input minimized?
- [ ] Upstream already fixed?
- [ ] MediaForge-owned code?
- [ ] Severity reasoned (not guessed)?
- [ ] Fix minimal?
- [ ] Regression added?
- [ ] Documented in SECURITY_AUDIT.md?

## 8. What not to do

- Do not publish weaponized exploits
- Do not commit huge binary crash corpora
- Do not disable sanitizers to “make CI green”
- Do not treat every `av_log` error as a vulnerability
