#!/usr/bin/env bash
# Fail closed if vendor/ffmpeg is incomplete or mismatched.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
set -a
# shellcheck source=/dev/null
source "$ROOT/config/upstream.env"
set +a

DEST="$ROOT/vendor/ffmpeg"
fail() { echo "verify-vendored-ffmpeg: FAIL: $*" >&2; exit 1; }

[ -d "$DEST" ] || fail "vendor/ffmpeg missing — run: bash scripts/vendor-ffmpeg.sh"

for f in configure Makefile LICENSE.md CREDITS; do
  [ -f "$DEST/$f" ] || fail "missing $f"
done

for d in libavutil libavcodec libavformat libavfilter libavdevice libswscale libswresample fftools ffbuild tests doc compat; do
  [ -d "$DEST/$d" ] || fail "required directory missing: $d"
done

for f in \
  libavutil/avutil.h \
  libavcodec/avcodec.h \
  libavformat/avformat.h \
  libavfilter/avfilter.h \
  libswscale/swscale.h \
  libswresample/swresample.h \
  fftools/ffmpeg.c \
  fftools/ffprobe.c
do
  [ -f "$DEST/$f" ] || fail "required file missing: $f"
done

count="$(find "$DEST" -type f ! -path '*/.*' | wc -l | tr -d ' ')"
if [ "$count" -lt 4000 ]; then
  fail "file count $count < 4000 — tree looks partial"
fi

[ -d "$DEST/.git" ] && fail "nested .git present"
[ -f "$DEST/ffmpeg" ] && fail "built binary ffmpeg present (clean source only)"
[ -f "$DEST/ffprobe" ] && fail "built binary ffprobe present (clean source only)"

if [ -f "$DEST/.mediaforge-upstream-commit" ]; then
  got="$(tr -d '[:space:]' < "$DEST/.mediaforge-upstream-commit")"
  [ "$got" = "$FFMPEG_COMMIT" ] || fail "provenance commit $got != $FFMPEG_COMMIT"
else
  fail "missing .mediaforge-upstream-commit"
fi
if [ -f "$DEST/.mediaforge-upstream-ref" ]; then
  ref="$(tr -d '[:space:]' < "$DEST/.mediaforge-upstream-ref")"
  [ "$ref" = "$FFMPEG_REF" ] || fail "provenance ref $ref != $FFMPEG_REF"
else
  fail "missing .mediaforge-upstream-ref"
fi

echo "verify-vendored-ffmpeg: OK ($count files, ${FFMPEG_REF} / ${FFMPEG_COMMIT:0:12})"
