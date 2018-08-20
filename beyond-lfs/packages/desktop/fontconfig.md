## fontconfig

Why: dependency of `libXfont2` in `xorg`

installed version: 2.13.0

links:

- [download page](https://www.freedesktop.org/software/fontconfig/release/)

### dependencies

`freetype` (it fails for `freetype2 >= 21.0.15` but freetype-2.9.1 works)

### commands

#### patch and configure options

`rm -fv src/fcobjshash.h`

`prefix`, `sysconfdir`, `localstatedir`, `disable-docs`, `docdir`

#### tests

`time make check --jobs=4`

all 4 tests passed. the first 3 tests passed instantly, last one took a few seconds

#### post install

installing to fakeroot gave warning for font.cache that was not build

`fc-cache --verbose --system`
