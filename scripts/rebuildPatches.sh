#!/usr/bin/env bash

(
  basedir="$(cd "$1" && pwd -P)"

  echo "Rebuilding patch files from current state..."

  git config core.safecrlf false

  echo "Formatting patches..."

  cd "$basedir/patches/" || exit 1
  if [ -d "$basedir/fstack-netty-transport/.git/rebase-apply" ]; then
    echo "REBASE DETECTED - PARTIAL SAVE"
    last=$(cat "$basedir/fstack-netty-transport/.git/rebase-apply/last")
    next=$(cat "$basedir/fstack-netty-transport/.git/rebase-apply/next")
    for i in $(seq -f "%04g" 1 1 "$last"); do
      if [ $i -lt "$next" ]; then
        rm "${i}"-*.patch
      fi
    done
  else
    rm -rf ./*.patch
  fi

  cd "$basedir/fstack-netty-transport" || exit 1

  git format-patch --no-stat -N -o "$basedir/patches/" upstream/upstream >/dev/null
  cd "$basedir" || exit 1
  git add -A "$basedir/patches"

  cd "$basedir/patches" || exit 1

  for patch in *.patch; do
    echo "$patch"
    gitver=$(tail -n 2 "$patch" | grep -ve "^$" | tail -n 1)
    diffs=$(git diff --staged "$patch" | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index)")

    testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
    if [ "x$testver" != "x" ]; then
      diffs=$(echo "$diffs" | sed 'N;$!P;$!D;$d')
    fi

    if [ "x$diffs" == "x" ]; then
      git reset HEAD "$patch" >/dev/null
      git checkout -- "$patch" >/dev/null
    fi
  done

  echo "Patches successfully saved."
)
