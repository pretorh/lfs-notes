# fstab

## should try to use uuid's of devices

get the uuid of the mount point (on the host): `lsblk -o MOUNTPOINT,UUID | grep $LFS`

## create fstab:

see `scripts/8/fstab.sh`

# Linux

## setup

```
tar xf linux-*tar.*
cd linux-*

make mrproper
```

## configure

Create a default config: `make defconfig`

Configure using the menu (replace `en_US.UTF-8` with the host's `$LANG`): `make LANG=en_US LC_ALL= menuconfig`

## build

Time: about half the time to build `GCC`

```
time make -j5
time make modules_install
```

## install boot

```
export LINUX_VERSION=4.4.2
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-$LINUX_VERSION-lfs-20160304-systemd
cp -v System.map /boot/System.map-$LINUX_VERSION
cp -v .config /boot/config-$LINUX_VERSION
```

## docs

```
install -d /usr/share/doc/linux-$LINUX_VERSION
cp -r Documentation/* /usr/share/doc/linux-$LINUX_VERSION
unset LINUX_VERSION
```

## No need to remove the sources

But need to chown: `chown -R 0:0 .`

## module load order

```
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF
```

# GRUB

Assuming `sda` is the drive with `/` or `/boot`

`grub-install /dev/sda`

had issue with the above, see [this](https://wiki.archlinux.org/index.php/GRUB#Install_to_partition_or_partitionless_disk)

```
chattr -i /boot/grub/i386-pc/core.img
grub-install --target=i386-pc --debug --force /dev/sda
chattr +i /boot/grub/i386-pc/core.img
```

Setup `grub.conf`. the kernel files are relative to the *partition* used, so remove `/boot`:

```
cat > /boot/grub/grub.cfg << "EOF"
set default=0
set timeout=5
insmod ext2
set root=(hd0,1)
menuentry "GNU/Linux, Linux 4.4.2-lfs-20160304-systemd" {
        linux   /vmlinuz-4.4.2-lfs-20160304-systemd root=/dev/sda2 ro
}
EOF
```
