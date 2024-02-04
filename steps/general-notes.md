# General notes

## Timings

Add the `user` and `sys` output as this would give an indication of how long serial-only builds could take (some packages do not run much faster on parallel)

Tracking the first GCC pass (the 2nd package) is also useful, as it is about 10 times longer than Binutils (making
it one of the longest building packages)

The longest build/testing packages are GCC (more than 100x)

Added my timings, around *all steps*: extracting, patch, configure, build and test (mostly with `--jobs 4`), install and post-install scripts
All times are relative to Binutils pass 1's `real` time

Small times are not shown (should be less than Binutils pass 1 in `real` time)

## sudo

You can run sudo with `sudo --preserve-env=LFS` in order to keep the LFS variable  
`scripts/sudo.sh <command>` does this, calling `<command>`

## Qemu

to use qemu:
- set `MEMORY` with the GB amount of ram for the vm
- set `LIVE_ISO` with the path to an iso for a live cd (ex Arch Linux)
- set `DRIVE1/DRIVE2`... with the path to drive images

This will redirect port 22 on the vm to 2222 on the host:

```shell
export MEMORY=4G
export LIVE_ISO=arch.iso
export DRIVE1=disk1
export DRIVE2=disk2
qemu-system-x86_64 \
    -m $MEMORY -enable-kvm -redir tcp:2222::22 \
    -boot order=d \
    -cdrom $LIVE_ISO \
    -drive file=$DRIVE1,format=raw \
    -drive file=$DRIVE2,format=raw
```

## SSH

### Start ssh on the vm

ex on Arch / systemd systems:
```
systemctl start sshd
```

### Since the host's port 2222 is mapped to vms 22 (ssh) we can ssh to localhost on port 2222:

```
ssh root@localhost -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

### Can also login as lfs user:

```
ssh lfs@localhost -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

## Copy sources over ssh using rsync

Replace `SOURCES` with the path of local source files:
```
rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222" --progress SOURCES/* root@localhost:/mnt/lfs/sources/
```
