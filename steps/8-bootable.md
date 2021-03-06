# fstab

## should try to use uuid's of devices

get the uuid of the mount point (on the host): `lsblk -o MOUNTPOINT,UUID | grep $LFS`

## create fstab:

see `scripts/8/fstab.sh`, and redirect to `/etc/fstab`

# Linux

## setup

make sure you are in the sources dir (`cd /sources`)

```
tar xf linux-*tar.*
cd linux-*/

make mrproper
```

## configure

Create a default config: `make defconfig`

Configure using the menu `make menuconfig`

see the note about required options!

(partial check: `scripts/8/check-kernel-config`)

## build

Time: 10x

```
time make -j5
time make modules_install
```

## install

see `scripts/8/install-linux.sh`

## No need to remove the sources

But need to chown: `chown -R 0:0 .`

## module load order

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
