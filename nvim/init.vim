set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
call plug#end()

syntax on
set number
set tabstop=4
set shiftwidth=4
set noexpandtab
set hlsearch
set showmatch
set backspace=indent,eol,start
let g:deoplete#enable_at_startup=1

filetype plugin indent on

