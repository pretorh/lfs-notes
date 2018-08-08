# FHS
mv -v $DESTDIR/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} $DESTDIR/bin
mv -v $DESTDIR/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} $DESTDIR/bin
mv -v $DESTDIR/usr/bin/{rmdir,stty,sync,true,uname} $DESTDIR/bin
mv -v $DESTDIR/usr/bin/chroot $DESTDIR/usr/sbin
mv -v $DESTDIR/usr/share/man/man1/chroot.1 $DESTDIR/usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 $DESTDIR/usr/share/man/man8/chroot.8

# move to bin
mv -v $DESTDIR/usr/bin/{head,sleep,nice} $DESTDIR/bin
