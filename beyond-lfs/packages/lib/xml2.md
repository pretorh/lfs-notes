## libxml2

Why: dependency for wayland

installed version: `2.9.8`

links:

- [download page](https://github.com/GNOME/libxml2/releases)
- download mask: `https://github.com/GNOME/libxml2/archive/v<VERSION>.tar.gz`

### dependencies

none

### commands

use `./autogen.sh` not configure from github tarball

`prefix`, `disable-static`, `with-history` (Readline support?), `--with-python=/usr/bin/python3`

#### install

`make instal DESTDIR=$DESTDIR`

#### install python2 module

```
cd python
python setup.py build
python setup.py install --root=$DESTDIR --optimize=1
```
