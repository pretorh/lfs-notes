# Notes for Beyond LFS

This is for notes taken while going through the [blfs book/docs](http://www.linuxfromscratch.org/blfs/downloads/stable-systemd)

Started with the [8.2 systemd version](http://www.linuxfromscratch.org/blfs/downloads/stable-systemd/BLFS-BOOK-8.2-systemd-nochunks.html)
though certain packages might update more frequently than others

times are still relative to the `Bin Utils` from lfs chapter 5 (though some contain the user time, ie without paralellism, in brackets)

## Wishlist

This is a wishlist of packages/high level thigngs that should (still) be added.

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

### users

create a new user, making sure the user's uid and gid are the same as current home partition:

get the user id and group id from `stat /home/username`

then create the group: `groupadd --gid 1000 username`

and the user: `useradd --uid 1000 --gid 1000 --no-create-home username`

(replacing `username`, and both `1000` values as needed)

## todo

`libexec`: why is it there, what should be in there (notes on some packages explicitly remove it, others mention the dirs are created)

### build and packaging

todo: publish a few helpers that:

- sets up a fakeroot
- add file system dirs
- package files installed with `DESTDIR`
- apply a package, checking that files dont already exist


