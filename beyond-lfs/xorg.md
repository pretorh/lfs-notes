# xorg

## intro

all files can be downloaded from `https://www.x.org/archive/individual/<group>/<name>`

## config

set env var used in all `configure` commands

`export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"`

(this assumed prefix in `/usr`, not using the `XORG_PREFIX` env var as in the book)

see helper script, that can be `source`d to load this, and set a `DESTDIR`: `packages/desktop/scripts/env.sh`

## xorg util-macros

group: `util`

names:

- `util-macros-1.19.1`
