# Host system setup

## install/update required packages on the host

For list of packages, and installing on Arch, use `sudo scripts/setup/pacman.sh`. Note Python 3 is required.
(Linux kernel not mentioned in script)

Use `scripts/setup/symlink-check.sh` to check that symlinks point to correct versions.

## Setup partition, set the LFS variable, and mount

Set `LFS` variable to a location where you can mount a new drive:

`export LFS=/mnt/lfs`

Create partitions, add filesystems, and mount the partitions in `$LFS`

Use `lsblk -oKNAME,UUID,LABEL,PARTLABEL` to find the uuid of the partition to add it to `/etc/fstab`.

You can use `scripts/sudo.sh <command>` to run commands as `sudo`, with the `LFS` environment variable still
set for root

## Setup the sources directory

Use `scripts/setup/sources.sh` as root

## Download the sources

Remember to read the [errata](https://www.linuxfromscratch.org/lfs/errata/stable/) as well

### tarbal

download from one of the [mirrors](https://www.linuxfromscratch.org/mirrors.html#files) and extract. may need to `--strip-components=1` to skip the root version name:

```
tar -xvf ~/Downloads/lfs-packages-<version>.tar --strip-components=1
md5sum --check md5sums
```

### wget-list

Get the wget-list from linuxfromscratch for the current version and download the sources.  

Use `scripts/setup/download-sources.sh <lfs-version-with-systemd-suffix>` to download the packages to the current directory (might want to change into the sources directory first ex `cd $LFS/sources`)

This script skips packages not needed in `systemd` LFS, and some packages that were previously downloaded but not installed:

- documentation-only packages
- `grub` (using the host's grub)

Some packages change frequently and is ignored in this script, and should be manually downloaded:

- [Linux kernel](https://www.kernel.org/)
- [Vim](https://github.com/vim/vim/tags)

`file` previously had issues (older releases not available)

## create and setup `lfs` user

Create the user (once) on the host system:

as root:

```
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

### setup lfs user environment

Initialize the user's bash profile and rc files (this might change between LFS versions) as root using `scripts/setup/create-lfs-user-environment.sh`

## directory structure

Create directory structure as root using `scripts/setup/create-dirs.sh`
