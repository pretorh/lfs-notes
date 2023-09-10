# Notes for Beyond LFS

This is for notes taken while going through the [blfs book/docs](http://www.linuxfromscratch.org/blfs/downloads/stable-systemd), [online](https://www.linuxfromscratch.org/blfs/view/stable-systemd/)

Started with the [8.2 systemd version](http://www.linuxfromscratch.org/blfs/downloads/stable-systemd/BLFS-BOOK-8.2-systemd-nochunks.html)
though certain packages might update more frequently than others

times are still relative to the `Bin Utils` from lfs chapter 5 (though some contain the user time, ie without paralellism, in brackets)

## Wishlist

This is a wishlist of packages/high level things that should (still) be added.

The goal will be to make this LFS build stable/feature complete enough to be used as an everyday distro

For that, the top level things needed:

- coding
- browser
- media
- games (steam)

So the wishlist packages (not really in a specific order):

- firefox
- X, xfce
- mplayer
- steam
- graphics drivers
- docker
- ssh
- nodejs
- geany
- gnupg
- gparted
- htop
- rsync
- redis
- slim
- keepassx2
- visual studio code
- dropbox
- nghttp2

## Configurations

### shared home partition

mount another system's `/home` partition

on the host/"other" system, use `findmnt` to get the uuid of the filesystem and generate an entry for `/etc/fstab`:

see `scripts/blfs/shared-home-drive.sh`

### users

create a new user, making sure the user's `uid` and `gid` are the same as current home partition:

get the user id and group id from `stat /home/$LOGNAME`

then create the group: `groupadd --gid 1000 username`

and the user: `useradd --uid 1000 --gid 1000 --no-create-home username`

(replacing `username`, and both `1000` values as needed)

### build and packaging

todo: publish a few helpers that:

- sets up a fakeroot
- add file system dirs
- package files installed with `DESTDIR`
- apply a package, checking that files dont already exist

## packages

This is only showing a quick overview of the packages. See
[BLFS main page](https://www.linuxfromscratch.org/blfs/view/stable-systemd/) for details of packages.

Keys:
- Build-config: non-trivial configuration needed to setup sources
- Install: Special installation steps required
- Test: non-trivial test setup; information about tests
- Post-config: post install configuration needed

### general

a list of packages that is useful to install first (makes it easier to install other packages)

- sudo: Build-config
  - Install: `make install install_uid=1000 install_gid=1000 DESTDIR=$DESTDIR` when using fake roots
  - Test: `beyond-lfs/packages/scripts/sudo-tests.sh`
  - Post-config: add group
- zsh:
  - Test: a lot of the tests take a few seconds. outputs a few lines to screen ("print", "echo") even though redirecting `stdout` and `stderr`
  - Post-config: allow shell `echo "/bin/zsh" >> /etc/shells`, change your shell: `chsh -s /bin/zsh $(whoami)`
- tmux

### dependencies

a list of packages to install for dependencies which require non-trivial/non-standard steps

- libevent:
  - Test: `make verify`. "6/353 TESTS FAILED"
