" ***********************
" Vim-Plug Plugin Manager
" ***********************

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tomasiser/vim-code-dark'

Plug 'itchyny/lightline.vim'
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

Plug 'airblade/vim-gitgutter'
set updatetime=100

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <silent> <C-f> :Files<CR>

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
autocmd StdinReadPre * let s:std_in=1
map <C-n> :NERDTreeToggle<CR>

call plug#end()

" ******************
" Vim Configurations
" ******************

set encoding=utf-8

" Color scheme
colorscheme codedark
set t_Co=256
set t_ut=
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

" Disable auto-wrapping
set formatoptions-=t

" Maps <C-i> to insert single character
nnoremap <C-i> i_<Esc>r

" Line numbers
set nu
set hidden

" System clipboard
set clipboard=unnamed

