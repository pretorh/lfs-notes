# xorg

## intro

all files can be downloaded from `https://www.x.org/archive/individual/<group>/<name>.tar.bz2`

all files are in `tar.bz2` packages

## config

set env var used in all `configure` commands

`export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"`

(this assumed prefix in `/usr`, not using the `XORG_PREFIX` env var as in the book)

see helper script, that can be `source`d to load this, and set a `DESTDIR`: `packages/desktop/scripts/env.sh`

## xorg util-macros

group: `util`

names:

- `util-macros-1.19.1`

no build commands ("make: Nothing to be done for 'all'") and no tests

## xorg protocol headers

group: `proto`

names and build order:

- `bigreqsproto-1.1.2`
- `compositeproto-0.4.2`
- `damageproto-1.2.1`
- `dmxproto-2.3.1`
- `dri2proto-2.8`
- `dri3proto-1.0`
- `fixesproto-5.0`
- `fontsproto-2.1.3`
- `glproto-1.4.17`
- `inputproto-2.3.2`
- `kbproto-1.0.7`
- `presentproto-1.1`
- `randrproto-1.5.0`
- `recordproto-1.14.2`
- `renderproto-0.11.1`
- `resourceproto-1.2.0`
- `scrnsaverproto-1.2.2`
- `videoproto-2.3.3`
- `xcmiscproto-1.2.2`
- `xextproto-7.3.0`
- `xf86bigfontproto-1.2.0`
- `xf86dgaproto-2.1`
- `xf86driproto-2.1.1`
- `xf86vidmodeproto-2.3.1`
- `xineramaproto-1.2.1`
- `xproto-7.0.31`

no build commands ("make: Nothing to be done for 'all'") and no tests

## libXau and libXdmcp

group: `lib`

names:

- `libXau-1.0.8` (authorization protocol)
- `libXdmcp-1.1.2` (display manager control protocol)

## xcb-proto and libxcb

download packages from: `https://xcb.freedesktop.org/dist/` and patches from `http://www.linuxfromscratch.org/patches/blfs/8.2/`

this assumes only python3 is installed

### xcb-proto

patch and configure:
```
patch -Np1 -i ../xcb-proto-1.12-schema-1.patch
patch -Np1 -i ../xcb-proto-1.12-python3-1.patch
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static
```

expanded `$XORG_CONFIG` variable in configure (had prefix include the other options)

no build commands ("Nothing to be done for 'all'") and no test commands (`python2` and `libxml` required) (though both commands still pass)

### libxcb

patch and configure:

```
patch -Np1 -i ../libxcb-1.12-python3-1.patch
sed -i "s/pthread-stubs//" configure
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --enable-xinput   \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.12
```

normal build, test and install commands. had 1 test that passed

### post install

`sudo /sbin/ldconfig --verbose`


## xorg libraries

group: `lib`

names and build order:

- `xtrans-1.3.5`
- `libX11-1.6.5`
    - tests
- `libXext-1.3.3`
- `libFS-1.0.7`
- `libICE-1.0.9`
    - `./configure $XORG_CONFIG ICE_LIBS=-lpthread`
- `libSM-1.2.2`
- `libXScrnSaver-1.2.2`
- `libXt-1.1.5`
    - `./configure $XORG_CONFIG --with-appdefaultdir=/etc/X11/app-defaults`
    - tests
- `libXmu-1.1.2`
- `libXpm-3.5.12`
- `libXaw-1.0.13`
- `libXfixes-5.0.3`
- `libXcomposite-0.4.4`
- `libXrender-0.9.10`
- `libXcursor-1.1.15`
- `libXdamage-1.1.4`
- `libfontenc-1.1.3`
- `libXfont2-2.0.3`
    - dependencies: `freetype` and `fontconfig`
    - `./configure $XORG_CONFIG --disable-devel-docs`
- `libXft-2.3.2`
- `libXi-1.7.9`
- `libXinerama-1.1.3`
- `libXrandr-1.5.1`
- `libXres-1.2.0`
- `libXtst-1.2.3`
- `libXv-1.0.11`
- `libXvMC-1.0.10`
- `libXxf86dga-1.1.4`
- `libXxf86vm-1.1.4`
- `libdmx-1.1.3`
- `libpciaccess-0.14`
- `libxkbfile-1.0.9`
- `libxshmfence-1.2`
    - `./configure $XORG_CONFIG CFLAGS="$CFLAGS -D_GNU_SOURCE"`
    - tests

to run tests and check results:

```
make check 2>&1 | tee make_check.log
grep -A9 summary make_check.log
```

after each, as root: `/sbin/ldconfig`

