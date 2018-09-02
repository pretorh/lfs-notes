## libdrm

Why: required for `mesa`

installed version: `2.4.93`

links:

- [download page](https://dri.freedesktop.org/libdrm/)

### dependencies

none

### commands

#### configure options

`prefix`, `--enable-udev`

can maybe disable some of the APIs that are compiled (AMDGPU, Intel, etc)

with above configure:

```
libdrm 2.4.93 will be compiled with:

    libkms         yes
    Intel API      yes
    vmwgfx API     yes
    Radeon API     yes
    AMDGPU API     yes
    Nouveau API    yes
    OMAP API       no
    EXYNOS API     no
    Freedreno API  no (kgsl: no)
    Tegra API      no
    VC4 API        no
    Etnaviv API    no
```

#### tests

`time make check --jobs=4`

"If nouveau threaded test hangs": `sed -i 's/^TESTS/#&/' tests/nouveau/Makefile.in.`

results:

looks like nouveau threaded tests are skipped.
took some time after `drmsl` (for `random`) though this was the last test
time: 1.5x
