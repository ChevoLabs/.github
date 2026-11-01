#!/usr/bin/env bash
# Create or update labels in one or more repositories.
# Usage: scripts/sync-labels.sh OWNER/REPO [OWNER/REPO ...]                       # organization labels (labels.json)
#        scripts/sync-labels.sh --labels path/to/labels.json OWNER/REPO [...]     # a project's own label file
# Needs: gh (authenticated), jq.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
file="$here/labels.json"
if [ "${1:-}" = "--labels" ]; then
  file="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
  shift 2
fi
[ -f "$file" ] || { echo "labels file not found: $file" >&2; exit 1; }
[ $# -ge 1 ] || { echo "usage: $0 [--labels FILE] OWNER/REPO [OWNER/REPO ...]" >&2; exit 1; }
for repo in "$@"; do
  echo "== $repo ($(basename "$file"))"
  jq -c '.[]' "$file" | while read -r label; do
    name=$(jq -r .name <<<"$label")
    gh label create "$name" --repo "$repo" --force \
      --color "$(jq -r .color <<<"$label")" \
      --description "$(jq -r .description <<<"$label")" >/dev/null
    echo "  ✓ $name"
  done
done
