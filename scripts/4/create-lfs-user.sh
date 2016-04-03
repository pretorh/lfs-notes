groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
EOF
echo "LFS=`echo $LFS`" >> /home/lfs/.bashrc
cat >> /home/lfs/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH

cd $LFS/sources
echo "lfs is set to $LFS"
echo "path contains $PATH"
echo "starting lfs specific directory (`pwd`)"
EOF
cat /home/lfs/.bashrc
chown -v lfs:lfs /home/lfs/.bashrc

chown -vR lfs $LFS/tools
chown -vR lfs $LFS/sources

# allow ssh from same users as current user
mkdir -vp /home/lfs/.ssh
cp -v ~/.ssh/authorized_keys /home/lfs/.ssh/
