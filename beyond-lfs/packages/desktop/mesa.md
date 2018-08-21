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

### commands

#### configure options

see build script: `packages/desktop/scripts/mesa-build.sh`
