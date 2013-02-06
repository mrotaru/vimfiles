set nocompatible
"-----------------------------------------------------------------------------
" FUNCTIONS {{{
"-----------------------------------------------------------------------------

" Returns the (zero-indexed) position of the `n`-th occurence of `needle` in
" `haystack`, counting from the end of the string.
" If `haystack` contains no `needle`s, returns -1
"-----------------------------------------------------------------------------
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

" Returns the (zero-indexed) position of the `n`-th occurence of `needle` in
" `haystack`, counting from the start of the string.
" If `haystack` contains no `needle`s, returns -1
"-----------------------------------------------------------------------------
function! NthFromTheStart( haystack, needle, n )
    let needles_sofar = 0
    let k=0
    while k < len( a:haystack ) && needles_sofar != a:n
        if a:haystack[k] == a:needle
            let needles_sofar=needles_sofar+1
        endif
        let k=k+1
    endwhile
    if needles_sofar == a:n
        return k-1
    else 
        return -1
    endif
endfunction

" determine path separator
if has('win16') || has('win32') || has ('win95') || has('win64')
    let s:path_separator = '\'
else 
    let s:path_separator = '/'
endif

" returns 'path' with 'num_dirs' removed, WITH a trailing path separator
function! TrimDirs( path, num_dirs )
    let sep_index=NthFromTheEnd( a:path, s:path_separator, a:num_dirs )
    if sep_index != -1
        return strpart( a:path, 0, sep_index + 1 )
    endif
endfunction

" TODO: needs special handling on linux
function! TrimDirsFromStart( path, num_dirs )
    let sep_index=NthFromTheStart( a:path, s:path_separator, a:num_dirs )
    if sep_index != -1
        return strpart( a:path, sep_index+1 )
    endif
endfunction

