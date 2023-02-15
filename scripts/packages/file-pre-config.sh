#!/usr/bin/env bash
set -e

mkdir build
pushd build
../configure \
  --disable-bzlib \
  --disable-libseccomp \
  --disable-xzlib \
  --disable-zlib
make --jobs 4
popd
