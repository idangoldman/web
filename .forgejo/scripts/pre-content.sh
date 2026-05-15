#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(git rev-parse --show-toplevel)}"
CONTENT_DIR="${CONTENT_DIR:-$ROOT_DIR/.build-content}"

# Clean and prepare destination
rm -rf "$CONTENT_DIR"
mkdir -p "$CONTENT_DIR"

# Single optimized rsync command
rsync -a \
  --exclude='.DS_Store' \
  --exclude='/.forgejo/' \
  --exclude='/.git/' \
  --exclude='/README.md' \
  --exclude="/${CONTENT_DIR#$ROOT_DIR/}/" \
  "$ROOT_DIR/" "$CONTENT_DIR/"

# Rename home.md to _index.md if it exists
if [[ -f "$CONTENT_DIR/home.md" ]]; then
  mv "$CONTENT_DIR/home.md" "$CONTENT_DIR/_index.md"
fi

# Process content.md files efficiently without nested loops
while IFS= read -r -d '' file; do
  dir="$(dirname "$file")"

  # Check if directory contains other markdown files or subdirectories
  has_siblings=$(find "$dir" -maxdepth 1 -name '*.md' ! -name 'content.md' -print -quit)
  has_subdirs=$(find "$dir" -mindepth 1 -type d -print -quit)

  if [[ -n "$has_siblings" || -n "$has_subdirs" ]]; then
    mv "$file" "$dir/_index.md"
  else
    mv "$file" "$dir/index.md"
  fi
done < <(find "$CONTENT_DIR" -name 'content.md' -print0)

echo "✓ Staged content at $CONTENT_DIR"
