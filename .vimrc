" ***********************
" Vim-Plug Plugin Manager
" ***********************

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-surround'
Plug 'dikiaap/minimalist'

call plug#end()

" ***********************

" Color Scheme
set t_Co=256
set t_ut=
colorscheme codedark
" colorscheme minimalist
:syntax on

" Tabs, spaces, and indenting
set ai
set si
set shiftwidth=4
set tabstop=4
set softtabstop=-1
set expandtab

" Git commit message formatting
au FileType gitcommit set tw=72

" Highlights text past 80 characters (warning) and past 100 characters (danger).
let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(120,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" Turn off auto-wrapping
set formatoptions-=t

" Maps <C-i> to insert single character
nnoremap <C-i> i_<Esc>r

" Line Numbers
" set nu rnu
set nu

" Status Line
set laststatus=2

" System Clipboard
set clipboard=unnamed
