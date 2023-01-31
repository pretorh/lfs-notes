#!/usr/bin/env bash

make DESTDIR="$DESTDIR" install
make DESTDIR="$DESTDIR" install-private-headers

ln -sfv tclsh8.6 "$DESTDIR"/usr/bin/tclsh
mv -v "$DESTDIR"/usr/share/man/man3/{Thread,Tcl_Thread}.3
