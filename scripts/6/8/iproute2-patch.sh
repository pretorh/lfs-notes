#!/usr/bin/env sh

# do not install arpd docs
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
# disable 2 modules that need iptables
sed -i 's/.m_ipt.o//' tc/Makefile
