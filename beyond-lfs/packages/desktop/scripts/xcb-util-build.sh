#! /bin/bash

set -e

SUFFIX=${1?'need package name suffix and version'}
ROOT=https://xcb.freedesktop.org/dist/

FULLNAME="xcb-util-$SUFFIX"

echo "building $FULLNAME"
curl -LO -C - $ROOT/$FULLNAME.tar.bz2

rm -rf $FULLNAME
tar xf $FULLNAME.tar.bz2
cd $FULLNAME

./configure $XORG_CONFIG
make --jobs=4
echo "build ok!"
echo ""

LD_LIBRARY_PATH=$XORG_PREFIX/lib make check
echo "test ok!"
echo ""

make install DESTDIR=$DESTDIR

cd ..
rm -rf $FULLNAME
echo "$FULLNAME built ok"
