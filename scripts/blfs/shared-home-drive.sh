#!/usr/bin/env sh
set -e

uuid=$(findmnt /home -o UUID | tail -n1)
fs_type=$(findmnt /home -o FSTYPE | tail -n1)

(
  echo "# shared home drive"
  echo "UUID=$uuid     /home   $fs_type    defaults    1   1"
) >> "$LFS/etc/fstab"

${EDITOR-vim} "$LFS/etc/fstab"
