# Installing the system

This should be run as the root user. Remember to have `LFS` set: `export LFS=/mnt/lfs`

## Chroot

See:

- setup virtual kernel file systems: `scripts/6/setup/prepare.sh`
- enter chroot: `scripts/6/setup/enter-chroot.sh`
- change ownership and setup the filesystem: `scripts/6/setup/filesystem.sh`
- setup the chroot environment (essential files and symlinks): `scripts/6/setup/chroot-setup.sh`

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
    - custom configure commands
    - time: 1.5x (0.4x for parallel)
- python
    - note the uppercase package name
    - time: 1.2x (0.3x for parallel)
- texinfo
    - basic configure (`prefix`) only
    - there is an error in configure (re `TestXS_la-TestXS.lo`), but it can be ignored
        - though did not get this
    - time: negligible
- util-linux
    - recheck: had to recreate `libncursesw.so`, might have missed on it's post install? (or miscopied from pdf without .so extention?)
    - time: 0.7x (0.2x for parallel)

## cleanup and backup

Note that the cleanup commands have been merged to remove the required and optional files in a single script. Both are run from outside of the chroot environment

First exit chroot (`exit`). Ensure LFS is still set and unmount devices. See `scripts/6/cleanup/umount-chroot.sh`

Remove static libs, documentation and strip debug symbols. See `scripts/6/cleanup/remove-files-strip.sh`

Backup the temp system, see `scripts/6/cleanup/backup.sh`. Note that this saves 2 archives (root and sources split) to `/tmp`

## deprecated/old notes from pre 10.0 book

### Part 1

- linux api headers

### Adjusting the Toolchain

Adjust the toolchain: see `scripts/6/toolchain/adjust.sh`

Run sanity check: see `scripts/6/toolchain/sanity-check.sh`

### Part 6

- XML-Parser
    - tests: all 141 passed
- intltool
    - see `scripts/6/6intltool-patch.sh`
    - 1 test that passes
- autoconf
    - the tests takes very long compared to the build
        - about as long as `perl`s tests - though this was on single core
        - time: 3x
    - run tests with `make check TESTSUITEFLAGS=-j4`
    - "two tests fail due to changes in libtool-2.4.3 and later" (6 failed, 4 exptected)
        - `501: Libtool`
        - `503: autoscan`
- automake
    - the tests takes very long compared to the build (21x times)
    - run tests with -j4 option to speed it up (even on single core systems)
    - see `scripts/6/6/automake-test.sh`
    - 2 tests are known to fail in LFS: `check12.sh`, `check12-w.sh`
        - had 5 failures:
            - t/check12
            - t/dejagnu3
            - t/dejagnu4
            - t/dejagnu5
            - t/check12-w
- kmod
    - no tests in `chroot`
    - see `scripts/6/6/kmod-post.sh`
- libelf
    - in archive: `elfutils-0.170`
    - one test failed: `run-strip-nothing.sh`
    - install only libelf:
        - `make DESTDIR=$DESTDIR -C libelf install`
        - `install -vm644 config/libelf.pc $DESTDIR/usr/lib/pkgconfig`
- libffi
    - fix makefiles for include file destinations
    - some tests failed (pthread issue again?)
- openssl
    - configure script is named `config`
    - tests: `40-test_rehash.t` failed (expected in chroot)
- python
    - archive name start with capital
    - no tests here
- ninja
    - see note on optional patch (to decrease/set parallel process count)
    - configured and build with python3 scripts
    - tests passed (18/18 and 235/235)
- meson
    - configure and build with python3 scripts
    - install with a setup.py, use `python3 setup.py install --root $DESTDIR/` to set DESTDIR

### Systemd

patch: `scripts/6/6/systemd-patch.sh`

post setup: `scripts/6/6/systemd-post.sh`

after installed, create machine id (`/etc/machine-id`): `systemd-machine-id-setup`

### Part 7

- procps-ng
    - see `scripts/6/7/procps-ng-test.sh`
    - tests failed with `make check`, but passed with `make check -k`
    - move shared lib: `mv-shared.sh /usr/lib/libprocps.so`
