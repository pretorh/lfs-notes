# Building the temporary system

## Restoring from toolchain backup

If you already built the toolchain and made a backup, you can restore it:

`tar xPvf FILE.tar.xz`

## General

You should login as `lfs`

if building on x64: (this was part of bin utils)
```
mkdir -pv /tools/lib
ln -sv lib /tools/lib64
```

## Timings

Remeber to time the first installed package, since all the others are relative to it.
Check the `user`+`sys` output (as this would give an indication of how long serial-only builds could take)
Tracking the first GCC build (the 2nd package) is also useful, as it is about 10 times longer than the 1st (which makes
it one of the longest building packages)
The longest build/testing packages are GCC (120x total) and GLibC (~80x total, mostly for the tests)

Added my timings, when used with `time make --jobs 4` for build and `time make check --jobs 4` (or `test`) for
tests (should `TESTSUITEFLAGS` be used here?).
Times are also relative to the initial bin utils build

The configure time is not tracked, but is usually quite small (though a few seem to take almost longer on configre than
build)

Small times are not shown (should be ones smaller than 1 SMB)

## Part 1

- Bin Utils
    - remember to time
- GCC
    - scripts:
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
        - `5/gcc/toolchain.sh`
    - time: 9x to 10x
- Linux API Headers
    - non default steps:
        - `make mrproper`
        - `make INSTALL_HDR_PATH=dest headers_install`
        - `cp -rv dest/include/* /tools/include`
    - had some issues previously during automation, and had to remove this before removing the extracted files
        - `rm -rf linux-4.4.2/arch/arm64/boot/dts/include`
- GLibc
    - time: 5x

## Sanity Check 1

see `scripts/sanity-check.sh` and run with `SANITY_CC=$LFS_TGT-gcc sh sanity-check.sh`

## Part 2

- libstdc++
- Bin Utils (pass 2)
    - "re-adjusting"
- GCC (pass 2)
    - scripts:
        - `5/gcc/patch-limits.sh`
        - `5/gcc/toolchain.sh`
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
    - `ln -sv gcc /tools/bin/cc`
    - time: 12x

## Sanity Check 2

see `scripts/sanity-check.sh` and run with `SANITY_CC=cc sh sanity-check.sh`

## Part 3

- tcl-core
    - post install steps:
        - `chmod -v u+w /tools/lib/libtcl8.6.so`
        - `make install-private-headers`
        - `ln -sv tclsh8.6 /tools/bin/tclsh`
- expect
    - patch the config file
- DejaGNU
- m4
- ncurses
    - patch the config file to find gawk
- bash
- bison
	- tests are mentioned, but they run a lot longer than the build
	    - some also fail: 430, 431, 432
- bzip2
    - no config needed
- coreutils

## The Easy Stuff

All of these just need to have the `prefix` set in configuration:

```
./configure --prefix=/tools
make --jobs
make install
```

- diffutils
- file
- findutils
- gawk

## Gettext

Only need to install some files, so need to `make -C` into dirs and finally copy the files out.

see `scripts/5/gettext/configure-build-install.sh`

## The Easy Stuff - Part 2

- grep
- gzip

## More

- make
	- fix issue from `glibc-2.27`
- patch
    - easy
- perl
    - custom configure
        - `sh Configure -des -Dprefix=/tools -Dlibs=-lm`
    - only some files need to be installed
        - `cp -v perl cpan/podlators/pod2man /tools/bin`
        - `mkdir -pv /tools/lib/perl5/5.22.1`
        - `cp -Rv lib/* /tools/lib/perl5/5.22.1`
- sed
    - easy
- tar
    - easy
- texinfo
    - easy
    - there is an error in configure, but it can be ignored
- util-linux
- xz
    - easy

# Finalizing the temp system

run as root user (at least for the change command, but also for all following that)

`export LFS=/mnt/lfs`

## Cleanup the toolchain

Strip debug symbols, remove documentation and chage ownership.

see `scripts/5/finalize/cleanup.sh`

## Backup the toolchain

see `scripts/5/finalize/backup.sh`
