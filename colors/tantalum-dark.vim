" tantalum-dark.vim
" jnnl.net

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "tantalum-dark"

function! s:hi(group, fg, bg, style)
    if !empty(a:fg)
        exec "hi ".a:group." ctermfg="(get(a:fg, "term", ""))
        exec "hi ".a:group." guifg="(get(a:fg, "gui", ""))
    endif
    if !empty(a:bg)
        exec "hi ".a:group." ctermbg="(get(a:bg, "term", ""))
        exec "hi ".a:group." guibg="(get(a:bg, "gui", ""))
    endif
    if !empty(a:style)
        exec "hi ".a:group." cterm=".a:style
        exec "hi ".a:group." gui=".a:style
    else
        exec "hi ".a:group." cterm=none"
        exec "hi ".a:group." gui=none"
    endif
endfunction

" Colors

let s:bg      = {"term": "236", "gui": "#303030"}
let s:bg2     = {"term": "237", "gui": "#3a3a3a"}
let s:bg3     = {"term": "240", "gui": "#585858"}
let s:bg4     = {"term": "249", "gui": "#b2b2b2"}
let s:bg5     = {"term": "253", "gui": "#dadada"}

let s:fg      = {"term": "252", "gui": "#d0d0d0"}
let s:fg2     = {"term": "248", "gui": "#a8a8a8"}
let s:fg3     = {"term": "247", "gui": "#9e9e9e"}
let s:fg4     = {"term": "243", "gui": "#767676"}
let s:fg5     = {"term": "241", "gui": "#626262"}

let s:cursor  = {"term": "239", "gui": "#4e4e4e"}

let s:white   = {"term": "255", "gui": "#ffffff"}
let s:red     = {"term": "131", "gui": "#af5f5f"}
let s:red2    = {"term": "88",  "gui": "#870000"}
let s:orange  = {"term": "215", "gui": "#ffaf5f"}
let s:orange2 = {"term": "179", "gui": "#dfaf5f"}
let s:yellow  = {"term": "186", "gui": "#dfdf87"}
let s:yellow2 = {"term": "143", "gui": "#afaf5f"}
let s:green   = {"term": "150", "gui": "#afd787"}
let s:green2  = {"term": "108", "gui": "#87af87"}
let s:blue    = {"term": "153", "gui": "#afd7ff"}
let s:blue2   = {"term": "110", "gui": "#87afd7"}

" Highlights

call s:hi("Normal", s:fg, s:bg, "")

call s:hi("ColorColumn", "", "", "")
call s:hi("Conceal", s:fg5, "", "")

call s:hi("Cursor", "", s:cursor, "")
call s:hi("CursorColumn", "", "", "")
call s:hi("CursorLine", "", "", "")

call s:hi("Directory", s:fg3, "", "")

call s:hi("DiffAdd", s:white, s:green2, "")
call s:hi("DiffChange", s:fg, s:bg2, "")
call s:hi("DiffDelete", s:white, s:red2, "")
call s:hi("DiffText", s:white, s:orange2, "")

call s:hi("ErrorMsg", s:red, s:bg, "")

call s:hi("VertSplit", s:bg2, s:bg2, "")

call s:hi("Folded", s:fg5, s:bg, "")
call s:hi("FoldColumn", "", "", "")

call s:hi("SignColumn", s:fg, s:bg, "")

call s:hi("IncSearch", s:bg, s:yellow, "")

call s:hi("LineNr", s:fg5, s:bg, "")
call s:hi("CursorLineNr", s:fg3, s:bg, "")

call s:hi("MatchParen", s:fg, s:bg3, "")

call s:hi("ModeMsg", s:blue2, "", "")
call s:hi("MoreMsg", s:yellow2, "", "")

call s:hi("NonText", s:fg5, "", "")

call s:hi("Pmenu", s:fg3, s:bg2, "")
call s:hi("PmenuSel", s:fg, s:bg3, "")
call s:hi("PmenuSbar", s:fg, s:bg3, "")
call s:hi("PmenuThumb", s:fg, s:bg3, "")

call s:hi("Question", s:fg, "", "")

call s:hi("Search", s:bg, s:yellow2, "")

call s:hi("SpecialKey", s:fg, "", "")

call s:hi("SpellBad", "", "", "")
call s:hi("SpellCap", "", "", "")
call s:hi("SpellLocal", "", "", "")
call s:hi("SpellRare", "", "", "")

call s:hi("StatusLine", s:fg, s:bg2, "")
call s:hi("StatusLineNC", s:fg3, s:bg2, "")

call s:hi("TabLine", s:fg3, s:bg3, "")
call s:hi("TabLineFill", "", s:bg3, "")
call s:hi("TabLineSel", s:fg, "", "")

call s:hi("Title", s:fg, s:bg, "")

call s:hi("Visual", s:fg, s:bg3, "")
call s:hi("VisualNOS", s:fg, s:bg3, "")

call s:hi("WarningMsg", s:orange2, "", "")

call s:hi("WildMenu", s:blue2, s:bg2, "")

hi! link Constant       Normal
hi! link Number         Normal
hi! link Boolean        Normal
hi! link Float          Normal
hi! link Identifier     Normal
hi! link Function       Normal
hi! link Statement      Normal
hi! link Conditonal     Normal
hi! link Repeat         Normal
hi! link Label          Normal
hi! link Operator       Normal
hi! link Keyword        Normal
hi! link Exception      Normal
hi! link PreProc        Normal
hi! link Include        Normal
hi! link Define         Normal
hi! link Macro          Normal
hi! link PreCondit      Normal
hi! link Type           Normal
hi! link StorageClass   Normal
hi! link Structure      Normal
hi! link Typedef        Normal
hi! link Special        Normal
hi! link Tag            Normal
hi! link Delimiter      Normal
hi! link Debug          Normal
hi! link Underlined     Normal

call s:hi("String", s:fg2, "", "")
hi! link Character      String
hi! link SpecialChar    String

call s:hi("Comment", s:fg4, "", "")
hi! link SpecialComment Comment

call s:hi("Ignore", s:fg4, s:bg, "")
call s:hi("Error", s:fg, s:red2, "")
call s:hi("Todo", s:fg3, s:bg2, "")
