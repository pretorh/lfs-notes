## midnight commander (mc)

Why: file management

installed version: 4.8.21

links:

- [download page](http://ftp.midnight-commander.org/)
- [how to](https://github.com/MidnightCommander/mc/blob/master/doc/INSTALL)

### dependencies

none (only core lfs libs)

### commands

#### configure options

```
./configure --prefix=/usr           \
            --libexecdir=/usr/lib   \
            --sysconfdir=/etc       \
            --with-internal-edit=no \
            --with-diff-viewer=no   \
            --disable-background    \
            --with-screen=ncurses   \
            --without-gpm-mouse     \
            --without-x             \
            --disable-static
```

reason:
- build without: internal editor, diff viewer, "Background code is known to be less stable ... may want to disable it"
- use ncurses
- do not install static libs, no gpm mouse support, less dependencies on x11 libraries,

#### tests

`time make check --jobs=4`

all tests passed

#### install

`make instal DESTDIR=$DESTDIR`

remove some extra installed files:
```
rm -v $DESTDIR/usr/bin/mcview
rm -v $DESTDIR/usr/share/man/man1/mc{edit,view}.1
```

still installed `mcview`, installed man pages for view and edit
TODO: what is: also install "the console screen saver" (`usr/lib/mc/cons.saver`)

quite a lot of skins were installed (`/usr/share/mc/skins`) might want do remove that, especially 256 and 16M files if the terminal will only support 16 colors
