#!/usr/bin/env bash
set -e

cd /usr/lib

for file in ld-linux* libc.so.* libthread_db.so.* libquadmath.so.* libstdc++.so.* libitm.so.* libatomic.so.* ; do
  if [ -f "$file.dbg" ] ; then
    echo "$file.dbg already exists"
  elif [ -L "$file" ] ; then
    echo "$file is a symlink"
  elif [ -f "$file" ] ; then
    pre_size="$(du -h "$file" | cut -f1)"
    objcopy --only-keep-debug "$file" "$file.dbg"
    strip --strip-unneeded "$file"
    objcopy --add-gnu-debuglink="$file.dbg" "$file"
    echo "split $file ($pre_size) into $file ($(du -h "$file" | cut -f1)) and $file.dbg ($(du -h "$file.dbg" | cut -f1))"
  fi
done
