#!/usr/bin/env sh
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

cd "$LFS"
tar -cf "/tmp/lfs-temp-tools-$(date --iso-8601).tar.xz" \
    --xz \
    --preserve-permissions  \
    --exclude ./sources \
    .
tar -cf "/tmp/lfs-sources-$(date --iso-8601).tar" \
    ./sources
