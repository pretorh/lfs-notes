## tmux

Why: multiple terminals screens

installed version: 2.1.8

links:

- [how to](https://github.com/tmux/tmux)
- [downloads](https://github.com/tmux/tmux/releases)

### dependencies

- libevent

### commands

#### configure options

`prefix`, `disable-static`

#### tests

no tests

#### install

`make install DESTDIR=$DESTDIR`

#### post install

setup configs (`~/.tmux.conf`)

tmux failed to launch using my shared config, due to `set-option -g default-shell /bin/zsh` (zsh was not installed yet, so tmux launched and then exited)
