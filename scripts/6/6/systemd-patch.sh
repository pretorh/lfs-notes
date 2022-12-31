#!/usr/bin/env sh
set -e

SYSTEMD_VERSION=251

echo "patch: apply from patch file"
patch -Np1 -i ../systemd-*.patch

#echo "patch: https://github.com/systemd/systemd/pull/20695"
#echo "#define ARPHRD_MCTP  290" >> src/basic/linux/if_arp.h

echo "patch: remove groups"
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //' \
    -i rules.d/50-udev-default.rules.in

echo "configure: meson in 'build' dir"
mkdir -p build
cd build

meson --prefix=/usr                 \
      --buildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Dpamconfdir=no               \
      -Ddocdir=/usr/share/doc/systemd-$SYSTEMD_VERSION \
      ..
