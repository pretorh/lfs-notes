#!/usr/bin/env sh

# fhs patch
glibc_version="$(basename "$(pwd)")"
patch -Np1 -i "../$glibc_version-fhs-1.patch"
