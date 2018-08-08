MPFR=4.0.1
GMP=6.1.2
MPC=1.1.0

mkdir -vp mpfr mpc gmp
tar -xf ../mpfr-$MPFR.tar.xz --strip-components=1 -C mpfr
tar -xf ../gmp-$GMP.tar.xz --strip-components=1 -C gmp
tar -xf ../mpc-$MPC.tar.gz --strip-components=1 -C mpc
