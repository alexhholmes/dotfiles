call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
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

"
"
"

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

" Ocaml
set rtp^="/Users/alex/.opam/default/share/ocp-indent/vim"

" ## added by OPAM user-setup for vim / base ## d611dd144a5764d46fdea4c0c2e0ba07 ## you can edit, but keep this line
let s:opam_share_dir = system("opam var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_available_tools = []
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if isdirectory(s:opam_share_dir . "/" . tool)
    call add(s:opam_available_tools, tool)
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 45558276ab95d4175a2827d117120588 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/Users/alex/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
"
