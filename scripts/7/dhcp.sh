#!/usr/bin/env sh

mac=${1?pass the mac address as the first argument}
ETH_NAME=${ETH_NAME-eth0}

mkdir -pv /etc/systemd/network/

echo "creating rule for mac $mac -> $ETH_NAME"
cat > "/etc/systemd/network/10-$ETH_NAME.link" << EOF
[Match]
MACAddress=$mac

[Link]
Name=$ETH_NAME
EOF

echo "creating dhcp for interface named $ETH_NAME"
cat > "/etc/systemd/network/10-$ETH_NAME-dhcp.network" << EOF
[Match]
Name=$ETH_NAME

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF

ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf
