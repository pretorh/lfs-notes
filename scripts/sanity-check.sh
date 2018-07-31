set -e

echo "using $SANITY_CC command to compile dummy.c"
echo "$SANITY_CC = $(which $SANITY_CC)"
[ -L $(which $SANITY_CC) ] && echo "links to $(readlink $(which $SANITY_CC))"
echo ""

echo 'int main(){}' > dummy.c
$SANITY_CC dummy.c
readelf -l a.out | grep 'Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2' && echo "SUCCESS" \
  || (echo "ERROR!" && false)
rm -v dummy.c a.out
