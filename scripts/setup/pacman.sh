#!/usr/bin/env sh
set -e

# do a system update first: `pacman -Syu`
pacman -Sy --needed \
    bash binutils bison coreutils diffutils findutils gawk gcc grep gzip m4 make patch perl python sed tar texinfo xz \
    wget
