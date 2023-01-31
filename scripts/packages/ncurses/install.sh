#!/usr/bin/env sh

make DESTDIR="$LFS" TIC_PATH="$(pwd)"/build/progs/tic install
echo "INPUT(-lncursesw)" > "$LFS"/usr/lib/libncurses.so
