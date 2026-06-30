#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(git rev-parse --show-toplevel)}"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/.build}"

# hugo-theme-stack-starter version pulled as the site base.
THEME_REPO="https://github.com/CaiJimmy/hugo-theme-stack-starter.git"
THEME_VERSION="${THEME_VERSION:-master}"

# --fresh wipes .build so the starter is re-cloned from scratch.
if [[ "${1:-}" == "--fresh" ]]; then
  echo "→ Removing $BUILD_DIR"
  rm -rf "$BUILD_DIR"
fi

# Clone the starter once; reuse it on later runs.
if [[ ! -d "$BUILD_DIR" ]]; then
  echo "→ Cloning $THEME_REPO ($THEME_VERSION)"
  git clone --branch master --depth=1 "$THEME_REPO" "$BUILD_DIR"
  rm -rf "$BUILD_DIR/.git"
else
  echo "→ Reusing $BUILD_DIR (pass --fresh to re-clone)"
fi
