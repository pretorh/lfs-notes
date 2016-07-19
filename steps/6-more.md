# GCC test failures:

`../contrib/test_summary | grep FAIL | sort`

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
