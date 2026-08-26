#!/usr/bin/env bash
# Validate MediaForge upstream baseline is pinned (not a moving branch).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/config/upstream.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "FAIL: missing $ENV_FILE" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

fail() { echo "FAIL: $*" >&2; exit 1; }

[ -n "${FFMPEG_REPOSITORY:-}" ] || fail "FFMPEG_REPOSITORY unset"
[ -n "${FFMPEG_REF:-}" ] || fail "FFMPEG_REF unset"
[ -n "${FFMPEG_COMMIT:-}" ] || fail "FFMPEG_COMMIT unset"

case "${FFMPEG_REF}" in
  master|main|HEAD|origin/master|origin/main)
    fail "FFMPEG_REF must not be a moving branch (got: ${FFMPEG_REF})"
    ;;
esac

# Prefer release-style tags
case "${FFMPEG_REF}" in
  n[0-9]*|v[0-9]*) ;;
  *)
    echo "WARN: FFMPEG_REF=${FFMPEG_REF} is not an n*/v* tag form" >&2
    ;;
esac

if ! [[ "${FFMPEG_COMMIT}" =~ ^[0-9a-f]{40}$ ]]; then
  fail "FFMPEG_COMMIT must be a 40-char lowercase hex SHA (got: ${FFMPEG_COMMIT})"
fi

echo "OK: upstream baseline"
echo "  FFMPEG_REPOSITORY=${FFMPEG_REPOSITORY}"
echo "  FFMPEG_REF=${FFMPEG_REF}"
echo "  FFMPEG_COMMIT=${FFMPEG_COMMIT}"
