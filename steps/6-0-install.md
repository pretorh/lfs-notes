# Installing the system

## Chroot

See `prepare.sh` and `chroot-setup.sh`

## Packages

Build and install from the `sources` directory

`cd /sources`

### Part 1

- linux api headers
- man-pages

### Glibc
Extract and build as normal

#### Tests are critical

`make check`

but some will fail:

- known to fail with latest binutils (FAILed previously, but on a later lfs in XPASSed):
    - elf/tst-protected1a
    - elf/tst-protected1b
- will always fail:
    - posix/tst-getaddrinfo4
    - posix/tst-getaddrinfo5

#### Install glibc
Install glibc (`make install`)

- setup nscd config runtime directory (see `scripts/6/glibc/nscd.sh`)
- setup locales (see `scripts/6/glibc/locale.sh`)

#### Congiure glibc

##### nsswitch.conf

    cat > /etc/nsswitch.conf << "EOF"

    # Begin /etc/nsswitch.conf
    passwd: files
    group: files
    shadow: files
    hosts: files dns myhostname
    networks: files
    protocols: files
    services: files
    ethers: files
    rpc: files
    # End /etc/nsswitch.conf
    EOF

##### timezone

Install timezone data (see `scripts/6/glibc/tz-install.sh`) and configure it:

Run:

    SELECTED_TZ=`tzselect`

And then:

    echo "selected $SELECTED_TZ"
    ln -sfv /usr/share/zoneinfo/$SELECTED_TZ /etc/localtime
    unset SELECTED_TZ

#### Dynamic Loader

    cat > /etc/ld.so.conf << "EOF"
    /usr/local/lib
    /opt/lib
    include /etc/ld.so.conf.d/*.conf
    EOF

    mkdir -pv /etc/ld.so.conf.d
