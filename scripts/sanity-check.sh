#!/usr/bin/env sh
set -e

echo "using $SANITY_CC"
full="$(which "$SANITY_CC")"
echo "$SANITY_CC = $full"
if [ -L "$full" ] ; then
  echo "  which is a symlink to $(readlink "$full")"
elif [ -x "$full" ] ; then
  echo "  which is an executable"
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
