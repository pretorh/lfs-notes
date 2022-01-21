# 0. Intro

## install required packages on the host

For list of packages, and installing on Arch, see `scripts/0/pacman.sh`. Note Python 3 is required

See `scripts/0/symlink-check.sh`

## Setup partition, set the LFS variable, and mount

set `LFS` variable to a location where you can mount a new drive:

`export LFS=/mnt/lfs`

Create partitions, add filesystems, and mount the partitions in $LFS

# 3. Sources

See general notes to copy sources over ssh.

## Setup the sources directory

See `scripts/3/setup-sources.sh`

## Download the sources

Get the wget-list from linuxfromscratch for the current version and download the sources.  

Use `scripts/3/download-sources.sh` to download the packages to the current directory (might want to change into the sources directory first ex `cd $LFS/sources`)

Some packages change frequently and is ignored in this script, and should be manually downloaded:

- [Linux kernel](https://www.kernel.org/)
- [Vim](https://github.com/vim/vim/tags)

Some packages were downloaded, but not installed:
- eudev-3.2.10.tar.gz
- grub-2.06.tar.xz (using host's grub)
- lfs-bootscripts-20210608.tar.xz
- python-3.9.6-docs-html.tar.bz2 (some doc installation skipped)
- sysklogd-1.5.1.tar.gz
- systemd-man-pages-249.tar.xz (some doc installation skipped)
- udev-lfs-20171102.tar.xz
- v8.2.4023.tar.gz

`file` previous had issues (older versions not kept)

# 4. Tools

## create lfs user

Create the user (once) on the host system:

as root:

```
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

Initialize the user's bash profile and rc files (this might change between LFS versions) using `sudo --preserve-env=LFS,HOME sh ./scripts/4/setup-lfs-user-environment.sh`

## directory structure

Create directory structure with `sudo --preserve-env=LFS sh ./scripts/4/create-dirs.sh`

## switch to lfs user

Switch to the lfs user using `su - lfs`
