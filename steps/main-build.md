# Building the LFS system

These notes are from Chapter 8 of the 10.0 version

## setup

These steps need to be done in chroot - reenter after cleanup/backup or a restore from a backup. See notes in chroot setup (`steps/6-install.md`)

See notes about package management

## packages

### Part 1

- man-pages
    - no configure or build (just `make install`)
    - time: negligible
- iana-etc
    - only need to copy the 2 files out (`cp -v services protocols /etc`)
    - time: negligible

### Glibc

Patches:
- file system standards: see, `scripts/5/glibc/patch.sh`. This patch is applied on all glib versions - consider ignoring this and using the non-compliant path
- using sed command: see `scripts/6/glibc/patch.sh`
- pre configure setup to install into `sbin`

Time (including tests): 7.6x real (user+sys: 18.9x)

#### tests

Create symlink for tests to work (`ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib`)

Tests are *critical*, but some will fail:

"You may see some test failures." the doc only lists some of the most common issues

- known to fail:
    - `io/tst-lchmod`
	  - `misc/tst-ttyname`

summary:

2.34:
```
Summary of test results:
      2 FAIL
   4399 PASS
     69 UNSUPPORTED
     16 XFAIL
      2 XPASS
```

2.32:
```
Summary of test results:
      2 FAIL
   4228 PASS
     34 UNSUPPORTED
     17 XFAIL
      2 XPASS
```

#### Install glibc

Prevent warnings and sanity checks, install glibc, fix ldd paths, install nscd configs and systemd files. See `scripts/6/glibc/install.sh`

#### Install timezone data

see `scripts/6/glibc/tz-install.sh` (note this should run in the `sources` dir) and configure it

#### Configure glibc

Install locales needed for future tests, see `scripts/6/glibc/locale.sh`

Find your locale in list of supported (`tar -xOf ./glibc-*.tar.xz --wildcards -- 'glibc-*/localedata/SUPPORTED'`) and install it

Run `scripts/6/glibc/tz-set-localtime.sh` to set `/etc/localtime`

See `scripts/6/glibc/dynamic-loader-setup.sh` to setup `/etc/ld.so.conf`

### Part 2

- zlib
    - basic config (`prefix`) and simple build/test/install
    - time: negligible
- bzip2
    - patch for docs, relative symlinks and man pages. build the dynamic library first: `scripts/6/3/bzip2-patch.sh`
    - no configure (but install with `PREFIX` - part of `bzip2-install.sh`)
    - install: `scripts/6/3/bzip2-install.sh`
    - time: negligible
- xz
    - tests: `All 9 tests passed`
    - time: negligible
- zstd
    - no configure (but `prefix=/usr` in install)
    - post: remove a static lib `rm -v /usr/lib/libzstd.a`
    - time: 0.4x real (user+sys: 1.3x)
- file
    - basic config (`prefix`) and simple build/test/install
    - time: negligible
- readline
    - reinstalling can cause issues with old files (but not reinstalling here, and should use fakeroots eventually)
    - no tests
    - time: negligible
- m4
    - then basic config (`prefix`) and simple build/test/install
    - tests: 170 total, 157 pass, 13 skipped
    - time: 0.4x real (user+sys: 0.5x)
- bc
    - all tests (`bc` and `dc`, `history`) pass
    - time: negligible
- flex
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install
    - post install: create `lex` symlink: `ln -sv flex /usr/bin/lex`
    - tests: all 114 passed
    - time: negligible
- tcl
    - custom archive name. also extract the documentation archive
    - custom build commands, see `scripts/6/main/tcl-post-build.sh`
    - install steps for headers, symlink (see `scripts/6/main/tcl-install.sh`, which also installs)
    - tests
        - `grep '^all.tcl:' out.log` to get summary
        - no failures (but a lot of skipped)
    - time: 1.7x real (user+sys: 1.1x)
- expect
    - post: symlink lib into `/usr/lib`
    - tests:
        - `grep '^all.tcl:' out.log` to get summary
        - all 29 passed
    - time: negligible
- DejaGNU
    - skipped building/installing docs
    - tests:
      - ran before install (book has install then test?)
      - `grep '^#' out.log` (but should get everything between "... Summary ===" and the next "===" line)
    - time: negligible

### binutils

First verify PTYs are working in chroot:
`(expect -c "spawn ls" | grep "spawn ls" && echo "SUCCESS") || echo "FAILED"`

