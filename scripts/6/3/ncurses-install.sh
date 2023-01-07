#!/usr/bin/env sh
set -e

echo "install"
# todo: use DESTDIR for this
make DESTDIR="$PWD/dest" install
install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib
rm -v dest/usr/lib/libncursesw.so.6.3
cp -av dest/* /

echo "symlink wide to non-wide libs"
for lib in ncurses form panel menu ; do
    rm -vf                    "$DESTDIR"/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > "$DESTDIR"/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        "$DESTDIR"/usr/lib/pkgconfig/${lib}.pc
done

echo "allow -lcurses"
rm -vf                     "$DESTDIR"/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > "$DESTDIR"/usr/lib/libcursesw.so
ln -sfv libncurses.so      "$DESTDIR"/usr/lib/libcurses.so

echo "done"
