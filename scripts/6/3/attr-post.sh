mv -v $DESTDIR/usr/lib/libattr.so.* $DESTDIR/lib
ln -sfv ../../lib/$(readlink $DESTDIR/usr/lib/libattr.so) $DESTDIR/usr/lib/libattr.so
