" strontium.vim
" jnnl.net

set background=dark
hi clear
syntax reset

let g:colors_name = "strontium"

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

let s:bg           = {"term": "235", "gui": "#262626"}
let s:bg_dark      = {"term": "234", "gui": "#1c1c1c"}
let s:bg_light     = {"term": "237", "gui": "#3a3a3a"}
let s:bg_light2    = {"term": "238", "gui": "#444444"}

let s:fg           = {"term": "249", "gui": "#b2b2b2"}
let s:fg_dark      = {"term": "245", "gui": "#878787"}
let s:fg_dark2     = {"term": "241", "gui": "#626262"}
let s:fg_light     = {"term": "251", "gui": "#c6c6c6"}
let s:fg_light2    = {"term": "254", "gui": "#e4e4e4"}

let s:red          = {"term": "88",  "gui": "#870000"}
let s:red2         = {"term": "131", "gui": "#d78787"}
let s:red3         = {"term": "138", "gui": "#af8787"}
let s:yellow       = {"term": "58",  "gui": "#5f5f00"}
let s:yellow2      = {"term": "100", "gui": "#878700"}
let s:yellow3      = {"term": "180", "gui": "#dfaf87"}
let s:yellow4      = {"term": "137", "gui": "#af875f"}
let s:green        = {"term": "65",  "gui": "#5f875f"}
let s:green2       = {"term": "101", "gui": "#87875f"}
let s:blue         = {"term": "66",  "gui": "#5f8787"}

" Highlights

call s:hi("Normal", s:fg, s:bg, "")

call s:hi("ColorColumn", "", s:bg_light, "")
call s:hi("Conceal", "", "", "")

call s:hi("Cursor", "", "", "")
call s:hi("CursorColumn", "", "", "")
call s:hi("CursorLine", "", "", "")

call s:hi("Directory", "", "", "")

call s:hi("DiffAdd", s:fg_light, s:green, "")
call s:hi("DiffChange", s:fg_light, s:bg_light2, "")
call s:hi("DiffDelete", s:fg_light, s:red2, "")
call s:hi("DiffText", s:fg_light, s:blue, "")

call s:hi("ErrorMsg", s:red2, s:bg, "")

call s:hi("VertSplit", s:fg_dark2, s:bg, "")

call s:hi("Folded", s:fg_dark2, s:bg, "")
call s:hi("FoldColumn", s:fg, s:bg, "")

call s:hi("SignColumn", "", s:bg, "")

call s:hi("IncSearch", s:fg_light2, s:yellow2, "")
call s:hi("Search", s:fg_light2, s:yellow, "")

call s:hi("LineNr", s:fg_dark2, "", "")
call s:hi("CursorLineNr", s:fg_dark, "", "")

call s:hi("MatchParen", s:fg, s:fg_dark2, "")

call s:hi("ModeMsg", s:blue, "", "")
call s:hi("MoreMsg", s:yellow3, "", "")

call s:hi("NonText", s:fg_dark2, "", "")

call s:hi("Pmenu", s:fg_dark, s:bg_light2, "")
call s:hi("PmenuSel", s:blue, s:bg_light, "")
call s:hi("PmenuSbar", "", s:bg_light2, "")
call s:hi("PmenuThumb", "", s:bg_light, "")

call s:hi("Question", s:fg, "", "")

call s:hi("SpecialKey", s:fg_dark2, "", "")

call s:hi("SpellBad", s:red2, s:bg_light, "")
call s:hi("SpellCap", s:fg, s:bg, "")
call s:hi("SpellLocal", s:fg, s:bg, "")
call s:hi("SpellRare", s:fg, s:bg, "")

call s:hi("StatusLine", s:fg_dark, s:bg_light, "")
call s:hi("StatusLineNC", s:fg_dark2, s:bg_light, "")

call s:hi("TabLine", s:fg_dark2, s:bg_light, "")
call s:hi("TabLineFill", "", s:bg_light, "")
call s:hi("TabLineSel", s:fg_dark, s:bg_light, "")

call s:hi("Title", s:fg, s:bg, "")

call s:hi("Visual", "", s:bg_light, "")
hi! link VisualNOS Visual

call s:hi("WarningMsg", s:yellow, s:bg, "")

call s:hi("WildMenu", s:blue, s:bg_light, "")

call s:hi("Comment", s:fg_dark2, "", "")
call s:hi("SpecialComment", s:fg_dark, "", "")
hi! link Todo SpecialComment

call s:hi("String", s:green2, "", "")
hi! link Character   String
hi! link SpecialChar String
hi! link Special     String

call s:hi("Number", s:yellow3, "", "")
hi! link Boolean Number
hi! link Float   Number

call s:hi("Operator", s:fg_light, "", "")
call s:hi("Identifier", s:fg_light, "", "")
call s:hi("Constant", s:fg_light, "", "")

call s:hi("Statement", s:red3, "", "")
hi! link Conditional Statement
hi! link Keyword     Statement
hi! link Label       Statement
hi! link Repeat      Statement
hi! link Exception   Statement

call s:hi("Function", s:blue, "", "")
hi! link Type         Function
hi! link StorageClass Function
hi! link Structure    Function
hi! link Typedef      Function

call s:hi("PreProc", s:fg, "", "")
call s:hi("Include", s:fg, "", "")
call s:hi("Define", s:red3, "", "")
call s:hi("Macro", s:fg, "", "")
call s:hi("PreCondit", s:red3, "", "")
call s:hi("Tag", s:fg, "", "")
call s:hi("Delimiter", s:fg, "", "")
call s:hi("Debug", s:fg, "", "")
call s:hi("Underlined", s:fg, "", "underline")
call s:hi("Ignore", s:fg, "", "")

call s:hi("Error", s:fg_light, s:red, "")

" C
call s:hi("cConditional", s:red3, "", "")
call s:hi("cRepeat", s:red3, "", "")
call s:hi("cType", s:blue, "", "")
call s:hi("cStorageClass", s:blue, "", "")

" HTML
call s:hi("htmlTag", s:red3, "", "")
hi! link htmlEndTag    htmlTag
hi! link htmlScriptTag htmlTag
hi! link htmlTagName   htmlTag
hi! link htmlArg       htmlTag

" Python
call s:hi("pythonInclude", s:fg, "", "")
call s:hi("pythonStatement", s:red3, "", "")
hi! link pythonConditional pythonStatement
hi! link pythonRepeat      pythonStatement
hi! link pythonException   pythonStatement
hi! link pythonPreCondit   pythonStatement

call s:hi("pythonFunction", s:blue, "", "")
hi! link pythonExClass pythonFunction

" Ruby
call s:hi("rubyConstant", s:fg_light, "", "")
call s:hi("rubyInclude", s:fg, "", "")
call s:hi("rubySymbol", s:red3, "", "")
hi! link rubyControl     rubySymbol
hi! link rubyConditional rubySymbol
hi! link rubyRepeat      rubySymbol
hi! link rubyException   rubySymbol

call s:hi("rubyFunction", s:blue, "", "")