Patch: upstream fix (patch file) and fix man pages

The tests are critical. 4 zlib tests failed (known to fail)

time: 2.3x real (user+sys: 7.0x)

### gmp, mpfr, mpc

- gmp
    - see notes on the architecture, and make sure that matches the CPU
    - The tests are critical. All 197 must pass
        - run `awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log` to get passed count
    - time: 0.4x real (user+sys: 1.1x)
- mpfr
    - simple build/test/install (skipped docs)
    - The tests are critical. All tests must pass (had 181 pass, 2 skipped)
    - time: 0.2x real (user+sys: 0.8x)
- mpc
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install (skipped docs)
    - tests: all 69 passed
    - time: negligible

### Part 3

- attr
    - tests: 2/2 passed
    - time: negligible
- acl
    - tests require coreutils, so cannot be run now
    - time: negligible
- libcap
    - no configure (but prefix= in make)
    - time: negligible

### Shadow

`touch /usr/bin/passwd`: file must exist before configure is run

Patch to disable groups, man pages, use sha-512, patch c file. See `scripts/6/3/shadow-patch.sh`

There are no tests

Install using `scripts/6/3/shadow-install.sh`

Time: negligible

#### post install configuring

See `scripts/6/3/shadow-post-install-config.sh`

### GCC

Takes *realy* long: 51.4x real (user+sys: 196.0x) for building and tests (47.0x/181.5x for the `time ... make ... check` line)

Patch, see `scripts/6/gcc/patch.sh`

#### Tests

The tests are critical.

Increase stack size, run tests as the `tester` user and print a summary of the test results, see `scripts/6/gcc/test.sh`

Some tests are known to fail. Compare with list in doc.
Compare the overall results with the [build logs](http://www.linuxfromscratch.org/lfs/build-logs/) and [gcc test results](https://gcc.gnu.org/ml/gcc-testresults). See `steps/6-more.md` for my list of failed tests

See `scripts/6/gcc/compare-test-results.sh` to get list of unexpected failures

#### Install and sanity checks

Install, cleanup and create symlinks: see `scripts/6/gcc/install.sh` (moved the final `*gdb.py` file move into this script)

Run another sanity check: see `scripts/6/gcc/sanity-check-4.sh`

### Part 4

- pkg-config
    - all 30 tests passed
    - time: negligible
- ncurses
    - tests can only be run after ncurses is installed
    - confirm for 10.0:
        - `bc` previously created `/usr/lib/libncurses.so`, which is overwritten here
    - post install: see `scripts/6/3/ncurses-post.sh`
    - time: negligible
- sed
    - basic config (`prefix`) and simple build/install
    - tests
        - run with `tester` user (same as gcc)
        - 157 passed, 21 skipped (of 178)
    - time: negligible
- psmisc
    - basic config (`prefix`) and simple build/install
    - no tests
    - time: negligible
- Gettext
    - basic config (`prefix`, `disable-static`, `docdir`) and simple build/test/install
    - tests: 727 total, 690 passed, 37 skipped
    - time: 1.6x real (user+sys: 2.9x)
- bison
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - tests: 11/11 passed, and "620 tests were successful. 43 tests were skipped."
    - time: 1.7x real (user+sys: 6.3x)
- grep
    - basic config (`prefix`) and simple build/test/install
    - tests: 318 total, 287 pass, 29 skipped, 2 xfail
    - time: 0.3x real (user+sys: 0.7x)

### Bash

Tests need to be run as user `tester`, using expect: see `scripts/6/main/bash-tests.sh`

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary)

After installing, start a new bash: `exec /bin/bash --login +h`

Time: 0.7x real (user+sys: 0.5x - less than real)

### Part 5

- libtool
    - basic config (`prefix`) and simple build/test/install
    - Five tests are known to fail (64 failed, 59 expected). see `grep FAIL tests/testsuite.log`
        - 123: compiling softlinked libltdl
        - 124: compiling copied libltdl
        - 125: installable libltdl
        - 126: linking libltdl without autotools
        - 130: linking libltdl without autotools
    - time: 0.8x real (user+sys: 1.7x)
- gdbm
    - tests, one test fail with `ERROR`, and summary shows "All 30 tests were successful." (but exits with failure)
    - time: negligible
