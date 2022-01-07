#!/usr/bin/env sh
set -e

pacman -Sy --noconfirm --needed \
    bash binutils bison bzip2 coreutils diffutils findutils gawk gcc glibc grep gzip m4 make patch perl python sed tar texinfo xz
