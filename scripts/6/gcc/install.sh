#!/usr/bin/env bash
GCC_VERSION=11.2.0

make DESTDIR="$DESTDIR" install
rm -rfv "$DESTDIR"/usr/lib/gcc/"$(gcc -dumpmachine)"/$GCC_VERSION/include-fixed/bits/

# symlink required by FHS
ln -srv /usr/bin/cpp "$DESTDIR/usr/lib"
# symlinks for link time optimization
install -v -dm755 "$DESTDIR"/usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/"$(gcc -dumpmachine)"/$GCC_VERSION/liblto_plugin.so "$DESTDIR"/usr/lib/bfd-plugins/

# misplaced file
mkdir -pv "$DESTDIR"/usr/share/gdb/auto-load/usr/lib
mv -v "$DESTDIR"/usr/lib/*gdb.py "$DESTDIR"/usr/share/gdb/auto-load/usr/lib
