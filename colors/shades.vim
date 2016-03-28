set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="shades"

hi Normal guifg=#e8e8d3 guibg=#151515
"call s:X("Visual","","404040","","","")
"call s:X("Cursor","","b0d0f0","","","")

"call s:X("LineNr","605958","151515","none","Black","")
hi Comment guifg=#888888
"call s:X("Todo","808080","","bold","","")

"call s:X("StatusLine","f0f0f0","101010","italic","","")
"call s:X("StatusLineNC","a0a0a0","181818","italic","","")
"call s:X("VertSplit","181818","181818","italic","","")

"call s:X("Folded","a0a8b0","384048","italic","black","")
"call s:X("FoldColumn","a0a8b0","384048","","","")
"call s:X("SignColumn","a0a8b0","384048","","","")

"call s:X("Title","70b950","","bold","","")

"call s:X("Constant","cf6a4c","","","Red","")
"call s:X("Special","799d6a","","","Green","")
"call s:X("Delimiter","668799","","","Grey","")

"call s:X("String","99ad6a","","","Green","")
"call s:X("StringDelimiter","556633","","","DarkGreen","")

"call s:X("Identifier","c6b6ee","","","LightCyan","")
"call s:X("Structure","8fbfdc","","","LightCyan","")
"call s:X("Function","fad07a","","","Yellow","")
"call s:X("Statement","8197bf","","","DarkBlue","")
"call s:X("PreProc","8fbfdc","","","LightBlue","")

"hi link Operator Normal

"call s:X("Type","ffb964","","","Yellow","")
"call s:X("NonText","808080","151515","","","")

"call s:X("SpecialKey","808080","343434","","","")

"call s:X("Search","f0a0c0","302028","underline","Magenta","")

"call s:X("Directory","dad085","","","","")
"call s:X("ErrorMsg","","902020","","","")
"hi link Error ErrorMsg

"" Diff

"hi link diffRemoved Constant
"hi link diffAdded String

"" VimDiff

"call s:X("DiffAdd","","032218","","Black","DarkGreen")
"call s:X("DiffChange","","100920","","Black","DarkMagenta")
"call s:X("DiffDelete","220000","220000","","DarkRed","DarkRed")
"call s:X("DiffText","","000940","","","DarkRed")


