#!/usr/bin/env sh

find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include "$LFS/usr"
