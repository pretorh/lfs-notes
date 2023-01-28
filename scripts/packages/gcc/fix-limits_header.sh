#!/usr/bin/env sh
libgcc_file=$("$LFS_TGT-gcc" -print-libgcc-file-name)
output=$(dirname "$libgcc_file")/install-tools/include/limits.h

sources="../gcc"
echo "creating limits.h ($output)"
cat $sources/limitx.h $sources/glimits.h $sources/limity.h > "$output"
