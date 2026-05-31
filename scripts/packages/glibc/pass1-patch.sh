#!/usr/bin/env sh

# fhs patch
glibc_version="$(basename "$(pwd)")"
patch -Np1 -i "../$glibc_version-fhs-1.patch"

# Valgrind
sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
__libc_rwlock_define_initialized (, reset_lock);\
memcpy (&lock, &reset_lock, sizeof (lock));' \
-i stdlib/abort.c
