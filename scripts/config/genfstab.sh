#!/usr/bin/env bash

printf '#    %-40s %-20s %-5s %-13s %-3s %-3s\n' \
  "file system uuid" "mount point" "type" "mount-options" "dump" "fsck-order"

while IFS= read -r line; do
  # change prefix to /
  line=${line//$LFS\//\/}
  line=${line//$LFS/\/}
  # split into fields
  IFS=" " read -r -a fields <<< "$line"

  device="${fields[3]:0:3}"

  echo ""
  printf '# %s %s\n' "${fields[3]}" "$(lsblk -o MODEL "/dev/$device" | grep -vE "^$" | grep -vE "MODEL")"
  printf 'UUID=%-40s %-20s %-5s %-13s %-3s %-3s\n' "${fields[0]}" "${fields[1]}" "${fields[2]}" "defaults" "1" "1"
done < <(lsblk -o UUID,MOUNTPOINT,FSTYPE,KNAME | grep "$LFS")
