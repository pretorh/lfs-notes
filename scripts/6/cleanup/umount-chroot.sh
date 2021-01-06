#!/usr/bin/env bash

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

umount -v "$LFS"/dev{/pts,}
umount -v "$LFS"/{sys,proc,run}
