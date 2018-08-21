set -e

# comma separated options: i915, nouveau, r300, r600, radeonsi, freedreno, svga, swrast, vc4, and virgl
# see http://www.mesa3d.org/systems.html
GALLIUM_DRIVERS=${1?'need gallium drivers to install'}

# ./configure CFLAGS='-O2' CXXFLAGS='-O2' LDFLAGS=-lLLVM \

./configure CFLAGS='-O2' CXXFLAGS='-O2' \
            --prefix=/usr                      \
            --sysconfdir=/etc                  \
            --enable-texture-float             \
            --enable-osmesa                    \
            --enable-xa                        \
            --enable-glx-tls                   \
            --with-platforms="drm,x11,wayland" \
            --with-gallium-drivers=$GALLIUM_DRIVERS

time make --jobs=4

time make check --jobs=4
