## sudo

Why: to no longer have to logout/login as root just to install packages

installed version: `1.9.12p1`

time: 0.22x real (0.5x user+sys)

links:

- [download page](https://www.sudo.ws/download.html#source)
- [how to](https://www.sudo.ws/install.html)

### build

#### configure options

- force the `PATH` variable: `with-secure-path="/bin:/usr/bin:/usr/sbin:/sbin"`
- add insult messages on incorrect passwords (`with-all-insults`)
- use a more specific pasword prompt (not just "Password:", `with-passprompt="[sudo] password for %p: "`)
- allow `EDITOR` env: `with-env-editor`
- common: `prefix`, `docdir`

#### tests

see `beyond-lfs/packages/scripts/sudo-tests.sh`. all tests passed

#### install

`make install install_uid=1000 install_gid=1000 DESTDIR=$DESTDIR`

reason: installing using `DESTDIR`, but it wants to `chown` and `install` the files.
use your own userid/groupid for the install, and let the unpackaging install it with root's uid/gid

(change a symlink if installing directly to `/` to avoid linking to previous versions)

### configuration

`visudo` to setup sudoers

enabled `sudo` group to run sudo ("Uncomment to allow members of group sudo to execute any command",
so add the group and add users to it:

```
groupadd sudo
usermod -a -G sudo <username>
```