" NOTE: Windows-only
function! OpenInBrowser()
    let l:url=""
    if expand('%:e') == 'php'
        let l:trimmed = TrimDirsFromStart( expand('%:p'), g:locahost_cutoff )
        if exists('g:locahost_cutoff')
            let l:url='http://localhost/' . l:trimmed
        else
            let l:url='http://localhost'
        endif
        let l:url=substitute( l:url, '\','/','g' )
        let l:cmd = 'silent ! start '.l:url
        execute l:cmd
    elseif expand('%:e') =~ 'x\?html'
        let l:cmd = 'silent ! start file:///'.expand('%:p')
        let l:cmd=substitute( l:cmd, '\','/','g' )
        execute l:cmd
    endif
endfunction

" fix qotes
" often, when pasting code from ebooks, the fancy qutes need to be replaced
" ------------------------------------------------------------------------------
function! FixQuotes()
    if &gdefault
        %s/“/"/e
        %s/”/"/e
        %s/’/'/e
    else
        %s/“/"/ge
        %s/”/"/ge
        %s/’/'/ge
    endif
endfunction

" transform: "function(parameter){" into "function( parameter ) {"
" ------------------------------------------------------------------------------
function! RAMStyle() range
    for linenum in range( a:firstline, a:lastline )
        let curr_line   = getline( linenum )
        let replacement = substitute( curr_line,  '(\(.\)','(\ \1','g' )
        let replacement = substitute( replacement,'\(.\))','\1\ )','g' )
        let replacement = substitute( replacement,'[\(.\)','[\ \1','g' )
        let replacement = substitute( replacement,'\(.\)]','\1\ ]','g' )
        let replacement = substitute( replacement,'){',') {','g' )
        call setline( linenum, replacement )
    endfor
endfunction
"}}} Functions

"-----------------------------------------------------------------------------
" pdev stuff {{{
"-----------------------------------------------------------------------------
if strlen($WINDIR)
    if( expand("$MSYSTEM") == "MINGW32" ) " run from within an MSYS environment
        let s:homedir='C:/pdev/MinGW/msys/1.0/home/'.$USERNAME
        if !isdirectory( s:homedir )
            echo "Cannot find home directory: ".s:homedir." is not a folder."
        else
            let $HOME=s:homedir
            let $MYVIMRC=s:homedir.'/.vimrc'
            let &runtimepath=&runtimepath.",".s:homedir.'/vimfiles'
            let &runtimepath=&runtimepath.",".s:homedir.'/vimfiles/bundle/vundle'
        endif

        let s:mingwdir='C:/pdev/MinGW'
        if !isdirectory( s:mingwdir )
            echo "Cannot find MINGW directory: ".s:mingwdir." is not a folder."
        else
            let $PATH=$PATH.";".s:mingwdir.'/msys/1.0/bin;'.s:mingwdir.'/bin;C:/pdev/bin'
        endif

        if isdirectory( 'C:/pdev/bin' )
            let $PATH=$PATH.';C:/pdev/bin'
        endif

    else " probably portable gvim; find the 'settings' folder
        let s:vimfiles=TrimDirs(expand("$VIM"),2).'Data\settings\vimfiles'
        if isdirectory( s:vimfiles ) 
            let s:homedir='C:/pdev/MinGW/msys/1.0/home/'.$USERNAME
            if isdirectory( s:homedir )
                let $HOME=s:homedir
            endif
            let $MYVIMRC=s:vimfiles.'/.vimrc'
            let &runtimepath=&runtimepath.",".s:vimfiles
            let &runtimepath=&runtimepath.",".s:vimfiles.'\bundle\vundle'
        else
            echo "Warning: assumed this is PortableGVim, but ".s:settings_dir." is not a folder."
        endif
    endif

else " most likely Linux
    let s:vimfiles=expand("$HOME").'/vimfiles'
    if isdirectory( s:vimfiles )
        let &runtimepath=&runtimepath.",".s:vimfiles
        let &runtimepath=&runtimepath.",".expand("$HOME").s:vimfiles.'/bundle/vundle'
    endif
endif
"}}}

if exists("$CODE")
    cd $CODE
endif

filetype off 
autocmd!

set rtp+=~/.vim/bundle/vundle/
"-----------------------------------------------------------------------------
" Vundle
"-----------------------------------------------------------------------------
call vundle#rc()

"-----------------------------------------------------------------------------
" Global Stuff
"-----------------------------------------------------------------------------

" Set filetype stuff to on
filetype on
filetype plugin on
filetype indent on

" ignore me some filez
set wildignore=*.lnk,*.o

" pathogen gets the (vim)balls
"set g:vimball_home=

" set vim to store backups in a certain directory to avoid clutter
if has("win32")
    set backupdir=$TMP
    set directory=$TMP
    set undodir=$TMP
else
    set backupdir=/tmp
    set directory=/tmp
    set undodir=/tmp
endif
set makeef=errorz

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

" regular expressions have /g by default
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
"set fillchars=stlnc:\ ,vert:â”ƒ,fold:-,diff:-

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

" enable modeline
set modeline

" Let the syntax highlighting for Java files allow cpp keywords
"let java_allow_cpp_keywords = 1

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
" [ http://vim.wikia.com/wiki/Make_make_more_helpful ]
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"-----------------------------------------------------------------------------
" KEYBOARD MAPPINGS {{{
"-----------------------------------------------------------------------------
let mapleader = ","
nmap mk :make<CR>

" compiling
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
imap <silent> <C-V><C-V> <Esc>"+gp

" cd to the directory containing the file in the buffer
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Turn off highlight search
nmap <silent> ,n :set invhls<CR>:set hls?<CR>

" put the vim directives for my file editing settings in
nmap <silent> ,vi
     \ ovim:set ts=4 sts=4 sw=4:<CR>vim600:fdm=marker fdl=1 fdc=0:<ESC>

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

" managing buffers
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>
"nnoremap <C-M> :buffers<CR>:buffer<Space>
command! -nargs=? -bang  Buffer  if <q-args> != '' | exe 'buffer '.<q-args> | else | ls<bang> | let buffer_nn=input('Which one: ') | if buffer_nn != '' | exe buffer_nn != 0 ? 'buffer '.buffer_nn : 'enew' | endif | endif
noremap <silent> ,bd :bd<CR>

" Map CTRL-E to do what ',' used to do
nnoremap <c-e> ,
vnoremap <c-e> ,

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
"}}} Mappings

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" I don't like it when the matching parens are automatically highlighted
"let loaded_matchparen = 1

" unicode settings - use UTF-8 encoding by default ( http://vim.wikia.com/wiki/Working_with_Unicode ) {{{
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif
"}}}

" Folding rules {{{
set foldenable " enable folding
set foldcolumn=2 " add a fold column
set foldlevelstart=99 " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " which commands trigger auto-unfold
set foldmethod=marker " detect triple-{ style fold markers
" }}}

"-----------------------------------------------------------------------------
" Vundle bundles
"-----------------------------------------------------------------------------
"Bundle 'gmarik/vundle'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'kien/ctrlp.vim'
Bundle 'matchit.zip'

" General Programming
" -------------------
"Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
"Bundle 'mattn/webapi-vim'
"Bundle 'mattn/gist-vim'
"Bundle 'scrooloose/nerdcommenter'
Bundle 'hrp/EnhancedCommentify'
"Bundle 'godlygeek/tabular'
if executable('ctags')
    Bundle 'majutsushi/tagbar'
endif

" Snippets & AutoComplete
" -----------------------
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'honza/snipmate-snippets'

" PHP
" ---
Bundle 'spf13/PIV'

" Python
" ------
" Pick either python-mode or pyflakes & pydoc
"Bundle 'klen/python-mode'
"Bundle 'python.vim'
"Bundle 'python_match.vim'
"Bundle 'pythoncomplete'

" Javascript
" ----------
Bundle 'leshill/vim-json'
Bundle 'groenewege/vim-less'
Bundle 'pangloss/vim-javascript'
Bundle 'briancollins/vim-jst'
Bundle 'kchmck/vim-coffee-script'

" HTML
" ----
Bundle 'amirh/HTML-AutoCloseTag'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'skammer/vim-css-color'
Bundle 'mattn/zencoding-vim'

" Misc
" ----
Bundle 'tpope/vim-markdown'
"Bundle 'spf13/vim-preview'
"Bundle 'tpope/vim-cucumber'
"Bundle 'quentindecock/vim-cucumber-align-pipes'
"Bundle 'Puppet-Syntax-Highlighting'

Bundle 'vim-scripts/localvimrc'
Bundle 'mihai-rotaru/vim-status-quo'
 Bundle 'gmarik/vundle'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'kien/ctrlp.vim'
Bundle 'matchit.zip'

" General Programming
" -------------------
"Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
"Bundle 'mattn/webapi-vim'
"Bundle 'mattn/gist-vim'
"Bundle 'scrooloose/nerdcommenter'
Bundle 'hrp/EnhancedCommentify'
"Bundle 'godlygeek/tabular'
if executable('ctags')
    Bundle 'majutsushi/tagbar'
endif

" Snippets & AutoComplete
" -----------------------
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'honza/snipmate-snippets'

" PHP
" ---
Bundle 'spf13/PIV'

" Python
" ------
" Pick either python-mode or pyflakes & pydoc
"Bundle 'klen/python-mode'
"Bundle 'python.vim'
"Bundle 'python_match.vim'
"Bundle 'pythoncomplete'

" Javascript
" ----------
Bundle 'leshill/vim-json'
Bundle 'groenewege/vim-less'
Bundle 'pangloss/vim-javascript'
Bundle 'briancollins/vim-jst'
Bundle 'kchmck/vim-coffee-script'

" HTML
" ----
Bundle 'amirh/HTML-AutoCloseTag'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'skammer/vim-css-color'
Bundle 'mattn/zencoding-vim'

" Misc
" ----
Bundle 'tpope/vim-markdown'
"Bundle 'spf13/vim-preview'
"Bundle 'tpope/vim-cucumber'
"Bundle 'quentindecock/vim-cucumber-align-pipes'
"Bundle 'Puppet-Syntax-Highlighting'

Bundle 'vim-scripts/localvimrc'
Bundle 'mihai-rotaru/vim-status-quo'
Bundle 'mihai-rotaru/vim-asciidoc-ft-syntax'

"-----------------------------------------------------------------------------
" set globals pointing to 'bundle' and plugin_data folders {{{
"-----------------------------------------------------------------------------
let s:pd = s:path_separator
let g:plugin_data = s:vimfiles . '\plugin_data'
let g:plugin_data = substitute( g:plugin_data, '\', s:pd, 'g')
" where are the plugins ? ( with pathogen.vim, usually the 'bundle' folder )
let g:plugins_folder = s:vimfiles . '\bundle'
let g:plugins_folder = substitute( g:plugins_folder, '\', s:pd, 'g')

let g:marvim_store = g:plugin_data . s:pd . 'marvim'

let g:snippets_dir = substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g')
let g:snippets_dir = g:snippets_dir . ',' .  g:plugin_data . 
            \s:pd . 'snipmate' . s:pd . 'default-snippets' . s:pd . 'snippets'
let g:snippets_dir = g:snippets_dir . ',' .  g:plugin_data . 
            \s:pd . 'snipmate' . s:pd . 'my-snippets'
" }}}

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
" LocalVimrc Plugin Settings
"-----------------------------------------------------------------------------
let g:localvimrc_ask = 0 "automatically source local vimrc's
let g:localvimrc_sandbox = 0 "local vimrcs are of little use in sandbox mode

"-----------------------------------------------------------------------------
" ErrorMarker Plugin Settings
"-----------------------------------------------------------------------------
let g:errormarker_disablemappings = 1 "errormarker: no mappings

"-----------------------------------------------------------------------------
" MRU Plugin Settings
"-----------------------------------------------------------------------------
" strangely, cannot map <C-M>, bc. will open MRU whenever I press Enter
map <leader>f :MRU<CR>

"-----------------------------------------------------------------------------
" zencoding plugin stuff
"-----------------------------------------------------------------------------
let g:user_zen_leader_key = '<c-l>'

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
" Other Plungins
"-----------------------------------------------------------------------------
if strlen($WINDIR)
    let g:ackprg="perl C:/pdev/bin/ack -H --nocolor --nogroup --column"
else
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
endif

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
" Auto commands {{{
"-----------------------------------------------------------------------------
if has( "autocmd" )
    augroup cpp
        au!

        " C++ headers ( h or hpp ) are kept in the same folder as the .cpp files
        au BufEnter *.h,*.hpp let b:fswitchlocs = 'rel:.,./src,../src' | let b:fswitchdst = 'cpp'
        au BufEnter *.c,*.cpp let b:fswitchlocs = 'rel:.,./include,../include' | let b:fswitchdst = 'h'
    augroup END

    let g:compiler_gcc_ingore_unmatched_lines=1

    autocmd BufRead,BufNewFile wscript set filetype=python

    augroup autoclose_group
        au!
        au BufEnter *.wiki let g:disable_autoclose = 1
    augroup END

    augroup java
        au!
        au BufEnter *.java map <F5> :execute('!javac ').expand('%:p')<CR> :execute('!java -cp '. expand('%:p:h') . ' ' . expand('%:t:r'))<CR>
    augroup END

    augroup vimfiles
        au!
        au BufEnter *.vim nmap <f5> :source %<CR>
    augroup END

    augroup xml
        au!
        au BufEnter *.xml :compiler xmlstar-val
    augroup END

    augroup docbook
        au!
        au BufEnter *.docbook :compiler xmlstar-val | :set filetype=xml
    augroup END

    augroup CoffeeScript
        au!
        au BufEnter *.coffee map <F5> :w<CR>:CoffeeMake<CR>:CoffeeRun<CR><CR>
    augroup END

    augroup WebDev
        au!
        au BufEnter *php,*html map <C-Enter> :call OpenInBrowser()<CR>
    augroup END

    "let coffee_make_options = '--bare'
    let coffee_make_options = ''

    " when loosing focus, write all buffers
    au FocusLost * :wa

    au BufEnter *.py,wscript set foldmethod=marker
endif
"}}}

"-----------------------------------------------------------------------------
" Fix constant spelling mistakes {{{
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
" }}} Spelling mistakes

"-----------------------------------------------------------------------------
" Set up the window colors and size
"-----------------------------------------------------------------------------
if has("gui_running")
    if has("win32")
        set guifont=Envy_Code_R:h10
    endif
    set background=light
    colorscheme jellybeans
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
