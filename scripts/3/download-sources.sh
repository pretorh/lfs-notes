#!/usr/bin/env sh

VERSION=${1:-lfs version not specified}

wget "http://www.linuxfromscratch.org/lfs/downloads/$VERSION/wget-list" -O wget-list
wget --input-file=wget-list --continue

wget "http://www.linuxfromscratch.org/lfs/downloads/$VERSION/md5sums" -O md5sums
md5sum -c md5sums
