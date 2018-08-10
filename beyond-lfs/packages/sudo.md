## sudo

Why: to no longer have to logout/login as root just to install packages

installed version: 1.8.23

links:

- [download page](https://www.sudo.ws/download.html#source)
- [how to](https://www.sudo.ws/install.html)

### commands

#### configure options

```
configure --prefix=/usr                                         \
          --libexecdir=/usr/lib                                 \
          --with-secure-path="/bin:/usr/bin:/usr/sbin:/sbin"    \
          --with-all-insults                                    \
          --with-passprompt="[sudo] password for %p: "
```

reason: set sane install paths, use specific `PATH` envvar when execuring in `sudo`,
add insult messages on incorrect passwords, use a more specific pasword prompt (not just "Password:")

#### tests

```
env LC_ALL=C make check 2>&1 | tee ../make-check.log
grep failed ../make-check.log
```

#### install

`make install install_uid=1000 install_gid=1000 DESTDIR=$DESTDIR`

reason: installing using `DESTDIR`, but it wants to `chown` and `install` the files.
use your own userid/groupid for the install, and let the unpackaging install it with root's uid/gid

(change a symlink if installing directly to `/` to avoid linking to previous versions)

#### post

`visudo` to setup sudoers

enabled `sudo` group to run sudo ("Uncomment to allow members of group sudo to execute any command",
so add the group and add users to it:

```
groupadd sudo
usermod -a -G sudo <username>
```
