" vimrc
" jnnl.net

" General

set encoding=utf-8
set backspace=indent,eol,start
set autoread
set wildmenu
set lazyredraw
set ttyfast
set mouse=a

" Indentation

if has('autocmd')
  filetype plugin indent on
endif

set autoindent
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Splits

set splitright
set splitbelow

" Search

set incsearch
set ignorecase
set smartcase

" Styles

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

set ruler
set rulerformat=%14l:%c
set number
set cursorline

colorscheme tantalum

" Screen

if !&scrolloff
    set scrolloff=1
endif
if !&sidescrolloff
    set sidescrolloff=5
endif
set display+=lastline

" Auxiliary directories

let AUXDIR = $HOME.'/.vim/'

if !isdirectory(AUXDIR.'backup')
    silent call mkdir (AUXDIR.'backup', 'p')
endif
if !isdirectory(AUXDIR.'swap')
    silent call mkdir (AUXDIR.'swap', 'p')
endif
if !isdirectory(AUXDIR.'undo')
    silent call mkdir (AUXDIR.'undo', 'p')
endif

let &backupdir = AUXDIR.'backup//'
let &directory = AUXDIR.'swap//'
let &undodir   = AUXDIR.'undo//'

" Mappings
" General
map         , <leader>
nnoremap    § :w<CR>
inoremap    <S-Tab> <C-V><Tab>

nnoremap    <leader>ww :w !sudo tee > /dev/null %<CR>
nnoremap    <silent><leader>py :!clear; python3 %<CR>
nnoremap    <silent><leader>cc :!clear; cc % && ./a.out<CR>
nnoremap    <leader>co :call JColorToggle()<CR>

nnoremap    <leader>mk :make<CR>
nnoremap    <leader>cw :cw<CR>

nnoremap    ﬁ <C-w><C-l> 
nnoremap    ˛ <C-w><C-h> 
nnoremap    ª <C-w><C-k> 
nnoremap    √ <C-w><C-j> 

nnoremap    ö gT
nnoremap    ä gt
nnoremap    <leader>hl :set hlsearch! hlsearch?<CR>
nnoremap    <leader>x :Explore<CR>

nnoremap    <leader>t2 :set expandtab shiftwidth=2 tabstop=2 softtabstop=2<CR>
nnoremap    <leader>t4 :set expandtab shiftwidth=4 tabstop=4 softtabstop=4<CR>
nnoremap    <leader>t8 :set expandtab shiftwidth=8 tabstop=8 softtabstop=8<CR>

" Vim-session
nnoremap    <leader>ss :SaveSession 
nnoremap    <leader>sd :DeleteSession
nnoremap    <leader>so :OpenSession<CR>
nnoremap    <leader>sc :CloseSession<CR>

" FZF
nnoremap    <leader>fb :Buffers<CR>
nnoremap    <leader>fc :Commits<CR>
nnoremap    <leader>ff :Files<CR>
nnoremap    <leader>fh :History<CR>
nnoremap    <leader>fl :Lines<CR>
nnoremap    <leader>fw :Windows<CR>

inoremap    <C-l> <plug>(fzf-complete-line)

" Functions

function! JColorToggle()
    if exists("g:colors_name")
        if g:colors_name != "blank"
            colorscheme blank
            set nonumber
        else
            colorscheme tantalum
            set number
        endif
    else
        colorscheme tantalum
    endif
endfunction

" Plugins

call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'xolox/vim-misc', { 'on': ['SaveSession', 'DeleteSession', 'OpenSession', 'CloseSession'] }
Plug 'xolox/vim-session', { 'on': ['SaveSession', 'DeleteSession', 'OpenSession', 'CloseSession'] }
let g:session_autosave = 'no'
let g:session_autoload = 'no'
call plug#end()
