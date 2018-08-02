# SANITY CHECK 4 (very similar to 3, expected output differs)
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
test -f a.out || (echo "ERROR! cc did not generate a.out" && false)
readelf -l a.out | grep 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' && echo "SUCCESS" \
    || (echo "ERROR!" && false)

# header files
# should be
#   #include <...> search starts here:
#       /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
#       /usr/local/include
#       /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include-fixed
#       /usr/include
grep -B4 '^ /usr/include' dummy.log

# correct start files: should have 3 lines
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc -l

# correct search paths:
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

# correct libc
(grep "/lib.*/libc.so.6 " dummy.log | grep "attempt to open /lib/libc.so.6 succeeded" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

# correct dynamic linker
(grep found dummy.log | grep "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2" && echo "SUCCESS") \
    || (echo "ERROR!" && false)

# cleanup
rm -v dummy.c a.out dummy.log
