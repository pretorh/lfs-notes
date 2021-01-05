#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

# create limited directory layout, tool chain directory
mkdir -pv "$LFS/"{bin,etc,lib,lib64,sbin,usr,var}
mkdir -pv "$LFS/tools"

# make lfs user the owner of these
chown -v lfs "$LFS/"{bin,etc,lib,lib64,sbin,usr,var,tools}