## xcb-utils

download packages from: `https://xcb.freedesktop.org/dist/`

considered merging with `xcb-proto` and `libxcb` (these seem to only depend on `libxcb`) but their versions are all related

see build script: `packages/desktop/scripts/xcb-util-build.sh`

names and order:

- `xcb-util-0.4.0`
- `xcb-util-image-0.4.0`
    - test: `LD_LIBRARY_PATH=$XORG_PREFIX/lib make check`
    - one test, passed
- `xcb-util-keysyms-0.4.0`
- `xcb-util-renderutil-0.3.9`
- `xcb-util-wm-0.4.1`
- `xcb-util-cursor-0.1.3`

all can be configured with `./configure $XORG_CONFIG`

tests can be run on all, but only `xcb-util-image` has tests

## mesa

see external mesa doc

## xbitmaps

group: `data`

names: `xbitmaps-1.1.1`

## xorg applications

group: `app`

names and build order:

- `iceauth-1.0.7`
- `luit-1.1.1`
    - patch with: `sed -i -e "/D_XOPEN/s/5/6/" configure`
- `mkfontdir-1.0.7`
- `mkfontscale-1.1.2`
- `sessreg-1.1.1`
- `setxkbmap-1.3.1`
- `smproxy-1.0.6`
- `x11perf-1.6.0`
- `xauth-1.0.10`
- `xbacklight-1.2.1`
- `xcmsdb-1.0.5`
- `xcursorgen-1.0.6`
    - dependencies: libpng >= 1.2.0
- `xdpyinfo-1.3.2`
- `xdriinfo-1.0.5`
    - dependencies: mesa
- `xev-1.2.2`
- `xgamma-1.0.6`
- `xhost-1.0.7`
- `xinput-1.6.2`
- `xkbcomp-1.4.0`
- `xkbevd-1.1.4`
- `xkbutils-1.0.4`
- `xkill-1.0.4`
- `xlsatoms-1.1.2`
- `xlsclients-1.1.3`
- `xmessage-1.0.4`
- `xmodmap-1.0.9`
- `xpr-1.0.4`
- `xprop-1.2.2`
- `xrandr-1.5.0`
    - pre package: `rm -v $DESTDIR/usr/bin/xkeystone` ("undocumented script which is reported to be broken")
- `xrdb-1.1.0`
- `xrefresh-1.0.5`
- `xset-1.2.3`
- `xsetroot-1.1.1`
- `xvinfo-1.1.3`
- `xwd-1.0.6`
- `xwininfo-1.1.3`
- `xwud-1.0.4`

## xcursor-themes

group: `data`

names and build order:

- xcursor-themes-1.0.4

## xorg fonts

group: `font`

names and build order:

- `font-util-1.3.1`
- `encodings-1.0.4`
- `font-alias-1.0.3`
- `font-adobe-utopia-type1-1.0.4`
- `font-bh-ttf-1.0.3`
- `font-bh-type1-1.0.3`
- `font-ibm-type1-1.0.3`
- `font-misc-ethiopic-1.0.3`
- `font-xfree86-type1-1.0.4`

recreate `fonts.scale` and `fonts.dir` files after unpacking:

```
mkfontscale /usr/share/fonts/X11/{Type1,TTF,OTF}/
mkfontdir /usr/share/fonts/X11/{Type1,TTF,OTF}/
fc-cache -s --verbose
```

setup symlinks to `X11-*`:

```
install -v -d -m755 $DESTDIR/usr/share/fonts/X11/{OTF,TTF}
ln -svfn $DESTDIR/usr/share/fonts/X11/OTF $DESTDIR/usr/share/fonts/X11-OTF
ln -svfn $DESTDIR/usr/share/fonts/X11/TTF $DESTDIR/usr/share/fonts/X11-TTF
```

## XKeyboardConfig

group: `data/xkeyboard-config`

build: `xkeyboard-config-2.23.1` with additional config `--with-xkb-rules-symlink=xorg`

## xorg server

group: `xserver`

dependencies:

- `pixman-1 >= 0.27.2`
- `epoxy`

build `xorg-server-1.19.6` with additional configs:

- `--enable-glamor`
- `--enable-suid-wrapper`
- `--with-xkb-output=/var/lib/xkb`

### tests

"You will need to run ldconfig as the root user first or some tests may fail."

tests passed (without running `ldconfig`): 11 passed + 1 skipped; 1/1 passed; 11/11 passed

### install

```
make install DESTDIR=$DESTDIR
mkdir -pv $DESTDIR/etc/X11/xorg.conf.d
```

## packages for testing

see external file: `xorg-test-setup.md`
