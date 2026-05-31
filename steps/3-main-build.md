# Building the LFS system

These notes are from Chapter 8 of the 10.0 to 12.4 version

## setup

These steps need to be done in chroot - reenter after cleanup/backup or a restore from a backup. See notes in chroot setup (`steps/2-chroot-temp-system2.md`)

See notes about package management

## packages

### Part 1

- man-pages
    - patch: remove password hashing function docs
    - no configure or build (just `make prefix=/usr install`)
- iana-etc
    - only need to copy the 2 files out (`cp -v services protocols /etc`)

### Glibc

Patches: see, `scripts/packages/glibc/pass2-patch.sh`
- file system standards: this patch is applied on all glib versions - consider ignoring this and using the non-compliant path
- fix for Valgrind
- pre configure setup to install into `sbin`, see `scripts/packages/glibc/pre-configure.sh`

Note: the configuring and installing is split up differently here than in the book

#### tests

Tests are *critical*, but some will fail:

"You may see some test failures." the doc only lists some of the most common issues

- known to fail: (and failed on `2.42`, `2.38`, `2.36` and `2.34`)
    - `io/tst-lchmod`

`grep '^FAIL' tests.sum` to get a list of failed

See `steps/test-results.md` for summary.

See `scripts/packages/glibc/tests.sh`

#### Install glibc

Prevent warnings and sanity checks, install glibc, fix ldd paths, install configuration files files. See `scripts/packages/glibc/install.sh`

#### Install timezone data

Run `scripts/packages/tzdata-install.sh` (note this should run in the `sources` directory) and configure it

#### Configure glibc

Install locales needed for future tests, run `scripts/config/install-locales.sh`

Find your locale in list of supported (ex `tar -xOf ./glibc-*.tar.xz --wildcards -- 'glibc-*/localedata/SUPPORTED' | grep en_GB`)
and install it, ex `localedef -i en_GB -f UTF-8 en_GB.UTF-8`

Run `scripts/config/tz-set-localtime.sh` to set `/etc/localtime`

Run `scripts/config/dynamic-loader-setup.sh` to setup `/etc/ld.so.conf`

### Part 2

- zlib
    - basic config (`prefix`) and simple build/test/install
    - remove static libs: `rm -vf /usr/lib/libz.a`
- bzip2
    - patch for docs, relative symlinks and man pages. build the dynamic library first: `scripts/packages/bzip2-patch.sh`
    - no configure (but install with `PREFIX` - part of `scripts/packages/bzip2-install.sh`)
    - install: `scripts/packages/bzip2-install.sh`
- xz
- lz4
- zstd
    - no configure (but `prefix=/usr` in install)
    - post: remove a static lib `rm -v /usr/lib/libzstd.a`
- file
    - basic config (`prefix`) and simple build/test/install
- readline
    - reinstalling can cause issues with old files (but not reinstalling here, and should use fakeroots eventually)
    - no tests
- m4
    - then basic config (`prefix`) and simple build/test/install
- bc
- flex
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install
    - post install: create `lex` symlink: `ln -sv flex /usr/bin/lex`
- tcl
    - custom archive name. also extract the documentation archive
    - custom build commands, `make` and then run `scripts/packages/tcl-post-build.sh`
    - install steps for headers, symlink (see `scripts/packages/tcl-install.sh`, which also installs)
- expect
    - post: symlink lib into `/usr/lib`
    - tests are *critical*. uses `all.tcl:  Total ...  Passed  ...` format
- DejaGNU
    - skipped building/installing docs
    - tests: ran before install (book has install then test?)
- pkgconf
    - post install symlink for compatibility with `pkg-config`, see `scripts/packages/pkgconf-post.sh`
    - no tests

### binutils

The tests are critical.  
Had issues on `2.39` when running in parallel, with the failing tests changing on reruns.  
`2.41` and later passed with `... --jobs 4` (expected errors only)
See `./scripts/packages/binutils/tests.sh`

Remove static libs after installing

### gmp, mpfr, mpc

- gmp
    - see notes on the architecture, and make sure that matches the CPU
    - skipped building/installing html docs
    - The tests are *critical*.
        - Check that "at least 199 tests"
        - See `scripts/packages/gmp-test.sh`
- mpfr
    - simple build/test/install
    - skipped building/installing html docs
    - The tests are *critical*. All tests must pass. Uses "Testsuite summary" output
- mpc
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install
    - The tests uses "Testsuite summary" output
    - skipped building/installing html docs

### Part 3

- attr
- acl
    - `test/cp.test` is known to fail
