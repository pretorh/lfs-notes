cp -v ../nscd/nscd.conf $DESTDIR/etc/nscd.conf
mkdir -pv $DESTDIR/var/cache/nscd
install -v -Dm644 ../nscd/nscd.tmpfiles $DESTDIR/usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service $DESTDIR/lib/systemd/system/nscd.service
