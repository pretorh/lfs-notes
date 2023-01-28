#!/usr/bin/env sh

# create symlink to use same machine id as systemd
ln -sfv /etc/machine-id /var/lib/dbus
