echo "creating dhcp for interface named $ETH_NAME"

mkdir -pv /etc/systemd/network/
cat > /etc/systemd/network/10-eth0-dhcp.network << EOF
[Match]
Name=$ETH_NAME

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF
cat /etc/systemd/network/10-eth0-dhcp.network
