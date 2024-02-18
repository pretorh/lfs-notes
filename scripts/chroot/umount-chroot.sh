#!/usr/bin/env bash

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

if findmnt "$LFS/boot" >/dev/null ; then
  umount -v "$LFS/boot"
fi
umount -v "$LFS"/dev/pts
mountpoint -q "$LFS"/dev/shm && umount "$LFS"/dev/shm
umount -v "$LFS"/dev
umount -v "$LFS"/{sys,proc,run}
