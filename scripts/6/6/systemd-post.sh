# cleanup temp symlink (on real root)
rm -f /usr/bin/xsltproc

# remove unnecessary dir
rm -rfv $DESTDIR/usr/lib/rpm

# create sysvinit compatability symlinks
for tool in runlevel reboot shutdown poweroff halt telinit; do
     ln -sfv ../bin/systemctl $DESTDIR/sbin/${tool}
done
ln -sfv ../lib/systemd/systemd $DESTDIR/sbin/init

# create systemd-user-sessions script
cat > $DESTDIR/lib/systemd/systemd-user-sessions << "EOF"
#!/bin/bash
rm -f /run/nologin
EOF
chmod 755 $DESTDIR/lib/systemd/systemd-user-sessions
