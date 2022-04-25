#!/usr/bin/env bash

pushd fstack-netty-transport || exit 1
git rebase --interactive upstream/upstream
popd || exit 1
