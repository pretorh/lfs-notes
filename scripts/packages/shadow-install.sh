#!/usr/bin/env bash

make exec_prefix=/usr DESTDIR="$DESTDIR" install
make -C man DESTDIR="$DESTDIR" install-man
mkdir -vp "$DESTDIR"/etc/default
