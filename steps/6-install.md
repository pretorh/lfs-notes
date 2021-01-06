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

## Packages

Build and install from the `sources` directory

`cd /sources`

### Part 1

- linux api headers
- man-pages

### Glibc

Time: 12x build, 65x test (tests are not as parallel)

patch for file system standards: `patch -Np1 -i ../glibc-2.27-fhs-1.patch`

Configs:
```
ln -sfv /tools/lib/gcc /usr/lib

GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

rm -fv /usr/include/limits.h
```

#### Tests are critical

`make check`

but some will fail:

"You may see some test failures.", the doc only lists some of the most common issues

- known to fail:
	- `misc/tst-ttyname`
- also failed:
	- `misc/tst-preadvwritev2`
	- `misc/tst-preadvwritev64v2`

some that might fail, but passed:
- will fail on some:
    - `posix/tst-getaddrinfo4`
    - `posix/tst-getaddrinfo5`
- FAILed previously, but on a later lfs in XPASSed)
    - `elf/tst-protected1a`
    - `elf/tst-protected1b`

#### Install glibc
Install glibc (`make install`)

- setup nscd config runtime directory (see `scripts/6/glibc/nscd.sh`)
- setup locales (see `scripts/6/glibc/locale.sh`)

#### Configure glibc

##### nsswitch.conf

    cat > /etc/nsswitch.conf << "EOF"

    # Begin /etc/nsswitch.conf
    passwd: files
    group: files
    shadow: files
    hosts: files dns myhostname
    networks: files
    protocols: files
    services: files
    ethers: files
    rpc: files
    # End /etc/nsswitch.conf
    EOF

##### timezone

Install timezone data (see `scripts/6/glibc/tz-install.sh`) and configure it

Run:

    SELECTED_TZ=`tzselect`

And then:

    echo "selected $SELECTED_TZ"
    ln -sfv /usr/share/zoneinfo/$SELECTED_TZ /etc/localtime
    unset SELECTED_TZ

#### Dynamic Loader

    cat > /etc/ld.so.conf << "EOF"
    /usr/local/lib
    /opt/lib
    include /etc/ld.so.conf.d/*.conf
    EOF

    mkdir -pv /etc/ld.so.conf.d

### Adjusting the Toolchain

Adjust the toolchain: see `scripts/6/toolchain/adjust.sh`

Run sanity check: see `scripts/6/toolchain/sanity-check.sh`

### Part 2

- zlib
- file
- readline
- m4
- bc
    - patch, see: `scripts/6/2/bc-patch.sh`
    - 10 tests fail due to round of errors
        - with index of: `97`, `8651`, `.80`, `4.47`, `2.19`, `4.31`, `2.36`, `2.04`, `.65`, `1.07`
- binutils
    - First verify PTYs are working in chroot: `expect -c "spawn ls" | grep "spawn ls" && echo "SUCCESS" || echo "FAILED"`
    - The tests are critical
    - time: 3x build, 2x to 3x for tests (not as parallel)

### Part 2.1

these final few have similar configure, build and install commands

- gmp
    - The tests are critical. All 190 must pass
- mpfr
    - The tests are critical. All tests must pass
- mpc

### GCC

Takes *realy* long

on a single core qemu vm:

- Build: about 3 times as long as `glibc`'s build time
- Tests: about 6 times longer than the build

Times: 10x build, 110x for tests

#### Configure

Fix for 64 bit lib: `sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64`

remove previous symlink: `rm -fv /usr/lib/gcc`

#### Tests
The tests are critical.

Increase stack size before running tests: `ulimit -s 32768`

To run the tests and check the results:

    make -k check --jobs 4
    ../contrib/test_summary | grep -A7 Summ
    ../contrib/test_summary | grep FAIL

Some tests may fail. Compare the results with:

- http://www.linuxfromscratch.org/lfs/build-logs/systemd/
- http://gcc.gnu.org/ml/gcc-testresults
- my list of failed tests: `steps/6-more.md`
- also, "six tests in the libstdc++ test suite are known to fail" (only these failed in `7.3.0`)

#### Install and sanity checks

- install using the normal `make install`
- see `scripts/6/gcc/install.sh` (moved the final `.py` file move to share into this script)
- this overwrites symlinks originally created when entering chroot (`chroot-setup`):
    - `/usr/lib/libstdc++.a`
    - `/usr/lib/libstdc++.so`
    - `/usr/lib/libstdc++.so.6`
    - `/usr/lib/libgcc_s.so`
    - `/usr/lib/libgcc_s.so.1`

run another sanity check: see `scripts/6/gcc/sanity-check-4.sh`

### Part 3

- bzip2
    - see `scripts/6/3/bzip2-patch.sh` and `scripts/6/3/bzip2-install.sh`
- pkg-config
    - all 30 tests passed
- ncurses
    - see `scripts/6/3/ncurses-post.sh`
    - `bc` previously created `/usr/lib/libncurses.so`, which is overwritten here
- attr
    - see `scripts/6/3/attr-patch.sh`
    - tests must be run with `-j1`, all 29 passed
    - see `scripts/6/3/attr-post.sh`
- acl
    - see `scripts/6/3/acl-patch.sh`
    - tests require coreutils, so cannot be run now (maybe run later with `make -j1 tests`)
    - move a shared lib: `scripts/6/mv-shared.sh /usr/lib/libacl.so`
- libcap
    - no tests
    - move a shared lib: `scripts/6/mv-shared.sh /usr/lib/libcap.so`
- sed
    - tests: 118 passed, 12 skipped (of 130)

### Shadow

#### build:

see `scripts/6/3/shadow-patch.sh`

There are no tests

#### configuring

Enable using:

```
pwconv
grpconv
```

optionally start groups at 100: `sed -i /etc/default/useradd -e 's/\(GROUP\)=.*/\1=100/'`

