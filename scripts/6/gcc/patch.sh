#!/usr/bin/env bash

echo "fix libasan.a build"
sed -e '/static.*SIGSTKSZ/d' \
    -e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
    -i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp

echo "fix lib directory for 64bit"
# todo: do we need this? why not let it build to lib64?
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
