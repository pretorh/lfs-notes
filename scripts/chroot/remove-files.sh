#!/usr/bin/env bash

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

echo "initial disk usage: $(du -sbBM "$LFS")"

echo "removing static libs, documentation"
find "$LFS"/usr/{lib,libexec} -name \*.la -delete
rm -rf "$LFS"/usr/share/{info,man,doc}/*

echo "remove tools dir"
rm -rf "$LFS"/tools

echo "final disk usage: $(du -sbBM "$LFS")"
