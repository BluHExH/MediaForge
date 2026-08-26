#!/usr/bin/env bash
# MediaForge smoke benchmarks — generated inputs only, best-of-3 wall time.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RESULTS="${ROOT}/benchmarks/results"
mkdir -p "${RESULTS}"

FFMPEG="${FFMPEG:-ffmpeg}"
command -v "${FFMPEG}" >/dev/null || { echo "ffmpeg not found (set FFMPEG=...)"; exit 1; }
TIME_BIN="${TIME_BIN:-/usr/bin/time}"
command -v "${TIME_BIN}" >/dev/null || TIME_BIN="time"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="${RESULTS}/smoke_${STAMP}.txt"
ENVF="${RESULTS}/env_${STAMP}.txt"

{
  echo "date_utc=${STAMP}"
  echo "ffmpeg_bin=$(command -v "${FFMPEG}")"
  echo "ffmpeg_version=$(${FFMPEG} -version 2>&1 | head -1)"
  echo "uname=$(uname -srm)"
  echo "nproc=$(nproc 2>/dev/null || echo unknown)"
  if [ -r /proc/cpuinfo ]; then
    echo "cpu_model=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')"
  fi
  if [ -r /proc/meminfo ]; then
    echo "mem_total_kb=$(awk '/MemTotal/{print $2}' /proc/meminfo)"
  fi
  if command -v git >/dev/null && [ -d "${ROOT}/.git" ]; then
    echo "mediaforge_commit=$(git -C "${ROOT}" rev-parse HEAD 2>/dev/null || echo unknown)"
  fi
} | tee "${ENVF}"

run_bm() {
  local name="$1"; shift
  local best="999999" best_rss="0" i out elapsed rss
  for i in 1 2 3; do
    # shellcheck disable=SC2086
    out="$(${TIME_BIN} -f '%e %M' "$@" 2>&1 >/dev/null || true)"
    elapsed="$(echo "${out}" | tail -1 | awk '{print $1}')"
    rss="$(echo "${out}" | tail -1 | awk '{print $2}')"
    if echo "${elapsed}" | grep -qE '^[0-9]+([.][0-9]+)?$'; then
      if awk -v e="${elapsed}" -v b="${best}" 'BEGIN{exit !(e<b)}'; then
        best="${elapsed}"
        best_rss="${rss}"
      fi
    fi
  done
  echo "${name} best_elapsed_s=${best} best_maxrss_kb=${best_rss}"
}

{
  echo "# MediaForge smoke benchmarks ${STAMP}"
  run_bm "startup_version" "${FFMPEG}" -version
  run_bm "decode_null_testsrc_640x360_3s" \
    "${FFMPEG}" -hide_banner -nostats -f lavfi -i "testsrc2=s=640x360:r=30:d=3" -f null -
  run_bm "scale_640x360_to_320x180_3s" \
    "${FFMPEG}" -hide_banner -nostats -f lavfi -i "testsrc2=s=640x360:r=30:d=3" -vf scale=320:180 -f null -
  # libx264 may be unavailable on minimal builds — skip gracefully
  if ${FFMPEG} -hide_banner -encoders 2>/dev/null | grep -E 'libx264 ' >/dev/null 2>&1; then
    HAS_X264=1
  else
    HAS_X264=0
  fi
  if [ "${HAS_X264}" = "1" ]; then
    run_bm "encode_x264_ultrafast_640x360_3s" \
      "${FFMPEG}" -hide_banner -nostats -f lavfi -i "testsrc2=s=640x360:r=30:d=3" \
      -c:v libx264 -preset ultrafast -crf 28 -f null -
    run_bm "transcode_scale_x264_640x360_3s" \
      "${FFMPEG}" -hide_banner -nostats -f lavfi -i "testsrc2=s=640x360:r=30:d=3" \
      -vf scale=320:180 -c:v libx264 -preset ultrafast -crf 28 -f null -
  else
    echo "encode_x264_ultrafast_640x360_3s SKIPPED (no libx264)"
    echo "transcode_scale_x264_640x360_3s SKIPPED (no libx264)"
  fi
  run_bm "audio_aresample_48k_to_44k_5s" \
    "${FFMPEG}" -hide_banner -nostats -f lavfi -i "sine=f=440:r=48000:d=5" -af aresample=44100 -f null -
} | tee "${OUT}"

echo "Wrote ${OUT}"
echo "Wrote ${ENVF}"
