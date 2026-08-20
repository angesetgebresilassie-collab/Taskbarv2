#!/usr/bin/env bash
set -euo pipefail

# import_farmerbb_taskbar.sh
# Usage: run from the root of your Taskbarv2 repo on a machine with git installed
# This script imports the app/ module and core files from farmerbb/Taskbar into this repo.

UPSTREAM_REPO="https://github.com/farmerbb/Taskbar.git"
TMPDIR=$(mktemp -d)
BRANCH="feature/macos-theme-frosted-minimize"

echo "Cloning upstream repo $UPSTREAM_REPO into $TMPDIR"

git clone --depth 1 "$UPSTREAM_REPO" "$TMPDIR/upstream"

cd "$TMPDIR/upstream"

if [ ! -d "app" ]; then
  echo "Upstream repo does not contain an app/ directory. Aborting."
  exit 1
fi

# Copy app/ into current repo (overwrite existing app/ in this repo)
# The user should run this script from the Taskbarv2 repository root (where .git exists)

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$OLDPWD")"

if [ ! -d "$REPO_ROOT" ]; then
  echo "Could not determine repository root. Run this script from inside your Taskbarv2 repo." >&2
  exit 1
fi

echo "Copying upstream app/ to $REPO_ROOT/app (will overwrite existing app/)"

# Backup existing app/ if present
if [ -d "$REPO_ROOT/app" ]; then
  BACKUP="$REPO_ROOT/app.backup.$(date +%s)"
  echo "Backing up existing app/ to $BACKUP"
  mv "$REPO_ROOT/app" "$BACKUP"
fi

# Perform the copy
cp -a "$TMPDIR/upstream/app" "$REPO_ROOT/"

# Copy LICENSE and NOTICE if present and not already present in the repo root
for f in LICENSE NOTICE; do
  if [ -f "$TMPDIR/upstream/$f" ] && [ ! -f "$REPO_ROOT/$f" ]; then
    echo "Copying $f to repo root"
    cp "$TMPDIR/upstream/$f" "$REPO_ROOT/"
  fi
done

cd "$REPO_ROOT"

echo "Adding files to git index"

git add app
[ -f LICENSE ] && git add LICENSE || true
[ -f NOTICE ] && git add NOTICE || true

MSG="chore(import): add upstream farmerbb/Taskbar app module and licenses\n\nImported from https://github.com/farmerbb/Taskbar at $(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "Committing on branch $BRANCH"

git checkout -B "$BRANCH"

git commit -m "$MSG" || { echo "Nothing to commit (files identical)"; }

echo "Pushing branch to origin ($BRANCH)"

git push -u origin "$BRANCH"

echo "Import complete. Clean up temporary files: $TMPDIR"
rm -rf "$TMPDIR"

echo "Done."
