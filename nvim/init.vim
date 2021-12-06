set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
call plug#end()

filetype plugin indent on
syntax on

nmap <F6> :NERDTreeToggle<CR>

set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set number
set backspace=indent,eol,start

"
" config from coc.vim documentation
"
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

filetype plugin indent on

