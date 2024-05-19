# Finalize

## Release details

Run `scripts/config/os-details.sh` to generate system details `etc` files

## Optional Packages

- [wget] (http://www.linuxfromscratch.org/blfs/view/systemd/basicnet/wget.html)
- [sudo] (http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/sudo.html)
- [openssh](http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/openssh.html)

## Exit chroot and reboot

`logout` and unmount virtual filesystem, see `scripts/chroot/umount-chroot.sh`

unmount all nested partitions of LFS, then LFS itself: `umount -v /mnt/lfs{/sources,}`

Reboot the host system
