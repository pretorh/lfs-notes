# Making the system bootable

## fstab

From outside chroot, run `scripts/config/genfstab.sh`, and redirect it:

`scripts/config/genfstab.sh | tee $LFS/etc/fstab`

Note: this gets the uuid (but that does not work from inside chroot) and use that to build the fstab entries

Re-enter chroot

## Linux

### setup

Run `scripts/kernel/linux-setup.sh` to extract sources and clean, and setup a default config. Note this starts bash in the extracted directory

### configure

Configure using the menu `make menuconfig`

See the note about required options. See also note about options for UEFI support  
partial check: `scripts/kernel/check-kernel-config`

### build

`time make --jobs 8`

Time: 8.1x real

### install

Run `scripts/kernel/install-linux.sh <kernal name, preferably something with lfs>`

### finalize

No need to remove the sources, but need to chown: `chown -R 0:0 .`

`exit` from the `linux-setup.sh` script

## GRUB

`/boot/grub/grub.cfg` is generated by `grub-mkconfig`, so rather make changes in `/etc/grub.d/` files, and use `grub-mkconfig`, even though it is not recommended by the book: when dual booting another Linux system, updates to it will overwrite the configs in any case, so rather use it

### using the host's boot partition

on the *host* system:

```
mkdir -pv $LFS/etc/grub.d/
cp -v scripts/config/gengrub.sh $LFS/etc/grub.d/11_lfs
ln -svf "$LFS/etc/grub.d/11_lfs" /etc/grub.d
```

`11_lfs` is used as the script name to sort this file after the default `10_linux` file. This file includes all kernels with "lfs" in their name

Then generate the `grub.cfg` (do this on every new Linux install)

```
cp -v /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
grub-mkconfig > /boot/grub/grub.cfg
diff --unified --color /boot/grub/grub.cfg.bak /boot/grub/grub.cfg
```

### previous notes

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
