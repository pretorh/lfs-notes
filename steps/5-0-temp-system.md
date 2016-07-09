# Building the temporary system

You should login as `lfs`

## Part 1

if building on x64: (this was part of bin utils)

```
mkdir -pv /tools/lib
ln -sv lib /tools/lib64
```

- Bin Utils
- GCC
    - scripts:
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
        - `5/gcc/toolchain.sh`
- Linux API Headers
    - non default steps:
        - `make mrproper`
        - `make INSTALL_HDR_PATH=dest headers_install`
        - `cp -rv dest/include/* /tools/include`
    - had some issues previously during automation, and had to remove this before removing the extracted files
        - `rm -rf linux-4.4.2/arch/arm64/boot/dts/include`
- GLibc

## Sanity Check 1

see script: `5/sanity-checks/1.sh`

## Part 2

- libstdc++
- Bin Utils (pass 2)
    - "re-adjusting"

- GCC (pass 2)
    - scripts:
        - `5/gcc/patch-limits.sh`
        - `5/gcc/toolchain.sh`
        - `5/gcc/patch-mpfr-mpc-gmp.sh`
    - `ln -sv gcc /tools/bin/cc`

## Sanity Check 2

see script: `5/sanity-checks/2.sh`

## Part 3

- tcl-core
    - post install steps:
        - `chmod -v u+w /tools/lib/libtcl8.6.so`
        - `make install-private-headers`
        - `ln -sv tclsh8.6 /tools/bin/tclsh`
- expect
    - patch the config file
- DejaGNU
- check
- ncurses
    - patch the config file
- bash
- bzip2
    - no config needed
- coreutils

## The Easy Stuff

All of these are just need to have the `prefix` set in configuration:

```
./configure --prefix=/tools
make --jobs
make install
```

- diffutils
- file
- findutils
- gawk

## Gettext

Only need to install some files, so need to `make -C` into dirs and finally copy the files out.

see `5/gettext/configure-build-install.sh`

## The Easy Stuff - Part 2

- grep
- gzip
- m4

## More

make-4.1.tar.bz2
./configure --prefix=/tools --without-guile

patch-2.7.5.tar.xz
perl-5.22.1.tar.bz2
sh Configure -des -Dprefix=/tools -Dlibs=-lm
...
cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.22.1
cp -Rv lib/* /tools/lib/perl5/5.22.1

sed-4.2.2.tar.bz2
tar-1.28.tar.xz
texinfo-6.1.tar.xz
util-linux-2.27.1.tar.xz
xz-5.2.2.tar.xz
