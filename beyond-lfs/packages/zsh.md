## zsh

Why: better shell than bash

installed version: `5.5.1`

links:

- [download page](http://zsh.sourceforge.net/Arc/source.html)
- [how to](https://sourceforge.net/p/zsh/code/ci/master/tree/INSTALL)

### commands

#### configure options

```
./configure --prefix=/usr         \
            --bindir=/bin         \
            --sysconfdir=/etc/zsh \
            --enable-etcdir=/etc/zsh
```

reason: place `zsh` in `/bin` (not `/usr/bin`), place configs in `/etc/zsh` (not in `/usr/etc`?)

#### build

```
time make --jobs 4
```

note: not building the text and html docs

time: 1x

#### tests

`time make check --jobs 4`

a lot of the tests take a few seconds.

50 successful, 0 failures, 1 skipped

time: 1x

#### install

```
make install DESTDIR=$DESTDIR
make infodir=/usr/share/info install.info DESTDIR=$DESTDIR
```

(skipping the `/usr/share/doc/zsh-....` files)

#### post

allow `zsh` to be selected as a shell:

```
echo "/bin/zsh" >> /etc/shells
```

to change your shell: `chsh -s /bin/zsh $(whoami)`
