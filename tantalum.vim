" tantalum.vim
" jnnl.net

set background=light
hi clear
syntax reset

let g:colors_name="tantalum"

" Highlight groups

hi ColorColumn     ctermfg=none    ctermbg=none    cterm=none

hi Conceal         ctermfg=253     ctermbg=none    cterm=none

hi Cursor          ctermfg=none    ctermbg=none    cterm=none
hi CursorColumn    ctermfg=none    ctermbg=none    cterm=none
hi CursorLine      ctermfg=none    ctermbg=none    cterm=none

hi Directory       ctermfg=none    ctermbg=none    cterm=none

hi DiffAdd         ctermfg=none    ctermbg=194     cterm=none
hi DiffChange      ctermfg=none    ctermbg=254     cterm=none
hi DiffDelete      ctermfg=none    ctermbg=224     cterm=none
hi DiffText        ctermfg=none    ctermbg=none    cterm=none

hi ErrorMsg        ctermfg=none    ctermbg=224     cterm=none

hi VertSplit       ctermfg=253     ctermbg=253     cterm=none

hi Folded          ctermfg=248     ctermbg=none    cterm=none
hi FoldColumn      ctermfg=none    ctermbg=none    cterm=none

hi SignColumn      ctermfg=none    ctermbg=none    cterm=none

hi IncSearch       ctermfg=none    ctermbg=222     cterm=none

hi LineNr          ctermfg=248     ctermbg=none    cterm=none
hi CursorLineNR    ctermfg=239     ctermbg=none    cterm=none

hi MatchParen      ctermfg=none    ctermbg=253     cterm=none

hi ModeMsg         ctermfg=24      ctermbg=none    cterm=bold
hi MoreMsg         ctermfg=none    ctermbg=none    cterm=none

hi NonText         ctermfg=248     ctermbg=none    cterm=none

hi Normal          ctermfg=239     ctermbg=255     cterm=none

hi Pmenu           ctermfg=243     ctermbg=254     cterm=none
hi PmenuSel        ctermfg=0       ctermbg=253     cterm=none
hi PmenuSbar       ctermfg=none    ctermbg=254     cterm=none
hi PmenuThumb      ctermfg=none    ctermbg=252     cterm=none

hi Question        ctermfg=none    ctermbg=none    cterm=none

hi Search          ctermfg=none    ctermbg=222     cterm=none

hi SpecialKey      ctermfg=0       ctermbg=none    cterm=none

hi SpellBad        ctermfg=none    ctermbg=none    cterm=none
hi SpellCap        ctermfg=none    ctermbg=none    cterm=none
hi SpellLocal      ctermfg=none    ctermbg=none    cterm=none
hi SpellRare       ctermfg=none    ctermbg=none    cterm=none

hi StatusLine      ctermfg=0       ctermbg=253     cterm=none
hi StatusLineNC    ctermfg=243     ctermbg=253     cterm=none

hi TabLine         ctermfg=243     ctermbg=253     cterm=none
hi TabLineFill     ctermfg=none    ctermbg=253     cterm=none
hi TabLineSel      ctermfg=0       ctermbg=none    cterm=none

hi Title           ctermfg=240     ctermbg=none    cterm=none

hi Visual          ctermfg=none    ctermbg=188     cterm=none
hi VisualNOS       ctermfg=none    ctermbg=188     cterm=none

hi WarningMsg      ctermfg=none    ctermbg=223     cterm=none

hi WildMenu        ctermfg=255     ctermbg=243     cterm=bold

" Syntax group names  

hi Comment         ctermfg=248     ctermbg=none    cterm=none

hi Constant        ctermfg=none    ctermbg=none    cterm=none
hi String          ctermfg=242     ctermbg=none    cterm=none
hi Character       ctermfg=242     ctermbg=none    cterm=none
hi Number          ctermfg=131     ctermbg=none    cterm=none
hi Boolean         ctermfg=none    ctermbg=none    cterm=bold
hi Float           ctermfg=131     ctermbg=none    cterm=none

hi Identifier      ctermfg=none    ctermbg=none    cterm=none
hi Function        ctermfg=24      ctermbg=none    cterm=none

hi Statement       ctermfg=none    ctermbg=none    cterm=bold
hi Conditional     ctermfg=none    ctermbg=none    cterm=bold
hi Repeat          ctermfg=none    ctermbg=none    cterm=bold
hi Label           ctermfg=none    ctermbg=none    cterm=bold
hi Operator        ctermfg=none    ctermbg=none    cterm=bold
hi Keyword         ctermfg=none    ctermbg=none    cterm=bold
hi Exception       ctermfg=none    ctermbg=none    cterm=bold

hi PreProc         ctermfg=none    ctermbg=none    cterm=none
hi Include         ctermfg=none    ctermbg=none    cterm=bold
hi Define          ctermfg=none    ctermbg=none    cterm=bold
hi Macro           ctermfg=none    ctermbg=none    cterm=bold
hi PreCondit       ctermfg=none    ctermbg=none    cterm=bold

hi Type            ctermfg=none    ctermbg=none    cterm=bold
hi StorageClass    ctermfg=none    ctermbg=none    cterm=bold
hi Structure       ctermfg=none    ctermbg=none    cterm=bold
hi Typedef         ctermfg=none    ctermbg=none    cterm=bold

hi Special         ctermfg=none    ctermbg=none    cterm=none
hi SpecialChar     ctermfg=none    ctermbg=none    cterm=none
hi Tag             ctermfg=none    ctermbg=none    cterm=none
hi Delimiter       ctermfg=none    ctermbg=none    cterm=none
hi SpecialComment  ctermfg=248     ctermbg=none    cterm=none
hi Debug           ctermfg=none    ctermbg=none    cterm=none

hi Underlined      ctermfg=none    ctermbg=none    cterm=none

hi Ignore          ctermfg=none    ctermbg=none    cterm=none

hi Error           ctermfg=none    ctermbg=none    cterm=none

hi Todo            ctermfg=243     ctermbg=none    cterm=none
