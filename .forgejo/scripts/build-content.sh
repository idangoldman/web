#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(git rev-parse --show-toplevel)}"
CONTENT_DIR="${CONTENT_DIR:-$ROOT_DIR/.build/content}"
BUILD_CONTENT_DIR="${BUILD_CONTENT_DIR:-$ROOT_DIR/.build/.build-content}"

# 1. Build a fresh transformed tree in a throwaway staging dir.
#    Nothing watches BUILD_CONTENT_DIR, so deleting it is safe.
rm -rf "$BUILD_CONTENT_DIR"
mkdir -p "$BUILD_CONTENT_DIR"

rsync -a \
  --exclude='.DS_Store' \
  --exclude='/.build/' \
  --exclude='/.forgejo/' \
  --exclude='/.git/' \
  --exclude='/README.md' \
  "$ROOT_DIR/" "$BUILD_CONTENT_DIR/"

# 2. Apply Hugo naming transforms inside the staging dir.
if [[ -f "$BUILD_CONTENT_DIR/home.md" ]]; then
  mv "$BUILD_CONTENT_DIR/home.md" "$BUILD_CONTENT_DIR/_index.md"
fi

while IFS= read -r -d '' file; do
  dir="$(dirname "$file")"

  has_siblings=$(find "$dir" -maxdepth 1 -name '*.md' ! -name 'content.md' -print -quit)
  has_subdirs=$(find "$dir" -mindepth 1 -type d -print -quit)

  # if [[ -n "$has_siblings" || -n "$has_subdirs" ]]; then
  if [[ -n "$has_siblings" ]]; then
    mv "$file" "$dir/_index.md"
  else
    mv "$file" "$dir/index.md"
  fi
done < <(find "$BUILD_CONTENT_DIR" -name 'content.md' -print0)

# 3. Sync the finished tree into the dir Hugo is watching.
#    --delete keeps it exact; the directory inode is preserved so
#    Hugo's inotify watch survives and only changed files emit events.
mkdir -p "$CONTENT_DIR"
rsync -a --delete "$BUILD_CONTENT_DIR/" "$CONTENT_DIR/"

echo "✓ Staged content at $CONTENT_DIR"
