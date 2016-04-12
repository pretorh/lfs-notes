patch -Np1 -i ../kbd-2.0.3-backspace-1.patch

# remove redunant programs
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
