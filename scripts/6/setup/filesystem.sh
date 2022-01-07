#!/usr/bin/env bash
set -e

# create missing root-level dirs
mkdir -pv /{boot,home,mnt,opt,srv}

# create sub dirs and links
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

# create root home dir, sticky temp dirs
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

# change ownership of previously-created dirs to root
# reference /root, since /etc/passwd not yet populated
chown -R --reference=/root /{bin,etc,lib,lib64,sbin,usr,var,tools}
