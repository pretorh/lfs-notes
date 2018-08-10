## make-ca

Why: build list of trusted certificates (for https to work)

installed version: 0.7

links:

- [download page](https://github.com/djlucas/make-ca/releases)
- [how to](https://github.com/djlucas/make-ca/blob/master/Makefile)

### commands

#### configure options

no configure scripts

#### tests

none

#### install

`make install DESTDIR=$DESTDIR`

#### post

run the update: `make-ca -g`

install system auto update timer task: `systemctl enable /etc/systemd/system/update-pki.timer`

or download the certs in different dir, and copy from there

```
mkdir -pv ca/etc/ssl
/usr/sbin/make-ca -g -D $(pwd)/ca
```
