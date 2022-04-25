#!/usr/bin/env bash

basedir="$(cd "$1" && pwd -P)"
use_gpgsign="$(git config commit.gpgsign || echo "false")"

function enableCommitSigningIfNeeded {
  if [[ "$use_gpgsign" == "true" ]]; then
    git config --global commit.gpgsign true
  fi
}

echo "Rebuilding project..."

if [[ "$use_gpgsign" == "true" ]]; then
  git config --global commit.gpgsign false
fi

cd "$basedir/netty" || exit 1
git fetch
git branch -f upstream HEAD >/dev/null

cd "$basedir" || exit 1

if [ ! -d "$basedir/fstack-netty-transport" ]; then
  git clone "netty" "fstack-netty-transport"
fi

cd "$basedir/fstack-netty-transport" || exit 1

echo "Resetting project..."

git remote rm upstream >/dev/null 2>&1
git remote add upstream "$basedir/netty" >/dev/null 2>&1
git checkout 4.1 2>/dev/null || git checkout -b 4.1
git fetch upstream >/dev/null 2>&1
git reset --hard upstream/upstream

echo "  Applying patches..."

git am --abort >/dev/null 2>&1

if git am --3way --ignore-whitespace "$basedir/patches/"*.patch; then
  echo "  Patches applied cleanly."
  enableCommitSigningIfNeeded
else
  echo "  Something did not apply cleanly."
  echo "  Please review above details and finish the apply then save the changes with rebuildPatches.sh."
  enableCommitSigningIfNeeded
  exit 1
fi
