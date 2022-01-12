#!/usr/bin/env bash

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod "$DESTDIR"/usr/sbin/$target
done
ln -sfv kmod "$DESTDIR"/usr/bin/lsmod
