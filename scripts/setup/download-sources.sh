#!/usr/bin/env bash
set -e

ROOT_URL=https://www.linuxfromscratch.org
VERSION=${1:?lfs version not specified}

(test -f wget-list && [ "$SKIP_REFRESH" = "1" ] && echo "wget-list already exists") || \
  wget "$ROOT_URL/lfs/downloads/$VERSION/wget-list" -O wget-list
(test -f md5sums && [ "$SKIP_REFRESH" = "1" ] && echo "md5sums already exists") || \
  wget "$ROOT_URL/lfs/downloads/$VERSION/md5sums" -O md5sums

function cleanup_list() {
  # remove packages for systemd version
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
      -e 'linux-5.' \
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

echo "moving sources into $VERSION/"
mkdir -pv "$VERSION"
awk -F '  ' '{print $NF}' md5sums.cleaned | xargs -IFILE mv FILE "$VERSION/"
mv md5sums.cleaned "$VERSION/md5sums"
mv md5sums "$VERSION/md5sums.orig"
mv wget-list.cleaned "$VERSION/wget-list"
mv wget-list "$VERSION/wget-list.orig"