set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
Plug 'preservim/tagbar'
call plug#end()

filetype plugin indent on
syntax on

nmap <F8> :TagbarToggle<CR>
nmap <F6> :NERDTreeToggle<CR>

set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set number
set hlsearch
set showmatch
set backspace=indent,eol,start
let g:deoplete#enable_at_startup=1

filetype plugin indent on

