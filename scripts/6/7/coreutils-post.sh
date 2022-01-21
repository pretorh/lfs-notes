#!/usr/bin/env bash

# FHS
mv -v "$DESTDIR"/usr/bin/chroot "$DESTDIR"/usr/sbin
mv -v "$DESTDIR"/usr/share/man/man1/chroot.1 "$DESTDIR"/usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 "$DESTDIR"/usr/share/man/man8/chroot.8
