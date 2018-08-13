## glib

Why: dependency of `libxfce4util`

installed version: 2.56.1

links:

- [download page](http://ftp.gnome.org/pub/gnome/sources/glib/)
- [how to](https://developer.gnome.org/glib/2.56/glib-building.html)

### dependencies

none

### commands

#### configure options

make sure your locale is set correctly.

build outside of source directory.

used configure, was easier to use `--disable-selinux`

```
mkdir bd && cd bd
../configure --prefix=/usr --disable-selinux --with-pcre=internal
```

#### tests

requires `desktop-file-utils`, but that requires glib2

#### install

```
make install DESTDIR=$DESTDIR
chmod -v 755 $DESTDIR/usr/bin/{gdbus-codegen,glib-gettextize}
```

(yes, "text ize", not "size")

#### post

maybe build `desktop-file-utils`, then run `glib2` tests
