#!/usr/bin/env bash
set -eo pipefail

echo "using $SANITY_CC"
full="$(which "$SANITY_CC")"
echo "$SANITY_CC = $full"
if [ -L "$full" ] ; then
  echo "  which is a symlink to $(readlink "$full")"
elif [ -x "$full" ] ; then
  echo "  which is an executable"
fi
echo ""

echo "check: compiling"
echo 'int main(){}' > dummy.c
$SANITY_CC dummy.c -v -Wl,--verbose &> dummy.log

echo "check: interpreter"
readelf -l a.out | grep 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' \
  || (echo "Failed" && exit 1)

echo "check: start files"
grep --only-matching '/.*/lib.*/S*crt[1in].*succeeded' dummy.log | \
  grep -E "$LFS/lib/../lib/(Scrt1.o|crti.o|crtn.o) succeeded" \
  || (echo "Failed" && exit 1)

echo "check: header files"
grep -B3 "^ $LFS/usr/include" dummy.log

echo "check: search paths"
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

echo "check: libc"
grep "/lib.*/libc.so.6 " dummy.log

echo "check: dynamic linker"
grep found dummy.log

echo "check: all passed"
rm dummy.c a.out dummy.log
