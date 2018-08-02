mv -v $DESTDIR/usr/lib/lib{readline,history}.so.* $DESTDIR/lib
ln -sfv ../../lib/$(readlink $DESTDIR/usr/lib/libreadline.so) $DESTDIR/usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink $DESTDIR/usr/lib/libhistory.so ) $DESTDIR/usr/lib/libhistory.so

install -v -m644 doc/*.{ps,pdf,html,dvi} $DESTDIR/usr/share/doc/readline-7.0
