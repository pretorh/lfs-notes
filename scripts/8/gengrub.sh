#!/usr/bin/env bash

ROOT="$(mount | grep 'on / ' | awk -F' ' '{print $1}')"

echo "#!/bin/sh"
echo "exec tail -n +3 \$0"
echo ""
echo "# begin of generated menuentries for lfs named kernels"

while IFS= read -r -d '' file
do
    linux=${file//\/boot\/}
    echo "menuentry \"$linux\" {"
    echo "    # replace $ROOT with UUID=..."
    echo "    linux $linux root=$ROOT ro"
    echo "}"
done <   <(find /boot -type f -name 'vmlinuz*lfs*' -print0)

echo "# end of generated menuentries for lfs named kernels"
