#!/usr/bin/env sh

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

echo "remove static lib"
rm -fv "$DESTDIR"/usr/lib/libncurses++w.a
