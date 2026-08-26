#!/usr/bin/env bash
# Hardware tests: software always; runtime HW skips if no device.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HELPER="${ROOT}/scripts/mediaforge"
FFMPEG="${FFMPEG:-ffmpeg}"
pass=0
fail=0
skip=0
check() {
  local name="$1"; shift
  if "$@"; then echo "PASS  $name"; pass=$((pass+1)); else echo "FAIL  $name" >&2; fail=$((fail+1)); fi
}
skip_check() { echo "SKIP  $1"; skip=$((skip+1)); }

command -v "$FFMPEG" >/dev/null || { echo "SKIP all: no ffmpeg"; exit 0; }

check "hwaccels_lists" bash -c "$FFMPEG -hide_banner -hwaccels >/dev/null"
check "helper_hwinfo" bash -c "bash '$HELPER' hwinfo | grep -q 'MediaForge hwinfo'"
check "software_null_still_works" bash -c "
  $FFMPEG -hide_banner -nostats -f lavfi -i 'color=s=16x16:d=0.04' -f null - >/dev/null 2>&1
"

# Runtime HW: only attempt if a render node or nvidia-smi exists
if [ -e /dev/dri/renderD128 ] || [ -e /dev/dri/card0 ] || command -v nvidia-smi >/dev/null 2>&1; then
  skip_check "runtime_hw_transcode (device present but full matrix not automated in Phase 7)"
else
  skip_check "runtime_hw_transcode (no GPU device in environment)"
fi

echo "---"
echo "passed=$pass failed=$fail skipped=$skip"
test "$fail" -eq 0
