#!/usr/bin/env bash
set -e

# TODO: this should change to create in an archive only, and not set owner to lfs

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

# create limited directory layout
mkdir -pv "$LFS/"{etc,var}
mkdir -pv "$LFS/usr/"{bin,lib,sbin}

# symlink root dirs into related /usr
for i in bin lib sbin; do
  rm -vf "$LFS/$i"
  ln -sv usr/$i "$LFS/$i"
done

# lib64 as symlink into lib
rm -vf "$LFS/lib64"
ln -sv usr/lib "$LFS/lib64"

# create tool chain directory
mkdir -pv "$LFS/tools"

# make lfs user the owner of these
chown -v lfs "$LFS"/{etc,lib64,var}
chown -v lfs "$LFS"/usr{,/*}
chown -v lfs "$LFS"/tools
