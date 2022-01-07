#!/usr/bin/env sh

ROOT_URL=https://lfs.nistix.com
VERSION=${1:-lfs version not specified}

wget "$ROOT_URL/lfs/downloads/$VERSION/wget-list" -O wget-list

# remove sysvinit (on systemd versions), vim and kernel (manually download latest items)
# replace root urls
grep -v \
    -e sysvinit \
    -e 'kernel\/v5.x' \
    -e vim wget-list | \
    sed -s "s|http://www.linuxfromscratch.org|$ROOT_URL|" \
    > wget-list.cleaned
diff wget-list wget-list.cleaned

wget --input-file=wget-list.cleaned --continue

wget "$ROOT_URL/lfs/downloads/$VERSION/md5sums" -O md5sums
md5sum -c md5sums
