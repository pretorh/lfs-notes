#!/usr/bin/env sh
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

cd "$LFS"
file="/tmp/lfs-temp-tools-$(date --iso-8601).tar.xz"
echo "creating $file"
tar -cf "$file" \
    --xz \
    --preserve-permissions  \
    --exclude ./sources \
    .
