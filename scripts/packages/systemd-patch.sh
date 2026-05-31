#!/usr/bin/env sh
set -e

SYSTEMD_VERSION=257.8

echo "patch: remove groups"
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //' \
    -i rules.d/50-udev-default.rules.in

echo "configure: meson in 'build' dir"
mkdir -p build
cd build

meson setup ..                   \
      --prefix=/usr                 \
      --buildtype=release           \
      -D default-dnssec=no          \
      -D firstboot=false            \
      -D install-tests=false        \
      -D ldconfig=false             \
      -D sysusers=false             \
      -D rpmmacrosdir=no            \
      -D homed=disabled             \
      -D userdb=false               \
      -D man=disabled               \
      -D mode=release               \
      -D pamconfdir=no              \
      -D dev-kvm-mode=0660          \
      -D nobody-group=nogroup       \
      -D sysupdate=disabled         \
      -D ukify=disabled             \
      -D docdir=/usr/share/doc/systemd-$SYSTEMD_VERSION
