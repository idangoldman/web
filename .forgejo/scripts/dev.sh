#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

# --fresh re-clones the theme starter.
if [[ "${1:-}" == "--fresh" ]]; then
  export FRESH=1
fi

exec process-compose up --config process-compose.yml