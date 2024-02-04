#!/usr/bin/env bash

systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-sysupdate{,-reboot}
