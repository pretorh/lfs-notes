#!/usr/bin/env sh

SYSTEMD_VERSION=246

# missing xsltproc, so add symlink
ln -sf /bin/true /usr/bin/xsltproc

# setup man pages
tar -xf ../systemd-man-pages-$SYSTEMD_VERSION.tar.xz

# remove tests that fail in chroot
sed '177,$ d' \
    -i src/resolve/meson.build

# remove unneeded group
sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in

# configure
mkdir -p build
cd build || (echo "failed to cd" && exit 1)

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=true                    \
      -Ddocdir=/usr/share/doc/systemd-$SYSTEMD_VERSION \
      ..
