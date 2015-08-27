" based on:
" Derek Wyatt's config: https://github.com/derekwyatt/vim-config
" spf-13: https://github.com/spf13/spf13-vim

set nocompatible

"-----------------------------------------------------------------------------
" Detect OS
"-----------------------------------------------------------------------------
silent function! WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
endfunction
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

"-----------------------------------------------------------------------------
" pdev stuff {{{
"-----------------------------------------------------------------------------
if WINDOWS()
    let s:vimfiles=$VIM."\\vimfiles"
    if isdirectory( s:vimfiles ) 
        let $HOME=s:vimfiles
        let $MYVIMRC=s:vimfiles.'\.vimrc'
        let &runtimepath=&runtimepath.",".s:vimfiles
        let &runtimepath=&runtimepath.",".s:vimfiles.'\bundle\vundle'
    else
        echo "Warning: cannot find vimfiles, ".s:vimfiles." is not a folder."
    endif

else " most likely Linux
    let s:vimfiles=expand("$HOME").'/vimfiles'
    if isdirectory( s:vimfiles )
        let &runtimepath=&runtimepath.",".s:vimfiles
        let &runtimepath=&runtimepath.",".expand("$HOME").s:vimfiles.'/bundle/vundle'
    endif
endif
"}}}

if filereadable(expand(s:vimfiles."/vimrclib.vim"))
    exec "source ".s:vimfiles."/vimrclib.vim"
endif

" set globals pointing to 'bundle' folder and plugin_data {{{
"-----------------------------------------------------------------------------
let g:plugin_data = s:vimfiles . vimrclib#UnixToWin('\plugin_data')
let g:plugins_folder = s:vimfiles . vimrclib#UnixToWin('\bundle')
" }}}

if exists("$CODE")
    cd $CODE
endif

filetype off 
autocmd!

"-----------------------------------------------------------------------------
" Plugins {{{
"-----------------------------------------------------------------------------
if filereadable(expand(s:vimfiles."/.vimrc.bundles"))
    exec "source ".s:vimfiles."/.vimrc.bundles"
endif
" }}}

"-----------------------------------------------------------------------------
" Settings {{{
"-----------------------------------------------------------------------------

" Set filetype stuff to on
filetype on
filetype plugin on
filetype indent on

" ignore me some filez
set wildignore=*.lnk,*.o

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

set nowrap          " don't wrap by default
set tabstop=4       " Tabstops are 4 spaces
set shiftwidth=4
set wrapscan        " set the search scan to wrap lines
set ignorecase
set smartcase
"set shellslash
set ch=2            " Make command line two lines high
set vb              " set visual bell
set backspace=2     " Allow backspacing over indent, eol, and the start of an insert
set hidden          " Make sure that unsaved buffers that are to be put in the background are
                    " allowed to go in there (ie. the "must save first" error doesn't come up)
set ruler
set undofile
set gdefault        " regular expressions have /g by default
set laststatus=2    " tell VIM to always put a status line in, even if there is only one window
set lazyredraw
set showcmd         " Show the current command in the lower right corner
set showmode        " Show the current mode
syntax on           " Switch on syntax highlighting.
set mousehide       " Hide the mouse pointer while typing

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

set guioptions=acif " set the gui options 
set timeoutlen=500 " ms between keys in macors and commands

set history=100         " Keep some stuff in the history
set scrolloff=8
set virtualedit=all     " Allow the cursor to go in to "invalid" places
set comments=sl:/*,mb:\ *,ex:\ */,O://,b:#,:%,:XCOMM,n:>,fb:- " These things start comment lines
set key=                " Disable encryption (:X)
set wildmenu            " Make the command-line completion better
set complete=.,w,b,t,i  " Same as default except 'u' option is removed
set showfulltag         " When completing by tag, show the whole tag, not just the function name
"set textwidth=120
"set fillchars=stlnc:\ ,vert:┃,fold:-,diff:- " get rid of the characters in window separators
set expandtab           " Turn tabs into spaces
set diffopt+=iwhite     " Add ignorance of whitespace to diff
set hlsearch            " Enable search highlighting
set incsearch           " Incrementally match the search
set tags=./tags,tags    " Set the tags files to be the following
set relativenumber      " show relative line numbers by default
set modeline            " enable modeline
" }}}

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
" [ http://vim.wikia.com/wiki/Make_make_more_helpful ]
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"-----------------------------------------------------------------------------
" KEYBOARD MAPPINGS {{{
"-----------------------------------------------------------------------------

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

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
imap <silent> <C-V><C-V> <Esc>"+gP

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

