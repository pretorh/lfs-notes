#!/usr/bin/env bash

echo "install: make ... install"
make PREFIX=/usr DESTDIR="$DESTDIR" install

echo "install: shared lib"
cp -av libbz2.so* "$DESTDIR"/usr/lib
ln -sv libbz2.so.1.0.8 "$DESTDIR"/usr/lib/libbz2.so

echo "install: binary, with symlinks to it"
cp -v bzip2-shared "$DESTDIR"/usr/bin/bzip2
ln -sfv bzip2 "$DESTDIR"/usr/bin/bunzip2
ln -sfv bzip2 "$DESTDIR"/usr/bin/bzcat

echo "install: remove static lib"
rm -fv "$DESTDIR"/usr/lib/libbz2.a
