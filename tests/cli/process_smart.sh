#!/usr/bin/env bash
# MF-S5-01 smart pipeline tests
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HELPER="${HELPER:-$ROOT/scripts/mediaforge}"
FFMPEG="${FFMPEG:-ffmpeg}"
FFPROBE="${FFPROBE:-ffprobe}"
TMP="$(mktemp -d /tmp/mf-smart-XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

pass=0
fail=0
check() {
  local name="$1"; shift
  if "$@"; then
    echo "PASS  $name"
    pass=$((pass + 1))
  else
    echo "FAIL  $name"
    fail=$((fail + 1))
  fi
}

command -v "$FFMPEG" >/dev/null || { echo "SKIP all: ffmpeg missing"; exit 0; }
command -v "$FFPROBE" >/dev/null || { echo "SKIP all: ffprobe missing"; exit 0; }

# Generate 64x48 mpeg4 clip (works with MediaForge minimal + typical system builds)
if ! "$FFMPEG" -nostdin -y -hide_banner -loglevel error \
  -f lavfi -i "testsrc2=s=64x48:d=0.5:r=25" -c:v mpeg4 -q:v 5 "$TMP/clip.mp4" 2>/dev/null; then
  echo "SKIP all: cannot generate test clip"
  exit 0
fi

# Plan-only: matching dimensions + smart → STREAM_COPY
check "plan_smart_match_stream_copy" bash -c "
  out=\$(bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/out1.mp4' --smart --plan --width 64 --height 48 --json)
  echo \"\$out\" | grep -q '\"decision\": \"STREAM_COPY\"'
"

# Plan: different dimensions + smart → PROCESS with scale
check "plan_smart_mismatch_process" bash -c "
  out=\$(bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/out2.mp4' --smart --plan --width 32 --height 24 --json)
  echo \"\$out\" | grep -q '\"decision\": \"PROCESS\"'
  echo \"\$out\" | grep -q '\"scale\": true'
"

# Plan: smart disabled always PROCESS when targets set
check "plan_nosmart_process" bash -c "
  out=\$(bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/out3.mp4' --plan --width 64 --height 48 --json)
  echo \"\$out\" | grep -q '\"decision\": \"PROCESS\"'
  echo \"\$out\" | grep -q '\"smart\": false'
"

# Execute smart match: must not invoke scale (check log line)
check "exec_smart_match_no_scale_log" bash -c "
  log=\$(bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/copy.mp4' --smart --width 64 --height 48 2>&1)
  echo \"\$log\" | grep -q 'stream_copy'
  echo \"\$log\" | grep -vq 'action: scale'
  test -s '$TMP/copy.mp4'
"

# Execute smart mismatch: must scale
check "exec_smart_mismatch_scales" bash -c "
  log=\$(bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/scaled.mp4' --smart --width 32 --height 24 --video-codec mpeg4 2>&1)
  echo \"\$log\" | grep -q 'action: scale 32x24'
  test -s '$TMP/scaled.mp4'
  w=\$($FFPROBE -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 '$TMP/scaled.mp4')
  test \"\$w\" = '32'
"

# Missing input
check "process_missing_input_fails" bash -c "
  ! bash '$HELPER' process '$TMP/missing.mp4' -o '$TMP/x.mp4' --smart --width 64 --height 48 2>/dev/null
"

# Invalid width
check "process_bad_width_fails" bash -c "
  ! bash '$HELPER' process '$TMP/clip.mp4' -o '$TMP/x.mp4' --smart --width 0 --plan 2>/dev/null
"

# Existing inspect still works
check "inspect_still_works" bash -c "
  bash '$HELPER' inspect '$TMP/clip.mp4' --json | grep -q schema_version
"

echo "---"
echo "passed=$pass failed=$fail"
[ "$fail" -eq 0 ]
