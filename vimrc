echo "sourcing vimrc"
set nocompatible
filetype on
filetype plugin on
filetype indent on
if has("win32")
  behave mswin
endif

" Patch slate, a nice built-in colorscheme, to remove the garish red on white
autocmd ColorScheme slate :hi clear PreProc | :hi def link PreProc Define

if !has("gui_running")
  set termguicolors
  if !has('nvim')
    set term=xterm
  endif
endif
set t_ut= " bg color in tmux fix - https://github.com/vim/vim/issues/804
if &t_Co > 2 || has("gui_running")
  set title titlestring=%t\ %y\ %m\ (%{expand('%:p')})
  set mousehide
  syntax on
  "set guifont=Noto\ Mono:h12,Envy\ Code\ R\ 10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
  if !has('nvim')
    set guioptions -=T
    set guioptions -=m
  endif
  set background=dark
  colorscheme slate
  if has("unix")
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
  endif
endif

set nrformats=

set wildcharm=<C-z>
cnoremap <Right> <Space><BS><Right><C-z>
cnoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
set wildignore=*.lnk,*.o,**/node_modules,**/dist
set wildignorecase

set fileformat=unix
set fileformats=unix,dos
set autoread
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

" copy/paste/cut
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
set clipboard=unnamed

" leader
let mapleader = ";"
nmap <silent> <leader>cd :lcd %:h<CR>
" close file without closing window
" 1) not working: cnoremap <leader>q bp<bar>vsp<bar>bn<bar>bd
" 2) from https://stackoverflow.com/a/19619038:
nmap <leader>d :b#<bar>bd#<CR>

imap jk <Esc>

" help helpers
autocmd FileType help nmap X :q<CR>
autocmd FileType help wincmd L
autocmd FileType help nmap <Enter> <C-]>
autocmd FileType vim nnoremap <leader>hh vawy:h <C-r>0<CR>

" frequent files
nmap <silent> <leader>ev :e ~/.vim/vimrc<CR>
nmap <silent> <leader>sv :so ~/.vim/vimrc<CR>
nmap <silent> <leader>en :e ~/.vim/init.vim<CR>
nnoremap <leader>ew :exec ":e ~/Desktop/" . strftime("%Y-W%W.md") <CR>

" built-in terminal
tnoremap <Esc> <C-\><C-n>

" navigate between next/previous locations
nmap <silent> H <c-o>
nmap <silent> L <c-i>

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

nmap <silent> S :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" netrw - the built-in file browser
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
nmap <silent> <c-e> :Lexplore<CR>
autocmd filetype netrw nmap <buffer> <Space> mf

" switch between buffers
nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

" easymotion - for all buffers, except netrw (file browser)
autocmd BufRead,BufNewFile * if &ft != 'netrw' | execute('nmap <silent> <buffer> <Space>j <Plug>(easymotion-w)') | endif
autocmd BufRead,BufNewFile * if &ft != 'netrw' | execute('nmap <silent> <buffer> <Space>k <Plug>(easymotion-b)') | endif

" substitute word under cursor (ref: https://stackoverflow.com/a/48657)
nmap <leader>w :%s/\(<c-r>=expand("<cword>")<cr>\)/

" grepper (search in files)
nmap <silent> <C-f> :Grepper<CR>
imap <silent> <C-f> <ESC>:Grepper<CR>
let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.tools = [ 'rg', 'ag', 'ack', 'ack-grep', 'grep' ]
let g:grepper.dir = 'repo,cwd'
" when grepper buffer is shown/entered, map j/k to navigate up/down matches -
" and press Enter/Esc to go back to normal mappings for j/k
" see: https://vi.stackexchange.com/q/14065
autocmd BufEnter * if &buftype == 'quickfix' | nnoremap <silent> j :cn<CR>
autocmd BufEnter * if &buftype == 'quickfix' | nnoremap <silent> k :cp<CR>
autocmd WinEnter,BufWinEnter quickfix nnoremap <silent> j :cn<CR>
autocmd WinEnter,BufWinEnter quickfix nnoremap <silent> k :cp<CR>
autocmd WinEnter,BufWinEnter quickfix nnoremap <silent> <Enter> :nunmap j<CR>:nunmap k<CR>
autocmd WinEnter,BufWinEnter quickfix nnoremap <silent> <Esc> :nunmap j<CR>:nunmap k<CR>

" probe (fuzzy file finder)
nmap <silent> <C-p> :Probe<CR>
let g:probe_use_gitignore = 1
let g:probe_use_wildignore = 1

" ale (linters and fixers)
let g:ale_sign_column_always = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma all --no-semi'
let g:ale_javascript_prettier_use_global = 1
let g:ale_fixers = { 'javascript': ['prettier'] }
let g:ale_linters = { 'javascript': ['eslint'] }

" file types
autocmd BufNewFile,BufReadPost *.nim,*.nims,*.nimble setfiletype nim

" packages (plugins)
packloadall
silent! helptags ALL
