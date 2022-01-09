# Installing the system

This should be run as the root user. Remember to have `LFS` set: `export LFS=/mnt/lfs`

Start bash with LFS set from the current environment: `sudo --preserve-env=LFS bash`

## Chroot

See:

- setup virtual kernel file systems: `scripts/6/setup/prepare.sh`
- enter chroot: `scripts/6/setup/enter-chroot.sh`
- setup the filesystem: `scripts/6/setup/filesystem.sh`
- setup the chroot environment (essential files and symlinks): `scripts/6/setup/chroot-setup.sh`

todo: had issue entering chroot (`/bin/bash` not found), which was fixed by removing the (empty) lib64 dir, and creating it as a symlink to `/usr/lib` (`ln -sv usr/lib "$LFS/lib64"`)

### Re-entering chroot

If you exit chroot, you will need to re-enter it before continuing

- mount the drive (`scripts/2/mount.sh`)
- export the `LFS` env var (`export LFS=/mnt/lfs`)
- ensure the tools directory exists (`scripts/4/setup-tools.sh`)
- setup virtual file systems and enter chroot (`scripts/6/setup/prepare.sh` and `scripts/6/setup/enter-chroot.sh`)
- run bash after it is installed (`exec /bin/bash --login +h`)
- change to sources directory (`cd /sources`)
- continue where you left

## Build more temporary tools

Build and install from the `sources` directory

- libstdc++ pass 2
    - part of gcc sources
    - patch by symlinking `gthr-posix.h`
    - run configure from `libstdc++-v3`
    - time: 0.7x (0.2x for parallel)
- gettext
    - install: only need to install 3 programs:
        - `cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin`
    - to check: previously build these only, which may be a bit faster
    - time: 1.4x (0.8x for parallel)
- bison
    - time: negligible
- perl
    - custom configure command, see `scripts/6/perl-configure.sh`
    - time: 1.5x (0.4x for parallel)
- python
    - note the uppercase archive name
    - time: 1.2x (0.3x for parallel)
- texinfo
    - fix building with glibc 2.34+, see `scripts/6/texinfo-patch.sh`
    - basic configure (`prefix`) only
    - time: negligible
- util-linux
    - time: 0.7x (0.2x for parallel)

## cleanup and backup

Note: the cleanup commands have been rearranged to run them from outside the chroot environment

First exit chroot (`exit`). Unmount the virtual filesystem. See `scripts/6/cleanup/umount-chroot.sh`

Remove static libs, documentation and the `/tools` directory. See `scripts/6/cleanup/remove-files.sh`

Optionally backup the temp system, see `scripts/5/finalize/backup.sh`

## deprecated/old notes from pre 10.0 book

### Part 1

- linux api headers

### Adjusting the Toolchain

Adjust the toolchain: see `scripts/6/toolchain/adjust.sh`

Run sanity check: see `scripts/6/toolchain/sanity-check.sh`
