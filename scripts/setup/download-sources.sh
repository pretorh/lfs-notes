#!/usr/bin/env bash
set -e

ROOT_URL=https://www.linuxfromscratch.org
VERSION=${1:?lfs version not specified}

cd "$LFS/sources"

wget "$ROOT_URL/lfs/downloads/$VERSION/wget-list"
wget "$ROOT_URL/lfs/downloads/$VERSION/md5sums"

function cleanup_list() {
  # remove packages not for systemd version
  # docs
  # grub (using the host's grub)
  # vim and kernel (manually download latest items)
  # replace root urls

  file=$1
  echo "$file:"
  grep "$file" -v \
      -e sysvinit \
      -e eudev \
      -e lfs-bootscripts \
      -e sysklogd \
      -e udev-lfs \
      \
      -e 'python-.*-docs-html' \
      -e systemd-man-pages \
      \
      -e grub \
      -e 'linux-6.' \
      -e vim | \
      \
      sed -s "s|http://www.linuxfromscratch.org|$ROOT_URL|" \
      > "$file.cleaned"
  diff --color "$file" "$file.cleaned" || true
}

function compare_download_and_checklist() {
  awk -F '/' '{print $NF}' wget-list.cleaned | while IFS= read -r file
  do
    if ! grep "$file" md5sums.cleaned >/dev/null ; then
      echo "WARNING: $file is in wget-list, but not in md5sums!" 1>&2
    fi
  done
}

cleanup_list wget-list
cleanup_list md5sums
compare_download_and_checklist

echo -e "enter to continue"
read -r

wget --input-file=wget-list.cleaned --continue || echo "wget failed" >&2
md5sum -c md5sums.cleaned

rm -v md5sums.cleaned wget-list.cleaned wget-list md5sums
