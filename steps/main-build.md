# Building the LFS system

These notes are from Chapter 8 of the 10.0 version

## setup

These steps need to be done in chroot - reenter after cleanup/backup or a restore from a backup. See notes in chroot setup (`steps/6-install.md`)

Todo: recheck enter scripts, since `mknod` commands fail (already exists)

See notes about package management

## packages

### part 1

- man-pages
    - no configure, build (just `make install`)
    - time: negligible
- tcl
    - custom archive name, also extract the documentation archive
    - custom build commands (sed to replace build dir)
        - see `scripts/6/main/tcl-post-build.sh`
    - post install steps for headers, symlink
        - `make install-private-headers`
        - `ln -sv tclsh8.6 /tools/bin/tclsh`
    - tests
        - some known errors in `clock.test`
        - also had errors in `tdbcmysql.test`, `tdbcodbc.test`, `tdbcpostgres.test` (libraries not found)
        - todo: filter output log for lines like `all.tcl:        Total   24996   Passed  21651   Skipped 3345    Failed  0`
    - time: 0.8x (0.5x for parallel) + 1.4x for tests
- expect
    - post: symlink lib into `/usr/lib`
    - time: negligible + 0.1x for tests
- DejaGNU
    - tests: ran before install (book has install then test?)
    - skipped building/installing docs
    - time: negligible
- iana-etc
    - only need to copy the 2 files out (`cp -v services protocols /etc`)
    - time: negligible

### Glibc

Patch for file system standards: `patch -Np1 -i ../glibc-2.*-fhs-1.patch`. This patch is applied on all glib versions - consider ignoring this and using the non-compliant path

Time: 4.8x (1.3x for parallel) + 14.2x (6.2x for parallel) for tests

#### tests

Create symlink for tests to work (`ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib`)

Tests are *critical*, but some will fail:

"You may see some test failures.", the doc only lists some of the most common issues

- known to fail:
    - `io/tst-lchmod`
	- `misc/tst-ttyname`
- others mentioned, but passed:
    - `nss/tst-nss-files-hosts-multi`
    - `rt/tst-cputimer{1,2,3}`
    - math tests on older CPUs

summary:

```
Summary of test results:
      2 FAIL
   4228 PASS
     34 UNSUPPORTED
     17 XFAIL
      2 XPASS
```

#### Install glibc

Prevent warnings and sanity checks, install and install nscd configs and systemd files. See `scripts/6/glibc/install.sh`

Setup locales. See `scripts/6/glibc/locale.sh` to install those needed for future tests

Use something like `grep en_ ../localedata/SUPPORTED` to find your locale

#### Configure glibc

##### nsswitch.conf

    cat > /etc/nsswitch.conf << "EOF"
    # Begin /etc/nsswitch.conf
    passwd: files
    group: files
    shadow: files
    hosts: files dns
    networks: files
    protocols: files
    services: files
    ethers: files
    rpc: files
    # End /etc/nsswitch.conf
    EOF

##### timezone

Install timezone data (see `scripts/6/glibc/tz-install.sh` - note this should run in the `sources` dir) and configure it

Run `scripts/6/glibc/tz-set-localtime.sh` to set `/etc/localtime`

#### Dynamic Loader

See `scripts/6/glibc/dynamic-loader-setup.sh` to setup `/etc/ld.so.conf`

### part 2

- zlib
    - basic config (`prefix`) and simple build/test/install
    - time: negligible
- bzip2
    - patch: `scripts/6/3/bzip2-patch.sh`
    - build the dynamic library first
    - post-install: `scripts/6/3/bzip2-install.sh`
    - time: negligible
- xz
    - tests: `All 9 tests passed`
    - install with `make install` and then
        - move files: `mv -v $DESTDIR/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} $DESTDIR/bin`
        - move and recreate shared object `scripts/6/mv-shared.sh /usr/lib/liblzma.so`
    - time: negligible
- zstd
    - no tests
    - post: remove a static lib `rm -v /usr/lib/libzstd.a`
    - time: 0.2x (no speedup in parallel) - but install does more building?
- file
    - basic config (`prefix`) and simple build/test/install
    - time: negligible