- e2fsprogs
    - see `scripts/6/7/e2fsprogs-test.sh`
    - one of the tests require 256mb memory (enable swap if needed)
    - see `scripts/6/7/e2fsprogs-post.sh`
    - tests: "342 tests succeeded, 0 tests failed"
    - build issue: this failed, because `/tools`'s gcc lib was 0 bytes. removed it for the main one to be used
    - time: 8x for tests
- coreutils
    - patch for character boundary
    - suppress test: `sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk`
    - see `scripts/6/7/coreutils-test.sh`
    - tests:
        - 1st: 31 total (18 passed, 13 skip)
        - 2nd: `test-getlogin` is known to fail
            - but it passed, only `tests/misc/tty.sh` failed
    - more files, see `scripts/6/7/coreutils-post.sh`
    - the install overwrite files that symlink to `/tools` files:
        - `/usr/bin/install`
        - `/usr/bin/env`
        - `/bin/cat`
        - `/bin/stty`
        - `/bin/dd`
        - `/bin/echo`
        - `/bin/pwd`
        - `/bin/ln`
        - `/bin/rm`
- check
    - tests take relatively long (TODO: calc relative times)
    - all 9 tests passed
- diffutils
    - tests ok (157 pass, 13 skip of 170 total)
- gawk
    - patch: `sed -i 's/extras//' Makefile.in`
    - optionally install docs, see `scripts/6/7/gawk-install-docs.sh`
    - all tests passed
- findutils
    - suppress test: `sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in`
    - some tests failed (phtread issue?)
    - install: see `scripts/6/7/findutils-post.sh`

### part 8

- groff
    - must be built with `-j1`
    - no tests
- grub
    - no tests
    - actual boot setup covered after packages installed
- less
    - no tests
- gzip
    - all tests passed (though 2 might fail: `help-version`, `zmore`)
    - move file after install: `mv -v $DESTDIR/usr/bin/gzip $DESTDIR/bin`
- iproute2
    - see `scripts/6/8/iproute2-patch.sh`
    - no tests in `chroot`
- kbd
    - patch, see `scripts/6/8/kbd-patch.sh`
    - all tests passed
    - optionally install docs
- libpipeline
    - tests: add 7 passed
- make
    - patch: `sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c`
    - test with `make PERL5LIB=$PWD/tests/ check --jobs 4`
    - all tests passed
- patch
    - tests passed

### part 9

- dbus
    - no tests in lfs
    - move a shared lib: `mv-shared.sh /usr/lib/libdbus-1.so`
    - post unpackage: see `scripts/6/9/dbus-post.sh`
    - potential extract issue with `/var/run/dbus: Cannot mkdir: Too many levels of symbolic links`
- util-linux
    - setup:
        - add to filesystem (move into filesystem.sh?): `mkdir -pv /var/lib/hwclock`
        - remove previous symlinks: `rm -vf /usr/include/{blkid,libmount,uuid}`
    - the tests may be harmful when run as root user
    - some failed to install, due to existing files (more of blkid,libmount,uuid, but libs and pc)
- man-db
    - all tests pass
    - no need to change man-db.conf anymore, file is already correct
- tar
    - tests: one test is known to fail, `92. link mismatch`
- texinfo
    - all tests passed
    - time: 5x
- vim
    - archive file (vim-8.0...tar.bz2) and dir (`vim80`) mismatch
        - same with vim 7.4 (`vim74`) version
    - patch default vimrc, ignore failing tests, see: `scripts/6/9/vim-patch.sh`
    - tests
        - redirect test output to file, see `scripts/6/9/vim-test.sh`
        - failed to load  libtcl (`ln -sv /tools/lib/libtcl8.6.so /usr/lib/libtcl8.6.so`)
    - post install (pre pack): see `scripts/6/9/vim-test.sh`

## Cleanup

- Re-enter chroot
    - `logout`
    - re-enter (see `scripts/6/setup/enter-chroot.sh`)
- Strip debug components. see `scripts/6/cleanup/strip.sh`
- Remove temp files (`rm -rf /tmp/*`)
- Remove static libs that were required in tests. see `scripts/6/cleanup/remove-static-libs.sh`
