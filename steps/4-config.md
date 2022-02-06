# System config

## Setup

### if you need to re-enter choot (mount devices still as in 6)

Use the same command as before. it differs with only the `+h` to bash
see `scripts/6/setup/enter-chroot.sh`

## Network

Get the mac address for your eth device (`ifconfig`).

Run `scripts/7/dhcp.sh <mac-address>` to create a rule for the mac address (named `eth0` by default) and setup DHCP for it

Run `scripts/7/host.sh <hostname>` to set hostname and create hosts file

## Hardware clock

Check if hardware clock is set to localtime or utc: `hwclock  --localtime --show`

If set to utc, remove the adjust file: `rm -fv /etc/adjtime`

# Other

Locale: see `scripts/7/select-locale.sh`

`inputrc`: copy `scripts/7/configs/inputrc` to `/etc/inputrc`

Shells:

```
cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF
```
