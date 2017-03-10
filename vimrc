" vimrc
" jnnl.net

" General
set encoding=utf-8
set backspace=indent,eol,start
set autoread
set wildmenu

" Performance tweaks
set ttyfast
set ttyscroll=3
set lazyredraw
set synmaxcol=256
syn sync minlines=256

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

set nocursorline
set nocursorcolumn

colorscheme tantalum-dark

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
map         , <leader>

nnoremap    ,, :
nnoremap    § :w<CR>
nnoremap    ö <C-o>
nnoremap    ä <C-i>

nnoremap    <leader>w :w<CR>
nnoremap    <leader>sw :w !sudo tee > /dev/null %<CR>
nnoremap    <silent><leader>cb :!clear; cargo build<CR>
nnoremap    <silent><leader>cr :!clear; cargo run<CR>
nnoremap    <leader>hl :set hlsearch! hlsearch?<CR>
nnoremap    <leader>hn /[^\x00-\x7F]<CR>
nnoremap    <leader>ex :Explore<CR>

nnoremap    <leader>fa :Ag<CR>
nnoremap    <leader>fb :Buffers<CR>
nnoremap    <leader>fc :Commits<CR>
nnoremap    <leader>ff :Files<CR>
nnoremap    <leader>fh :History<CR>
nnoremap    <leader>fl :Lines<CR>
nnoremap    <leader>fw :Windows<CR>

imap        <C-l> <plug>(fzf-complete-line)


" Functions
function! <SID>AutoMkDir()
    let s:directory = expand("<afile>:p:h")
    if !isdirectory(s:directory)
        call mkdir(s:directory, "p")
    endif
endfunction

augroup mkdir
    autocmd!
    autocmd BufWritePre,FileWritePre * :call <SID>AutoMkDir()
augroup END

augroup exec
    autocmd!
    autocmd FileType c      nnoremap <buffer> <leader>xx :!clear; gcc -o %:p:r %:p && %:p:r<CR>
    autocmd FileType c      nnoremap <buffer> <leader>xa :!clear; gcc -o %:p:r %:p && %:p:r 
    autocmd FileType cpp    nnoremap <buffer> <leader>xx :!clear; g++ -o %:p:r %:p && %:p:r<CR>
    autocmd FileType cpp    nnoremap <buffer> <leader>xa :!clear; g++ -o %:p:r %:p && %:p:r 
    autocmd FileType python nnoremap <buffer> <leader>xx :!clear; python3 %:p<CR>
    autocmd FileType python nnoremap <buffer> <leader>xa :!clear; python3 %:p 
    autocmd FileType ruby   nnoremap <buffer> <leader>xx :!clear; ruby %:p<CR>
    autocmd FileType rust   nnoremap <buffer> <leader>xx :!clear; rustc -o %:p:r %:p && %:p:r<CR>
    autocmd FileType sh     nnoremap <buffer> <leader>xx :!clear; %:p<CR>
    autocmd FileType sh     nnoremap <buffer> <leader>xa :!clear; %:p 
augroup END

" Plugins
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'ajh17/vimcompletesme'
call plug#end()

" Plugin settings
let g:netrw_banner = 0
