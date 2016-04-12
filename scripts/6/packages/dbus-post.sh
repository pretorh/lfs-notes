# move shared lib to /lib
mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

# use same machine-id as systemd
ln -sfv /etc/machine-id /var/lib/dbus
