cd $LFS/sources
export VERSION=xxxxxx

wget http://www.linuxfromscratch.org/lfs/downloads/$VERSION/wget-list
wget --input-file=wget-list --continue
wget --continue http://www.linuxfromscratch.org/patches/lfs/systemd/systemd-229-compat-1.patch
wget --continue http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-229.tar.xz
