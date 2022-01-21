#!/usr/bin/env sh

# backspace/delete keymaps
patch -Np1 -i ../kbd-*-backspace-1.patch

# remove redunant programs
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
