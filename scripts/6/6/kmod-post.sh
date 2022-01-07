#!/usr/bin/env bash

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod "$DESTDIR"/sbin/$target
done
ln -sfv kmod "$DESTDIR"/bin/lsmod
