#!/usr/bin/env bash
# Media processing helper smoke tests — generated inputs only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HELPER="${ROOT}/scripts/mediaforge"
FFMPEG="${FFMPEG:-ffmpeg}"
FFPROBE="${FFPROBE:-ffprobe}"

pass=0
fail=0

check() {
  local name="$1"; shift
  if "$@"; then
    echo "PASS  $name"
    pass=$((pass + 1))
  else
    echo "FAIL  $name" >&2
    fail=$((fail + 1))
  fi
}

command -v "$FFMPEG" >/dev/null || { echo "SKIP: ffmpeg missing"; exit 0; }
command -v "$FFPROBE" >/dev/null || { echo "SKIP: ffprobe missing"; exit 0; }
[ -f "$HELPER" ] || { echo "FAIL: helper missing"; exit 1; }

TMP="$(mktemp -d /tmp/mf_mediaXXXXXX)"
trap 'rm -rf "$TMP"' EXIT

# Generate tiny fixtures with ffmpeg
"$FFMPEG" -nostdin -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=red:s=64x48:d=0.5" -f lavfi -i "sine=f=440:d=0.5" \
  -c:v rawvideo -c:a pcm_s16le -shortest "$TMP/clip.mkv" 2>/dev/null \
  || "$FFMPEG" -nostdin -y -hide_banner -loglevel error \
       -f lavfi -i "testsrc2=s=64x48:d=0.5" -c:v mpeg4 "$TMP/clip.mkv"

check "inspect_reports_streams" bash -c "
  bash '$HELPER' inspect '$TMP/clip.mkv' 2>/dev/null | grep -Eq 'codec_type|codec_name|width'
"

check "inspect_missing_fails" bash -c "
  set +e
  bash '$HELPER' inspect '$TMP/missing.mp4' >/dev/null 2>&1
  rc=\$?
  set -e
  test \"\$rc\" -ne 0
"

check "thumbnail_creates_file" bash -c "
  bash '$HELPER' thumbnail '$TMP/clip.mkv' '$TMP/thumb.png' --time 00:00:00
  test -s '$TMP/thumb.png'
"

check "thumbnail_missing_fails" bash -c "
  set +e
  bash '$HELPER' thumbnail '$TMP/nope.mp4' '$TMP/x.png' --time 00:00:00 >/dev/null 2>&1
  rc=\$?
  set -e
  test \"\$rc\" -ne 0
"

check "extract_audio_wav" bash -c "
  bash '$HELPER' extract-audio '$TMP/clip.mkv' '$TMP/out.wav'
  test -s '$TMP/out.wav'
"

check "extract_audio_missing_fails" bash -c "
  set +e
  bash '$HELPER' extract-audio '$TMP/nope.mp4' '$TMP/out2.wav' >/dev/null 2>&1
  rc=\$?
  set -e
  test \"\$rc\" -ne 0
"

echo "---"
echo "passed=$pass failed=$fail"
test "$fail" -eq 0
