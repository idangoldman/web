#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
BUILD_DIR="$ROOT_DIR/.build"
CONTENT_DIR="$BUILD_DIR/content"
export ROOT_DIR BUILD_DIR CONTENT_DIR

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

# Overlay custom Hugo config/assets on top of the starter (every run).
echo "→ Copying .forgejo/hugo/ overlay"
cp -r "$ROOT_DIR/.forgejo/hugo/." "$BUILD_DIR/"

# Stage content into .build/content (every run).
echo "→ Staging content"
$ROOT_DIR/.forgejo/scripts/pre-content.sh

# Serve.
echo "→ Starting hugo serve"
hugo serve \
  --buildDrafts \
  --buildExpired \
  --buildFuture \
  --contentDir="$CONTENT_DIR" \
  --source="$BUILD_DIR" \
  --watch
