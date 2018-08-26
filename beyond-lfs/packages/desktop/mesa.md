## mesa

Why: dependency of `xorg`

installed version: `18.1.6`

links:

- [download page](https://mesa.freedesktop.org/archive/)
- [how to](https://mesa.freedesktop.org/install.html)

### dependencies

- `LLVM`
    - config failed on "wheter the C compiler works" (due to `LDFLAGS=-lLLVM`)
- `libdrm >= 2.4.75`
- `wayland-client >= 1.11`
    - can try and skip by excluding from `--with-platforms` config
- `python2`
    - can try to skip using symlink from python3: `ln -sv python3 /usr/bin/python`
    - but needed to install for cmake in anyway

### commands

see build script: `packages/desktop/scripts/mesa-build.sh`

build time: 4x (user: 14x)

test time: 1x

all tests passed

before python2, 2 tests failed:
- optimazation test
- glcpp-test-cr-lf

some wayland files will get overwritten:

- /usr/lib/libwayland-egl.so.1: Cannot create symlink to 'libwayland-egl.so.1.0.0'
- /usr/lib/libwayland-egl.la
- /usr/lib/libwayland-egl.so.1.0.0
- /usr/lib/pkgconfig/wayland-egl.pc
- /usr/lib/libwayland-egl.so: Cannot create symlink to 'libwayland-egl.so.1.0.0'