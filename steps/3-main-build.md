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
- file system standards: see, `scripts/packages/glibc/patch.sh`. This patch is applied on all glib versions - consider ignoring this and using the non-compliant path
- pre configure setup to install into `sbin`

Note: the configuring and installing is split up differently here than in the book

Time (including tests and install): 7.6x real (user+sys: 21.4x)

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

See `steps/test-results.md` for my list of failed tests

#### Install glibc

Prevent warnings and sanity checks, install glibc, fix ldd paths, install nscd configs and systemd files. See `scripts/6/glibc/install.sh`

#### Install timezone data

see `scripts/6/glibc/tz-install.sh` (note this should run in the `sources` dir) and configure it

time: negligible

#### Configure glibc

Install locales needed for future tests, see `scripts/config/install-locales.sh` (about 0.2x real/usr+sys)

Find your locale in list of supported (`tar -xOf ./glibc-*.tar.xz --wildcards -- 'glibc-*/localedata/SUPPORTED' | grep en_GB`)
and install it, ex `localedef -i en_GB -f UTF-8 en_GB.UTF-8`

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
    - time: 0.35x real (user+sys: 1.0x)
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
    - time: 0.3x real (user+sys: 0.5x)
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
    - time: 1.4x real (user+sys: 1.0x)
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
See `steps/test-results.md` for my list of failed tests

Remove static libs after installing

time: 2.3x real (user+sys: 8.5x)

### gmp, mpfr, mpc

- gmp
    - see notes on the architecture, and make sure that matches the CPU
    - skipped building/installing html docs
    - The tests are critical. All 197 must pass
        - run `awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log` to get passed count
    - time: 0.33x real (user+sys: 1.0x)
- mpfr
    - simple build/test/install
    - skipped building/installing html docs
    - The tests are critical. All tests must pass (had 181 pass, 2 skipped)
    - time: 0.23x real (user+sys: 0.75x)
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

See `scripts/config/shadow.sh` for post install configuration

### GCC

Takes *realy* long: 41.0x real (user+sys: 287.2x to 294.2x) total

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
    - install and post install using `scripts/6/3/ncurses-install.sh`
    - time: negligible
- sed
    - basic config (`prefix`) and simple build/install (not building docs)
    - tests
        - run with `tester` user (same as gcc)
        - 217 passed, 28 skipped (of 245)
    - time: negligible
- psmisc
    - basic config (`prefix`) and simple build/install
    - no tests
    - time: negligible
- Gettext
    - basic config (`prefix`, `disable-static`, `docdir`) and simple build/test/install
    - tests: 727 total, 690 passed, 37 skipped
    - time: 1.3x real (user+sys: 2.6x)
- bison
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - tests: "712 tests were successful. 64 tests were skipped."
    - time: 2.4x real (user+sys: 8.9x)
- grep
    - basic config (`prefix`) and simple build/test/install
    - tests: 318 total, 289 pass, 21 skipped, 1 xfail
    - time: 0.28x real (user+sys: 0.58x)

### Bash

Tests need to be run as user `tester`, using expect: see `scripts/6/main/bash-tests.sh`

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary)

After installing, start a new bash: `exec /bin/bash --login`

Time: 0.6x real (user+sys: 0.4x - less than real)

### Part 5

- libtool
    - basic config (`prefix`) and simple build/test/install
    - Five tests are known to fail (63 failed, 58 expected). see `grep FAIL tests/testsuite.log`
        - 122. compiling softlinked libltdl
        - 123. compiling copied libltdl
        - 124. installable libltdl
        - 125. linking libltdl without autotools
        - 129. linking libltdl without autotools
    - remove static libs: `/usr/lib/libltdl.a`
    - time: 0.7x real (user+sys: 1.5x)
- gdbm
    - tests: "All 33 tests were successful."
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
    - time: negligible
- less
    - basic config (`prefix`, `sysconfdir`) and simple build/install
    - no tests
    - time: negligible

### Perl

Patch using `.patch` file. Configure: `scripts/6/5/perl-config.sh`

Tests: "All tests successful."

Time: 5.6x to 5.8x real (user+sys: same)

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
    - time: 1.8x real (user+sys: 6.9x)
- automake
    - tests:
        - run tests with `-j4` option to speed it up (even on single core systems)
        - results: 2926 total, 2726 pass (162 skip, 38 xfail)
        - `t/subobj.sh` is known to fail
    - time: 4.6x real (user+sys: 12.9x)
- openssl
    - configure script is named `config`
    - tests:
        - `30-test_afalg.t` is known to sometime fail (but it passed)
        - All tests successful. ("Files=243, Tests=3299")
    - pre-install: skip static libs
    - to check: a lot of `/usr/bin/perl ./util/mkpod2html.pl` commands during install
    - time: 3.4x real (user+sys: 5.2x)
- kmod
    - no tests available in LFS
    - post-install: `scripts/6/6/kmod-post.sh`
    - time: negligible
