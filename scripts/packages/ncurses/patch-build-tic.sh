#!/usr/bin/env bash
set -e

echo "patch to find gawk"
sed -i s/mawk// configure

echo "build 'tic'..."
build_dir=build
mkdir $build_dir
pushd $build_dir
../configure
make --jobs=4 -C include
make --jobs=4 -C progs tic
popd
