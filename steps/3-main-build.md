# Building the LFS system

These notes are from Chapter 8 of the 10.0 to 11.2 version

## setup

These steps need to be done in chroot - reenter after cleanup/backup or a restore from a backup. See notes in chroot setup (`steps/2-chroot-temp-system2.md`)

See notes about package management

## packages

### Part 1

- man-pages
    - no configure or build (just `make prefix=/usr install`)
    - time: negligible
- iana-etc
    - only need to copy the 2 files out (`cp -v services protocols /etc`)
    - time: negligible

### Glibc

Patches:
- file system standards: see, `scripts/5/glibc/patch.sh`. This patch is applied on all glib versions - consider ignoring this and using the non-compliant path
- pre configure setup to install into `sbin`

Note: the configuring and installing is split up differently here than in the book

Time (including tests and install): 7.3x to 7.6x real (user+sys: 18.5x to 18.9x)

#### tests

Tests are *critical*, but some will fail:

"You may see some test failures." the doc only lists some of the most common issues

- known to fail: (and failed on `2.36` and `2.34`)
    - `io/tst-lchmod`
    - `misc/tst-ttyname`
- other test failures (on `2.36`)
    - `nptl/tst-cancel24`
    - `nptl/tst-minstack-throw`
    - `nptl/tst-once5`
    - `nptl/tst-thread-exit-clobber`

`grep '^FAIL' tests.sum` to get a list of failed

##### summary:

2.36:
```
Summary of test results:
      6 FAIL
   4921 PASS
    234 UNSUPPORTED
     16 XFAIL
      4 XPASS
```

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

Install locales needed for future tests, see `scripts/config/install-locales.sh` (about 0.2x real/usr+sys)

Find your locale in list of supported (`tar -xOf ./glibc-*.tar.xz --wildcards -- 'glibc-*/localedata/SUPPORTED'`) and install it

Run `scripts/config/tz-set-localtime.sh` to set `/etc/localtime`

See `scripts/config/dynamic-loader-setup.sh` to setup `/etc/ld.so.conf`

### Part 2

- zlib
    - basic config (`prefix`) and simple build/test/install
    - remove static libs: `rm -vf /usr/lib/libz.a`
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
    - time: 0.4x real (user+sys: 1.4x)
- file
    - basic config (`prefix`) and simple build/test/install
    - time: negligible
- readline
    - reinstalling can cause issues with old files (but not reinstalling here, and should use fakeroots eventually)
    - no tests
    - time: negligible
- m4
    - then basic config (`prefix`) and simple build/test/install
    - tests: 267 total, 245 pass, 22 skipped
    - time: 0.4x real (user+sys: 0.6x)
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
        - `grep '^all.tcl:' out.log` to get summary. shows 11 rows
        - no failures (but a lot of skipped)
    - time: 1.7x real (user+sys: 1.1x)
- expect
    - post: symlink lib into `/usr/lib`
    - tests:
        - `grep '^all.tcl:' out.log` to get summary
        - all 29 passed
    - outputs "via send_tty" even when redirecting `stdout` and `stderr`
    - time: negligible
- DejaGNU
    - skipped building/installing docs
    - tests:
      - ran before install (book has install then test?)
      - `grep '^#' out.log`
      - "# of expected passes": 54, 5, 245, 300
    - time: negligible

### binutils

First verify PTYs are working in chroot:
`(expect -c "spawn ls" | grep "spawn ls" && echo "SUCCESS") || echo "FAILED"`

The tests are critical.

Failed on `2.39`:

- `.sleb128 tests (2)`
- `.sleb128 tests (3)`
- `.sleb128 tests (4)`
- `.sleb128 tests (5)`
- `Run with libdl3a.so`
- `Run with libdl3c.so`
- `eh_test`
- `exception_test`
- `exception_shared_1_test`
- `exception_shared_2_test`
- `exception_same_shared_test`
- `exception_separate_shared_21_test`
- `exception_separate_shared_12_test`
- `relro_test`
- `relro_now_test`
- `relro_strip_test`
- `exception_x86_64_bnd_test`

Remove static libs after installing

time: 2.4x real (user+sys: 7.2x)

### gmp, mpfr, mpc

- gmp
    - see notes on the architecture, and make sure that matches the CPU
    - skipped building/installing html docs
    - The tests are critical. All 197 must pass
        - run `awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log` to get passed count
    - time: 0.4x real (user+sys: 1.1x)
- mpfr
    - simple build/test/install
    - skipped building/installing html docs
    - The tests are critical. All tests must pass (had 181 pass, 2 skipped)
    - time: 0.2x real (user+sys: 0.8x)
