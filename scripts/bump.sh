#!/usr/bin/env bash
set -eu

# Bump the package version everywhere it must stay in sync before tagging.
#
# Updates:
#   - typst.toml                          version =
#   - *.typ                               package version strings (imports, manual)
#   - README.md, docs/architecture.md     @preview/exp-resume:<ver> pins only
#   - CHANGELOG.md                        new vX.Y.Z stub entry
#
# Markdown should avoid non-essential version numbers so this script does not
# have to maintain them. Prefer relative asset links and generic semver prose.
#
# Usage:
#   ./scripts/bump.sh              # patch bump
#   ./scripts/bump.sh patch
#   ./scripts/bump.sh minor
#   ./scripts/bump.sh major
#   ./scripts/bump.sh 1.2.3         # explicit version

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PKG_NAME="$(perl -ne 'print "$1" if /^name\s*=\s*"(.*)"/' typst.toml)"
CURRENT="$(perl -ne 'print "$1" if /^version\s*=\s*"(.*)"/' typst.toml)"
REPO_URL="$(perl -ne 'print "$1" if /^repository\s*=\s*"(.*)"/' typst.toml)"

if [[ -z "$PKG_NAME" || -z "$CURRENT" ]]; then
  echo "error: could not read name/version from typst.toml" >&2
  exit 1
fi

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

echo "Bumping $PKG_NAME $CURRENT → $NEW"

# 1. Manifest
sed -i "s/^version = \"$CURRENT\"/version = \"$NEW\"/" typst.toml

# 2. All Typst sources (template import, manual #let version, etc.)
while IFS= read -r -d '' file; do
  sed -i "s/$CURRENT/$NEW/g" "$file"
done < <(find . -name '*.typ' -not -path './.git/*' -print0)

# 3. Markdown pins that must track the package version
#    Only rewrite @preview/<pkg>:<ver> (covers typst init and #import examples).
MD_FILES=(README.md docs/architecture.md)
for file in "${MD_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    sed -i "s|@preview/${PKG_NAME}:${CURRENT}|@preview/${PKG_NAME}:${NEW}|g" "$file"
  fi
done

# 4. Changelog stub (after title line)
{
  head -n 1 CHANGELOG.md
  echo ""
  echo "## [v$NEW](${REPO_URL}/releases/tag/v$NEW)"
  echo ""
  echo "<describe changes here>"
  echo ""
  tail -n +3 CHANGELOG.md
} > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md

# 5. Sanity: no stale package pins left for the old version
STALE="$(
  grep -RIn --exclude-dir=.git --exclude='CHANGELOG.md' --exclude='*.png' --exclude='*.pdf' \
    -e "@preview/${PKG_NAME}:${CURRENT}" \
    -e "version = \"${CURRENT}\"" \
    -e "#let version = \"${CURRENT}\"" \
    . || true
)"
if [[ -n "$STALE" ]]; then
  echo ""
  echo "warning: possible stale references to ${CURRENT}:" >&2
  echo "$STALE" >&2
fi

echo ""
echo "Updated:"
echo "  typst.toml                     version = \"$NEW\""
echo "  *.typ                          ${CURRENT} → ${NEW}"
echo "  README.md / docs/architecture  @preview/${PKG_NAME}: pins"
echo "  CHANGELOG.md                   v${NEW} stub added"
echo ""
echo "Still manual:"
echo "  CHANGELOG.md                   replace \"<describe changes here>\""
echo "  example-resume.pdf/.png        rebuild if the template output changed"
echo "  docs/manual.pdf                just doc   (gitignored; for local/package)"
echo ""
echo "Pre-tag checklist:"
echo "  1. Fill in CHANGELOG.md for v${NEW}"
echo "  2. just ci                     # or: just test && just doc"
echo "  3. git add -A && git commit -m \"Release v${NEW}\""
echo "  4. git tag -a v${NEW} -m \"v${NEW}\""
echo "  5. git push origin main && git push origin v${NEW}"
echo "  6. gh release create v${NEW} --title \"v${NEW}\" --notes-from-tag"
