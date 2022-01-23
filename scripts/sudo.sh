#!/usr/bin/env sh
set -e

if [ -z "$LFS" ] ; then
  echo "LFS env is not set!" 1>&2
  exit 1
fi

if [ -z "$1" ] ; then
  sh "$0" bash
  exit 0
fi

echo "sudo with" 1>&2
echo "  LFS: $LFS" 1>&2
echo "  running: $*" 1>&2
sudo --preserve-env=LFS "$@"