- readline
    - patch: see `scripts/6/2/readline-patch.sh`
    - no tests
    - time: negligible
- m4
    - patch: see `scripts/5/tools/m4-patch.sh` (same as temp tools)
    - then basic config (`prefix`) and simple build/test/install
    - tests: 170 total, 157 pass, 13 skipped
    - time: negligible
- bc
    - custom configure script
    - all tests (`bc` and `dc`) pass
    - time: negligible
- flex
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - post install: create `lex` symlink `ln -sv flex /usr/bin/lex`
    - tests: all 114 passed
    - time: negligible + 0.3x (0.1x in parallel) for tests

### binutils

First verify PTYs are working in chroot:
`expect -c "spawn ls" | grep "spawn ls" && echo "SUCCESS" || echo "FAILED"`

Patch: remove a test (`sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in`)

The tests are critical. docs mention to run with `-k`, but they pass without it

time: 3x to 4.2x (1.3x for parallel) + 3.1x (1.3x for parallel) for tests

### gmp, mpfr, mpc

- gmp
    - see the architecture after configure, and make sure that matches the CPU (see notes to change)
    - The tests are critical. All 197 must pass
        - run `awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log` to get passed count
    - time: 0.4x (0.1x for parallel) + 0.7x (0.2x for parallel) for tests
- mpfr
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install (skipped docs)
    - The tests are critical. All tests must pass (had 181 pass, 2 skipped)
    - time: 0.3x (0.1x for parallel) + 0.6x (0.2x for parallel) for tests
- mpc
    - basic config (`prefix`, `docdir`, `disable-static`) and simple build/test/install (skipped docs)
    - tests: all 67 passed
    - time: negligible + 0.2x (negligible for parallel) for tests

### part 3

- attr
    - move a shared lib: `scripts/6/mv-shared.sh /usr/lib/libattr.so`
    - time: negligible
- acl
    - tests require coreutils, so cannot be run now
    - move a shared lib: `scripts/6/mv-shared.sh /usr/lib/libacl.so`
    - time: negligible
- libcap
    - no configure
    - patch to disable static lib install
    - post install: move libs, create libcap in `/usr/lib`
    - time: negligible

### Shadow

Patch to disable groups, man pages, use sha-256, fix first user id. See `scripts/6/3/shadow-patch.sh`

`touch /usr/bin/passwd` must exist before configure in run

There are no tests

Time: negligible

#### post install configuring

Enable using:

```
pwconv
grpconv
```

optionally start groups at 100: `sed -i /etc/default/useradd -e 's/\(GROUP\)=.*/\1=100/'`

optinally disable mail spool: `sed -i /etc/default/useradd -e 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/'`

set the password for root: `passwd root`

### GCC

Takes *realy* long: 15.2x (4.5x for parallel) + 110.7x (29.3x for parallel) for the tests

Patch to fix for 64 bit lib: `sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64`

#### Tests

The tests are critical.

Increase stack size and run tests as the `tester` user:

```
ulimit -s 32768
chown -Rv tester .
time su tester -c "PATH=$PATH make --jobs 4 -k check"
```

to get a summary of the results: `../contrib/test_summary | grep -A7 Summ`

Some tests are known to fail:

- "Six tests related to get_time are known to fail."
- `asan_test.C`, `co-ret-17-void-ret-coro.C`, `pr95519-05-gro.C`, `pr80166.c`

