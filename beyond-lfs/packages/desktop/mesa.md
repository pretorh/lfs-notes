## mesa

still to install!

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

### commands

#### configure options

see build script: `packages/desktop/scripts/mesa-build.sh`

build time: 4x (user: 14x)

test time: 1.5x

2 tests failed:
- optimazation test
- glcpp-test-cr-lf
