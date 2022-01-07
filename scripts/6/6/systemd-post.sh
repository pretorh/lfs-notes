#!/usr/bin/env sh

# cleanup temp symlink (on real root)
rm -f /usr/bin/xsltproc

systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-time-wait-sync.service
rm -f /usr/lib/sysctl.d/50-pid-max.conf
