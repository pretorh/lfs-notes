# GCC test failures:

`../contrib/test_summary | grep FAIL | sort`

## `11.2.0`

(matches the list of known failures)

```
FAIL: 17_intro/headers/c++1998/49745.cc (test for excess errors)
FAIL: 22_locale/numpunct/members/char/3.cc execution test
FAIL: 22_locale/time_get/get_time/char/2.cc execution test
FAIL: 22_locale/time_get/get_time/char/wrapped_env.cc execution test
FAIL: 22_locale/time_get/get_time/char/wrapped_locale.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/2.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/wrapped_env.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/wrapped_locale.cc execution test
FAIL: g++.dg/asan/asan_test.C   -O2  (test for excess errors)
FAIL: gcc.dg/analyzer/analyzer-verbosity-2a.c (test for excess errors)
FAIL: gcc.dg/analyzer/analyzer-verbosity-3a.c (test for excess errors)
FAIL: gcc.dg/analyzer/edges-1.c (test for excess errors)
FAIL: gcc.dg/analyzer/file-1.c (test for excess errors)
FAIL: gcc.dg/analyzer/file-2.c (test for excess errors)
FAIL: gcc.dg/analyzer/file-paths-1.c (test for excess errors)
FAIL: gcc.dg/analyzer/file-pr58237.c (test for excess errors)
FAIL: gcc.dg/analyzer/pr99716-1.c (test for excess errors)
```

## `10.2.0`

```
FAIL: 22_locale/time_get/get_time/char/2.cc execution test
FAIL: 22_locale/time_get/get_time/char/wrapped_env.cc execution test
FAIL: 22_locale/time_get/get_time/char/wrapped_locale.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/2.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/wrapped_env.cc execution test
FAIL: 22_locale/time_get/get_time/wchar_t/wrapped_locale.cc execution test
FAIL: g++.dg/asan/asan_test.C   -O2  (test for excess errors)
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O0  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O1  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O2  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O2 -flto -fno-use-linker-plugin -flto-partition=none  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O2 -flto -fuse-linker-plugin -fno-fat-lto-objects  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -O3 -g  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C   -Os  execution test
FAIL: g++.dg/coroutines/torture/co-ret-17-void-ret-coro.C execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O0  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O1  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O2  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O2 -flto -fno-use-linker-plugin -flto-partition=none  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O2 -flto -fuse-linker-plugin -fno-fat-lto-objects  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -O3 -g  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C   -Os  execution test
FAIL: g++.dg/coroutines/torture/pr95519-05-gro.C execution test
FAIL: gcc.dg/asan/pr80166.c   -O0  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -O1  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -O2  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -O2 -flto -fno-use-linker-plugin -flto-partition=none  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -O2 -flto -fuse-linker-plugin -fno-fat-lto-objects  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -O3 -g  (test for excess errors)
FAIL: gcc.dg/asan/pr80166.c   -Os  (test for excess errors)
```

## `7.3.0`

```
FAIL: experimental/filesystem/iterators/directory_iterator.cc execution test
FAIL: experimental/filesystem/iterators/recursive_directory_iterator.cc execution test
FAIL: experimental/filesystem/operations/exists.cc execution test
FAIL: experimental/filesystem/operations/is_empty.cc execution test
FAIL: experimental/filesystem/operations/remove.cc execution test
FAIL: experimental/filesystem/operations/temp_directory_path.cc execution test
```

## `5.3.0`

```
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O1  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O1 execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O2 -ftree-vectorize  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O2 -std=c99  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O3 -flto -g  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O3 -g  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -O3 execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -g  execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -g -O2 execution test
FAIL: c-c++-common/cilk-plus/CK/spawning_arg.c  -g execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O1  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O1 execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O2 -ftree-vectorize  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O2 -std=c99  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O3 -flto -g  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O3 -g  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -O3 execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -g  execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -g -O2 execution test
FAIL: c-c++-common/cilk-plus/CK/steal_check.c  -g execution test
FAIL: experimental/filesystem/iterators/directory_iterator.cc execution test
FAIL: experimental/filesystem/iterators/recursive_directory_iterator.cc execution test
FAIL: g++.dg/cilk-plus/CK/catch_exc.cc  -O1 -fcilkplus execution test
FAIL: g++.dg/cilk-plus/CK/catch_exc.cc  -O3 -fcilkplus execution test
FAIL: g++.dg/cilk-plus/CK/catch_exc.cc  -g -O2 -fcilkplus execution test
FAIL: g++.dg/cilk-plus/CK/catch_exc.cc  -g -fcilkplus execution test
```
