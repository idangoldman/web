#!/usr/bin/env bash
set -euo pipefail

export ROOT_DIR="$(git rev-parse --show-toplevel)"

# --fresh re-clones the theme starter.
if [[ "${1:-}" == "--fresh" ]]; then
  export FRESH=1
fi

exec process-compose up --config "$ROOT_DIR/.forgejo/process-compose.yml"
