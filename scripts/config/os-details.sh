#!/usr/bin/env bash

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

version=$(date --iso-8601=minutes)

cat > "$LFS"/etc/os-release << EOF
NAME="Linux From Scratch"
VERSION="$version"
ID=lfs
PRETTY_NAME="Linux From Scratch $version"
EOF

cat > "$LFS"/etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="$version"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
