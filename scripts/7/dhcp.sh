#!/usr/bin/env sh

echo "creating dhcp for interface named $ETH_NAME"

mkdir -pv /etc/systemd/network/
cat > "/etc/systemd/network/10-$ETH_NAME-dhcp.network" << EOF
[Match]
Name=$ETH_NAME

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF
echo "created /etc/systemd/network/10-$ETH_NAME-dhcp.network:"
cat "/etc/systemd/network/10-$ETH_NAME-dhcp.network"
