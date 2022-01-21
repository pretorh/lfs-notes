#!/usr/bin/env sh

mkdir -pv "$LFS_TGT"/libgcc
ln -vs ../../../libgcc/gthr-posix.h "$LFS_TGT"/libgcc/gthr-default.h
