# Setup

## if you need to re-enter choot (mount devices still as in 6)

see `scripts/7/enter-chroot.sh`

# Network

## DHCP

set `ETH_NAME` and run `scripts/7/dhcp.sh`

## resolve.conf

for systemd-resolved: `ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf`

## Hostname

`echo "lfs" > /etc/hostname`

## Hosts

(change `lfs.localdomain` as needed)

```
cat > /etc/hosts << "EOF"
127.0.0.1 localhost
127.0.0.1 lfs.localdomain
::1       localhost
EOF
```

# Hardware clock

Check if hardware clock is set to localtime or utc: `hwclock  --localtime --show`

If set to utc, remove the adjust file: `rm -fv /etc/adjtime`

# LOCALE

see `scripts/7/locale.sh`

# inputrc

see `scripts/7/configs/inputrc` (copy to `/etc/inputrc`)

# Shells

```
cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF
```
