## libevent

Why: dependency of `tmux`

installed version: `2.1.12`

time: >1.0x (need to rechec with tests)

links:

- [how to](https://github.com/libevent/libevent)
- [downloads](https://github.com/libevent/libevent/releases)

### build

#### configure options

- common: `prefix` and `disable-static`

#### tests

different name: `verify`

got a lot of errors related to "nameserver" and "lock function", but in the end all 10 tests passed

on `2.1.12` there were test failures, need to recheck
