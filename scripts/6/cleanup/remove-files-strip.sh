#!/usr/bin/env bash

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

du -sbBM "$LFS"

echo "removing static libs, documentation"
find "$LFS"/usr/{lib,libexec} -name \*.la -delete
rm -rf "$LFS"/usr/share/{info,man,doc}/*

ignore_warnings() {
	grep -iv \
        -e "file format not recognized" \
        -e "is not an ordinary file" \
        -e "is a directory" \
        -
}

echo "strip"
strip --strip-debug "$LFS"/usr/lib/* 2>&1 | ignore_warnings
strip --strip-unneeded "$LFS"/usr/{,s}bin/* 2>&1 | ignore_warnings
strip --strip-unneeded "$LFS"/tools/bin/* 2>&1 | ignore_warnings

du -sbBM "$LFS"
