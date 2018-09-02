# install kernel after build to $DESTDIR

mkdir -pv $DESTDIR/boot

cp -v arch/x86_64/boot/bzImage $DESTDIR/boot/vmlinuz-lfs
cp -v System.map $DESTDIR/boot/System.map
cp -v .config $DESTDIR/boot/config
echo "$VERSION-$(date '+%s')" | tee $DESTDIR/boot/version
