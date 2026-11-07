#!/usr/bin/env bash
# Renders every docs/src/*.mmd to docs/img/<same name>.svg with pele-preview.
# Override the renderer with PELE=/path/to/pele-preview and the stylesheet
# with PELE_CSS=/path/to/style.css.
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
pele="${PELE:-$root/../mermaid_preview/bin/pele-preview}"
css="${PELE_CSS:-$(dirname "$pele")/../pele-plex.css}"

for src in "$root"/docs/src/*.mmd; do
  name="$(basename "$src" .mmd)"
  "$pele" "$src" "$css" -o "$root/docs/img/$name.svg" "$@"
done
