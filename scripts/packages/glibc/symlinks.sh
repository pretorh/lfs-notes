#!/usr/bin/env sh

ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64"
ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64/ld-lsb-x86-64.so.3"
