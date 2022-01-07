# 0. Intro

## install required packages on the host

For list of packages, and installing on Arch, see `scripts/0/pacman.sh`. Note Python 3 is required

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

## create lfs user

as root:

```
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

## directory structure

Create directory structure with `sudo --preserve-env=LFS sh ./scripts/4/create-dirs.sh`

## initialize lfs user's environment and switch

initialize the user's bash profile and rc files: `sudo --preserve-env=LFS,HOME sh ./scripts/4/setup-lfs-user-environment.sh`

Switch to the lfs user using `su - lfs`
