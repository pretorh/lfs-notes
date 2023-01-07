#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

mkdir -pv "$LFS"/{dev,proc,sys,run}
mount -v --bind /dev "$LFS"/dev

mount -v --bind /dev/pts "$LFS"/dev/pts
mount -vt proc proc "$LFS"/proc
mount -vt sysfs sysfs "$LFS"/sys
mount -vt tmpfs tmpfs "$LFS"/run

if [ -h "$LFS"/dev/shm ]; then
  mkdir -pv "$LFS"/"$(readlink "$LFS"/dev/shm)"
fi

if findmnt /boot >/dev/null ; then
  mkdir -pv "$LFS/boot"
  mount -v --bind /boot "$LFS/boot"
fi

findmnt --submounts "$LFS"
