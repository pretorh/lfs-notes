# 0. Intro

## set the LFS variable
`export LFS=/mnt/lfs`

## install required packages

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
- sed
- tar
- texinfo
- xz

For installing on Arch, see `0/pacman.sh`

# 2. Mount

see `2/mount.sh`

May need to cleanup the root drive: see `2/cleanup.sh`

# 3. Sources

See general notes to copy sources over ssh.

## Setup the sources directory.
See `3/setup-sources.sh`

## Download the sources
Get the wget-list from linuxfromscratch for the current version and download the sources.  
There were some files not in the wget-list, so will need to download them separately.  
See `3/download-sources.sh`

# 4. Tools

## Setup the tools directory.
See `4/setup-tools.sh`

## Create the lfs user
See `4/create-lfs-user.sh`
