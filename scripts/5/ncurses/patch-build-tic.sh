#!/usr/bin/env bash
set -e

sed -i s/mawk// configure

echo "build 'tic'..."
build_dir=build

mkdir $build_dir
pushd $build_dir
../configure
make -C include
make -C progs tic
popd
