#!/usr/bin/env bash
# Populate vendor/ffmpeg from pinned baseline (local archive preferred).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
set -a
# shellcheck source=/dev/null
source "$ROOT/config/upstream.env"
set +a

DEST="$ROOT/vendor/ffmpeg"
ARCHIVE="$ROOT/vendor/ffmpeg-${FFMPEG_REF}.tar.gz"
# also accept n7.1.5 naming
ARCHIVE2="$ROOT/vendor/ffmpeg-n7.1.5.tar.gz"

bash "$ROOT/scripts/check-upstream-baseline.sh"

if [ -f "$DEST/configure" ] && [ -f "$DEST/libavutil/avutil.h" ]; then
  if bash "$ROOT/scripts/verify-vendored-ffmpeg.sh"; then
    echo "vendor/ffmpeg already complete"
    exit 0
  fi
  echo "incomplete tree present; removing"
  rm -rf "$DEST"
fi

tmpdir="$(mktemp -d /tmp/mf-vendor-XXXXXX)"
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

if [ -f "$ARCHIVE" ]; then
  SRC_ARCHIVE="$ARCHIVE"
elif [ -f "$ARCHIVE2" ]; then
  SRC_ARCHIVE="$ARCHIVE2"
else
  echo "Downloading ${FFMPEG_REF} archive from GitHub..."
  SRC_ARCHIVE="$tmpdir/src.tar.gz"
  wget -q --timeout=120 --tries=3 -O "$SRC_ARCHIVE" \
    "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/${FFMPEG_REF}.tar.gz"
fi

echo "Extracting $SRC_ARCHIVE ..."
tar -xzf "$SRC_ARCHIVE" -C "$tmpdir"
# GitHub archive top-level: FFmpeg-<tag>
top="$(find "$tmpdir" -maxdepth 1 -type d -name 'FFmpeg-*' | head -1)"
[ -n "$top" ] || { echo "FAIL: no FFmpeg-* dir in archive"; exit 1; }
mkdir -p "$ROOT/vendor"
rm -rf "$DEST"
mv "$top" "$DEST"
printf '%s\n' "$FFMPEG_REF" > "$DEST/.mediaforge-upstream-ref"
printf '%s\n' "$FFMPEG_COMMIT" > "$DEST/.mediaforge-upstream-commit"
bash "$ROOT/scripts/verify-vendored-ffmpeg.sh"
echo "Vendored FFmpeg $FFMPEG_REF into vendor/ffmpeg"
