#!/usr/bin/env bash
set -e

linux_name=${1?need the name for this kernal as first parameter}

echo "installing modules"
make DESTDIR="$DESTDIR" modules_install

echo "installing '$linux_name' kernel"
mkdir -pv "$DESTDIR"/{boot,etc}
cp -v arch/x86_64/boot/bzImage "$DESTDIR/boot/vmlinuz-$linux_name"
cp -v System.map "$DESTDIR/boot/System.map-$linux_name"
cp -v .config "$DESTDIR/boot/config-$linux_name"

echo "installing docs"
cp -r Documentation -T "$DESTDIR/usr/share/doc/linux-$linux_name"

echo "configure module load order"
install -v -m755 -d "$DESTDIR/etc/modprobe.d"
cat > "$DESTDIR/etc/modprobe.d/usb.conf" << "EOF"
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF
