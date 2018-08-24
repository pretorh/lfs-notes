## libpng

Why: dependency of xorg applications

installed version: `1.6.35`

links:

- [download page](https://sourceforge.net/projects/libpng/files/)

### commands

#### configure options

`LIBS=-lpthread ./configure --prefix=/usr --disable-static`

#### tests

`make check --jobs=4`

all 33 tests passed

time: about 1x
