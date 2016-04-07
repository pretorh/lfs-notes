echo 'int main(){}' > dummy.c
cc dummy.c
(readelf -l a.out | grep 'Requesting program interpreter: /tools/lib.*/ld-linux-x86.*.so.2' && echo "SUCCESS") || (echo "ERROR!" && exit 1)
rm -v dummy.c a.out
