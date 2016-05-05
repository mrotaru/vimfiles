" vim: set filetype=vim:

function! vimrclib#RunSystemCall(systemcall)
    let output = system(a:systemcall)
    let output = substitute(output, "\n", '', 'g')
    return output
endfunction

" Returns the (zero-indexed) position of the `n`-th occurence of `needle` in
" `haystack`, counting from the end of the string.
" If `haystack` contains no `needle`s, returns -1
"-----------------------------------------------------------------------------
function! vimrclib#NthFromTheEnd( haystack, needle, n )
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
function! vimrclib#NthFromTheStart( haystack, needle, n )
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

" hex editing mode
" http://www.kevssite.com/2009/04/21/using-vi-as-a-hex-editor/#comment-1045723510
let $in_hex=0
function! vimrclib#HexMe()
    set binary
    set noeol
    if $in_hex>0
        :%!xxd -r
        let $in_hex=0
    else
        :%!xxd
        let $in_hex=1
    endif
endfunction

" determine path separator
if has('win16') || has('win32') || has ('win95') || has('win64')
    let g:sep = '\'
else 
    let g:sep = '/'
endif

" returns 'path' with 'num_dirs' removed, WITH a trailing path separator
function! vimrclib#TrimDirs( path, num_dirs )
    let sep_index=NthFromTheEnd( a:path, g:sep, a:num_dirs )
    if sep_index != -1
        return strpart( a:path, 0, sep_index + 1 )
    endif
endfunction

" TODO: needs special handling on linux
function! vimrclib#TrimDirsFromStart( path, num_dirs )
    let sep_index=NthFromTheStart( a:path, g:sep, a:num_dirs )
    if sep_index != -1
        return strpart( a:path, sep_index+1 )
    endif
endfunction

" NOTE: Windows-only
function! vimrclib#OpenInBrowser()
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
function! vimrclib#FixQuotes()
    if &gdefault
        %s//"/e
        %s//"/e
        %s//'/e
        %s/¿/'/e
        %s/¿/"/e
        %s/¿/"/e
    else
        %s//"/ge
        %s//"/ge
        %s//'/ge
        %s/¿/'/ge
        %s/¿/"/ge
        %s/¿/"/ge
    endif
endfunction

" converts a Windows path to Pathname format
" see: https://github.com/oneclick/rubyinstaller/issues/179
" ------------------------------------------------------------------------------
function! vimrclib#PathToPathname(path)
    if has('win16') || has('win32') || has ('win95') || has('win64')
        return substitute( a:path, '\\','/','g')
    else
        return a:path
    endif
endfunction

" converts a Unix path to a Windows path, if needed
" ------------------------------------------------------------------------------
function! vimrclib#UnixToWin(path)
    if has('win16') || has('win32') || has ('win95') || has('win64')
        return substitute( a:path, '/','\\','g')
    else
        return a:path
    endif
endfunction
