#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(git rev-parse --show-toplevel)}"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/.build}"

# hugo-theme-stack-starter version pulled as the site base.
STARTER_REPO="https://github.com/CaiJimmy/hugo-theme-stack-starter.git"
STARTER_VERSION="master"

# --fresh wipes .build so the starter is re-cloned from scratch.
if [[ "${1:-}" == "--fresh" ]]; then
  echo "→ Removing $BUILD_DIR"
  rm -rf "$BUILD_DIR"
fi

# Clone the starter once; reuse it on later runs.
if [[ ! -d "$BUILD_DIR" ]]; then
  echo "→ Cloning $STARTER_REPO ($STARTER_VERSION)"
  git clone --branch "$STARTER_VERSION" --depth=1 "$STARTER_REPO" "$BUILD_DIR"
  rm -rf "$BUILD_DIR/.git"
else
  echo "→ Reusing $BUILD_DIR (pass --fresh to re-clone)"
fi