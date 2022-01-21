#!/usr/bin/env sh

# fix path in ldd
sed '/RTLDLIST=/s@/usr@@g' -i "$LFS/usr/bin/ldd"
