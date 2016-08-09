# Release details

```
cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="20160304-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 20160304-systemd"
EOF
```

```
echo 20160304-systemd > /etc/lfs-release
```

```
cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="20160304-systemd"
DISTRIB_CODENAME="<your name here>"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
```

# Optional Packages

- [dhcpcd] (http://www.linuxfromscratch.org/blfs/view/systemd/basicnet/dhcpcd.html)
- [wget] (http://www.linuxfromscratch.org/blfs/view/systemd/basicnet/wget.html)
- [sudo] (http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/sudo.html)
- ssh
    - [openssl] (http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/openssl.html)
    - [openssh](http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/openssh.html)

# Exit chroot and reboot

```
logout

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

umount -v $LFS/boot
umount -v $LFS

shutdown -r now
```
