#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

mkdir -pv "$LFS"/{dev,proc,sys,run}
mount -v --bind /dev "$LFS"/dev

mount -vt devpts devpts -o gid=5,mode=0620 "$LFS"/dev/pts
mount -vt proc proc "$LFS"/proc
mount -vt sysfs sysfs "$LFS"/sys
mount -vt tmpfs tmpfs "$LFS"/run

if [ -h "$LFS"/dev/shm ]; then
  install -v -d -m 1777 "$LFS""$(realpath /dev/shm)"
else
  mount -v -t tmpfs -o nosuid,nodev tmpfs "$LFS"/dev/shm
fi

mkdir -pv "$LFS/boot"
if findmnt /boot >/dev/null && ! findmnt "$LFS/boot" >/dev/null ; then
  echo "bind mounting the host's /boot"
  mount -v --bind /boot "$LFS/boot"
fi

findmnt --submounts "$LFS"
