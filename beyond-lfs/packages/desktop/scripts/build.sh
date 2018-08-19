#! /bin/bash

set -e

GROUP=${1?'need group name'}
NAME=${2?'need package name and version'}
ROOT=https://www.x.org/archive/individual
export GROUP NAME

echo "running external: $PREPARE_COMMAND"
$PREPARE_COMMAND

echo "building $GROUP/$NAME.tar.bz2"
curl -LO -C - $ROOT/$GROUP/$NAME.tar.bz2

echo "building $GROUP/$NAME.tar.bz2"
rm -rf $NAME
tar xf $NAME.tar.bz2
cd $NAME

echo "configuring using $XORG_CONFIG $XORG_CONFIG_MORE"
[ ! -z "$XORG_CONFIG_MORE" ] && read
./configure $XORG_CONFIG $XORG_CONFIG_MORE
make --jobs=4
echo "build ok!"
echo ""

make check --jobs=4 2>&1 | tee make_check.log
if [ ! -z "$TESTS" ] ; then
  grep -A9 summary make_check.log
  read
fi

make install DESTDIR=$DESTDIR

cd ..
rm -rf $NAME
echo "$NAME build ok"

echo "running external: $INSTALL_COMMAND"
$INSTALL_COMMAND
