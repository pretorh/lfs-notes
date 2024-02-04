#!/usr/bin/env sh
set -e

ln -sv pkgconf "$DESTDIR/usr/bin/pkg-config"
ln -sv pkgconf.1 "$DESTDIR/usr/share/man/man1/pkg-config.1"
