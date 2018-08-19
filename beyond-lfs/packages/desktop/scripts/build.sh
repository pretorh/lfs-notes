#! /bin/bash

set -e

GROUP=${1?'need group name'}
NAME=${2?'need package name and version'}
ROOT=https://www.x.org/archive/individual

echo "building $GROUP/$NAME.tar.bz2"
curl -LO -C - $ROOT/$GROUP/$NAME.tar.bz2

echo "building $GROUP/$NAME.tar.bz2"
rm -rf $NAME
tar xf $NAME.tar.bz2
cd $NAME

echo "configuring using $XORG_CONFIG"
./configure $XORG_CONFIG
make --jobs=4
echo "build ok!"
echo ""

make install DESTDIR=$DESTDIR

cd ..
rm -rf $NAME
echo "$NAME build ok"
