mv -v $DESTDIR/usr/bin/find $DESTDIR/bin
sed -i 's|find:=${BINDIR}|find:=/bin|' $DESTDIR/usr/bin/updatedb
