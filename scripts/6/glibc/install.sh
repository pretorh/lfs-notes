#!/usr/bin/env bash
# ignore expression expanding issue in sed command
# shellcheck disable=SC2016

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install

echo "fix path in ldd"
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

echo "nscd"
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /usr/lib/systemd/system/nscd.service

echo "nsswitch.conf"
cat > /etc/nsswitch.conf << "EOF"
passwd: files
group: files
shadow: files
hosts: files dns
networks: files
protocols: files
services: files
ethers: files
rpc: files
EOF
