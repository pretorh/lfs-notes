#!/usr/bin/env bash
set -e

mkdir -pv "$LFS/sources"
mount "$LFS/sources" || true
chmod -v a+w "$LFS/sources"
chown -v "$(logname)" "$LFS"/sources
