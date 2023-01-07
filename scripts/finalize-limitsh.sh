#!/usr/bin/env sh
set -e

tgt_dir=$LFS/tools/libexec/gcc/$LFS_TGT
gcc_version=$(ls "$tgt_dir")

echo "using mkheaders for gcc $gcc_version in $tgt_dir"
"$tgt_dir/$gcc_version"/install-tools/mkheaders
