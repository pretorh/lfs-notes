#!/usr/bin/env bash
set -e

mkdir -pv "$LFS/sources/new"
chmod -v a+w "$LFS/sources"{,/new}
chown -v "$(logname)" "$LFS"/sources/{,new}
