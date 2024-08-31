#!/bin/bash

dir=$(cd $(dirname $0);pwd)
dir_1="$dir/vim"
dir_2="$HOME/.vim"

vim_1="$dir/vimrc"
vim_2="$HOME/.vimrc"

rm -rf $dir_2 $vim_2

echo "
# 请安装最新版VIM
ln -s $dir_1 $dir_2
ln -s $vim_1 $vim_2
"

ln -s $dir_1 $dir_2
ln -s $vim_1 $vim_2



