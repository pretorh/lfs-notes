SYSTEMD_VERSION=237

# missing xsltproc, so add symlink
ln -sfv /tools/bin/true /usr/bin/xsltproc

# setup man pages
tar -xf ../systemd-man-pages-$SYSTEMD_VERSION.tar.xz

# remove tests that fail in chroot
sed '178,222d' -i src/resolve/meson.build

# remove unneeded group
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in

# configure
mkdir -p build
cd build

LANG=en_US.UTF-8
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkill-path=/bin/kill         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false

unset SYSTEMD_VERSION