- mpc
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install
    - skipped building/installing html docs
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

Patch to disable groups, man pages, use sha-512. See `scripts/6/3/shadow-patch.sh`

There are no tests

Install using `scripts/6/3/shadow-install.sh`

Time: negligible

#### post install configuring

See `scripts/config/shadow.sh`

### GCC

Takes *realy* long: 51.0x to 51.4x real (user+sys: 194.6x to 196.0x) total

Patch, see `scripts/6/gcc/patch.sh`

#### Tests

Takes most of the time: 46.5x to 47.0x real (179.7x to 181.5x user+sys) for the `time ... make ... check` line

The tests are critical.

Increase stack size, run tests as the `tester` user and print a summary of the test results, see `scripts/6/gcc/test.sh`

Some tests are known to fail. Compare with list in doc.
Compare the overall results with the [build logs](http://www.linuxfromscratch.org/lfs/build-logs/) and [gcc test results](https://gcc.gnu.org/ml/gcc-testresults).  
See `steps/test-results.md` for my list of failed tests

#### Install

Install, cleanup and create symlinks: see `scripts/6/gcc/install.sh` (moved the final `*gdb.py` file move into this script)


### Sanity check

Run another sanity check: see `scripts/sanity-check-2.sh`
(todo: try and merge with first sanity check script)


### Part 4

- pkg-config
    - all 30 tests passed
    - time: negligible
- ncurses
    - tests can only be run after ncurses is installed
    - confirm for 10.0 (does still exist before ncurses installed in LFS 11.0):
        - `bc` previously created `/usr/lib/libncurses.so`, which is overwritten here
    - post install: see `scripts/6/3/ncurses-post.sh`
    - time: negligible
- sed
    - basic config (`prefix`) and simple build/install (not building docs)
    - tests
        - run with `tester` user (same as gcc)
        - 216 passed, 29 skipped (of 245)
    - time: negligible
- psmisc
    - basic config (`prefix`) and simple build/install
    - no tests
    - time: negligible
- Gettext
    - basic config (`prefix`, `disable-static`, `docdir`) and simple build/test/install
    - tests: 727 total, 690 passed, 37 skipped
    - time: 1.6x real (user+sys: 3.0x)
- bison
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - tests: 11/11 passed, and "620 tests were successful. 43 tests were skipped."
    - time: 1.8x real (user+sys: 6.4x)
- grep
    - basic config (`prefix`) and simple build/test/install
    - tests: 318 total, 287 pass, 29 skipped, 2 xfail
    - time: 0.4x real (user+sys: 0.7x)

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
    - remove static libs: `/usr/lib/libltdl.a`
    - time: 0.8x real (user+sys: 1.7x)
- gdbm
    - tests:
        - one test fail with `ERROR`, and summary shows "All 30 tests were successful." (but exits with failure)
        - passes when first removing the test: `rm ./tests/gdbmtool/base.exp`
    - time: negligible
- gperf
    - basic config (`prefix` and `docdir`) and simple build/install
    - tests:
        - run with `-j1`
        - no summary
    - time: negligible
- expat
    - basic config (`prefix`, `disable-static` and `docdir`) and simple build/test/install
    - tests: all 2 passed
    - time: negligible
- inetutils
    - config: disable obsolete programs/programs provided by other packages
    - tests: 10 of 11 passed (1 skipped)
    - post install: move `ifconfig` into `/usr/sbin`
    - time: 0.3x real (user+sys: 0.3x)
- less
    - basic config (`prefix`, `sysconfdir`) and simple build/install
    - no tests
    - time: negligible

### Perl

Patch using `.patch` file. Configure: `scripts/6/5/perl-config.sh`

Tests: "All tests successful."

Time: 6.2x real (user+sys: 6.2x)

### Part 6

- XML-Parser
    - in archive: `XML-P*`
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
        - results: 2926 total, 2726 pass (162 skip, 38 xfail - did get 1 more skip in a previous pass)
    - time: 5.5x real (user+sys: 15.9x)
- kmod
    - no tests in `chroot`
    - post-install: `scripts/6/6/kmod-post.sh`
    - time: negligible
- libelf
    - in archive: `elfutils-*`
    - tests: 226 total, 220 pass, 5 skipped
        - `run-backtrace-native.sh` failed
    - install only libelf, see `scripts/6/6/libelf-install.sh`
    - time: 0.3x real (user+sys: 0.9x)
- libffi
    - tests: 2304 passed
    - time: 1.7x real (user+sys: 1.7x)
- openssl
    - configure script is named `config`
    - tests:
        - `30-test_afalg.t` is known to sometime fail (but it passed)
        - All tests successful. ("Files=158, Tests=2638")
    - pre-install: skip static libs
    - time: 1.5x real (user+sys: 2.3x)
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
    - time: 0.9x real (user+sys: 0.1x, less than real)
- diffutils
    - basic config (`prefix`) and simple build/test/install
    - tests: 225 total, 207 passed/17 skipped/1 xfail
    - time: negligible
- gawk
    - patch: `sed -i 's/extras//' Makefile.in`
    - basic config (`prefix`) and simple build/test/install
    - "ALL TESTS PASSED" (no summary)
    - time: negligible
- findutils
    - tests:
        - run as `tester`
        - 271 total, 254 pass, 17 skipped
        - expected passes: 957, 96, 32
    - time: 0.5x real (user+sys: 0.8x)


### Part 7

- groff
    - must be built with `-j1`
    - no tests
    - time: 0.5x real (user+sys: 0.5x)
- grub
    - skip when using uefi: using host's grub to generate config. can install as part of blfs
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
    - time: negligible
- libpipeline
    - basic config (`prefix`) and simple build/test/install
    - tests: all 7 passed
    - time: negligible
- make
    - basic config (`prefix`) and simple build/test/install
    - all tests passed ("690 Tests in 125 Categories Complete ... No Failures :-)")
    - time: negligible
- patch
    - tests passed (44 total, 41 pass, 1 skip, 2 xfail)
    - time: negligible
- tar
    - tests
        - one test is known to fail, `227: capabilities: binary store/restore` (`capabs_raw01.at`)
        - others passed (218 run, 20 skipped)
    - time: 1.2x real (user+sys: 0.8x, less)
- texinfo
    - patch for glibc 2.43
    - basic config (`prefix`, `disable-static`) and simple build/test/install
    - tests: 253 total, 234 passed, 19 skipped
    - time: 0.3x real (user+sys: 0.6x)
- vim
    - patch default vimrc: see `scripts/6/9/vim-patch.sh`
    - tests
        - run as `tester`, redirect test output to file, see `scripts/6/9/vim-test.sh`
        - ends with "ALL DONE"
    - post install and config: see `scripts/6/9/vim-post.sh`
    - time: 1.3x real (user+sys: 1.2x, less)
- MarkupSafe
    - capital name in archive
    - no config, compile and install with `setup.py`
    - time: negligible
- Jinja2
    - capital name in archive
    - no config, no build, install with `setup.py`
    - time: negligible

### Systemd

Patch and configure: `scripts/6/6/systemd-patch.sh`

Build and install with `ninja`

Tests not mentioned in book. previous (pre LFS11) running `LANG=en_US.UTF-8 ninja test` had errors

Remove dir: `rm -rf /usr/lib/pam.d`

Post-install/extract setup: `scripts/config/systemd.sh`

Time: 0.6x real (user+sys: 3.9x)

### Part 8

- dbus
    - no tests in lfs
    - post install: see `scripts/6/9/dbus-post.sh`
    - potential extract issue with `/var/run/dbus: Cannot mkdir: Too many levels of symbolic links`
    - time: 0.1x real (user+sys: 0.2x)
- man-db
    - tests: 50/50 pass
    - time: 0.3x real (user+sys: 0.4x)
- procps-ng
    - different extract dir (`procps-$version`)
    - tests:
        - 99 passed
        - 5 `pkill` related tests failed (known to fail)
    - time: 0.2x real (user+sys: 0.1x, less)
- util-linux
    - tests:
        - may be harmful when run as root user, see `scripts/6/main/util-linux-tests.sh`
        - "All 212 tests PASSED"
    - time: 0.5x real (user+sys: 1.1x)
- e2fsprogs
    - tests: "369 tests succeeded     1 tests failed" (`u_direct_io` is known to fail)
    - post-install: see `scripts/6/main/e2fsprogs-post.sh`
    - time: 0.4x real (user+sys: 0.6x)

## Cleanup

Run these scripts from outside chroot: `logout` to exit. probably need to umount devices to get better disk usage stats

First extract symbols for some libraries. run: `scripts/split-out-debug-symbols.sh`

Then strip from binaries and libraries. run: `scripts/strip-debug-symbols-and-cleanup.sh` (this ignores the running binaries)

Pre LFS11: Saved about 2.8GB with this (less on 11, but more than 2GB)

To re-enter you need a new command - but it differs in only a now extra `+h` param to bash - so can still use `scripts/chroot/enter-chroot.sh`