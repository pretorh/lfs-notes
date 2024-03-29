#!/usr/bin/env bash
GCC_VERSION=13.2.0

make DESTDIR="$DESTDIR" install

echo "symlink required by FHS"
ln -srv /usr/bin/cpp "$DESTDIR/usr/lib"

echo "symlink for cc man pages"
ln -sv gcc.1 "$DESTDIR/usr/share/man/man1/cc.1"

echo "symlinks for link time optimization"
install -v -dm755 "$DESTDIR"/usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/"$(gcc -dumpmachine)"/$GCC_VERSION/liblto_plugin.so "$DESTDIR"/usr/lib/bfd-plugins/

# misplaced file
mkdir -pv "$DESTDIR"/usr/share/gdb/auto-load/usr/lib
mv -v "$DESTDIR"/usr/lib/*gdb.py "$DESTDIR"/usr/share/gdb/auto-load/usr/lib
