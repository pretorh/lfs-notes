#!/usr/bin/env sh

find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include "$LFS/usr"
