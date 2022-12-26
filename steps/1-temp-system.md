# Building the temporary system

## Restoring from toolchain backup

If you already built the toolchain and made a backup, you can restore it:

`tar xPvf FILE.tar.xz`

## General

You should login as `lfs`: `su - lfs`

Remeber to time the first installed package, since all the others are relative to it.

## Part 1

- Bin Utils (pass 1)
    - time: 0.3x real (user+sys is defined as 1x)
- GCC (pass 1)
    - patch scripts:
        - `scripts/5/gcc/patch-mpfr-mpc-gmp.sh`
        - `scripts/5/gcc/patch-lib64.sh`: not patching any more, `lib64` and `lib` are symlinks
    - post install scritps:
        - `scripts/5/gcc/fix-limits_header.sh`
    - time: 3.5x to 3.8x real (user+sys: 13.0x)
- Linux API Headers
    - extract from the linux sources (use downloaded version)
    - ensure clean working directory: `make mrproper`
    - build using `make headers`
    - intstall script: see `scripts/5/linux-headers/install.sh`
    - time: negligible
- GLibc
    - install symlinks (is this needed before, can it be run after install?): see `scripts/5/glibc/symlinks.sh`
    - patch for FHS compliance: see `scripts/5/glibc/patch.sh`
    - run pre configure script (after `cd`ing into build directory, but before `../configure ...`), see `scripts/5/glibc/pre-configure.sh`
    - post install patch: see `scripts/5/glibc/post-install.sh`
    - time: 1.6x real (user+sys: 4.7x)

## Sanity Check 1

See `scripts/sanity-check.sh` and run with `SANITY_CC=$LFS_TGT-gcc ./scripts/sanity-check.sh`

To check: why did this change to just `gcc` (which resolves to the host's `/bin/gcc`)

Finalize `limits.h` header, see `scripts/finalize-limitsh.sh`

## Part 2

- libstdc++
    - part of gcc sources
    - run configure from `libstdc++-v3`
    - post: remove libtool archive files (though they existed in `lib64`)
    - time: 0.3x real (user+sys: 0.6x)

## cross compiling temporary tools

### fast/simple

These mostly use `make DESTDIR=$LFS install` when installing

These all have negligible build times: less than 0.3x real, less than 1x usr+sys (usually 0.7x)

- m4
- ncurses
    - patch and build `tic`, see `scripts/5/ncurses/patch-build-tic.sh`
    - install and update libraries, see `scripts/5/ncurses/install.sh`
- bash
    - post install: create `sh` symlink
- coreutils
    - post install: see `scripts/5/coreutils/post.sh`
- diffutils
    - basic config (`prefix` and `host`) only
- file
    - build file with `disable`s first, see `scripts/5/file/pre-config.sh`
    - use the previously built file when running make: `make FILE_COMPILE=$(pwd)/build/src/file`
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

### cleanup

check no libtool archive files were installed: `find $LFS -name '*.la'` (some in `gcc` dirs)

### bin utils and gcc - pass 2

- Bin Utils (pass 2)
    - patch: outdated libtool
    - post install: remove libtool archive files
    - time: 0.4x real (user+sys: 1.3x)
- GCC (pass 2)
    - patch:
        - `scripts/5/gcc/patch-mpfr-mpc-gmp.sh` (same as in pass 1)
        - `scripts/5/gcc/patch-lib64.sh`: not patching any more, `lib64` and `lib` are symlinks
        - `scripts/5/gcc/patch-libgcc-posix-support.sh`
    - post install:
        - `ln -sv gcc $LFS/usr/bin/cc`
    - time: 3.9x to 4.1x real (user+sys: 13.5x to 14.2x)

## finalize temporary system

Logout `lfs` user, most of the remaining commands should be run as `root` (or `sudo`)

Fix the LFS root file ownership, use `scripts/fix-permissions.sh`
