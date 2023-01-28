#!/usr/bin/env sh

sed -e '/m64=/s/lib64/lib/' \
    -i.orig gcc/config/i386/t-linux64
