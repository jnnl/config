" vimrc
" jnnl.net

" General

set encoding=utf-8
set backspace=indent,eol,start
set autoread
set wildmenu
set lazyredraw

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
set relativenumber
set cursorline

set background=light
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

let VIMDIR = $HOME.'/.vim/'

if !isdirectory(VIMDIR.'backup')
    silent call mkdir (VIMDIR.'backup', 'p')
endif
if !isdirectory(VIMDIR.'swap')
    silent call mkdir (VIMDIR.'swap', 'p')
endif
if !isdirectory(VIMDIR.'undo')
    silent call mkdir (VIMDIR.'undo', 'p')
endif

let &backupdir = VIMDIR.'backup//'
let &directory = VIMDIR.'swap//'
let &undodir   = VIMDIR.'undo//'

" Mappings
" General
map         , <leader>

nnoremap    ,, :
nnoremap    § :w<CR>
nnoremap    B ^
nnoremap    E $
nnoremap    gV `[v`]
nnoremap    <BS> <C-^>
inoremap    <S-Tab> <C-n>
inoremap    <expr> <Tab> TabComplete()

nnoremap    <leader>w :w<CR>
nnoremap    <leader>sw :w !sudo tee > /dev/null %<CR>
nnoremap    <silent><leader>cc :!clear; cc % && ./a.out<CR>
nnoremap    <silent><leader>ca :!clear; cargo run<CR>
nnoremap    <silent><leader>cb :!clear; cargo build<CR>
nnoremap    <silent><leader>py :!clear; python3 %<CR>
nnoremap    <silent><leader>rb :!clear; ruby %<CR>
nnoremap    <silent><leader>rs :!clear; rustc % && ./%:r<CR>
nnoremap    <silent><leader>sh :!clear; ./%<CR>
nnoremap    <leader>co :call ToggleColors()<CR>
nnoremap    <leader>hl :set hlsearch! hlsearch?<CR>
nnoremap    <leader>z /[^\x00-\x7F]<CR>
nnoremap    <leader>x :Explore<CR>

" FZF
nnoremap    <leader>fa :Ag<CR>
nnoremap    <leader>fb :Buffers<CR>
nnoremap    <leader>fc :Commits<CR>
nnoremap    <leader>ff :Files<CR>
nnoremap    <leader>fh :History<CR>
nnoremap    <leader>fl :Lines<CR>
nnoremap    <leader>fw :Windows<CR>

imap        <C-l> <plug>(fzf-complete-line)

" Functions

function! TabComplete()
    let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
            return "\<Tab>"
        else
            return "\<C-p>"
        endif
endfunction

function! ToggleColors()
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
Plug 'tpope/vim-fugitive'
Plug 'rust-lang/rust.vim'
call plug#end()

" Netrw settings
let g:netrw_banner = 0
