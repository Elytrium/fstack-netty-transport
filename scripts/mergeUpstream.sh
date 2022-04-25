#!/usr/bin/env bash

basedir=$(pwd)

cd "$basedir/netty" || exit 1
git fetch && git reset --hard origin/4.1
cd "$basedir/netty/.." || exit 1
git add netty

git submodule update --recursive
