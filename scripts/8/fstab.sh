echo | awk '{ print "# file system" "\t" "mount" "\t" "type" "\t" "mount-options" "\t" "dump" "\t" "fsck-order" }'
mount | grep "^/dev/" | awk '{ print $1 "\t" $3 "\t" $5 "\t" "defaults" "\t" "1" "\t" "1" }'
echo "# end fstab"
