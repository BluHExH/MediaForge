#!/usr/bin/env bash
# Lightweight CLI regression smoke tests (deterministic, no large assets).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FFMPEG="${FFMPEG:-ffmpeg}"
FFPROBE="${FFPROBE:-ffprobe}"
HELPER="${ROOT}/scripts/mediaforge"

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

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "SKIP all: $1 not found"; exit 0; }
}

need_cmd "$FFMPEG"
need_cmd "$FFPROBE"

# --- ffmpeg / ffprobe ---
check "ffmpeg_version" bash -c "$FFMPEG -version >/dev/null"
check "ffprobe_version" bash -c "$FFPROBE -version >/dev/null"

check "ffmpeg_invalid_option_exit" bash -c "
  set +e
  $FFMPEG -nonexistent_option_mf_test >/dev/null 2>&1
  rc=\$?
  set -e
  test \"\$rc\" -ne 0
"

check "ffmpeg_missing_input_exit" bash -c "
  set +e
  $FFMPEG -v error -i /nonexistent/mediaforge_missing.mp4 -f null - >/dev/null 2>&1
  rc=\$?
  set -e
  test \"\$rc\" -ne 0
"

check "ffprobe_json_lavfi" bash -c "
  $FFPROBE -v quiet -print_format json -show_format -show_streams -f lavfi -i 'sine=f=440:d=0.05' \
    | grep -q '\"streams\"'
"

check "ffmpeg_lavfi_null" bash -c "
  $FFMPEG -hide_banner -nostats -f lavfi -i 'color=c=blue:s=16x16:d=0.04' -f null - >/dev/null 2>&1
"

check "ffmpeg_thumbnail_generated" bash -c "
  out=\$(mktemp /tmp/mf_thumbXXXXXX.png)
  $FFMPEG -nostdin -y -hide_banner -nostats -f lavfi -i 'color=s=32x32:d=0.1' -frames:v 1 \"\$out\" >/dev/null 2>&1
  test -s \"\$out\"
  rm -f \"\$out\"
"

# --- helper ---
if [ -x "$HELPER" ] || [ -f "$HELPER" ]; then
  check "helper_help" bash -c "bash $HELPER help | grep -q MediaForge"
  check "helper_version_mediaforge" bash -c "bash $HELPER version | grep -q MediaForge"
  check "helper_recipes" bash -c "bash $HELPER recipes | grep -q Inspect"
  check "helper_unknown_exit" bash -c "
    set +e
    bash $HELPER definitely_not_a_command >/dev/null 2>&1
    rc=\$?
    set -e
    test \"\$rc\" -eq 2
  "

  check "helper_hwinfo" bash -c "
    bash $HELPER hwinfo | grep -q 'MediaForge hwinfo'
  "
  check "helper_inspect_missing_fails" bash -c "
    set +e
    bash $HELPER inspect /nonexistent/mf_cli_missing.mp4 >/dev/null 2>&1
    rc=\$?
    set -e
    test \"\$rc\" -ne 0
  "
  check "helper_probe_passthrough" bash -c "
    bash $HELPER probe -v quiet -print_format json -show_format -f lavfi -i 'sine=f=440:d=0.05' \
      | grep -q '\"format\"'
  "
else
  echo "SKIP  helper tests (scripts/mediaforge missing)"
fi

echo "---"
echo "passed=$pass failed=$fail"
test "$fail" -eq 0
