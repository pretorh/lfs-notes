## xorg packages for testing

Why: testing xorg setup

These are not part of xorg, but used as dependency for other packages and for testing xorg setup

Installing the latest versions here

Re-arranged the order of installation to install from most-like-other-xorg to least-like...


### xclock

xorg group name: `app`

file: `xclock-1.0.7`

normal xorg config, make and install


### xinit

xorg group name: `app`

file: `xinit-1.3.4`

additional configure options: `--with-xinitdir=/etc/X11/app-defaults`


### twm

xorg group name: `app`

file: `twm-1.0.10`

patch and configure:

```
sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in
./configure $XORG_CONFIG
```


### xterm

version: `335`

download mask: `https://invisible-mirror.net/archives/xterm/xterm-<VERSION_NUMBER>.tgz`

to patch (terminal input "for consistency with the Linux console") configure and build, see `xterm-build.sh` script

a lot of `/usr/share/terminfo/` files gets overwritten by this
