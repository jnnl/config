" vimrc
" jnnl.net

" General

set encoding=utf-8
set backspace=indent,eol,start
set autoread
set wildmenu
set lazyredraw
set ttyfast

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

set number
set cursorline
set background=light
colorscheme tungsten

" Screen

if !&scrolloff
    set scrolloff=1
endif
if !&sidescrolloff
    set sidescrolloff=5
endif
set display+=lastline

" Auxiliary directories

if has('win32')
    let AUXDIR = $HOME.'\vimfiles\'
else
    let AUXDIR = $HOME.'/.vim/'
endif

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

map         , <leader>
noremap     § :w<CR>
nnoremap    <leader>ww :w !sudo tee > /dev/null %
inoremap    <S-Tab> <C-V><Tab>
nnoremap    <silent><leader>py :!clear; python %<CR>
nnoremap    <silent><leader>cc :!clear; cc % && ./a.out<CR>

nnoremap    ﬁ <C-w><C-l> 
nnoremap    ˛ <C-w><C-h> 
nnoremap    ª <C-w><C-k> 
nnoremap    √ <C-w><C-j> 
nnoremap    <leader>ö gT
nnoremap    <leader>ä gt
nnoremap    <leader>hl :set hlsearch! hlsearch?<CR>
nnoremap    <leader>x :Explore<CR>

nnoremap    <leader>ss :SaveSession 
nnoremap    <leader>sd :DeleteSession
nnoremap    <leader>so :OpenSession<CR>
nnoremap    <leader>sc :CloseSession<CR>

nnoremap    <leader>fb :Buffers<CR>
nnoremap    <leader>fc :Commits<CR>
nnoremap    <leader>ff :Files
nnoremap    <leader>fh :History<CR>
nnoremap    <leader>fl :Lines<CR>
nnoremap    <leader>fw :Windows<CR>

imap        <C-l> <plug>(fzf-complete-line)

" Windows-specific settings

if has('win32')
    source $HOME\_winrc
endif

" Plugins

call plug#begin()
if !has('gui_running')
    Plug 'godlygeek/csapprox'
endif
if !has('win32')
    Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
    Plug 'junegunn/fzf.vim'
endif
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
let g:session_autosave = 'no'
let g:session_autoload = 'no'
call plug#end()
