#!/usr/bin/env sh

# remove directory
rm -rf /usr/lib/pam.d

systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-time-wait-sync.service
