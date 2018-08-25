## python2

Why: required/optional by a few packages

installed version: `2.7.15`

links:

- [download page](https://www.python.org/ftp/python/)
- download mask: `https://www.python.org/ftp/python/<VERSION>/Python-<VERSION>.tar.xz`

### commands

```
sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4 \
            --enable-optimizations
time make --jobs=8
```

auto started some (399) tests

reason:

- ?

time: 17x

#### tests

`time make -k test --jobs=8`

tests are run sequentially

one test is known to fail. 403 tests (with a failure), then 403

- 356 ok
- one failed: `test_ssl`
- 46 skipped
- 9 unexpected skips

time: 6x

#### install

```
make instal DESTDIR=$DESTDIR
chmod -v 755 $DESTDIR/usr/lib/libpython2.7.so.1.0
rm $DESTDIR/usr/bin/2to3
```
