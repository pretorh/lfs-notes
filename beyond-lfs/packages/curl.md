## curl

Why: Need to be able to download packages from inside LFS

installed version: 7.61.0

links:

- [download page](https://curl.haxx.se/download.html)
- [how to](https://curl.haxx.se/docs/install.html)
- and see the file `GIT-INFO` in the extracted files

### commands

#### configure options

- `--prefix=/usr`
- `--disable-static`
- `--enable-threaded-resolver`
- `--with-ca-path=/etc/ssl/certs`

#### tests

`make test --jobs 4`

time: 6x

+- 930 tests ran, all passed

#### install

`make install`

see notes on installing docs
