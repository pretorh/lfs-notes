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
