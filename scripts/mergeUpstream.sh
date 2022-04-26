#!/usr/bin/env bash

basedir=$(pwd)

function update {
  cd "$basedir/$1" || exit 1
  git fetch && git reset --hard "origin/$2"
  cd "$basedir/$1/.." || exit 1
  git add "$1"
}

update netty 4.1
update f-stack dev

git submodule update --recursive

scripts/upstreamCommit.sh
