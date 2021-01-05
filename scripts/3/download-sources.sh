#!/usr/bin/env sh

VERSION=${1:-lfs version not specified}

wget "http://www.linuxfromscratch.org/lfs/downloads/$VERSION/wget-list" -O wget-list

# remove sysvinit (on systemd versions), vim and kernel (manually download latest items)
grep -v \
    -e sysvinit \
    -e 'kernel\/v5.x' \
    -e vim wget-list \
    > wget-list.cleaned
diff wget-list wget-list.cleaned

wget --input-file=wget-list.cleaned --continue

wget "http://www.linuxfromscratch.org/lfs/downloads/$VERSION/md5sums" -O md5sums
md5sum -c md5sums
