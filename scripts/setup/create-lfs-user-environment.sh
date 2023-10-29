#!/usr/bin/env sh
set -e

[ -z "$LFS" ] && echo "LFS env var is not set!" && exit 1

# replace shell with empty environment (except HOME TERM PS1)
cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << EOF
set +h
umask 022
LFS=$LFS
EOF
cat >> /home/lfs/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=$LFS/tools/bin:/bin:/usr/bin
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
# added for debugging
cd $LFS
echo "lfs is set to $LFS"
echo "path contains $PATH"
echo "starting in lfs specific directory (`pwd`)"
EOF

# allow ssh from same users as currently logged in user
mkdir -vp /home/lfs/.ssh
chmod -v 0700 /home/lfs/.ssh
cp -v /home/"$(logname)"/.ssh/authorized_keys /home/lfs/.ssh/ || echo "failed to copy ssh authorized_keys"

chown -Rv lfs:lfs /home/lfs/.bash_profile /home/lfs/.bashrc /home/lfs/.ssh
echo ""
cat /home/lfs/.bash_profile
echo ""
cat /home/lfs/.bashrc
