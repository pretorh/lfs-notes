#!/usr/bin/env bash
set -e

ROOT=${1?pass relative root path as the first argument}
echo "spliting relative to $ROOT"
cd "$ROOT/usr/lib"

for file in ld-linux* libc.so.* libthread_db.so.* libquadmath.so.* libstdc++.so.* libitm.so.* libatomic.so.* ; do
  if [ -f "$file.dbg" ] ; then
    echo "$file.dbg already exists"
  elif [ "${file: -4}" == ".dbg" ] ; then
    echo "skipping .dbg file $file"
  elif [ -L "$file" ] ; then
    echo "$file is a symlink"
  elif [ -f "$file" ] ; then
    pre_size="$(du -h "$file" | cut -f1)"
    objcopy --only-keep-debug "$file" "$file.dbg"
    cp "$file" "/tmp/$file.bak"
    cp "$file" "/tmp/$file"
    strip --strip-unneeded "/tmp/$file"
    objcopy --add-gnu-debuglink="$file.dbg" "/tmp/$file"
    install -vm755 "/tmp/$file" "$file"
    echo "split $file ($pre_size) into $file ($(du -h "$file" | cut -f1)) and $file.dbg ($(du -h "$file.dbg" | cut -f1))"
  fi
done
