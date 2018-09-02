set -e

tar -xf ../cfe-*.src.tar.xz -C tools
tar -xf ../compiler-rt-*.src.tar.xz -C projects

mv tools/cfe-*.src tools/clang
mv projects/compiler-rt-*.src projects/compiler-rt

mkdir -pv build
cd build

CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DLLVM_BUILD_LLVM_DYLIB=ON            \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -Wno-dev                              \
      ..

time make --jobs=8
