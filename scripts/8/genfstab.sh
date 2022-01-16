#!/usr/bin/env bash

printf '# %s\t\t\t\t%s\t%s\t%s\t%s\t%s\n' "file system uuid" "mount point" "type" "mount-options" "dump" "fsck-order"

while IFS= read -r line; do
  # change prefix to /
  line=${line//$LFS\//\/}
  line=${line//$LFS/\/}
  # split into fields
  IFS=" " read -r -a fields <<< "$line"

  device="${fields[3]:0:3}"

  printf '# %s\n' "$(lsblk -o KNAME,MODEL "/dev/$device" | grep "^$device ")"
  printf 'UUID=%s\t%s\t\t%s\t%s\t%s\t%s\n' "${fields[0]}" "${fields[1]}" "${fields[2]}" "defaults" "1" "1"
done < <(lsblk -o UUID,MOUNTPOINT,FSTYPE,KNAME | grep "$LFS")

echo "# end fstab"
