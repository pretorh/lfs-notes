# VM and SSH notes

## Qemu

to use qemu:
- replace `MEMORY` with the GB amount of ram for the vm
- replace `LIVE_ISO` with the path to an iso for a live cd (ex Arch Linux)
- replace `DRIVE1/DRIVE2`... with the path to drive images

This will redirect port 22 on the vm to 2222 on the host:

```shell
qemu-system-x86_64 \
    -m MEMORYG -enable-kvm -redir tcp:2222::22 \
    -boot order=d \
    -cdrom LIVE_ISO \
    -drive file=DRIVE1,format=raw \
    -drive file=DRIVE2,format=raw
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
