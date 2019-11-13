#!/bin/bash

CURRENT=`pwd`
TMP_FILE=/tmp/vimrc.tmp
touch $TMP_FILE

# Copy the default settings
cat vimrc.template > $TMP_FILE

# Nerd tree plugin
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
echo "\" Nerd tree" >> $TMP_FILE
echo "map <C-b> :NERDTreeToggle<CR>" >> $TMP_FILE
echo "let NERDTreeShowHidden=1" >> $TMP_FILE
echo 'autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " autoquit if only nerdtree is open' >> $TMP_FILE

# cntrlp plugin
git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
echo "\" load ctrlp" >> $TMP_FILE
echo "set runtimepath^=~/.vim/bundle/ctrlp.vim" >> $TMP_FILE
echo "\" ctrl-p plugin shortcut" >> $TMP_FILE
echo "let g:ctrlp_map = '<c-p>'" >> $TMP_FILE
echo "let g:ctrlp_cmd = 'CtrlP'" >> $TMP_FILE

# vim-gitgutter
git clone https://github.com/airblade/vim-gitgutter ~/.vim/pack/airblade/start/vim-gitgutter
echo "let g:gitgutter_realtime=1" >> $TMP_FILE
echo "set updatetime=100" >> $TMP_FILE

# pathogen
git clone https://github.com/tpope/vim-pathogen ~/.vim/bundle/vim-pathogen
mkdir -p ~/.vim/autoload/
cp ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/

# Monokai color scheme
mkdir -p ~/.vim/colors
wget -qO ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim
#echo "colorscheme monokai" >> $TMP_FILE

# You complete me
# git clone https://github.com/ycm-core/YouCompleteMe ~/.vim/bundle/YouCompleteMe
# cd ~/.vim/bundle/YouCompleteMe
# git submodule update --init --recursive
# python3 install.py --all
# echo "set runtimepath^=~/.vim/bundle/YouCompleteMe" >> $TMP_FILE
# echo "let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'" >> $TMP_FILE
# echo "let g:ymc_add_preview_to_completeopt=1" >> $TMP_FILE
# echo "let g_ymc_autoclose_preview_window_after_completion=1" >> $TMP_FILE

# This should always final thing
echo "execute pathogen#infect()" >> $TMP_FILE
cp $TMP_FILE ~/.vimrc
