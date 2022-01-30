#!/usr/bin/env sh
set -e

SYSTEMD_VERSION=249

echo "patch: apply from patch file"
patch -Np1 -i ../systemd-$SYSTEMD_VERSION-upstream_fixes-1.patch

echo "patch: https://github.com/systemd/systemd/pull/20695"
echo "#define ARPHRD_MCTP  290" >> src/basic/linux/if_arp.h

echo "patch: remove groups"
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //' \
    -i rules.d/50-udev-default.rules.in

echo "configure: meson in 'build' dir"
mkdir -p build
cd build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-$SYSTEMD_VERSION \
      ..
