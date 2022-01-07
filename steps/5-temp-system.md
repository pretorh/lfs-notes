# Building the temporary system

## Restoring from toolchain backup

If you already built the toolchain and made a backup, you can restore it:

`tar xPvf FILE.tar.xz`

## General

You should login as `lfs`: `su - lfs`

## Timings

Remeber to time the first installed package, since all the others are relative to it.

Add the `user` and `sys` output as this would give an indication of how long serial-only builds could take (some packages do not run much faster on parallel)

Tracking the first GCC build (the 2nd package) is also useful, as it is about 10 times longer than the 1st (which makes
it one of the longest building packages)

The longest build/testing packages are GCC (120x total) and GLibC (~80x total, mostly for the tests)

Added my timings, when used with `time make --jobs 4` for build and `time make check --jobs 4` (or `test`) for
tests (should `TESTSUITEFLAGS` be used here?).
Times are also relative to the initial bin utils build. Parallel timing is relative to bin utils

The configure time is not tracked, but is usually quite small (though a few seem to take almost longer on configre than
build)

Small times are not shown (should be ones smaller than 1 SMB)

## Part 1

- Bin Utils (pass 1)
    - remember to time this (defined as 1x)
    - parallel: 0.3x
- GCC (pass 1)
    - patch scripts:
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
        - `5/gcc/patch-lib64.sh`
    - post install scritps:
        - `5/gcc/fix-limits_header.sh`
    - time: 9x to 13x (3.9x for parallel)
- Linux API Headers
    - extract from the linux sources (use downloaded version)
    - ensure clean working directory: `make mrproper`
    - build using `make headers`
    - intstall script: see `5/linux-headers/install.sh`
    - time: negligible
- GLibc
    - install symlinks (is this needed before, can it be run after install?): see `scripts/5/glibc/symlinks.sh`
    - patch for FHS compliance: see `scripts/5/glibc/patch.sh`
    - run pre configure script (after `cd`ing into build directory, but before `../configure ...`)
    - post install patch: see `scripts/5/glibc/post-install.sh`
    - time: 5x (1.4x for parallel). installation (untimed) took non trivial time

## Sanity Check 1

see `scripts/sanity-check.sh` and run with `SANITY_CC=$LFS_TGT-gcc sh sanity-check.sh`

Finalize `limits.h` header, see `scripts/5/finalize-limitsh.sh`

## Part 2

- libstdc++
    - part of gcc sources
    - run configure from `libstdc++-v3`
    - time: 0.4x (0.1x for parallel)

## cross compiling temporary tools

### fast/simple

most of these have negligible build times

- m4
- ncurses
    - patch and build `tic`, see `scripts/5/ncurses/patch-build-tic.sh`
    - install and update libraries, see `scripts/5/ncurses/install.sh`
    - time: 0.3x for `tic`, negligible for main
- bash
    - post install: create `sh` symlink
    - time: 0.3x (negligible for parallel)
- coreutils
    - post install: see `scripts/5/coreutils/post.sh`
    - time: 0.4x (0.1x for parallel)
- diffutils
    - basic config (`prefix` and `host`) only
- file
    - build file with `disable`s first, see `scripts/5/file/pre-config.sh`
    - use the previously built file when running make: `make FILE_COMPILE=$(pwd)/build/src/file`
- findutils
    - post install: move into `bin` and change `updatedb`
- gawk
    - patch: remove extras in makefile
- grep
- gzip
    - basic config (`prefix` and `host`) only
- make
- patch
    - basic config (`prefix`, `host`, `build`) only
- sed
- tar
- xz
    - post install: move into `bin`, `lib`, update symlink

### bin utils and gcc - pass 2

- Bin Utils (pass 2)
    - time: 1.3x (0.4x for parallel)
- GCC (pass 2)
    - patch:
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
        - `5/gcc/patch-lib64.sh`
        - create symlink for libgcc posix thread support
    - post install:
        - `ln -sv gcc $LFS/usr/bin/cc`
    - time: 12x to 14x (4.0x for parallel)

# deprecated notes from pre-10.0 book

## Sanity Check 2

see `scripts/sanity-check.sh` and run with `SANITY_CC=cc sh sanity-check.sh`

# Finalizing the temp system

run as root user (at least for the change command, but also for all following that)

`export LFS=/mnt/lfs`

## Cleanup the toolchain

Strip debug symbols, remove documentation and chage ownership.

see `scripts/5/finalize/cleanup.sh`

## Backup the toolchain

see `scripts/5/finalize/backup.sh`
