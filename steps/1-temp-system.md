# Building the temporary system

## Restoring from toolchain backup

If you already built the toolchain and made a backup, you can restore it:

`tar xPvf FILE.tar.xz`

## General

You should login as `lfs`: `su - lfs`

Remeber to time the first installed package, since all the others are relative to it.

## Part 1

- Bin Utils (pass 1)
    - time: 0.38x real (user+sys is defined as 1x)
- GCC (pass 1)
    - patch scripts:
        - `scripts/packages/gcc/patch-mpfr-mpc-gmp.sh`
        - `scripts/packages/gcc/patch-lib64.sh`
    - post install scripts:
        - `scripts/packages/gcc/fix-limits_header.sh`
    - time: 3.9x real (user+sys: 13.7x to 13.9x)
- Linux API Headers
    - extract from the linux sources (use downloaded version)
    - ensure clean working directory: `make mrproper`
    - build using `make headers`
    - install script: see `scripts/packages/linux-headers/install.sh`
    - time: negligible
- GLibc
    - install symlinks (is this needed before, can it be run after install?): see `scripts/packages/glibc/symlinks.sh`
    - patch for FHS compliance: see `scripts/packages/glibc/patch.sh`
    - run pre configure script (after `cd`ing into build directory, but before `../configure ...`), see `scripts/packages/glibc/pre-configure.sh`
    - post install patch: see `scripts/packages/glibc/post-install.sh`
    - time: 1.7x real (user+sys: 4.9x)

## Sanity Check 1

See `scripts/sanity-check.sh` and run with `SANITY_CC=$LFS_TGT-gcc ./scripts/sanity-check.sh`

Finalize `limits.h` header, see `scripts/finalize-limitsh.sh`

## Part 2

- libstdc++
    - part of gcc sources
    - run configure from `libstdc++-v3`
    - post: remove libtool archive files (though they existed in `lib64`)
    - time: 0.25x real (user+sys: 0.5x)

## cross compiling temporary tools

### fast/simple

These mostly use `make DESTDIR=$LFS install` when installing

These all have negligible build times: less than 0.3x real, less than 1x usr+sys (usually 0.7x)

- m4
- ncurses
    - patch and build `tic`, see `scripts/packages/ncurses/patch-build-tic.sh`
    - install and update libraries, see `scripts/packages/ncurses/install.sh`
- bash
    - post install: create `sh` symlink
- coreutils
    - post install: see `scripts/packages/coreutils-post.sh`
- diffutils
    - basic config (`prefix` and `host`) only
- file
    - build file with `disable`s first, see `scripts/packages/file-pre-config.sh`
    - use the previously built file when running make: `make FILE_COMPILE=$(pwd)/build/src/file`
    - post install: remove libtool archive files
- findutils
    - post install: move into `bin` and change `updatedb`
- gawk
    - patch: remove "extras" in makefile
- grep
    - basic config (`prefix` and `host`) only
- gzip
    - basic config (`prefix` and `host`) only
- make
- patch
    - basic config (`prefix`, `host`, `build`) only
- sed
    - basic config (`prefix`, `host`) only
- tar
    - basic config (`prefix`, `host`, `build`) only
- xz
    - post install: remove libtool archive files

### cleanup

check no libtool archive files were installed: `find $LFS -name '*.la'` (3 in `gcc` dirs, `libcc1`)

### bin utils and gcc - pass 2

- Bin Utils (pass 2)
    - patch: outdated libtool
    - post install: remove libtool archive files
    - time: 0.4x real (user+sys: 1.3x)
- GCC (pass 2)
    - patch:
        - `scripts/packages/gcc/patch-mpfr-mpc-gmp.sh` (same as in pass 1)
        - `scripts/packages/gcc/patch-lib64.sh` (same as in pass 1)
        - `scripts/packages/gcc/patch-libgcc-posix-support.sh`
    - post install:
        - `ln -sv gcc $LFS/usr/bin/cc`
    - time: 4.9x to 5.3x real (user+sys: 16.3x to 17.7x)

## finalize temporary system

Logout `lfs` user, most of the remaining commands should be run as `root` (or `sudo`)

Fix the LFS root file ownership, use `scripts/fix-permissions.sh`
