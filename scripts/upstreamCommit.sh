#!/usr/bin/env bash

(
  set -e

  netty_raw_changes=$(cd netty && git log --oneline "$(git ls-tree HEAD netty | cut -d ' ' -f3 | cut -f1)"...HEAD)

  netty_changes=""
  if [ -n "$netty_raw_changes" ]; then
    netty_changes="\n\nNetty Changes:\n$netty_raw_changes"
  fi

  echo -e "Updated Upstream${netty_changes}" | git commit -F -
) || exit 1
