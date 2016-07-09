# arch: ensure the system is up to date, and install required packages
pacman -Syu --noconfirm
pacman -S --noconfirm --needed bash binutils bison bzip2 coreutils diffutils findutils gawk gcc glibc grep gzip m4 make patch perl sed tar texinfo xz

# download gcc-5.3.0 and install it
wget --continue \
    -P /var/cache/pacman/pkg/ \
    https://archive.archlinux.org/packages/g/gcc/gcc-5.3.0-5-x86_64.pkg.tar.xz
wget --continue \
    -P /var/cache/pacman/pkg/ \
    https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-5.3.0-5-x86_64.pkg.tar.xz
pacman -U /var/cache/pacman/pkg/gcc-libs-5.3.0-5-x86_64.pkg.tar.xz /var/cache/pacman/pkg/gcc-5.3.0-5-x86_64.pkg.tar.xz
