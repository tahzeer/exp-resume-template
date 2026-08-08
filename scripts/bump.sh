#!/usr/bin/env bash
set -eu

# Bump the package version across typst.toml, *.typ files, and CHANGELOG.md.
# .md files (README.md, docs/architecture.md) are NOT updated — edit those manually.
#
# Usage:
#   ./scripts/bump.sh              # patch bump (0.0.1 → 0.0.2)
#   ./scripts/bump.sh patch        # same as above
#   ./scripts/bump.sh minor        # 0.0.1 → 0.1.0
#   ./scripts/bump.sh major        # 0.0.1 → 1.0.0
#   ./scripts/bump.sh 1.2.3         # explicit version

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Read current version from typst.toml
CURRENT="$(perl -ne 'print "$1" if /^version\s*=\s*"(.*)"/' typst.toml)"

# Determine bump type / explicit version
if [[ $# -eq 0 ]]; then
  BUMP="patch"
elif [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  NEW="$1"
  BUMP="explicit"
else
  BUMP="$1"
fi

if [[ "$BUMP" != "explicit" ]]; then
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"
  case "$BUMP" in
    patch) PATCH=$((PATCH + 1)) ;;
    minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
    major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
    *)
      echo "Usage: $0 [patch|minor|major|X.Y.Z]"
      exit 1
      ;;
  esac
  NEW="${MAJOR}.${MINOR}.${PATCH}"
fi

if [[ "$NEW" == "$CURRENT" ]]; then
  echo "Version is already $NEW — nothing to do."
  exit 0
fi

echo "Bumping $CURRENT → $NEW"

# 1. Update typst.toml
sed -i "s/^version = \"$CURRENT\"/version = \"$NEW\"/" typst.toml

# 2. Update all .typ files (global string replace of old version → new)
find . -name '*.typ' -not -path './.git/*' -print0 \
  | xargs -0 sed -i "s/$CURRENT/$NEW/g"

# 3. Prepend CHANGELOG.md entry (after the title line)
REPO_URL="$(perl -ne 'print "$1" if /^repository\s*=\s*"(.*)"/' typst.toml)"
{
  head -n 1 CHANGELOG.md
  echo ""
  echo "## [v$NEW](${REPO_URL}/releases/tag/v$NEW)"
  echo ""
  echo "<describe changes here>"
  echo ""
  tail -n +3 CHANGELOG.md
} > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md

echo ""
echo "Updated:"
echo "  typst.toml          version = \"$NEW\""
echo "  *.typ files         $CURRENT → $NEW"
echo "  CHANGELOG.md        v$NEW entry added"
echo ""
echo "Manual updates needed in .md files:"
echo "  README.md           Version line, typst init, import examples"
echo "  docs/architecture.md  @preview import example"
echo ""
echo "Next steps:"
echo "  git add -A"
echo "  git commit -m \"Release v$NEW\""
echo "  git tag v$NEW"
echo "  git push origin main"
echo "  git push origin v$NEW   # triggers release workflow"