- libcap
    - patch: prevent installing static libraries
    - no configure (but `make prefix=`)
- libxcrypt

### Shadow

`touch /usr/bin/passwd`: file must exist before configure is run

Patch to disable groups, man pages, and change hashing algorithm. See `scripts/packages/shadow-patch.sh`

There are no tests

Install using `scripts/packages/shadow-install.sh`

Run `scripts/config/shadow.sh` for post install configuration

### GCC

Takes *realy* long

Patch, see `scripts/packages/gcc/patch-lib64.sh` (same as before)

#### Tests

Takes most of the time

The tests are *critical*.

Increase stack size, run tests as the `tester` user and print a summary of the test results, see `scripts/packages/gcc/tests.sh`

Some tests are known to fail. Compare with list in doc.
Compare the overall results with the [build logs](http://www.linuxfromscratch.org/lfs/build-logs/) and [gcc test results](https://gcc.gnu.org/ml/gcc-testresults).  
See `steps/test-results.md` for my list of failed tests

#### Install

Install, cleanup and create symlinks: see `scripts/packages/gcc/install.sh` (moved the final `*gdb.py` file move into this script)

### Sanity check

Run another sanity check: see `scripts/sanity-check-2.sh`
(todo: try and merge with first sanity check script)

### Part 4

- ncurses
    - tests can only be run after ncurses is installed
    - install and post install using `scripts/packages/ncurses/install-main.sh`
- sed
    - basic config (`prefix`) and simple build/install (not building docs)
    - tests: run with `tester` user (same as gcc). Uses "Testsuite summary" output
- psmisc
    - basic config (`prefix`) and simple build/install
    - tests: uses separate tests for executables, find "... Summary"
- Gettext
    - basic config (`prefix`, `disable-static`, `docdir`) and simple build/test/install
    - tests: uses "Testsuite summary" output
- bison
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - tests: uses "Testsuite summary" output
- grep
    - patch to setup tests: `scripts/packages/grep-patch.sh`
    - basic config (`prefix`) and simple build/test/install
    - tests: uses "Testsuite summary" output

### Bash

Tests need to be run as user `tester`, using expect: see `scripts/packages/bash-tests.sh`

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary)

After installing, start a new bash: `exec /usr/bin/bash --login`

### Part 5

- libtool
    - basic config (`prefix`) and simple build/test/install
    - remove static libs: `/usr/lib/libltdl.a`
- gdbm
    - tests: shows after "Test results."
- gperf
    - basic config (`prefix` and `docdir`) and simple build/install
    - tests: No summary
- expat
    - basic config (`prefix`, `disable-static` and `docdir`) and simple build/test/install
    - tests: uses "Testsuite summary" output
- inetutils
    - config: disable obsolete programs/programs provided by other packages
    - tests: uses "Testsuite summary" output
    - post install: move `ifconfig` into `/usr/sbin`
- less
    - basic config (`prefix`, `sysconfdir`) and simple build/install
    - no tests

### Perl

Configure: `scripts/packages/perl-configure-main.sh`

Tests: "All tests successful."

### Part 6

- XML-Parser
    - in archive: `XML-P*`
    - prepare with `perl Makefile.PL`. then basic build/test/install
    - tests: "All tests successful."
- intltool
    - patch: `scripts/packages/intltool-patch.sh`
    - then basic config (`prefix`) and build/test/install
    - tests: uses "Testsuite summary" output
- autoconf
    - basic config (`prefix`) and build/test/install
    - tests: shows after "Test results."
- automake
    - tests:
        - run tests with `-j4` option to speed it up (even on single core systems)
        - uses "Testsuite summary" output
- openssl
    - configure script is named `config`
    - tests:
        - "All tests successful."
    - pre-install: skip static libs
    - to check: a lot of `/usr/bin/perl ./util/mkpod2html.pl` commands during install
- libelf
    - in archive: `elfutils-*`
    - tests: uses "Testsuite summary" output
      - known to fail: `dwarf_srclang_check`, `run-backtrace-native-core.sh`
    - install only libelf, see `scripts/packages/libelf-install.sh`
- libffi
    - see note on processor architecture
    - tests: find "libffi Summary"
- python
    - archive name start with capital
    - tests
      - some are "known to hang indefinitely", so set a timeout
      - `test_ssl` is known to fail
      - some still ran, "Tests result: SUCCESS"
    - see note on pip usage as root, update checks. see `scripts/packages/python-post.sh` to create a default `pip.conf`

### Python packages

