#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

echo "chown on LFS ($LFS) root filesystem"
chown -R root:root "$LFS"/{etc,var,usr,lib64,tools}