- gperf
    - basic config (`prefix` and `docdir`) and simple build/install
    - tests:
        - run with `-j1`
    - time: negligible
- expat
    - basic config (`prefix`, `disable-static` and `docdir`) and simple build/test/install
    - tests: all 2 passed
    - time: negligible
- inetutils
    - config: disable obsolete programs/programs provided by other packages
    - tests: all 10 passed
    - post install: move `ifconfig` into `/usr/sbin`
    - time: 0.3x real (user+sys: 0.3x)
- less
    - basic config (`prefix`, `sysconfdir`) and simple build/install
    - no tests
    - time: negligible

### Perl

Patch using `.patch` file. Configure: `scripts/6/5/perl-config.sh`

Tests: "All tests successful."

Time: 6.1x real (user+sys: 6.1x)

### Part 6

- XML-Parser
    - prepare with `perl Makefile.PL`. then basic build/test/install
    - tests: all 140 passed
    - time: negligible
- intltool
    - patch: `scripts/6/6/intltool-patch.sh`
    - then basic config (`prefix`) and build/test/install
    - 1 test that passes
    - time: negligible
- autoconf
    - basic config (`prefix`) and build/test/install
    - tests: "543 tests behaved as expected, 56 tests were skipped"
    - time: 1.9x real (user+sys: 7.6x)
- automake
    - tests:
        - run tests with `-j4` option to speed it up (even on single core systems)
        - results: 2926 total, 2725 pass (163 skip, 38 xfail)
    - time: negligible + 17.7x (6.3x for parallel) for tests
    - time: 5.5x real (user+sys: 15.7x)
- kmod
    - no tests in `chroot`
    - post-install: `scripts/6/6/kmod-post.sh`
    - time: negligible
- libelf
    - in archive: `elfutils-*`
    - tests: 226 total, 220 pass, 5 skipped
        - `run-backtrace-native.sh` failed
    - install only libelf, see `scripts/6/6/libelf-install.sh`
    - time: 0.3x real (user+sys: 0.8x)
- libffi
    - tests: 2304 passed
    - time: 1.6x real (user+sys: 1.7x)
- openssl
    - configure script is named `config`
    - tests:
        - `30-test_afalg.t` is known to sometime fail (but it passed)
        - All tests successful. ("Files=158, Tests=2638")
    - pre-install: skip static libs
    - time: 1.5x real (user+sys: 2.4x)
- python
    - archive name start with capital
    - tests: skipped, "known to hang indefinitely" (needs networking)
    - time: 2.0x real (user+sys: 4.6x)
- ninja
    - see note on optional patch (to decrease/set parallel process count)
    - configured and build with python3 scripts
    - tests passed (343/343)
    - time: 0.2x real (user+sys: 0.7x)
- meson
    - configure and build with python3 scripts
    - no tests
    - install with a setup.py, use `python3 setup.py install --root $DESTDIR/` to set DESTDIR
    - time: negligible
- coreutils
    - patch: for character boundary, then `autoreconf -fiv`
    - tests:
        - see `scripts/6/7/coreutils-test.sh`
        - 1006 total, 844 pass, 162 skip
    - post install: move files, see `scripts/6/7/coreutils-post.sh`
    - time: 0.9x real (user+sys: 2.1x)
- check
    - basic config (`prefix`, `disable-static`) and simple build/test/install
    - tests:
        - take relatively long
        - seems to hang after `test_tap_output.sh`
        - all 10 tests passed
    - time: negligible + 0.9x for tests
    - time: 0.8x real (user+sys: 0.1x, less than real)
- diffutils
    - basic config (`prefix`) and simple build/test/install
    - tests: 225 total, 207 passed/17 skipped/1 xfail
    - time: negligible
- gawk
    - patch: `sed -i 's/extras//' Makefile.in`
    - basic config (`prefix`) and simple build/test/install
    - all tests passed (no summary)
    - time: negligible
- findutils
    - tests:
        - run as `tester`
        - 271 total, 254 pass, 17 skipped
    - time: 0.5x real (user+sys: 0.8x)
- groff
    - must be built with `-j1`
    - no tests
    - time: 0.5x real (user+sys: 0.5x)
- grub
    - skip when using uefi (todo: install as part of blfs)
    - actual boot setup covered after packages installed
- gzip
    - basic config (`prefix`) and simple build/test/install
    - all 22 tests passed
    - time: negligible
