set -e

install -vd -m755 $DESTDIR/usr/share/fonts/TTF/
install -v -m644 $@ $DESTDIR/usr/share/fonts/TTF/
