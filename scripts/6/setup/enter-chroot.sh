#!/usr/bin/env sh

echo "entering chroot"

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin  \
    /bin/bash --login +h

echo "chroot done"
echo "back on the host system"
