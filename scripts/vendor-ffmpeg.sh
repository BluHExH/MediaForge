#!/usr/bin/env bash
# Populate vendor/ffmpeg from the pinned upstream baseline.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
set -a
source "$ROOT/config/upstream.env"
set +a

DEST="${ROOT}/vendor/ffmpeg"
bash "$ROOT/scripts/check-upstream-baseline.sh"

if [ -f "$DEST/configure" ]; then
  if [ -d "$DEST/.git" ]; then
    got="$(git -C "$DEST" rev-parse HEAD 2>/dev/null || true)"
    if [ "$got" = "$FFMPEG_COMMIT" ]; then
      echo "vendor/ffmpeg already at $FFMPEG_COMMIT"
      exit 0
    fi
  fi
  echo "vendor/ffmpeg exists but may not match pin; move aside or delete to re-vendor"
  exit 1
fi

mkdir -p "$ROOT/vendor"
echo "Cloning ${FFMPEG_REPOSITORY} tag ${FFMPEG_REF} → vendor/ffmpeg"
git clone --depth 1 --branch "$FFMPEG_REF" "$FFMPEG_REPOSITORY" "$DEST"
got="$(git -C "$DEST" rev-parse HEAD)"
if [ "$got" != "$FFMPEG_COMMIT" ]; then
  echo "WARNING: resolved HEAD $got != FFMPEG_COMMIT $FFMPEG_COMMIT" >&2
fi
# Drop nested git metadata so MediaForge owns a plain source tree in git
rm -rf "$DEST/.git"
echo "$FFMPEG_REF" > "$DEST/.mediaforge-upstream-ref"
echo "$FFMPEG_COMMIT" > "$DEST/.mediaforge-upstream-commit"
echo "Vendored FFmpeg $FFMPEG_REF ($got) without nested .git"
