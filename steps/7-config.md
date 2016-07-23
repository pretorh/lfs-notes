# Setup

## if you need to re-enter choot (mount devices still as in 6)

    chroot "$LFS" /usr/bin/env -i              \
        HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
        /bin/bash --login

# Network

## DHCP

    cat > /etc/systemd/network/10-eth0-dhcp.network << "EOF"
    [Match]
    Name=eth0
    [Network]
    DHCP=ipv4
    EOF

## Hostname

echo "my lfs-system" > /etc/hostname

## Hosts

    cat > /etc/hosts << "EOF"
    127.0.0.1 localhost
    ::1       localhost
    EOF

# Hardware clock

Check if hardware clock is set to localtime or utc:

    hwclock  --localtime --show

If set to utc, rmeove the adjust file:

    rm -fv /etc/adjtime

# LOCALE

List available locales:

    locale -a

Get the canonical name for the locale

    LC_ALL=en_GB.utf8 locale charmap

test

    LC_ALL=en_GB.UTF-8 locale language
    LC_ALL=en_GB.UTF-8 locale charmap
    LC_ALL=en_GB.UTF-8 locale int_curr_symbol
    LC_ALL=en_GB.UTF-8 locale int_prefix

save

    cat > /etc/locale.conf << "EOF"
    LANG=en_GB.UTF-8
    EOF

# inputrc

    cat > /etc/inputrc << "EOF"
    # Modified by Chris Lynn <roryo@roryo.dynup.net>
    # Allow the command prompt to wrap to the next line
    set horizontal-scroll-mode Off
    # Enable 8bit input
    set meta-flag On
    set input-meta On
    # Turns off 8th bit stripping
    set convert-meta Off
    # Keep the 8th bit for display
    set output-meta On
    # none, visible or audible
    set bell-style none
    # All of the following map the escape sequence of the value
    # contained in the 1st argument to the readline specific functions
    "\eOd": backward-word
    "\eOc": forward-word
    # for linux console
    "\e[1~": beginning-of-line
    "\e[4~": end-of-line
    "\e[5~": beginning-of-history
    "\e[6~": end-of-history
    "\e[3~": delete-char
    "\e[2~": quoted-insert
    # for xterm
    "\eOH": beginning-of-line
    "\eOF": end-of-line
    # for Konsole
    "\e[H": beginning-of-line
    "\e[F": end-of-line
    EOF

# Shells

    cat > /etc/shells << "EOF"
    /bin/sh
    /bin/bash
    EOF
