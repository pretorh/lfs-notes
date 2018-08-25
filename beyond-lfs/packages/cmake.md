## cmake

Why: dependency of llvm

installed version: `3.12.1`

links:

- [download page](https://cmake.org/files/)
- direct link mask: `https://cmake.org/files/v<VERSION_MAJOR>.<VERSION_MINOR>/cmake-<VERSION>.tar.gz`

### dependencies

- `libarchive` (unless `--no-system-libarchive`)
- `libuv >= 1.10.0`

### commands

to not install in lib64 dir:

`sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake`

configure:
(not installing in a versioned doc dir)

```
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake \
            --parallel=8
```

use `parallel=8` option to speed up bootstrap

time: 1x (6x)

build using normal `make --jobs=8`

time: 2x (13x)

#### tests

`./bin/ctest -j8 -O cmake-test.log`

using 8 cores. change based on cpu core count

time: 4x (20x)

got a few segfaults during some of the tests

after python2 installed, all tests passed

7 tests failed (before python2 installed):

- 60 - ExportImport (Failed)
- 68 - StagingPrefix (Failed)
- 119 - SimpleInstall (Failed)
- 120 - SimpleInstall-Stage2 (Failed)
- 181 - CTestTestUpload (Failed)
- 261 - CMakeOnly.MajorVersionSelection-PythonInterp_2 (Failed)
- 399 - RunCMake.install (Failed)
