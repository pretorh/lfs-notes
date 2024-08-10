#!/usr/bin/env bash
set -e

root_columns="$(findmnt --target "$0" -o SOURCE,UUID,PARTLABEL | tail -n1)"
IFS=" " read -r -a script_roots <<< "$root_columns"
root_dev=${script_roots[0]}
root_uuid=${script_roots[1]}
root_label=${script_roots[2]}
if [ -z "$root_label" ] ; then root_label=$root_uuid ; fi

is_first=1

output() {
    echo "[LFS-grub] $*" >&2
}

add_menuentry() {
    root_mode=$1
    base_name=$2

    root=$root_dev
    if [ "$root_mode" == "uuid" ] ; then
        root="UUID=$root_uuid"
    fi

    label="${base_name:8}"
    label=${label//lfs-/}

    indent="    "
    if [ "$is_first" ] ; then
        indent=""
        label="LFS on $root with $label"
    elif [ "$root_mode" == "uuid" ] ; then
        label="$label (UUID)"
    fi

    echo "${indent}menuentry '$label' {"
    echo "${indent}    load_video"
    echo "${indent}    linux /$base_name root=$root ro"
    echo "${indent}}"
}

output "generating menu entries for $root_label"
while read -r file; do
    output "found vmlinuz $file"
    base_name=${file//\/boot\/}

    if [ "$is_first" ] ; then
        add_menuentry "dev" "$base_name"
        is_first=
        echo ""
        echo "submenu 'LFS on $root_label' {"
    else
        add_menuentry "dev" "$base_name"
    fi

    add_menuentry "uuid" "$base_name"
done <   <(ls -1 /boot/vmlinuz-*lfs* --sort=time)

if [ "$is_first" ] ; then
    output "no vmlinuz-*lfs* kernels found!"
    echo "# no LFS kernels found"
else
    echo "}"
fi
