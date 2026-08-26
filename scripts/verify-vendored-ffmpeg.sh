#!/usr/bin/env bash
# Fail if vendor/ffmpeg is missing, partial, or mismatches config/upstream.env
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
set -a
source "$ROOT/config/upstream.env"
set +a

DEST="$ROOT/vendor/ffmpeg"
fail() { echo "verify-vendored-ffmpeg: FAIL: $*" >&2; exit 1; }

[ -d "$DEST" ] || fail "vendor/ffmpeg missing — run: bash scripts/vendor-ffmpeg.sh"
[ -f "$DEST/configure" ] || fail "configure missing (incomplete tree)"
[ -f "$DEST/Makefile" ] || fail "Makefile missing"
[ -f "$DEST/LICENSE.md" ] || fail "LICENSE.md missing"

for d in libavutil libavcodec libavformat libavfilter libavdevice libswscale libswresample fftools ffbuild tests compat; do
  [ -d "$DEST/$d" ] || fail "required directory missing: $d"
done

for f in \
  libavutil/avutil.h \
  libavcodec/avcodec.h \
  libavformat/avformat.h \
  libavfilter/avfilter.h \
  fftools/ffmpeg.c
do
  [ -f "$DEST/$f" ] || fail "required file missing: $f"
done

# Reject obviously partial checkouts (full n7.1.x trees are thousands of files)
count="$(find "$DEST" -type f | wc -l | tr -d ' ')"
if [ "$count" -lt 5000 ]; then
  fail "file count $count < 5000 — tree looks partial (do not commit)"
fi

if [ -f "$DEST/.mediaforge-upstream-commit" ]; then
  got="$(tr -d '[:space:]' < "$DEST/.mediaforge-upstream-commit")"
  [ "$got" = "$FFMPEG_COMMIT" ] || fail "provenance commit $got != FFMPEG_COMMIT $FFMPEG_COMMIT"
fi
if [ -f "$DEST/.mediaforge-upstream-ref" ]; then
  ref="$(tr -d '[:space:]' < "$DEST/.mediaforge-upstream-ref")"
  [ "$ref" = "$FFMPEG_REF" ] || fail "provenance ref $ref != FFMPEG_REF $FFMPEG_REF"
fi

[ -d "$DEST/.git" ] && fail "nested .git must be removed before commit"

echo "verify-vendored-ffmpeg: OK ($count files, ref=${FFMPEG_REF})"
