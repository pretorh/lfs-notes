#!/usr/bin/env sh

# do not install arpd docs
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
