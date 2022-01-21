#!/usr/bin/env sh
# shellcheck disable=SC2016

patch -Np1 -i ../bzip2-*-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so --jobs 4
make clean
