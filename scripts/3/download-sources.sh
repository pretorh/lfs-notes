#!/usr/bin/env bash
set -e

ROOT_URL=https://www.linuxfromscratch.org
VERSION=${1:?lfs version not specified}

wget "$ROOT_URL/lfs/downloads/$VERSION/wget-list" -O wget-list
wget "$ROOT_URL/lfs/downloads/$VERSION/md5sums" -O md5sums

function cleanup_list() {
  # remove sysvinit (on systemd versions)
  # vim and kernel (manually download latest items)
  # replace root urls
  file=$1
  grep "$file" -v \
      -e sysvinit \
      -e 'linux-5.' \
      -e vim | \
      sed -s "s|http://www.linuxfromscratch.org|$ROOT_URL|" \
      > "$file.cleaned"
}

cleanup_list wget-list
cleanup_list md5sums

echo "file list changes:"
echo "wget-list:"
diff wget-list wget-list.cleaned || true
echo "md5sums:"
diff md5sums md5sums.cleaned || true
echo -e "enter to continue"
read -r

wget --input-file=wget-list.cleaned --continue || echo "wget failed" >&2
md5sum -c md5sums.cleaned
