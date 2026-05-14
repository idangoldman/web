#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
DEST="${DEST:-$ROOT/.build-content}"

# Clean and prepare destination
rm -rf "$DEST"
mkdir -p "$DEST"

# Single optimized rsync command
rsync -a \
  --exclude='/.build-content/' \
  --exclude='/.build/' \
  --exclude='.DS_Store' \
  --exclude='/.forgejo/' \
  --exclude='/.git/' \
  --exclude='/README.md' \
  "$ROOT/" "$DEST/"

# Flatten the home directory if it exists
if [[ -d "$DEST/home" ]]; then
  if [[ -f "$DEST/home/content.md" ]]; then
    mv "$DEST/home/content.md" "$DEST/_index.md"
  fi
  shopt -s nullglob dotglob
  for file in "$DEST/home"/*; do
    mv "$file" "$DEST/"
  done
  rmdir "$DEST/home"
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
done < <(find "$DEST" -name 'content.md' -print0)

echo "✓ Staged content at $DEST"
