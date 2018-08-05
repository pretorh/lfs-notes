LINUX_VERSION=4.17.9

# setup
mkdir -pv $DESTDIR/{boot,etc}

cp -v arch/x86_64/boot/bzImage $DESTDIR/boot/vmlinuz-$LINUX_VERSION-lfs
cp -v System.map $DESTDIR/boot/System.map-$LINUX_VERSION
cp -v .config $DESTDIR/boot/config-$LINUX_VERSION

install -d $DESTDIR/usr/share/doc/linux-$LINUX_VERSION
cp -r Documentation/* $DESTDIR/usr/share/doc/linux-$LINUX_VERSION

echo "configure module load order"
install -v -m755 -d $DESTDIR/etc/modprobe.d
cat > $DESTDIR/etc/modprobe.d/usb.conf << "EOF"
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF

unset LINUX_VERSION
