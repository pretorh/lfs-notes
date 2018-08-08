GCC_VERSION=7.3.0

ln -sv ../usr/bin/cpp $DESTDIR/lib
ln -sv gcc $DESTDIR/usr/bin/cc
install -v -dm755 $DESTDIR/usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$GCC_VERSION/liblto_plugin.so $DESTDIR/usr/lib/bfd-plugins/

mkdir -pv $DESTDIR/usr/share/gdb/auto-load/usr/lib
mv -v $DESTDIR/usr/lib/*gdb.py $DESTDIR/usr/share/gdb/auto-load/usr/lib

unset GCC_VERSION
