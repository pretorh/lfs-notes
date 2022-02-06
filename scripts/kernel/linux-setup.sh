#!/usr/bin/env bash
set -e

echo "extracting"
tar xf linux-*tar.*
cd linux-*/

echo "mrproper and defconfig"
make mrproper
make defconfig

echo ""
echo "now run: make menuconfig"
echo "or"
echo "copy an old config: cp <old config file> .config"
echo "  and manually check new changes: make oldconfig"
echo "  or accept default changes: yes '' | make oldconfig"
PS1='(lfs chroot:linux) \w\$ ' bash
