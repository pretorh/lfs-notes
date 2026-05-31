#!/usr/bin/env bash
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

echo "chown on LFS ($LFS) root file system"
chown -R root:root "$LFS"/{usr,var,etc,lib64,tools}
ls -l "$LFS"
