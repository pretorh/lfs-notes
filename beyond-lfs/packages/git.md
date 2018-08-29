## git

Why: source control

installed version: `2.18.0`

links:

- [download page](https://www.kernel.org/pub/software/scm/git/)
- download masks:
    - git: `https://mirrors.edge.kernel.org/pub/software/scm/git/git-<VERSION>.tar.xz`
    - man pages: `https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-<VERSION>.tar.xz`

### commands

`prefix`, `--with-gitconfig=/etc/gitconfig`

test with `make test --jobs=8`

tests runs in parallel, and produce a lot of output. all tests passed (153)

2x times

```
make instal DESTDIR=$DESTDIR
tar -xf ../git-manpages-*.tar.xz -C $DESTDIR/usr/share/man --no-same-owner --no-overwrite-dir
```