- iproute2
    - see `scripts/6/8/iproute2-patch.sh`
    - no configure, tests
    - time: negligible
- kbd
    - patch, see `scripts/6/8/kbd-patch.sh`
    - 40 tests, 36 passed, 4 skipped
    - post install: remove internal `libtswrap`
    - time: negligible
- libpipeline
    - basic config (`prefix`) and simple build/test/install
    - tests: all 7 passed
    - time: negligible
- make
    - basic config (`prefix`) and simple build/test/install
    - all tests passed ("690 Tests in 125 Categories Complete ... No Failures :-)")
    - time: negligible + 0.2x for tests
- patch
    - tests passed (44 total, 41 pass, 1 skip, 2 xfail)
    - time: negligible
- man-db
    - patch: path to `find`
    - all 50 tests passed
    - time: negligible
- tar
    - tests
        - one test is known to fail, `223: capabilities: binary store/restore`
        - others passed (215 passed, 19 skipped, 1 failed)
    - time: negligible + 1.3x for tests
- texinfo
    - basic config (`prefix`, `disable-static`) and simple build/test/install
    - tests: 243 total, 228 passed, 15 skipped
    - time: negligible + 0.5x (0.1x for parallel) for tests
- vim
    - patch default vimrc: `echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h`
    - tests: run as `tester`, redirect test output to file, see `scripts/6/9/vim-test.sh`
    - post install and config: see `scripts/6/9/vim-post.sh`
    - time: 1.0x (0.2x for parallel) + 1.5x for tests

### Systemd

patch and configure: `scripts/6/6/systemd-patch.sh`

tests not mentioned in book (expect for disabling 1) and running `LANG=en_US.UTF-8 ninja test` has errors

post-install setup: `scripts/6/6/systemd-post.sh`

time: 3.3x (0.4x for parallel)

### Part 7

- dbus
    - no tests in lfs
    - move a shared lib: `mv-shared.sh /usr/lib/libdbus-1.so`
    - post install: see `scripts/6/9/dbus-post.sh`
    - potential extract issue with `/var/run/dbus: Cannot mkdir: Too many levels of symbolic links`
    - time: negligible
- procps-ng
    - tests passed
    - move shared lib: `mv-shared.sh /usr/lib/libprocps.so`
    - time: negligible
- util-linux
    - setup: add to filesystem (move into filesystem.sh?): `mkdir -pv /var/lib/hwclock` - is this needed here, or at install time only?
    - tests:
        - may be harmful when run as root user, `chown -R tester .` and  `su tester -c "make -k check | tee check-log"`
        - "All 207 tests PASSED"
    - time: 0.8x (0.2x for parallel) + 0.5x for tests
- e2fsprogs
    - tests:
        - previous docs: one of the tests require 256mb memory (enable swap if needed)
        - "357 tests succeeded  0 tests failed"
    - post-install:
        - extract an info doc `gunzip -v "$DESTDIR/usr/share/info/libext2fs.info.gz"`
        - update info dir
    - time: 0.4x (0.1x for parallel) + 0.4x for tests

## Cleanup

### Strip debug symbols

First extract symbols for some libraries. See `./scripts/split-out-debug-symbols.sh`

```
sh ./scripts/split-out-debug-symbols.sh \
    /lib/ld-2.32.so /lib/libc-2.32.so /lib/libpthread-2.32.so /lib/libthread_db-1.0.so \
    /usr/lib/libquadmath.so.0.0.0 /usr/lib/libstdc++.so.6.0.28 /usr/lib/libitm.so.1.0.0 /usr/lib/libatomic.so.1.2.0
```

Then strip from binaries and libraries. See `bash ./scripts/strip-debug-symbols.sh`

Saved about 2.1GB with this

### cleanup

`rm -rf /tmp/*`

Remove static libs that were required in tests (binutils, bzip2, e2fsprogs, flex, libtool, and zlib). See `scripts/6/cleanup/remove-static-libs.sh`

Remove libtool archives: `find /usr/lib /usr/libexec -name \*.la -delete`

Remove previous partially installed compiler and the `/tools` dir

```
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rvf
rm -rf /tools
```

Saved about 1GB with this

finally, `logout`

To re-enter you need a new command - but it differs in only a now extra `+h` param to bash - so can still use `scripts/6/setup/enter-chroot.sh`
