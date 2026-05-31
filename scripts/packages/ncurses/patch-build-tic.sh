#!/usr/bin/env bash
set -e

echo "build 'tic'..."
build_dir=build
mkdir $build_dir
pushd $build_dir
../configure --prefix="$LFS/tools" AWK=gawk
make --jobs=4 -C include
make --jobs=4 -C progs tic
install progs/tic $LFS/tools/bin
popd
