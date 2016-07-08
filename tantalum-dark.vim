" tantalum.vim
" Author: Juho Junnila (juho@jnnl.net)
" Maintainer: Juho Junnila (juho@jnnl.net)

set background=dark
hi clear
syntax reset

let g:colors_name="tantalum"

" Highlight groups

hi ColorColumn     ctermfg=none    ctermbg=none    cterm=none

hi Conceal         ctermfg=241     ctermbg=none    cterm=none

hi Cursor          ctermfg=none    ctermbg=none    cterm=none
hi CursorColumn    ctermfg=none    ctermbg=none    cterm=none
hi CursorLine      ctermfg=none    ctermbg=none    cterm=none

hi Directory       ctermfg=none    ctermbg=none    cterm=none

hi DiffAdd         ctermfg=none    ctermbg=194     cterm=none
hi DiffChange      ctermfg=none    ctermbg=254     cterm=none
hi DiffDelete      ctermfg=none    ctermbg=88      cterm=none
hi DiffText        ctermfg=none    ctermbg=none    cterm=none

hi ErrorMsg        ctermfg=none    ctermbg=88      cterm=none

hi VertSplit       ctermfg=241     ctermbg=241     cterm=none

hi Folded          ctermfg=241     ctermbg=none    cterm=none
hi FoldColumn      ctermfg=none    ctermbg=none    cterm=none

hi SignColumn      ctermfg=none    ctermbg=none    cterm=none

hi IncSearch       ctermfg=none    ctermbg=58     cterm=none

hi LineNr          ctermfg=241     ctermbg=none    cterm=none
hi CursorLineNR    ctermfg=251     ctermbg=none    cterm=none

hi MatchParen      ctermfg=none    ctermbg=241     cterm=none

hi ModeMsg         ctermfg=67      ctermbg=none    cterm=bold
hi MoreMsg         ctermfg=none    ctermbg=none    cterm=none

hi NonText         ctermfg=241     ctermbg=none    cterm=none

hi Normal          ctermfg=251     ctermbg=236     cterm=none

hi Pmenu           ctermfg=243     ctermbg=254     cterm=none
hi PmenuSel        ctermfg=255     ctermbg=241     cterm=none
hi PmenuSbar       ctermfg=none    ctermbg=254     cterm=none
hi PmenuThumb      ctermfg=none    ctermbg=251     cterm=none

hi Question        ctermfg=none    ctermbg=none    cterm=none

hi Search          ctermfg=none    ctermbg=58     cterm=none

hi SpecialKey      ctermfg=255     ctermbg=none    cterm=none

hi SpellBad        ctermfg=none    ctermbg=none    cterm=none
hi SpellCap        ctermfg=none    ctermbg=none    cterm=none
hi SpellLocal      ctermfg=none    ctermbg=none    cterm=none
hi SpellRare       ctermfg=none    ctermbg=none    cterm=none

hi StatusLine      ctermfg=15      ctermbg=241     cterm=none
hi StatusLineNC    ctermfg=249     ctermbg=241     cterm=none

hi TabLine         ctermfg=249     ctermbg=241     cterm=none
hi TabLineFill     ctermfg=none    ctermbg=241     cterm=none
hi TabLineSel      ctermfg=15      ctermbg=none    cterm=none

hi Title           ctermfg=251     ctermbg=none    cterm=none

hi Visual          ctermfg=none    ctermbg=238     cterm=none
hi VisualNOS       ctermfg=none    ctermbg=238     cterm=none

hi WarningMsg      ctermfg=none    ctermbg=94      cterm=none

hi WildMenu        ctermfg=236     ctermbg=248     cterm=bold

" Syntax group names  

hi Comment         ctermfg=241     ctermbg=none    cterm=none

hi Constant        ctermfg=none    ctermbg=none    cterm=none
hi String          ctermfg=247     ctermbg=none    cterm=none
hi Character       ctermfg=247     ctermbg=none    cterm=none
hi Number          ctermfg=174     ctermbg=none    cterm=none
hi Boolean         ctermfg=none    ctermbg=none    cterm=bold
hi Float           ctermfg=174     ctermbg=none    cterm=none

hi Identifier      ctermfg=none    ctermbg=none    cterm=none
hi Function        ctermfg=67      ctermbg=none    cterm=none

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
hi SpecialComment  ctermfg=241     ctermbg=none    cterm=none
hi Debug           ctermfg=none    ctermbg=none    cterm=none

hi Underlined      ctermfg=none    ctermbg=none    cterm=none

hi Ignore          ctermfg=none    ctermbg=none    cterm=none

hi Error           ctermfg=none    ctermbg=none    cterm=none

hi Todo            ctermfg=243     ctermbg=none    cterm=none