Compare the results with the [build logs](http://www.linuxfromscratch.org/lfs/build-logs/) and [gcc test results](https://gcc.gnu.org/ml/gcc-testresults). See also my list of failed tests: `steps/6-more.md`

See `scripts/6/gcc/compare-test-results.sh` to get list of unexpected failures

Change the ownership back to root (remove the need to change post-install): `chown -Rv root .`

#### Install and sanity checks

Install using the normal `make install`

Post install clean and symlinks: see `scripts/6/gcc/install.sh` (moved the final `.py` file move to share into this script)

Run another sanity check: see `scripts/6/gcc/sanity-check-4.sh`

### part 4

- pkg-config
    - all 30 tests passed
    - time: negligible
- ncurses
    - tests can only be run after ncurses is installed
    - confirm for 10.0:
        - `bc` previously created `/usr/lib/libncurses.so`, which is overwritten here
    - post install:
        - move shared lib
        - symlinks for non-wide-character library `scripts/6/3/ncurses-post.sh`
    - time: 0.3x (0.1x for parallel)
- sed
    - basic config (`prefix`, `bindir`) and simple build/install
    - tests
        - run with `tester` user (same as gcc)
        - 157 passed, 21 skipped (of 178)
    - time: negligible
- psmisc
    - basic config (`prefix`) and simple build/install
    - no tests
    - post install: move files for FHS: `mv -v $DESTDIR/usr/bin/{fuser,killall} $DESTDIR/bin`
    - time: negligible
- Gettext
    - basic config (`prefix`, `disable-static`, `docdir`) and simple build/test/install
    - tests: 727 total, 690 passed, 37 skipped
    - time: (configure takes some time) 1.5x (0.8x for parallel) + 1.2x (0.3x for parallel) for tests
- bison
    - basic config (`prefix`, `docdir`) and simple build/test/install
    - tests: "617 tests were successful. 43 tests were skipped."
    - time: negligible + 6.7x (1.7x for parallel) for tests
- grep
    - basic config (`prefix`, `bindir`) and simple build/test/install
    - tests: 298 total, 269 pass, 27 skipped, 2 xfail
    - time: negligible + 0.4x (0.1x for parallel) for tests

### Bash

Tests need to be run as user `tester`:

```
chown -Rv tester .
time su tester << EOF
PATH=$PATH make tests < $(tty) | tee check-log
EOF
chown -R root .
```

Some tests seem to hang for a few seconds. Running the tests passed (exit code 0, but no summary), but had a few errors/warnings output

Post install: `mv -vf $DESTDIR/usr/bin/bash $DESTDIR/bin`

After installing, start a new bash: `exec /bin/bash --login +h`

Time: 0.3x (negligible for parallel) + 0.9x for tests

### Part 5

- libtool
    - basic config (`prefix`) and simple build/test/install
    - tests: take some time, can be improved with `TESTSUITEFLAGS=-j4`
    - Five tests are known to fail (64 failed, 59 expected). see `grep FAIL tests/testsuite.log`
        - 123: compiling softlinked libltdl
        - 124: compiling copied libltdl
        - 125: installable libltdl
        - 126: linking libltdl without autotools
        - 130: linking libltdl without autotools
    - time: negligible + 2.2x (1.0x for parallel) for tests (both with `TESTSUITEFLAGS=-j4`, sys+user vs real times)
- gdbm
    - patch with `sed` command
    - tests: "All 30 tests were successful."
    - time: negligible + negligible for tests
- gperf
    - basic config (`prefix` and `docdir`) and simple build/test/install
    - tests are known to fail if running simultaneous (run with `-j1`)
    - time: negligible + negligible for tests
- expat
    - basic config (`prefix`, `disable-static` and `docdir`) and simple build/test/install
    - tests: all 2 passed
    - time: negligible + negligible for tests
- inetutils
    - config: disable obsolete programs/programs provided by other packages
    - tests: all 10 passed
    - post install: move files into `bin`, `sbin`
        - `mv -v $DISTROOT/usr/bin/{hostname,ping,ping6,traceroute} $DISTROOT/bin`
        - `mv -v $DISTROOT/usr/bin/ifconfig $DISTROOT/sbin`
    - time: negligible + negligible for tests

### Perl

Configure: `scripts/6/5/perl-config.sh`

Tests: "All tests successful."

Time: 1.7x (0.5x for parallel) + 6.2x (parallel) for tests + 0.2x for install

### Part 6

- XML-Parser
    - prepare with `perl Makefile.PL`. then basic build/test/install
    - tests: all 140 passed
    - time: negligible
- intltool
    - patch: `scripts/6/6intltool-patch.sh`
    - then basic config (`prefix`) and build/test/install
    - 1 test that passes
    - time: negligible
- autoconf
    - patch: `sed -i '361 s/{/\\{/' bin/autoscan.in`
    - then basic config (`prefix`) and build/test/install
    - tests are broken due to bash and libtool
        - from previous book: "two tests fail due to changes in libtool-2.4.3 and later"
        - had a lot of failures (138, 4 expected of 450)
    - time: negligible + 4.0x for tests
- automake
    - patch: fix a test
    - tests:
        - run tests with `-j4` option to speed it up (even on single core systems)
        - `t/subobj.sh` is known to fail in LFS (but it passed)
        - results: 2915 total, 2719 pass (157 skip, 39 xfail)
    - time: negligible + 17.7x (6.3x for parallel) for tests
- kmod
    - no tests in `chroot`
    - post-install: `scripts/6/6/kmod-post.sh`
    - time: negligible
- libelf
    - in archive: `elfutils-*`
    - tests: 218 total, 213 pass, 5 skipped
    - install only libelf, see `scripts/6/6/libelf-install.sh`
    - time: 0.6x (0.2x for parallel) + 0.2x for tests
- libffi
    - tests: 2284 passed
    - time: negligible + 1.8x for tests
- openssl
    - configure script is named `config`
    - tests:
        - `30-test_afalg.t` is known to sometime fail (but it passed)
        - All tests successful. ("Files=155, Tests=1468")
    - pre-install: skip static libs
    - time: 1.1x (0.3x for parallel) + 0.7x for tests (install takes some time)
- python
    - archive name start with capital
    - tests:
        - `test_normalization` fails due to network config
    - post: create `pip3` symlink: `/usr/bin/pip3' -> 'pip3.8`
    - time: 1.3x (0.3x for parallel) + 6.9x (1.2x for parallel) for tests
- ninja
    - see note on optional patch (to decrease/set parallel process count)
    - configured and build with python3 scripts
    - tests passed (341/341)
    - time: 0.4x (0.2x for parallel) + 0.3x (negligible for parallel) for tests (test building takes most of the time)
- meson
    - configure and build with python3 scripts
    - no tests
    - install with a setup.py, use `python3 setup.py install --root $DESTDIR/` to set DESTDIR
    - time: negligible
- coreutils
    - patch:
        - for character boundary
        - suppress test in `gnulib-tests/gnulib.mk`
    - configure
        - `autoreconf -fiv`
        - disable `kill`, `uptime`
    - tests:
        - see `scripts/6/7/coreutils-test.sh`
        - check-root:
            - 32 tests: 19 passed, 13 skipped
        - check:
            - `test-getlogin` is known to fail (but it passed)
            - 970 tests: 819 passed, 151 skipped
    - post install: move files, see `scripts/6/7/coreutils-post.sh`
    - time: (configure takes some time) + 0.4x (0.1x for parallel) + 1.4x (0.4 for parallel) for tests
- check
    - basic config (`prefix`, `disable-static`) and simple build/test/install
    - tests:
        - take relatively long
        - seems to hang at `test_tap_output.sh`
        - all 10 tests passed
    - time: negligible + 0.9x for tests
- diffutils
    - basic config (`prefix`) and simple build/test/install
    - tests: 195 total, 180 passed/14 skipped/1 xfail
    - time: negligible
- gawk
    - patch: `sed -i 's/extras//' Makefile.in`
    - basic config (`prefix`) and simple build/test/install
    - all tests passed
    - time: negligible
- findutils
    - tests:
        - run as `tester`
        - 250 total, 237 pass, 13 skipped
    - post-install: see `scripts/6/7/findutils-post.sh`
    - time: negligible + 1.4x for tests
- groff
    - must be built with `-j1`
    - no tests
    - time: 0.4x
- grub
    - no tests
    - post-install
        - `mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions`
        - actual boot setup covered after packages installed
    - time: 0.7x (0.2x for parallel)
- less
    - basic config (`prefix`, `sysconfdir`) and simple build/install
    - no tests
    - time: negligible
- gzip
    - basic config (`prefix`) and simple build/test/install
    - all 22 tests passed
    - post install: `mv -v $DESTDIR/usr/bin/gzip $DESTDIR/bin`
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
