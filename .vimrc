"-----------------------------------------------------------------------------
" pdev stuff
"-----------------------------------------------------------------------------
if has("win32")
    if !empty("$PDEV")
        let $HOME=$PDEV."/MinGW/msys/1.0/home/Boboc"
        let $MYVIMRC=$PDEV."/MinGW/msys/1.0/home/Boboc/.vimrc"
        let $PATH=$PATH.";".$PDEV."/MinGW/msys/1.0/bin;".$PDEV."/MinGW/bin"
        set runtimepath+=$PDEV/MinGW/msys/1.0/home/Boboc/vimfiles
    endif
    cd D:/projekts
endif

filetype off 

set nocompatible

"-----------------------------------------------------------------------------
" pathogen plugin stuff
"-----------------------------------------------------------------------------
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

"-----------------------------------------------------------------------------
" Global Stuff
"-----------------------------------------------------------------------------

" ignore me some filez
set wildignore=*.lnk,*.o

" pathogen gets the (vim)balls
"set g:vimball_home=


" set vim to store backups in a certain directory to avoid clutter
set backupdir=$TMP

" Set filetype stuff to on
filetype on
filetype plugin on
filetype indent on

" don't wrap by default
set nowrap

" Tabstops are 4 spaces
set tabstop=4
set shiftwidth=4

" set the search scan to wrap lines
set wrapscan

" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase
set smartcase

" set the forward slash to be the slash of note.  Backslashes suck
"set shellslash

" Make command line two lines high
set ch=2

" set visual bell
set vb

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Makeke sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
"set cpoptions=ces$

set ruler

set undofile
set gdefault

" tell VIM to always put a status line in, even if there is only one window
set laststatus=2

" Don't update the display while executing macros
set lazyredraw

" Show the current command in the lower right corner
set showcmd

" Show the current mode
set showmode

" Switch on syntax highlighting.
syntax on

" Hide the mouse pointer while typing
set mousehide

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" set the gui options
set guioptions=acif

" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"      "," key and the "d" key.  If the "d" key isn't pressed before the
"      timeout expires, one of two things happens: The "," command is executed
"      if there is one (which there isn't) or the command aborts.
set timeoutlen=500

" Keep some stuff in the history
set history=100

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Allow the cursor to go in to "invalid" places
set virtualedit=all

" These things start comment lines
set comments=sl:/*,mb:\ *,ex:\ */,O://,b:#,:%,:XCOMM,n:>,fb:-

" Disable encryption (:X)
set key=

" Make the command-line completion better
set wildmenu

" Same as default except that I remove the 'u' option
set complete=.,w,b,t,i

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Set the textwidth to be 120 chars
"set textwidth=120

" get rid of the characters in window separators
"set fillchars=stlnc:\ ,vert:┃,fold:-,diff:-

" Turn tabs into spaces
set expandtab

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" Initial path seeding
"set path=/home/saddoveanu/Projects/**

" Set the tags files to be the following
set tags=./tags,tags

" show relative line numbers by default
set relativenumber

" Let the syntax highlighting for Java files allow cpp keywords
"let java_allow_cpp_keywords = 1

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
" [ http://vim.wikia.com/wiki/Make_make_more_helpful ]
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"-----------------------------------------------------------------------------
" KEYBOARD MAPPINGS
"-----------------------------------------------------------------------------
let mapleader = ","
nmap <Tab> <C-W><C-W>
nmap mk :make<CR>

" compiling
nmap <silent> <F5> :execute '!' . &makeprg . " 2>errorz 1>&2"<CR>:cexpr system('egrep ":[0-9]+:[0-9]+: error" ' . 'errorz')<CR>
nmap <silent> <F6> :!main<CR>
nmap <silent> <F11> :cprevious<CR>
nmap <silent> <F12> :cnext<CR>

nmap <silent> <S-Right> :bnext<CR>
nmap <silent> <S-Left> :bprevious<CR>

imap <silent> jj <Esc>
imap jk <Esc>:
imap <S-Enter> <Esc>A;<Enter>

" Toggle paste mode
"nmap <silent> ,p :set invpaste<CR>:set paste?<CR>
"nmap <silent> ,p "+gP

" need an easy way to paste from global clipboard
imap <silent> <C-V><C-V> <Esc>"+gP

" cd to the directory containing the file in the buffer
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Turn off highlight search
nmap <silent> ,n :set invhls<CR>:set hls?<CR>

" put the vim directives for my file editing settings in
nmap <silent> ,vi
     \ ovim:set ts=4 sts=4 sw=4:<CR>vim600:fdm=marker fdl=1 fdc=0:<ESC>

