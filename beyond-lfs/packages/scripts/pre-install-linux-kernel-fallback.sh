# run this to backup current kernel as a -fallback

echo "copy current as fallback"
mv -v /boot/vmlinuz-lfs{,-fallback}
mv -v /boot/System.map{,-fallback}
mv -v /boot/config{,-fallback}
mv -v /boot/version{,-fallback}
