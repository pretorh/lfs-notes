sed -i "s:minix:ext4:g" src/test/test-path-util.c
make LD_LIBRARY_PATH=/tools/lib -k check
