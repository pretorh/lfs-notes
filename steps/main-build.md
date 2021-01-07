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
