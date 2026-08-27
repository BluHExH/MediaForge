#!/usr/bin/env bash
# Deterministic extract of pinned FFmpeg archive into vendor/ffmpeg (build workspace).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
set -a
# shellcheck source=/dev/null
source "$ROOT/config/upstream.env"
set +a

DEST="$ROOT/vendor/ffmpeg"
ARCHIVE="$ROOT/vendor/ffmpeg-${FFMPEG_REF}.tar.gz"
ARCHIVE2="$ROOT/vendor/ffmpeg-n7.1.5.tar.gz"

fail() { echo "vendor-ffmpeg: FAIL: $*" >&2; exit 1; }

bash "$ROOT/scripts/check-upstream-baseline.sh"

if [ -f "$DEST/configure" ] && [ -f "$DEST/libavutil/avutil.h" ]; then
  if bash "$ROOT/scripts/verify-vendored-ffmpeg.sh" >/dev/null 2>&1; then
    echo "vendor/ffmpeg already complete (verified)"
    exit 0
  fi
  echo "vendor/ffmpeg incomplete or wrong provenance; removing"
  rm -rf "$DEST"
fi

SRC_ARCHIVE=""
if [ -f "$ARCHIVE" ]; then
  SRC_ARCHIVE="$ARCHIVE"
elif [ -f "$ARCHIVE2" ]; then
  SRC_ARCHIVE="$ARCHIVE2"
else
  fail "pinned archive missing ($ARCHIVE or $ARCHIVE2); do not download an unrelated version silently"
fi

gzip -t "$SRC_ARCHIVE" || fail "gzip integrity check failed: $SRC_ARCHIVE"

tmpdir="$(mktemp -d /tmp/mf-vendor-XXXXXX)"
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

echo "Extracting $SRC_ARCHIVE → vendor/ffmpeg"
tar -xzf "$SRC_ARCHIVE" -C "$tmpdir"
top="$(find "$tmpdir" -maxdepth 1 -type d -name 'FFmpeg-*' | head -1)"
[ -n "$top" ] || fail "archive missing FFmpeg-* top-level directory"
[ -f "$top/configure" ] || fail "archive extract missing configure"
[ -f "$top/libavutil/avutil.h" ] || fail "archive extract missing libavutil/avutil.h"

rm -rf "$DEST"
mkdir -p "$ROOT/vendor"
mv "$top" "$DEST"
printf '%s\n' "$FFMPEG_REF" > "$DEST/.mediaforge-upstream-ref"
printf '%s\n' "$FFMPEG_COMMIT" > "$DEST/.mediaforge-upstream-commit"
rm -rf "$DEST/.git"

bash "$ROOT/scripts/verify-vendored-ffmpeg.sh"
echo "vendor-ffmpeg: OK — FFmpeg ${FFMPEG_REF} (${FFMPEG_COMMIT})"
echo "FFmpeg source: MediaForge pinned archive"
echo "FFmpeg tree: $DEST"
