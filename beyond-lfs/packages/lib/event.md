## libevent

Why: dependency of `tmux`

installed version: `2.1.8`

links:

- [how to](https://github.com/libevent/libevent)
- [downloads](https://github.com/libevent/libevent/releases)

### commands

#### configure options

`prefix`, `disable-static`

#### tests

`time make verify --jobs 4`

got a lot of errors related to "nameserver" and "lock function", but in the end all 10 tests passed

time: 5x

#### install

`make install`
