#!/usr/bin/env sh
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

backup_dir=$PWD/pkgs
cd "$LFS"
file="$backup_dir/lfs-temp-tools-$(date --iso-8601).tar.xz"
echo "creating $file"
tar -cf "$file" \
    --xz \
    --preserve-permissions  \
    --exclude ./sources \
    .
