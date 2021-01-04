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
There were some files not in the wget-list, so will need to download them separately.  
See `scripts/3/download-sources.sh`
If running this script from within the new lfs system, change into the sources directory first (`cd $LFS/sources`)

# 4. Tools

## Setup the tools directory
See `scripts/4/setup-tools.sh`

## Create the lfs user
See `scripts/4/create-lfs-user.sh`

## ssh as lfs or switch:

```
passwd lfs
su - lfs
```
