# Installing the system

This should be run as the root user. Remember to have `LFS` set: `export LFS=/mnt/lfs`

Start bash with LFS set from the current environment: `./scripts/sudo.sh`

## Chroot

See:

- setup virtual kernel file systems: `scripts/chroot/prepare.sh`
- enter chroot: `scripts/chroot/enter-chroot.sh`
- setup the filesystem: `scripts/chroot/filesystem.sh`
- setup the chroot environment (essential files and symlinks): `scripts/chroot/essential-files-setup.sh`

### Re-entering chroot

If you exit chroot, you will need to re-enter it before continuing

- mount the drives
- export the `LFS` env var (`export LFS=/mnt/lfs`)
- run as root (`scripts/sudo.sh`)
- setup virtual file systems and enter chroot (`scripts/chroot/prepare.sh` and `scripts/chroot/enter-chroot.sh`)
- run bash after it is installed (`exec /bin/bash --login`)
- change to sources directory (`cd /sources`)
- continue where you left

## Build more temporary tools

Build and install from the `sources` directory

- gettext
    - install: only need to install 3 programs:
        - `cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin`
    - to check: previously build these only, which may be a bit faster
    - time: 1.2x real (user+sys: 1.7x)
- bison
    - time: negligible
- perl
    - custom configure command, see `scripts/6/perl-configure.sh`
    - time: 0.7x real (user+sys: 1.8x)
- python
    - note the uppercase archive name
    - time: 0.5x real (user+sys: 1.7x)
- texinfo
    - basic configure (`prefix`) only
    - time: negligible
- util-linux
    - time: negligible

## cleanup and backup

Note: the cleanup and backup commands are rearranged here to run them from outside the chroot environment (different from book)

First exit chroot (`exit`). Unmount the virtual filesystem. See `scripts/chroot/umount-chroot.sh`

Remove static libs, documentation and the `/tools` directory. See `scripts/chroot/remove-files.sh` (saved 1183M)

### backup

Optionally backup the temp system, see `scripts/backup.sh`

Time: 2.6x real and user+sys
