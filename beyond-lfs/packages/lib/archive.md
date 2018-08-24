## libarchive

Why: requirement for cmake

installed version: `3.3.2`

links:

- [download page](https://www.libarchive.org/)
- download mask: `https://www.libarchive.org/downloads/libarchive-<VERSION>.tar.gz`
- [how to](https://github.com/libarchive/libarchive/wiki/BuildInstructions)

### commands

confige options: `prefix`, `disable-static`

#### tests

time: 1x

seemed to hang after `bsdtar_test`

all 4 tests passed
