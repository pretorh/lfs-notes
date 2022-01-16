#!/usr/bin/env bash

ROOT="$(findmnt / -o UUID | tail -n1)"

echo "#!/bin/sh"
echo "exec tail -n +3 \$0"
echo ""
echo "# begin of generated menuentries for lfs named kernels"

while IFS= read -r -d '' file
do
    base_name=${file//\/boot\/}
    label="LFS: ${base_name:8}"

    echo "menuentry \"$label\" {"
    echo "    linux /$base_name root=UUID=$ROOT ro"
    echo "}"
done <   <(find /boot -type f -name 'vmlinuz*lfs*' -print0)

echo "# end of generated menuentries for lfs named kernels"
