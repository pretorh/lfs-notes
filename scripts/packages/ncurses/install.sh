#!/usr/bin/env sh

make DESTDIR="$LFS" install
ln -sv libncursesw.so "$LFS/usr/lib/libncurses.so"
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
  -i "$LFS/usr/include/curses.h"
