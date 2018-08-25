## LLVM

Why: required for `mesa`

installed version: `6.0.1`

links:

- [download page](https://releases.llvm.org/download.html)
- [how to](https://releases.llvm.org/6.0.1/docs/GettingStarted.html)
- direct link mask: `https://releases.llvm.org/<VERSION>/<NAME>-<VERSION>.src.tar.xz`

source code files:

- `llvm` (llvm)
- `cfe` (CLang)
- `compiler-rt` (compiler-rt)

### dependencies

`CMake`

### commands

see `build-llvm.sh` script

patch by adding clang and compiler-rt sources. configure using `cmake`. build using `make`

- config: 1x times
- build: 37x times (282x)

#### tests

`time make check-all --jobs=8`

"several Sanitizer tests (9 of 26479) are known to fail"

tests builds some time, test running self has eta

times: 18 (120x)

results:

```
Failing Tests (8):
    LeakSanitizer-AddressSanitizer-x86_64 :: TestCases/Linux/use_tls_dynamic.cc
    LeakSanitizer-Standalone-x86_64 :: TestCases/Linux/use_tls_dynamic.cc
    MemorySanitizer-X86_64 :: Linux/sunrpc.cc
    MemorySanitizer-X86_64 :: Linux/sunrpc_bytes.cc
    MemorySanitizer-X86_64 :: Linux/sunrpc_string.cc
    MemorySanitizer-X86_64 :: dtls_test.c
    SanitizerCommon-lsan-x86_64-Linux :: Posix/sanitizer_set_death_callback_test.cc
    ThreadSanitizer-x86_64 :: sunrpc.cc

Expected Passes    : 29113
Expected Failures  : 103
Unsupported Tests  : 8920
Unexpected Failures: 8
```
