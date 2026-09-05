#!/usr/bin/env bash
# Symlink the Specs of Theseus skills into ~/.claude/skills for experimentation.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.claude/skills"
SKILLS=(
  specs-of-theseus
  refining-an-epic
  slicing-an-epic
  delivering-a-story
  adopting-a-subsystem
  growing-a-subsystem
  regrowing-a-subsystem
)

mkdir -p "$DEST"

if [[ "${1:-}" == "--uninstall" ]]; then
  for s in "${SKILLS[@]}"; do
    if [[ -L "$DEST/$s" ]]; then
      rm "$DEST/$s"
      echo "removed  $DEST/$s"
    else
      echo "skipped  $DEST/$s (not a symlink)"
    fi
  done
  exit 0
fi

for s in "${SKILLS[@]}"; do
  target="$REPO/skills/$s"
  link="$DEST/$s"
  if [[ -e "$link" && ! -L "$link" ]]; then
    echo "ERROR: $link exists and is not a symlink; refusing to replace it" >&2
    exit 1
  fi
  ln -sfn "$target" "$link"
  echo "linked   $link -> $target"
done

echo
echo "Restart your Claude Code session so the new skill descriptions load."
