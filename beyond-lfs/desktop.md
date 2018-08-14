# Setup desktop

## general

Xfce consists of a number of packages and dependencies, so grouping them together here

Why: desktop environment preferred for everyday use

installed version: 4.12.0

links:

- [how to](https://docs.xfce.org/xfce/building)
- [download](http://archive.xfce.org/xfce/)

build order and dependencies:

- `libxfce4util`
    - `glib2`
- `xfconf`
    - `dbus-glib`
- `libxfce4ui`
- `garcon`
- `exo`
- `xfce4-panel`
- `thunar`
- `xfce4-settings`, `xfce4-session`, `xfdesktop`, `xfwm4`, `xfce4-appfinder`, ...
