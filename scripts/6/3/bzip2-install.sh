#!/usr/bin/env bash

cp -v bzip2-shared "$DESTDIR"/bin/bzip2
cp -av libbz2.so* "$DESTDIR"/lib
ln -sv ../../lib/libbz2.so.1.0 "$DESTDIR"/usr/lib/libbz2.so
rm -v "$DESTDIR"/usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 "$DESTDIR"/bin/bunzip2
ln -sv bzip2 "$DESTDIR"/bin/bzcat
