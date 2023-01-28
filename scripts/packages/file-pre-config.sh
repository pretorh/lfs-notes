#!/usr/bin/env bash
set -e

build_dir=build

mkdir $build_dir
pushd $build_dir
../configure \
  --disable-bzlib \
  --disable-libseccomp \
  --disable-xzlib \
  --disable-zlib
make --jobs 4
popd