Most of these build and install with `pip3`, without no tests

- Flit-Core
- packaging
- wheel
- setuptools
- ninja
    - see note on optional patch (to decrease/set parallel process count)
    - configured and build with python3 scripts
    - no tests in chroot
- meson

### Part 6 (2)

- kmod
    - no tests available in LFS
- coreutils
    - patch: for character boundary, then `autoreconf -fiv`
    - tests:
        - see `scripts/packages/coreutils-test.sh`
        - `test-getlogin` may fail
        - Uses "Testsuite summary" output
    - post install: move files, see `scripts/packages/coreutils-post-main.sh` (similar to 1st)
- diffutils
    - basic config (`prefix`) and simple build/test/install
    - tests: uses "Testsuite summary" output
- gawk
    - patch: `sed -i 's/extras//' Makefile.in`
    - basic config (`prefix`) and simple build
    - tests:
        - needs to change to `tester`
        - "ALL TESTS PASSED" (no summary)
- findutils
    - tests:
        - run as `tester`
        - uses "Testsuite summary" *and* "<executable> Summary" outputs

### Part 7

- groff
- grub
    - skip when using uefi: using host's grub to generate config. can install as part of blfs
    - actual boot setup covered after packages installed
- gzip
    - basic config (`prefix`) and simple build/test/install
    - tests: uses "Testsuite summary"
- iproute2
    - skip `arpd`: `scripts/packages/iproute2-patch.sh`
    - no configure, tests
    - build and install with specific `make` variables
- kbd
    - patch, see `scripts/packages/kbd-patch.sh`
    - tests: not available (requires `valgrind`)
- libpipeline
    - basic config (`prefix`) and simple build/test/install
    - tests: not available (requires `check`)
- make
    - basic config (`prefix`) and simple build/test/install
    - tests run as `tester`, see `scripts/packages/make-tests.sh`
    - all tests passed ("... Tests in ... Categories Complete ... No Failures :-)")
- patch
    - tests: uses "Testsuite summary"
- tar
    - tests: see `scripts/packages/tar-tests.sh`
        - one test is known to fail, `233: capabilities: binary store/restore` (`capabs_raw01.at`)
        - others passed (218 run, 1 failed unexpectedly, 20 skipped)
- texinfo
    - basic config (`prefix`) and simple build/test/install
    - tests: uses "Testsuite summary" (multiple)
- vim
    - patch default vimrc: see `scripts/packages/vim/patch.sh`
    - tests
        - run as `tester`, redirect test output to file, see `scripts/packages/vim/tests.sh`
        - tests: **note** require 24 lines (increase `tmux` pane)
        - ends with "ALL DONE"
    - post install and config: see `scripts/packages/vim/post.sh`
- MarkupSafe
    - compile and install with `pip3`
    - no tests
- Jinja2
    - compile and install with `pip3`
    - no tests

### Systemd

Patch and configure: `scripts/packages/systemd-patch.sh`

Build and install with `ninja`

Tests require `/etc/os-release` to exist first.
- `systemd:core / test-namespace` is known to fail
- Other tests may fail due to kernel options

Post-install/extract setup: `scripts/config/systemd.sh`

### Part 8

- dbus
    - many tests are disabled
    - `meson`/`ninja`
    - post install: see `scripts/packages/dbus-post.sh`
    - potential extract issue with `/var/run/dbus: Cannot mkdir: Too many levels of symbolic links`
- man-db
    - tests: `man1/lexgrog.1` is known to fail
- procps-ng
    - tests: need to `chown` the directory
- util-linux
    - tests:
        - may be harmful when run as root user, see `scripts/packages/util-linux-tests.sh` (to run as `tester`)
        - `hardlink/options` ("The hardlink tests will fail if...")
        - `kill: decode functions`
- e2fsprogs
    - tests: `m_assume_storage_prezeroed` is known to fail
    - see `scripts/packages/e2fsprogs-tests.sh`
    - post-install: see `scripts/packages/e2fsprogs-post.sh`

## Cleanup

Run these scripts from outside chroot: `logout` to exit. Probably need to umount devices to get better disk usage stats

To calculate usage saved, run `du -hms "$LFS"` before and after

First extract symbols for some libraries. run: `scripts/split-out-debug-symbols.sh "$LFS"`

Then strip from binaries and libraries. run: `scripts/strip-debug-symbols-and-cleanup.sh "$LFS"`.  
This script does not skip the running binaries check as the book does, because it is meant to be run outside chroot (so none of the binaries will be running)  

Saved >2.5GB with this