" Enable neosnippet snipmate compatibility mode
let g:neosnippet#enable_snipmate_compatibility = 1

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"" neosnippet mappings
"" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"" Tell Neosnippet about the other snippets
let g:snippets_dir  =       s:vimfiles . vimrclib#UnixToWin('/bundle/vim-snippets/snippets')
let g:snippets_dir .= ',' . s:vimfiles . vimrclib#UnixToWin('/bundle/vim-snippets/snippets/javascript')
let g:snippets_dir .= ',' . g:plugin_data . vimrclib#UnixToWin('/snipmate')

" Align plugin stuff
"-----------------------------------------------------------------------------
let g:align_dont_map_keys = 1

" EnhancedCommentify Plugin Settings {{{
"-----------------------------------------------------------------------------
imap <C-c> <Esc><Plug>Commentji
imap <C-x> <Esc><Plug>DeCommentji
nmap <C-c> <Plug>Comment
nmap <C-x> <Plug>DeComment
vmap <C-c> <Plug>Comment
vmap <C-x> <Plug>DeComment
" }}}

" LocalVimrc Plugin Settings {{{
"-----------------------------------------------------------------------------
let g:localvimrc_ask = 0 "automatically source local vimrc's
let g:localvimrc_sandbox = 0 "local vimrcs are of little use in sandbox mode
" }}}

"-----------------------------------------------------------------------------
" ErrorMarker Plugin Settings
"-----------------------------------------------------------------------------
let g:errormarker_disablemappings = 1 "errormarker: no mappings


"-----------------------------------------------------------------------------
" zencoding plugin stuff
"-----------------------------------------------------------------------------
let g:user_zen_leader_key = '<c-l>'

"-----------------------------------------------------------------------------
" FSwitch Settings {{{
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
" }}}

"-----------------------------------------------------------------------------
" Startify Settings {{{
"-----------------------------------------------------------------------------
let g:startify_bookmarks = [
            \'C:/notes/workflow.md',
            \'C:/notes/work/tc/2015-W35.md',
            \'C:/notes/todos/2015-W35.md',
            \'C:/code/habitg/NOTES.md'
            \]
"}}}

"-----------------------------------------------------------------------------
" Other Plungins {{{
"-----------------------------------------------------------------------------

map <leader>f :CtrlPMRUFiles<CR>

let g:DisableAutoPHPFolding = 1
if WINDOWS()
    let g:ackprg="perl C:/pdev/bin/ack -H --nocolor --nogroup --column"
else
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
endif

let g:marvim_store = g:plugin_data . g:sep . 'marvim'
let java_highlight_all=1
let g:vim_markdown_initial_foldlevel=10
let g:compiler_gcc_ingore_unmatched_lines=1
let coffee_make_options = ''
let g:asciidoc_txt_force = 1
let g:asciidoc_common_force = 1 " }}}

function! ColorTodo() abort
    syntax keyword todoOk √
    syntax keyword todoFailed ×
    highlight todoOk guifg=green
    highlight todoFailed guifg=red
endfunction


"-----------------------------------------------------------------------------
" Digraphs
"-----------------------------------------------------------------------------
digraph vv 8730 
digraph xx 215
digraph oo 9675 


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

    autocmd BufRead,BufNewFile wscript set filetype=python

    augroup misc
        au!
        au BufEnter             *.md            set digraph | call ColorTodo()
        au BufRead,BufNewFile   *.md            set filetype=markdown
        au BufRead,BufNewFile   *.pp            set filetype=puppet
        au BufEnter             *.py,wscript    set foldmethod=marker
        au BufEnter             *.java          map <F5> :execute('!javac ').expand('%:p')<CR> :execute('!java -cp '. expand('%:p:h') . ' ' . expand('%:t:r'))<CR>
        au BufEnter             *.ahk           map <F5> :execute('silent !C:\pdev\ahk\AutoHotkey /force ').expand('%:p')<CR>
        au BufEnter             *.coffee        map <F5> :w<CR>:CoffeeMake<CR>:CoffeeRun<CR><CR>
        au BufWritePost         [^_]*.scss      :execute('!scss --sourcemap --trace '.PathToPathname(expand('%:p')).' '.PathToPathname(TrimDirs(expand('%:p'),2).'css'.g:sep.expand('%:t:r').'.css'))
        au BufEnter             *.jade,*.js     set tabstop=2 shiftwidth=2 expandtab
    augroup END
    au FocusLost * :wa

    au BufReadPost quickfix nnoremap <buffer> <CR> <CR><C-W><C-P>
    au BufReadPost quickfix nnoremap <buffer> o <CR>
endif
"}}}

"-----------------------------------------------------------------------------
" Set up the window colors and size {{{
"-----------------------------------------------------------------------------
if has("gui_running")
"    let g:netrw_silent= 1
    if WINDOWS()
"        set guifont=Envy_Code_R:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        set guifont=Consolas:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
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
