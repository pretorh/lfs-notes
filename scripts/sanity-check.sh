#!/usr/bin/env sh

set -e

echo "using $SANITY_CC to compile dummy.c"
echo "$SANITY_CC = $(which "$SANITY_CC")"
[ -L "$(which "$SANITY_CC")" ] && echo "links to $(readlink "$(which "$SANITY_CC")")"
echo ""

echo 'int main(){}' > dummy.c
$SANITY_CC dummy.c
if readelf -l a.out | grep 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' ; then
    echo "SUCCESS"
else
    echo "ERROR!"
fi
rm -v dummy.c a.out
