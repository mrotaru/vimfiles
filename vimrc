set nocompatible
filetype on
filetype plugin on
filetype indent on
if has("win32")
	behave mswin
endif

if !has("gui_running")
  set termguicolors
  if !has('nvim')
    set term=xterm
  endif
endif
set t_ut=
if &t_Co > 2 || has("gui_running")
  set mousehide
  syntax on
  set guifont=Noto\ Mono\ Regular:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
  if !has('nvim')
    set guioptions -=T
    set guioptions -=m
  endif
  set background=dark
  colorscheme darkblue
endif

let g:neovide_cursor_animation_length=0.05
let g:neovide_cursor_trail_length=0.4
let g:neovide_cursor_vfx_mode = "sonicboom"

set nrformats=

set fileformat=unix
set fileformats=unix,dos
set autoread
set wildignore=*.lnk,*.o,**/node_modules,**/dist
set wildignorecase
set nobackup
set nowritebackup
set noswapfile
set undofile
if has("win32")
    set undodir=$TMP		
else		
    set undodir=/tmp		
endif

set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set wrapscan
set backspace=indent,eol,start
set hidden
set ruler
set gdefault
set lazyredraw
set number

set updatetime=250

set ignorecase
set smartcase
set shellslash
set laststatus=2
set showcmd
set showmode

set noerrorbells
set visualbell
set t_vb=

" copy/paste/cut in insert/visual modes
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

set clipboard=unnamed

let mapleader = ";"
nmap <silent> <leader>cd :lcd %:h<CR>

autocmd FileType help nmap X :q<CR>
nmap <leader>hh viw<Esc>:h <C-r>*<CR>
nmap <silent> <leader>ev :e ~/.vim/vimrc<CR>
nmap <silent> <leader>sv :so ~/.vim/vimrc<CR>
nnoremap <leader>ew :exec ":e ~/notes/todos/" . strftime("%Y-W%W.md") <CR>

nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

nmap <silent> <C-p> :Probe<CR>

nmap <silent> <C-f> :Grepper<CR>
imap <silent> <C-f> <ESC>:Grepper<CR>
let g:grepper = {}
let g:grepper.tools = [ 'rg', 'ag', 'ack', 'ack-grep', 'grep' ]
let g:grepper.dir = 'repo,cwd'

let g:probe_use_gitignore = 1
let g:probe_use_wildignore = 1

let g:ale_sign_column_always = 1
"let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma all --no-semi'
let g:ale_javascript_prettier_use_global = 1
let g:ale_fixers = { 'javascript': ['prettier'] }
let g:ale_linters = { 'javascript': ['eslint'] }

packloadall
silent! helptags ALL