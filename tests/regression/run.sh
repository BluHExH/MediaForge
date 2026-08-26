#!/usr/bin/env bash
# Aggregate MediaForge regression/smoke suites.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

echo "=== MediaForge regression aggregate ==="
bash tests/cli/smoke.sh
bash tests/media/smoke.sh
bash tests/hardware/smoke.sh
echo "=== regression aggregate OK ==="
