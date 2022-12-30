#!/usr/bin/env bash
set -e

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod "$DESTDIR"/usr/sbin/$target
done
ln -sfv kmod "$DESTDIR"/usr/bin/lsmod
