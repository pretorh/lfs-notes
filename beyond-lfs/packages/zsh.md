## zsh

Why: preferred shell

installed version: `5.9`

time: 0.7x real (0.47x user+sys)

links:

- [download page](http://zsh.sourceforge.net/Arc/source.html)
- [how to](https://sourceforge.net/p/zsh/code/ci/master/tree/INSTALL)

### build

#### configure options

- create a parent directory for `etc` files: `sysconfdir=/etc/zsh` and `enable-etcdir=/etc/zsh`
- enable: `cap`, `gdbm`
- common: `prefix`

#### tests

a lot of the tests take a few seconds. outputs a few lines to screen ("print", "echo") even though redirecting `stdout` and `stderr`

`62 successful test scripts, 0 failures, 2 skipped`

#### build

also: `makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt` (and others) for infodir

#### install

also:
- `infodir=/usr/share/info install.info`
- copying `/usr/share/doc/zsh-....` files

### configuration

allow `zsh` to be selected as a shell:

```
echo "/bin/zsh" >> /etc/shells
```

to change your shell: `chsh -s /bin/zsh $(whoami)`
