#!/usr/bin/env sh
set -e

version=6.5

echo "install"
make DESTDIR="$PWD/dest" install
install -vm755 dest/usr/lib/libncursesw.so.$version /usr/lib
rm -v dest/usr/lib/libncursesw.so.$version
echo "Use wide-character ABI"
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp -av dest/* "$DESTDIR"/

echo "symlink wide to non-wide libs"
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so     "$DESTDIR"/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        "$DESTDIR"/usr/lib/pkgconfig/${lib}.pc
done

echo "allow -lcurses"
ln -sfv libncursesw.so      "$DESTDIR"/usr/lib/libcurses.so

echo "done"
