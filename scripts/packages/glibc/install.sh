#!/usr/bin/env bash
# ignore expression expanding issue in sed command
# shellcheck disable=SC2016

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install

echo "fix path in ldd"
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

echo "nsswitch.conf"
cat > /etc/nsswitch.conf << "EOF"
passwd: files systemd
group: files systemd
shadow: files systemd
hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files
protocols: files
services: files
ethers: files
rpc: files
EOF
