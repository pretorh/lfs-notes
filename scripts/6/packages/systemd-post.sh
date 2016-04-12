mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib

rm -rfv /usr/lib/rpm

for tool in runlevel reboot shutdown poweroff halt telinit; do
     ln -sfv ../bin/systemctl /sbin/${tool}
done
ln -sfv ../lib/systemd/systemd /sbin/init

systemd-machine-id-setup
