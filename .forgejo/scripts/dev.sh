#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
CONTENT="$ROOT/.build-content"

hugo serve --watch --contentDir="$CONTENT" --source=
