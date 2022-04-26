#!/usr/bin/env bash

git submodule update --recursive --init && ./scripts/applyPatches.sh || exit 1

if [ "$1" == "--jar" ]; then
  cd fstack-netty-transport && mvn package && cd ..
fi
