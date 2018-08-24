## libuv

Why: requirement of `CMake`

installed version: `1.23.0`

links:

- [download page](https://github.com/libuv/libuv/releases)
- download mask: `https://github.com/libuv/libuv/archive/v<VERSION>.tar.gz`
- [how to](https://github.com/libuv/libuv#build-instructions)

### commands

```
sh autogen.sh
./configure --prefix=/usr --disable-static
time make --jobs=4
```

#### tests

time: 2x

all 336 passed (in 1 script, so "1 test passed")
