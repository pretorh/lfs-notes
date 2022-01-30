#!/usr/bin/env bash

ROOT=${1?pass relative root path as the first argument}
echo "working relative to $ROOT"

ignore_warnings() {
	grep -iv \
        -e "file format not recognized" \
        -e "is not an ordinary file" \
        - || true
}

echo "stipping debug symbols"
while IFS= read -r -d '' file
do
  strip --strip-unneeded "$file" 2>&1 | ignore_warnings
done <   <(find "$ROOT"/usr/lib -type f -name '*.so*' ! -name '*dbg' -print0
           find "$ROOT"/usr/lib -type f -name '*.a' -print0
           find "$ROOT"/usr/{bin,sbin,libexec} -type f -print0)

echo "cleanup: /tmp"
rm -rf "$ROOT"/tmp/*

echo "Remove libtool archives"
find "$ROOT"/usr/lib "$ROOT"/usr/libexec -name \*.la -delete

echo "Remove previous partially installed compiler"
find "$ROOT"/usr -depth -name "$(uname -m)"-lfs-linux-gnu\* -print0 | xargs -0 rm -rvf
