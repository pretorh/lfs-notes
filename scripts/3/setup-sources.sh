#!/usr/bin/env sh

mkdir -pv "$LFS/sources/new"
chmod -Rv a+wt "$LFS/sources"
chown -Rv "$(logname)" "$LFS/sources"
