# System config

## Setup

Use `scripts/chroot/enter-chroot.sh` if you need to re-enter chroot. See `2-chroot-temp-system2.md`.

## Network

Get the mac address for your eth device (`ifconfig` or `ip addr show | grep -B1 'link/ether'`).

Run `scripts/config/dhcp.sh <mac-address>` to create a rule for the ethernet (named `eth0` by default) from it's mac address and to setup DHCP on it

Run `scripts/config/host.sh <hostname>` to set hostname and create hosts file

## Hardware clock

Check if hardware clock is set to localtime or utc: `hwclock  --localtime --show`

If set to utc, remove the adjust file: `rm -fv /etc/adjtime`

## Other

Locale: run `scripts/config/select-locale.sh`

`inputrc`: copy `scripts/config/inputrc` to `/etc/inputrc`

Shells:

```
cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF
```
