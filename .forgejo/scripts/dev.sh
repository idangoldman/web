#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
BUILD="$ROOT/.build"

# hugo-theme-stack-starter version pulled as the site base.
STARTER_REPO="https://github.com/CaiJimmy/hugo-theme-stack-starter.git"
STARTER_VERSION="master"

# --fresh wipes .build so the starter is re-cloned from scratch.
if [[ "${1:-}" == "--fresh" ]]; then
  echo "→ Removing $BUILD"
  rm -rf "$BUILD"
fi

# Clone the starter once; reuse it on later runs.
if [[ ! -d "$BUILD" ]]; then
  echo "→ Cloning $STARTER_REPO ($STARTER_VERSION)"
  git clone --branch "$STARTER_VERSION" --depth=1 "$STARTER_REPO" "$BUILD"
  rm -rf "$BUILD/.git"
else
  echo "→ Reusing $BUILD (pass --fresh to re-clone)"
fi

# Overlay custom Hugo config/assets on top of the starter (every run).
echo "→ Copying .forgejo/hugo/ overlay"
cp -r "$ROOT/.forgejo/hugo/." "$BUILD/"

# Stage content into .build/content (every run).
echo "→ Staging content"
DEST="$BUILD/content" $ROOT/.forgejo/scripts/pre-content.sh

# Serve.
echo "→ Starting hugo serve"
hugo serve --watch --source="$BUILD"
