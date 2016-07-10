mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

# ensure that all instances of "/tools" are removed
(cat `dirname $(gcc --print-libgcc-file-name)`/specs | grep tools && echo "CHECK OUTPUT") || echo -e "no tools in output\nSUCCESS"

# SANITY CHECK 3
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
(readelf -l a.out | grep 'Requesting program interpreter: /lib.*/ld-linux-x86.*.so.2' && echo "SUCCESS") || echo "ERROR!"

# correct start files: should have 3 lines
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc -l

# header files: should be /usr/include
grep -B1 '^ /usr/include' dummy.log

# correct search paths: should be /usr/lib and /lib
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' | grep -ve "-linux-gnu"

# correct libc
(grep "/lib.*/libc.so.6 " dummy.log | grep "attempt to open /lib.*/libc.so.6 succeeded" && echo "SUCCESS") || echo "ERROR!"

# correct dynamic linker
(grep found dummy.log | grep "found ld-linux.*.so.2 at /lib.*/ld-linux.*.so.2" && echo "SUCCESS") || echo "ERROR!"

# cleanup
rm -v dummy.c a.out dummy.log
