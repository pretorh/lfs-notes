set -e

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep 'Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2' && echo "SUCCESS" \
  || (echo "ERROR!" && false)
rm -v dummy.c a.out
