#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

echo "chown on LFS ($LFS) root filesystem"
chown -R root:root "$LFS"/{usr,lib,var,etc,bin,sbin,lib64,tools}
ls -l "$LFS"
