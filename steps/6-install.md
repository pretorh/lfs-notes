# Installing the system

Remember to have `LFS` set: `export LFS=/mnt/lfs`

## Chroot

See:

- setup virtual kernel file systems: `scripts/6/setup/prepare.sh`
- enter chroot: `scripts/6/setup/enter-chroot.sh`
- setup the filesystem: `scripts/6/setup/filesystem.sh`
	- note that the leading `/` is not added to paths (to easier create a package), so need to run from `/`
- setup the chroot environment: `scripts/6/setup/chroot-setup.sh`

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

`make check` (this took about 3 times longer than `make --jobs 4`)

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
    - tests: 134 pass, 7 skpped (of 141 total)

### Bash

Tests need to be run as user `nobody`, see `scripts/6/4/bash-test.sh`

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary), but had a few errors/warnings output

Installing replaces the existing `/bin/bash` symlink

After installing, start a new bash: `exec /bin/bash --login +h`

### Part 5

- libtool
    - The tests take some time (1/4 of `GCC` build time)
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

Setup hosts file: `echo "127.0.0.1 localhost $(hostname)" > /etc/hosts`

see: `scripts/6/5/perl-config.sh` and `scripts/6/5/perl-post.sh`

Tests:
- about 1/3 of `GCC` build time
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
    - the tests takes very long compared to the build (about as long as `perl`s tests)
    - run tests with `make check TESTSUITEFLAGS=-j4`
    - "two tests fail due to changes in libtool-2.4.3 and later" (6 failed, 4 exptected)
        - `501: Libtool`
        - `503: autoscan`
- automake
    - the tests takes very long compared to the build (2x the time to build `GCC`)
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

Build: half the `GCC` build time

Run the tests after installing

`cat ./test-suite.log | grep "^FAIL:"`

5 tests failed:
- test-path-util
- test-calendarspec
- test-copy
- test-dnssec
- test/udev-test.pl

### Part 7

- procps-ng
- e2fsprogs
    - one of the tests require 256mb memory (enable swap if needed)
- coreutils
- diffutils
    - `cat gnulib-tests/test-suite.log | grep "^FAIL:"`
        - `test-update-copyright.sh` failure can be safely ignored
- gawk
- findutils
- groff
    - failed when building with --jobs 4, but passed with --jobs 1
    - no tests
- grub
    - no tests
    - actual boot setup covered after packages installed
- less
    - no tests
- gzip
- iproute2
    - no tests in `chroot`
- kbd
- libpipeline
- make
- patch
- dbus
    - no tests in lfs
- util-linux
    - the test `tests/ts/ipcs/limit` fails on recent kernels, can be ignored
- man-db
- tar
- texinfo
- vim

## Cleanup

- Re-enter chroot
    - `logout`
    - re-enter (see `scripts/6/setup/enter-chroot.sh`)
- Strip debug components. see `scripts/6/cleanup/strip.sh`
- Remove temp files (`rm -rf /tmp/*`)
- Remove static libs that were required in tests. see `scripts/6/cleanup/remove-static-libs.sh`
