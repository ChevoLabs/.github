#!/usr/bin/env bash
# Create a private repository in the ChevoLabs organization (if missing) and apply the standard settings:
# squash-only merges, auto-update suggestions, no wiki/projects/discussions, Dependabot alerts + security updates.
#
# Usage: scripts/create-repo.sh NAME "Description" "topic1,topic2" [--public]
# Example: scripts/create-repo.sh acme-web "Acme storefront" "nextjs,web"
# Then:    scripts/sync-labels.sh ChevoLabs/NAME
# Needs:   gh authenticated as an organization owner (scopes: repo, admin:org).
set -euo pipefail
ORG="ChevoLabs"
[ $# -ge 3 ] || { echo "usage: $0 NAME DESCRIPTION TOPICS [--public]" >&2; exit 1; }
name="$1"; description="$2"; topics="$3"; visibility="--private"
[ "${4:-}" = "--public" ] && visibility="--public"
repo="$ORG/$name"

echo "== $repo"
if gh repo view "$repo" >/dev/null 2>&1; then
  echo "  exists"
else
  gh repo create "$repo" "$visibility" --add-readme --disable-wiki --description "$description"
fi

gh repo edit "$repo" \
  --default-branch main \
  --enable-issues \
  --enable-wiki=false \
  --enable-projects=false \
  --enable-discussions=false \
  --enable-squash-merge \
  --squash-merge-commit-message pr-title-description \
  --enable-merge-commit=false \
  --enable-rebase-merge=false \
  --allow-update-branch \
  --add-topic "$topics"
# --delete-branch-on-merge \

gh api -X PUT "repos/$repo/vulnerability-alerts" >/dev/null && echo "  ✓ Dependabot alerts"
gh api -X PUT "repos/$repo/automated-security-fixes" >/dev/null && echo "  ✓ Dependabot security updates"
