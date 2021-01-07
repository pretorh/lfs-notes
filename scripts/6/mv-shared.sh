#!/usr/bin/env sh

NAME=${1?'need name of so file to move'}
MAIN=$DESTDIR$NAME

mv -v "$MAIN".* "$DESTDIR/lib"
ln -sfv ../../lib/"$(readlink "$MAIN")" "$MAIN"
