# ensure that all instances of "/tools" are removed
(cat `dirname $(gcc --print-libgcc-file-name)`/specs | grep "tools" && echo "CHECK OUTPUT" && false) \
    || echo -e "no tools in output\nSUCCESS"

# SANITY CHECK 3
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
test -f a.out || (echo "ERROR! cc did not generate a.out" && false)
readelf -l a.out | grep 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' && echo "SUCCESS" \
    || (echo "ERROR!" && false)

# correct start files: should have 3 lines
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc -l

# header files: should be /usr/include
grep -B1 '^ /usr/include' dummy.log

# correct search paths: should be /usr/lib and /lib
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' | grep -ve "-linux-gnu"

# correct libc
(grep "/lib.*/libc.so.6 " dummy.log | grep "attempt to open /lib/libc.so.6 succeeded" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

# correct dynamic linker
(grep found dummy.log | grep "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

# cleanup
rm -v dummy.c a.out dummy.log
