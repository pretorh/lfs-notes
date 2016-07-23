# Installing the system

## Chroot

See `scripts/6/setup/prepare.sh` and `scripts/6/setup/chroot-setup.sh`

### Re-entering chroot

If you exit chroot, you will need to re-enter it before continuing

- mount the drive (`scripts/2/mount.sh`)
- export the `LFS` env var (`export LFS=/mnt/lfs`)
- ensure the tools directory exists (`scripts/4/setup-tools.sh`)
- setup virtual file systems and enter chroot (`scripts/6/setup/prepare.sh`)
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
Extract and build as normal

#### Tests are critical

`make check` (this took about 3 times longer than `make --jobs 4`)

but some will fail:

- known to fail with latest binutils (FAILed previously, but on a later lfs in XPASSed):
    - elf/tst-protected1a
    - elf/tst-protected1b
- will always fail:
    - posix/tst-getaddrinfo4
    - posix/tst-getaddrinfo5

#### Install glibc
Install glibc (`make install`)

- setup nscd config runtime directory (see `scripts/6/glibc/nscd.sh`)
- setup locales (see `scripts/6/glibc/locale.sh`)

#### Congiure glibc

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

Install timezone data (see `scripts/6/glibc/tz-install.sh`) and configure it:

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

see `scripts/6/toolchain.sh`

### Part 2

- zlib
- file
- binutils
    - First verify PTYs are working in chroot: `expect -c "spawn ls" | grep "spawn ls" && echo "SUCCESS" || echo "FAILED"`
    - The tests are critical
        - The test `Link with zlib-gabi compressed debug output` is known to fail
- gmp
    - The tests are critical. All 190 must pass
- mpfr
    - The tests are critical. All tests must pass
        - `tget_set_d64` was skipped
- mpc

### GCC

Takes *realy* long

on a single core qemu vm:

- Build: about 3 times as long as `glibc`'s build time
- Tests: about 6 times longer than the build

#### Tests
The tests are critical. To run the tests and check the results:

    make -k check --jobs 4
    ../contrib/test_summary | grep -A7 Summ
    ../contrib/test_summary | grep FAIL

Some tests may fail. Compare the results with:

- http://www.linuxfromscratch.org/lfs/build-logs/systemd/
- http://gcc.gnu.org/ml/gcc-testresults
- my list of failed tests: `steps/6-more.md`

#### Install and sanity checks

- install using the normal `make install`
- see `scripts/6/gcc/symlinks.sh`
- see `scripts/6/gcc/fix.sh`

run another sanity check: see `scripts/6/gcc/sanity-check-4.sh`

### Part 3

- bzip2
- pkg-config
- ncurses
- attr
- acl
- libcap
- sed

### Shadow

Enable using:

    pwconv
    grpconv

start groups at 100:

    sed -i /etc/default/useradd -e 's/\(GROUP\)=.*/\1=100/'

disable mail spool:

    sed -i /etc/default/useradd -e 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/'

set the password for root:

    passwd root

### Part 4

- psmisc
- iana-etc
- m4
    - The `test-update-copyright.sh` failure can safely be ignored
- bison
- flex
- grep
- readline

### Bash

To start new bash:

    exec /bin/bash --login +h

### Part 5

- bc
    - 10 tests fail due to round of errors
        - to get the count `cat bc-test-log | grep "Total failures: [^0]"`
        - to get the details: `cat bc-test-log | grep -e "index\|val1\|val2"`
- libtool
    - Five tests are known to fail
        - 123: compiling softlinked libltdl                    FAILED (standalone.at:35)
        - 124: compiling copied libltdl                        FAILED (standalone.at:50)
        - 125: installable libltdl                             FAILED (standalone.at:67)
        - 126: linking libltdl without autotools               FAILED (standalone.at:85)
        - 130: linking libltdl without autotools               FAILED (subproject.at:115)
- gdbm
- expat
- inetutils

### Perl

Setup hosts file: `echo "127.0.0.1 localhost $(hostname)" > /etc/hosts`

### Part 6

- XML-Parser
- autoconf
    - the tests takes very long compared to the build
    - "two tests fail due to changes in libtool-2.4.3 and later"
        - `501: Libtool`
        - `503: autoscan`
- automake
    - the tests takes very long compared to the build
    - run tests with -j4 option to speed it up (even on single core systems)
- coreutils
    - `stty-pairs` test is known to fail
    - `cat gnulib-tests/test-suite.log | grep FAIL`
- diffutils
    - `test-update-copyright.sh` failure can be safely ignored
    - cat gnulib-tests/test-suite.log | grep FAIL
- gawk
- findutils

### Gettext

`cat gettext-tools/tests/test-suite.log | grep FAIL`

- had these failing:
    - xgettext-c-19
    - xgettext-glade-2
    - xgettext-java-2
    - xgettext-python-1
    - xgettext-python-3
    - xgettext-stringtable-1
    - xgettext-tcl-4
    - xgettext-javascript-4
    - xgettext-vala-1

### Part 7

- intltool
- gperf
    - known to fail if running simultaneous(run with `-j1`)
- groff
    - failed when building with --jobs 4, but passed with --jobs 1
    - no tests
- xz
- grub
    - no tests
    - actual boot setup covered after packages installed
- less
    - no tests
- gzip
- iproute2
    - no tests in `chroot`
- kbd
- kmod
    - no tests in `chroot`
- libpipeline
- make
- patch
- sysklogd
    - no configure (just a patch)
    - no tests
- sysvinit
    - no configure (just a patch)
    - no tests
- tar
- texinfo
- eudev
- util-linux
    - the test tests/ts/ipcs/limit fails on recent kernels, can be ignored
- man-db
- vim

## Cleanup

Stip debug comments and remove temp files: see `scripts/6/cleanup/strip.sh`

### No longer in a part

- procps-ng
- e2fsprogs
