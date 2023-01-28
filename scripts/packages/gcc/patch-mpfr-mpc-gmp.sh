#!/usr/bin/env sh

mkdir -vp mpfr mpc gmp
tar -xf ../mpfr-*.tar.xz --strip-components=1 -C mpfr
tar -xf ../gmp-*.tar.xz --strip-components=1 -C gmp
tar -xf ../mpc-*.tar.gz --strip-components=1 -C mpc
