## tmux

Why: multiple terminals screens

installed version: `3.3a`

time: negligible

links:

- [how to](https://github.com/tmux/tmux)
- [downloads](https://github.com/tmux/tmux/releases)

### dependencies

- `libevent`

### build

#### configure options

- common: `prefix` and `disable-static`

#### post install

setup configs (`~/.tmux.conf`)

`tmux` failed to launch using my shared config, due to `set-option -g default-shell /bin/zsh` (`zsh` was not installed yet,
so `tmux` launched and then exited)
