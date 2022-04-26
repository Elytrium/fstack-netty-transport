#!/usr/bin/env bash

(
  set -e

  function changelog() {
    current_last_commit=$(git ls-tree HEAD "$1" | cut -d ' ' -f3 | cut -f1)
    cd "$1" && git log --oneline "${current_last_commit}"...HEAD
  }

  updated=""
  changes=""

  netty_changes=$(changelog netty)
  if [ -n "$netty_changes" ]; then
    changes="\n\nNetty Changes:\n$netty_changes"
    updated="Netty"
  fi

  fstack_changes=$(changelog f-stack)
  if [ -n "$fstack_changes" ]; then
    changes="$changes\n\nF-Stack Changes:\n$fstack_changes"
    if [ -n "$updated" ]; then
      updated="$updated/F-Stack"
    else
      updated="F-Stack"
    fi
  fi

  echo -e "Updated Upstream ($updated)${changes}" | git commit -F -
) || exit 1
