#!/usr/bin/env bash

case "$1" in
"rb" | "rbp" | "rebuild")
  scripts/rebuildPatches.sh || exit 1
  ;;
"p" | "patch")
  scripts/build.sh || exit 1
  ;;
"m" | "up" | "merge")
  scripts/mergeUpstream.sh || exit 1
  ;;
"b" | "build")
  scripts/build.sh --jar || exit 1
  ;;
"e" | "edit")
  scripts/edit.sh || exit 1
  ;;
*)
  echo "The project build tools script."
  echo "View below for details of the available commands."
  echo "Original scripts provided by PaperMC."
  echo ""
  echo "Commands:"
  echo "  * rb, rbp, rebuild | Rebuilds the patches."
  echo "  * p, patch         | Applies all the patches."
  echo "  * m, up, merge     | Utility to aid in merging upstream."
  echo "  * b, build         | Builds the project."
  echo "  * e, edit          | Runs git rebase -i, allowing patches to be easily modified."
  ;;
esac