" Show all available VIM servers
"nmap <silent> ,ss :echo serverlist()<CR>

" set text wrapping toggles
nmap <silent> ,w :set invwrap<CR>:set wrap?<CR>

" Run the command that was just yanked
nmap <silent> ,rc :@"<cr>

" F1 = Esc
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" re-hardwrap current paragraph
nnoremap <leader>q gqip

" select previously pasted text
nnoremap <leader>v V`]

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <End>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>

" Maps to make handling windows a bit easier
noremap <silent> ,h :wincmd h<CR>
noremap <silent> ,j :wincmd j<CR>
noremap <silent> ,k :wincmd k<CR>
noremap <silent> ,l :wincmd l<CR>
noremap <silent> ,sb :wincmd p<CR>
noremap <silent> <C-F9>  :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
noremap <silent> ,s8 :vertical resize 83<CR>
noremap <silent> ,cj :wincmd j<CR>:close<CR>
noremap <silent> ,ck :wincmd k<CR>:close<CR>
noremap <silent> ,ch :wincmd h<CR>:close<CR>
noremap <silent> ,cl :wincmd l<CR>:close<CR>
noremap <silent> ,cc :close<CR>
noremap <silent> ,cw :cclose<CR>
noremap <silent> ,ml <C-W>L
noremap <silent> ,mk <C-W>K
noremap <silent> ,mh <C-W>H
noremap <silent> ,mj <C-W>J
noremap <silent> <C-7> <C-W>>
noremap <silent> <C-8> <C-W>+
noremap <silent> <C-9> <C-W>+
noremap <silent> <C-0> <C-W>>

" Map CTRL-E to do what ',' used to do
nnoremap <c-e> ,
vnoremap <c-e> ,

" Buffer commands
noremap <silent> ,bd :bd<CR>

" Edit the vimrc file
nmap <silent> ,ev :e $MYVIMRC<CR>
nmap <silent> ,sv :so $MYVIMRC<CR>

" Make horizontal scrolling easier
"nmap <silent> <C-o> 10zl
nmap <silent> <C-i> 10zh

" Highlight all instances of the current word under the cursor
nmap <silent> ^ :setl hls<CR>:let @/="<C-r><C-w>"<CR>

" Search the current file for what's currently in the search
" register and display matches
nmap <silent> ,gs
     \ :vimgrep /<C-r>// %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>

" Search the current file for the word under the cursor and display matches
nmap <silent> ,gw
     \ :vimgrep /<C-r><C-w>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>

" Search the current file for the WORD under the cursor and display matches
nmap <silent> ,gW
     \ :vimgrep /<C-r><C-a>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" Search help for the word under the cursor
nmap ,hh viw<Esc>:h <C-r>*<CR>

" Underline the current line with '='
nmap <silent> ,ul :t.\|s/./=/g\|set nohls<cr>

" print variable under cursor - only for vim files, for now
nmap ,pv "xyawoecho '<Esc>"xpi ' . <Esc>"xp

" Delete all buffers
nmap <silent> ,da :exec "1," . bufnr('$') . "bd"<cr>

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" I don't like it when the matching parens are automatically highlighted
"let loaded_matchparen = 1

"-----------------------------------------------------------------------------
" FUNCTIONS
"-----------------------------------------------------------------------------
" looks for the n'th needle in the haystack, searching from the end
" if haystack contains no needles, returns -1
function! NthFromTheEnd( haystack, needle, n )
    let k=len( a:haystack )-1
    let needles_sofar = 0
    while k >= 0 && needles_sofar < a:n
        if a:haystack[k] == a:needle
            let needles_sofar=needles_sofar+1
        endif
        let k=k-1
    endwhile
    if needles_sofar == a:n
        let k=k+1
        return k
    else 
        let k=-1
        return k
    endif
endfunction

" where to place swap files and undo files
if has('win16') || has('win32') || has ('win95') || has('win64')
    set directory=$TMP
    set undodir=$TMP
else 
    set directory=~/tmp
endif

set makeef=errorz

" determine path separator
if has('win16') || has('win32') || has ('win95') || has('win64')
    let s:path_seperator = '\'
else 
    let s:path_seperator = '/'
endif

" returns 'path' with 'num_dirs' removed, WITH a trailing path separator
function! TrimDirs( path, num_dirs )
    let sep_index=NthFromTheEnd( a:path, s:path_seperator, a:num_dirs )
    if sep_index != -1
        return strpart( a:path, 0, sep_index + 1 )
    endif
endfunction

"-----------------------------------------------------------------------------
" set globals pointing to 'bundle' and plugin_data folders 
"-----------------------------------------------------------------------------
let g:plugin_data = expand('~') . '\vimfiles\plugin_data'
let g:plugin_data = substitute( g:plugin_data, '\', s:path_seperator, 'g')
" where are the plugins ? ( with pathogen.vim, usually the 'bundle' folder )
let g:plugins_folder = expand('~') . '\vimfiles\bundle'
let g:plugins_folder = substitute( g:plugins_folder, '\', s:path_seperator, 'g')

let g:marvim_store = g:plugin_data . s:path_seperator . 'marvim'

"-----------------------------------------------------------------------------
" tracvim plugin stuff
"-----------------------------------------------------------------------------
let g:tracServerList = {}

"-----------------------------------------------------------------------------
" Align plugin stuff
"-----------------------------------------------------------------------------
let g:align_dont_map_keys = 1

"-----------------------------------------------------------------------------
" EnhancedCommentify Plugin Settings
"-----------------------------------------------------------------------------
imap <C-c> <Esc><Plug>Commentji
imap <C-x> <Esc><Plug>DeCommentji
nmap <C-c> <Plug>Comment
nmap <C-x> <Plug>DeComment
vmap <C-c> <Plug>Comment
vmap <C-x> <Plug>DeComment

"-----------------------------------------------------------------------------
" Disabled plugins
"-----------------------------------------------------------------------------
let loaded_minibufexplorer = 1
let g:loaded_showmarks = 1

"-----------------------------------------------------------------------------
" FSwitch Settings
"-----------------------------------------------------------------------------
nmap <silent> ,of :FSHere<CR>
nmap <silent> ,ol :FSRight<CR>
nmap <silent> ,oL :FSSplitRight<CR>
nmap <silent> ,oh :FSLeft<CR>
nmap <silent> ,oH :FSSplitLeft<CR>
nmap <silent> ,ok :FSAbove<CR>
nmap <silent> ,oK :FSSplitAbove<CR>
nmap <silent> ,oj :FSBelow<CR>
nmap <silent> ,oJ :FSSplitBelow<CR>

"-----------------------------------------------------------------------------
" Java highlighting
"-----------------------------------------------------------------------------
let java_highlight_all=1

"-----------------------------------------------------------------------------
" Functions
"-----------------------------------------------------------------------------

function! RunSystemCall(systemcall)
    let output = system(a:systemcall)
    let output = substitute(output, "\n", '', 'g')
    return output
endfunction

"-----------------------------------------------------------------------------
" Auto commands
"-----------------------------------------------------------------------------
" C++ headers ( h or hpp ) are kept in the same folder as the .cpp files
augroup fswitch_au_group
    au!
    au BufEnter *.h,*.hpp let b:fswitchlocs = 'rel:.' | let b:fswitchdst = 'cpp'
    au BufEnter *.c,*.cpp let b:fswitchlocs = 'rel:.' | let b:fswitchdst = 'cpp'
augroup END

let g:compiler_gcc_ingore_unmatched_lines=1

augroup autoclose_group
    au!
    au BufEnter *.wiki let g:disable_autoclose = 1
augroup END

augroup java_stuff
    au!
    au BufEnter *.java map <F5> :execute('!javac ').expand('%:p')<CR> :execute('!java -cp '. expand('%:p:h') . ' ' . expand('%:t:r'))<CR>
augroup END

augroup vimfiles
    au!
    au BufEnter *.vim nmap <f5> :source %<CR>

" when loosing focus, write all buffers
au FocusLost * :wa

"-----------------------------------------------------------------------------
" Fix constant spelling mistakes
"-----------------------------------------------------------------------------
iab teh       the
iab Teh       The
iab taht      that
iab Taht      That
iab alos      also
iab Alos      Also
iab aslo      also
iab Aslo      Also
iab becuase   because
iab Becuase   Because
iab bianry    binary
iab Bianry    Binary
iab bianries  binaries
iab Bianries  Binaries
iab charcter  character
iab Charcter  Character
iab charcters characters
iab Charcters Characters
iab exmaple   example
iab Exmaple   Example
iab exmaples  examples
iab Exmaples  Examples
iab shoudl    should
iab Shoudl    Should
iab seperate  separate
iab Seperate  Separate
iab fone      phone
iab Fone      Phone

"-----------------------------------------------------------------------------
" Set up the window colors and size
"-----------------------------------------------------------------------------
if has("gui_running")
    if has("win32")
        set guifont=DejaVu_Sans_mono:h10
    endif
    set background=light
    colorscheme sift
    if !exists("g:vimrcloaded")
        winpos 0 0
        if ! &diff
            winsize 130 90
        else
            winsize 227 90
        endif
        let g:vimrcloaded = 1
    endif
endif
:nohls
