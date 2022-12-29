#!/usr/bin/env sh

SRCDIR="$(realpath ..)"

tdbc_version=1.1.3
itcl_version=4.2.2

echo "fixing references to $SRCDIR to root dirs"
echo "  tdbc=$tdbc_version, itcl=$itcl_version"

sed -e "s|$SRCDIR/unix|/usr/lib|"   \
    -e "s|$SRCDIR|/usr/include|"    \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc$tdbc_version|/usr/lib/tdbc$tdbc_version|"  \
    -e "s|$SRCDIR/pkgs/tdbc$tdbc_version/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc$tdbc_version/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc$tdbc_version|/usr/include|"             \
    -i pkgs/tdbc$tdbc_version/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl$itcl_version|/usr/lib/itcl$itcl_version|"  \
    -e "s|$SRCDIR/pkgs/itcl$itcl_version/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/itcl$itcl_version|/usr/include|"             \
    -i pkgs/itcl$itcl_version/itclConfig.sh
