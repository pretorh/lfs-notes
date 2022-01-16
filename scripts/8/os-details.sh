#!/usr/bin/env bash

version=$(date --iso-8601=minutes)

cat > /etc/os-release << EOF
NAME="Linux From Scratch"
VERSION="$version"
ID=lfs
PRETTY_NAME="Linux From Scratch $version"
EOF

cat > /etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="$version"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
