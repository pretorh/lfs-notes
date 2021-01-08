#!/usr/bin/env sh

# symlink wide to non-wide
for lib in ncurses form panel menu ; do
    rm -vf                    "$DESTDIR"/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > "$DESTDIR"/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        "$DESTDIR"/usr/lib/pkgconfig/${lib}.pc
done

# old applications that look for -lcurses at build time
rm -vf                     "$DESTDIR"/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > "$DESTDIR"/usr/lib/libcursesw.so
ln -sfv libncurses.so      "$DESTDIR"/usr/lib/libcurses.so
