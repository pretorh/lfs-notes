#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

# create limited directory layout
mkdir -pv "$LFS/"{etc,lib64,var}
mkdir -pv "$LFS/usr/"{bin,lib,sbin}

# symlink root dirs into related /usr
for i in bin lib sbin; do
  rm -vf "$LFS/$i"
  ln -sv usr/$i "$LFS/$i"
done

# create tool chain directory
mkdir -pv "$LFS/tools"

# make lfs user the owner of these
chown -v lfs "$LFS"/{etc,lib64,var}
chown -v lfs "$LFS"/usr{,/*}
chown -v lfs "$LFS"/{tools,sources}
