#!/usr/bin/env bash
set -e

# TODO: update this script, which is now even more similar to the main script

echo "check: header files"
# should be
#   #include <...> search starts here:
#       /usr/lib/gcc/x86_64-pc-linux-gnu/<gcc-version>/include
#       /usr/local/include
#       /usr/lib/gcc/x86_64-pc-linux-gnu/<gcc-version>/include-fixed
#       /usr/include
grep -B4 '^ /usr/include' dummy.log
echo "(manually compare the expected 4 lines)"

echo "check: correct search paths for linker"
# should be
#   SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
#   SEARCH_DIR("/usr/local/lib64")
#   SEARCH_DIR("/lib64")
#   SEARCH_DIR("/usr/lib64")
#   SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
#   SEARCH_DIR("/usr/local/lib")
#   SEARCH_DIR("/lib")
#   SEARCH_DIR("/usr/lib");
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo "(manually compare the expected 8 lines)"

echo "check: correct libc"
(grep "/lib.*/libc.so.6 " dummy.log | grep "attempt to open /usr/lib/libc.so.6 succeeded" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

echo "check: correct dynamic linker"
(grep found dummy.log | grep "found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

echo "cleanup"
rm dummy.c a.out dummy.log