optinally disable mail spool: `sed -i /etc/default/useradd -e 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/'`

set the password for root: `passwd root`

### Part 4

- psmisc
    - no tests
- iana-etc
    - no tests
- bison
    - tests depend on flex, so cannot be run now
- flex
    - fix issue introduces in glibc: `sed -i "/math.h/a #include <malloc.h>" src/flexdef.h`
    - all 114 tests passed
- grep
    - tests: 134 pass, 7 skipped (of 141 total)

### Bash

Tests need to be run as user `nobody`, see `scripts/6/4/bash-test.sh`

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary), but had a few errors/warnings output

Installing replaces the existing `/bin/bash` symlink

After installing, start a new bash: `exec /bin/bash --login +h`

### Part 5

- libtool
    - time: the build is fast, but the tests take some time (2x to 3x)
        - Especially the `Libtool stress test` section
    - Five tests are known to fail (64 failed, 59 expected)
        - 123: compiling softlinked libltdl
        - 124: compiling copied libltdl
        - 125: installable libltdl
        - 126: linking libltdl without autotools
        - 130: linking libltdl without autotools
- gdbm
    - tests: "All 25 tests were successful."
- gperf
    - known to fail if running simultaneous(run with `-j1`)
- expat
    - fix tests before configuring: `sed -i 's|usr/bin/env |bin/|' run.sh.in`
    - tests: all 2 passed
- inetutils
    - tests: `libls.sh` fails, the other 9 tests pass

### Perl

Time: 1x build, 15x test

Setup hosts file: `echo "127.0.0.1 localhost $(hostname)" > /etc/hosts`

see: `scripts/6/5/perl-config.sh` and `scripts/6/5/perl-post.sh`

Tests:
- Run tests with `make -k --jobs 4`
- "some tests related to zlib will fail". had 9 failing tests:
    - ../cpan/Compress-Raw-Zlib/t/01version.t
    - ../cpan/Compress-Raw-Zlib/t/02zlib.t
    - ../cpan/Compress-Raw-Zlib/t/18lvalue.t
    - ../cpan/Compress-Raw-Zlib/t/19nonpv.t
    - ../cpan/IO-Compress/t/cz-01version.t
    - ../cpan/IO-Compress/t/cz-03zlib-v1.t
    - ../cpan/IO-Compress/t/cz-06gzsetp.t
    - ../cpan/IO-Compress/t/cz-08encoding.t
    - ../cpan/IO-Compress/t/cz-14gzopen.t
- this replaces `/usr/bin/perl` which was created as a symlink

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
- xz
    - all tests 9 passed
    - install with `make install` and then
        - move a file: `mv -v $DESTDIR/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} $DESTDIR/bin`
        - move and recreate shared object `scripts/6/mv-shared.sh /usr/lib/liblzma.so`
    - this overwrites a symlink: `/usr/lib/liblzma.so`
- kmod
    - no tests in `chroot`
    - see `scripts/6/6/kmod-post.sh`
- Gettext
    - Configure: `sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in && sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in`
    - tests: no issues (393 passed, 19 skipped)
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
