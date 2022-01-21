#!/usr/bin/env sh
set -e

echo "using $SANITY_CC"
echo "$SANITY_CC = $(which "$SANITY_CC")"
if [ -L "$(which "$SANITY_CC")" ] ; then
  echo "  which is a symlink to $(readlink "$(which "$SANITY_CC")")"
else
  echo "  which is not a symlink"
fi
echo ""

echo "testing:"
echo 'int main(){}' > dummy.c
$SANITY_CC dummy.c
if readelf -l a.out | grep 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' ; then
    echo "SUCCESS"
else
    echo "ERROR!"
    exit 1
fi
rm dummy.c a.out
