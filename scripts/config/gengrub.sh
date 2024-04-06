#!/usr/bin/env bash

ROOT="$(findmnt / -o SOURCE,UUID | tail -n1)"
IFS=" " read -r -a sources <<< "$ROOT"

echo "#!/bin/sh"
echo "exec tail -n +3 \$0"
echo ""
echo "# begin of generated menuentries for lfs named kernels"

while IFS= read -r -d '' file
do
    base_name=${file//\/boot\/}
    label="${base_name:8}"
    label=${label//lfs-/LFS: }

    echo "menuentry \"$label\" {"
    echo "    load_video"
    echo "    # needs initramfs: linux /$base_name root=UUID=${sources[1]} ro"
    echo "    linux /$base_name root=${sources[0]} ro"
    echo "}"
done <   <(find /boot -type f -name 'vmlinuz-*lfs*' -print0)

echo "# end of generated menuentries for lfs named kernels"
