#!/usr/bin/env bash

# symlink vi binary, docs
ln -sv vim "$DESTDIR/usr/bin/vi"
for L in "$DESTDIR"/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 "$(dirname "$L")/vi.1"
done

# create default config
cat > "$DESTDIR/etc/vimrc" << "EOF"
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1
set nocompatible
EOF
