#!/usr/bin/env sh

make DESTDIR="$DESTDIR" -C libelf install
install -vm644 config/libelf.pc "$DESTDIR"/usr/lib/pkgconfig
rm -v "$DESTDIR"/usr/lib/libelf.a
