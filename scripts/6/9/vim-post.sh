VIM_VERSION=8.0.586
VIM_SIMPLE_VERSION=80

# symlink vi binary, docs
ln -sv vim $DESTDIR/usr/bin/vi
ln -sv vim.1 $DESTDIR/usr/share/man/man1/vi.1

# symlink docs for consistency
ln -sv ../vim/vim$VIM_SIMPLE_VERSION/doc $DESTDIR/usr/share/doc/vim-$VIM_VERSION

# create default config
cat > $DESTDIR/etc/vimrc << "EOF"
" Begin /etc/vimrc

source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

unset VIM_VERSION
unset VIM_SIMPLE_VERSION
