NCURSES_VERSION=6.1

# move shared libs
mv -v $DESTDIR/usr/lib/libncursesw.so.6* $DESTDIR/lib
ln -sfv ../../lib/$(readlink $DESTDIR/usr/lib/libncursesw.so) $DESTDIR/usr/lib/libncursesw.so

# symlink wide to non-wide
for lib in ncurses form panel menu ; do
    rm -vf                    $DESTDIR/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > $DESTDIR/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        $DESTDIR/usr/lib/pkgconfig/${lib}.pc
done

# old applications that look for -lcurses at build time
rm -vf                     $DESTDIR/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > $DESTDIR/usr/lib/libcursesw.so
ln -sfv libncurses.so      $DESTDIR/usr/lib/libcurses.so

# install docs
mkdir -pv      $DESTDIR/usr/share/doc/ncurses-$NCURSES_VERSION
cp -v -R doc/* $DESTDIR/usr/share/doc/ncurses-$NCURSES_VERSION

unset NCURSES_VERSION
