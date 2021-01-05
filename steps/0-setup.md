# 0. Intro

## install required packages on the host

- bash
- binutils
- bison
- bzip2
- coreutils
- diffutils
- findutils
- gawk
- gcc
- glibc
- grep
- gzip
- m4
- make
- patch
- perl
- python (3.4)
- sed
- tar
- texinfo
- xz

For installing on Arch, see `scripts/0/pacman.sh`

See `scripts/0/symlink-check.sh`

## set the LFS variable
`export LFS=/mnt/lfs`

# 2. Partition and Mount

see `scripts/2/mount.sh`
Note: this script assumes 2 partitions are used: `sda1` for `/boot` and `sda2` for `/`

May need to cleanup the root drive: see `scripts/2/cleanup.sh`

# 3. Sources

See general notes to copy sources over ssh.

## Setup the sources directory
See `scripts/3/setup-sources.sh`

## Download the sources

Get the wget-list from linuxfromscratch for the current version and download the sources.  

Consider downloading from a [mirror](http://www.linuxfromscratch.org/mirrors.html) with https

See `scripts/3/download-sources.sh`
If running this script from within the new lfs system, change into the sources directory first (ex `cd $LFS/sources`)

### versions/missing packages

- file (older versions not kept)
- linux: get the latest version from https://www.kernel.org/pub/linux/kernel/v5.x/
- vim: get the latest version from https://github.com/vim/vim/releases

# 4. Tools

## directory structure

assumes 64 bit. `-p` is used since that ignored already-existing directories

```
sudo --preserve-env=LFS mkdir -pv $LFS/{bin,etc,lib,lib64,sbin,usr,var}
mkdir -pv $LFS/tools
```

## Setup the tools directory
See `scripts/4/setup-tools.sh`

## Create the lfs user
See `scripts/4/create-lfs-user.sh`

## ssh as lfs or switch:

```
passwd lfs
su - lfs
```
