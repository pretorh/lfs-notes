#!/usr/bin/env sh

cat > /etc/ld.so.conf << "EOF"
/usr/local/lib
/opt/lib
include /etc/ld.so.conf.d/*.conf
EOF

mkdir -pv /etc/ld.so.conf.d
