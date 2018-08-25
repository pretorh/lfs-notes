## wayland and wayland-protocols

Why: required by mesa, kde

installed version: `1.16.0` for wayland and `1.16` for -protocols

links:

- [download page](https://wayland.freedesktop.org/releases.html)
- download mask: `https://wayland.freedesktop.org/releases/wayland-<VERSION>.tar.xz`
- download mask: `https://wayland.freedesktop.org/releases/wayland-protocols-<VERSION>.tar.xz`
- [how to](https://wayland.freedesktop.org/building.html)

### dependencies

`libxml2`

### wayland

`prefix`, `distable-static`, `disable-documentation`

all 23 tests passed

### wayland-protocols

`prefix`

no build: "nothing to be done for 'all'"

all 23 tests passed
