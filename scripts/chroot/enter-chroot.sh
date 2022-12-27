#!/usr/bin/env sh

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

echo "entering chroot"

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login

echo "chroot done, exited with $?"
echo "back on the host system"
