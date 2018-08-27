set -e

mkfontscale /usr/share/fonts/X11/{misc,100dpi,75dpi,Type1,TTF,OTF}
mkfontdir /usr/share/fonts/X11/{misc,100dpi,75dpi,Type1,TTF,OTF}
fc-cache -s --verbose
