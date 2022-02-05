# Host system setup

## install/update required packages on the host

For list of packages, and installing on Arch, use `sudo scripts/0/pacman.sh`. Note Python 3 is required

See `scripts/0/symlink-check.sh`

## Setup partition, set the LFS variable, and mount

Set `LFS` variable to a location where you can mount a new drive:

`export LFS=/mnt/lfs`

Create partitions, add filesystems, and mount the partitions in `$LFS`

You can use `scripts/sudo.sh <command>` to run commands as `sudo`, with the `LFS` environment variable set for root

## Setup the sources directory

Use `scripts/3/setup-sources.sh` as root

## Download the sources

Get the wget-list from linuxfromscratch for the current version and download the sources.  

Use `scripts/3/download-sources.sh <lfs-version-with-systemd-suffix>` to download the packages to the current directory (might want to change into the sources directory first ex `cd $LFS/sources`)

This script skips packages not needed in systemd LFS, and some packages that were previously downloaded but not installed:

- documentation-only packages
- grub (using the host's grub)

Some packages change frequently and is ignored in this script, and should be manually downloaded:

- [Linux kernel](https://www.kernel.org/)
- [Vim](https://github.com/vim/vim/tags)

`file` previously had issues (older versions not kept)

## create lfs user

Create the user (once) on the host system:

as root:

```
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

## setup lfs user environment

Initialize the user's bash profile and rc files (this might change between LFS versions) as root using `scripts/4/setup-lfs-user-environment.sh`

## directory structure

Create directory structure as root using `scripts/4/create-dirs.sh`

## switch to lfs user

Switch to the lfs user using `su - lfs`
