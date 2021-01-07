#!/usr/bin/env sh

SRCDIR="$(realpath ..)"

echo "fixing references to $SRCDIR to root dirs"

sed -e "s|$SRCDIR/unix|/usr/lib|"   \
    -e "s|$SRCDIR|/usr/include|"    \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.1|/usr/lib/tdbc1.1.1|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1|/usr/include|"             \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.0|/usr/lib/itcl4.2.0|"  \
    -e "s|$SRCDIR/pkgs/itcl4.2.0/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/itcl4.2.0|/usr/include|"             \
    -i pkgs/itcl4.2.0/itclConfig.sh
