# System config

## Setup

### if you need to re-enter choot (mount devices still as in 6)

Use the same command as before. it differs with only the `+h` to bash
see `scripts/6/setup/enter-chroot.sh`

## Network

Get the mac address for your eth device (`ifconfig`).
Run `scripts/7/dhcp.sh <mac-address>` to create a rule for the mac address (named `eth0` by default) and setup DHCP for it

Hostname: `echo "lfs" > /etc/hostname`

Hosts: (change `lfs.localdomain` as needed)

```
cat > /etc/hosts << "EOF"
127.0.0.1 localhost
127.0.0.1 lfs.localdomain
::1       localhost
EOF
```

## Hardware clock

Check if hardware clock is set to localtime or utc: `hwclock  --localtime --show`

If set to utc, remove the adjust file: `rm -fv /etc/adjtime`

# Other

Locale: see `scripts/7/select-locale.sh`

inputrc: see `scripts/7/configs/inputrc` (copy to `/etc/inputrc`)

Shells:

```
cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF
```