- libelf
    - in archive: `elfutils-*`
    - tests: 232 total, 227 pass, 5 skipped
        - `run-backtrace-native.sh` failed
    - install only libelf, see `scripts/6/6/libelf-install.sh`
    - time: 0.28x real (user+sys: 0.9x)
- libffi
    - tests: 2304 passed
    - time: 1.5x real (user+sys: same)
- python
    - archive name start with capital
    - tests: skipped, "known to hang indefinitely" (needs networking)
    - see note on pip usage as root, update checks. see `scripts/6/6/python-post.sh` to create a default `pip.conf`
    - time: 1.9x real (user+sys: 4.4x)
- wheel
    - install using `pip3`
      - but had issue with command in book, installed directly from package: `pip3 install --no-index wheel-*.tar.gz`
    - time: negligible
- ninja
    - see note on optional patch (to decrease/set parallel process count)
    - configured and build with python3 scripts
    - tests passed (384/384)
    - time: 0.26x real (user+sys: 0.74x)
- meson
    - build with `pip3 wheel ...`
    - no tests
    - install with `pip3`
    - time: negligible
- coreutils
    - patch: for character boundary, then `autoreconf -fiv`
    - tests:
        - see `scripts/6/7/coreutils-test.sh`
        - `sort-NaN-infloop` is known to fail with gcc 12 (but it passed)
        - 1041 total, 896 pass, 145 skip
    - post install: move files, see `scripts/6/7/coreutils-post.sh`
    - time: 0.9x real (user+sys: 2.1x)
- check
    - basic config (`prefix`, `disable-static`) and simple build/test/install
    - tests:
        - take relatively long
        - seems to hang after `test_tap_output.sh`
        - all 10 tests passed
    - time: 0.7x real (user+sys: 0.11x, less than real)
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
        - 281 total, 263 pass, 18 skipped
        - expected passes: 487, 96, 32
    - time: 0.38x real (user+sys: 0.66x)

### Part 7

- groff
    - must be built with `-j1`
    - no tests
    - time: 0.4x real (user+sys: same)
- grub
    - skip when using uefi: using host's grub to generate config. can install as part of blfs
    - actual boot setup covered after packages installed
- gzip
    - basic config (`prefix`) and simple build/test/install
    - all 26 tests passed
    - time: negligible
- iproute2
    - skip `arpd`: `scripts/6/8/iproute2-patch.sh`
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
        - others passed (218 run, 1 failed unexpectedly, 20 skipped)
    - time: 1.0x real (user+sys: 0.63x, less)
- texinfo
    - basic config (`prefix`) and simple build/test/install
    - tests: 253 total, 234 passed, 19 skipped
    - time: 0.25x real (user+sys: 0.55x)
- vim
    - patch default vimrc: see `scripts/6/9/vim-patch.sh`
    - tests
        - run as `tester`, redirect test output to file, see `scripts/6/9/vim-test.sh`
        - ends with "ALL DONE"
    - post install and config: see `scripts/6/9/vim-post.sh`
    - time: 1.3x real (user+sys: 1.2x, less)
- MarkupSafe
    - capital name in archive
    - compile and install with `pip3`
    - no tests
    - time: negligible
- Jinja2
    - capital name in archive
    - compile and install with `pip3`
    - no tests
    - time: negligible

### Systemd

Patch and configure: `scripts/6/6/systemd-patch.sh`

Build and install with `ninja`

Tests not mentioned in book. previous (pre LFS11) running `LANG=en_US.UTF-8 ninja test` had errors

Post-install/extract setup: `scripts/config/systemd.sh`

Time: 0.6x real (user+sys: 4.0x)

### Part 8

- dbus
    - no tests in lfs
    - post install: see `scripts/6/9/dbus-post.sh`
    - potential extract issue with `/var/run/dbus: Cannot mkdir: Too many levels of symbolic links`
    - time: negligible
- man-db
    - tests: 52/52 pass
    - time: negligible
- procps-ng
    - tests. all passed. "free with commit may fail"
    - time: negligible
- util-linux
    - tests:
        - may be harmful when run as root user, see `scripts/6/main/util-linux-tests.sh`
        - "1 tests of 225 FAILED"
            - `hardlink/options` ("The hardlink tests will fail if...")
    - time: 0.37x real (user+sys: 1.0x)
- e2fsprogs
    - tests: "371 tests succeeded     0 tests failed"
    - post-install: see `scripts/6/main/e2fsprogs-post.sh`
    - time: 0.35x real (user+sys: 0.6x)

## Cleanup

Run these scripts from outside chroot: `logout` to exit. Probably need to umount devices to get better disk usage stats

To calculate usage saved, run `du -hms "$LFS"` before and after

First extract symbols for some libraries. run: `scripts/split-out-debug-symbols.sh "$LFS"`

Then strip from binaries and libraries. run: `scripts/strip-debug-symbols-and-cleanup.sh "$LFS"`.  
This script does not skip the running binaries check as the book does, because it is meant to be run outside chroot (so none of the binaries will be running)  
Saved 2118MB with this
