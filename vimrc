set nocompatible
if has("win32")
	behave mswin
endif
set fileformat=unix
set fileformats=unix,dos

filetype on
filetype plugin on
filetype indent on

set autoread

set wildignore=*.lnk,*.o,**/node_modules,**/dist

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
set wrapscan
set backspace=indent,eol,start
set hidden
set ruler
set gdefault
set lazyredraw

set ignorecase
set smartcase
set shellslash
set laststatus=2
set showcmd
set showmode

if &t_Co > 2 || has("gui_running")
	set mousehide
  syntax on
	colorscheme darkblue
	set background=dark
	set guifont=Envy_Code_R:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
endif
