" vimrc
" jnnl.net

" Plugins
call plug#begin()
Plug 'jnnl/tantalum.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
let g:surround_indent = 1

Plug 'w0rp/ale'
let g:ale_enabled = 0
let g:ale_history_enabled = 0

Plug 'rust-lang/rust.vim', { 'for': 'rust' }

Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-slash'

Plug 'metakirby5/codi.vim', { 'on': 'Codi' }

Plug 'justinmk/vim-gtfo'
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
call plug#end()

" General
set encoding=utf-8
set backspace=indent,eol,start
set hidden
set wildmenu
set display+=lastline
set laststatus=1

set ttimeout
set ttimeoutlen=10

" Performance tweaks
set synmaxcol=1000
set lazyredraw

if has('vim')
    set ttyfast
    set ttyscroll=3
endif

" Indentation
set autoindent
set expandtab
set smarttab

set shiftwidth=4
set tabstop=4
set softtabstop=4

" Splits
set splitright
set splitbelow

" Search
set incsearch
set ignorecase
set smartcase

" Styles
set number
set noruler

set background=dark
colorscheme tantalum

" Auxiliary directories
if has('nvim')
    let s:vimdir = $HOME.'/.config/nvim/'
else
    let s:vimdir = $HOME.'/.vim/'
endif

if !isdirectory(s:vimdir.'swap')
    silent call mkdir(s:vimdir.'swap', 'p')
endif
if !isdirectory(s:vimdir.'backup')
    silent call mkdir(s:vimdir.'backup', 'p')
endif
if !isdirectory(s:vimdir.'undo')
    silent call mkdir(s:vimdir.'undo', 'p')
endif

let &directory = s:vimdir.'swap//'
let &backupdir = s:vimdir.'backup//'
let &undodir   = s:vimdir.'undo//'

" Mappings
map , <leader>

nnoremap § :w<CR>
nnoremap ö <C-o>
nnoremap ä <C-i>
nnoremap j gj
nnoremap k gk

nnoremap <leader>m :Make<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>t <C-]>
nnoremap <silent> <leader>l :ALEToggle<CR>

nnoremap <leader>fa :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commits<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fw :Windows<CR>

" Commands
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null '
    \ .shellescape(expand('%')) | :e!

command! StripTrailingWhitespace :call s:StripTrailingWhitespace()
command! MatchNonASCII :call s:MatchNonASCII()

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \     'rg --column --line-number --no-heading --color always '.
    \     '--colors path:fg:green --colors line:fg:yellow '
    \     .shellescape(<q-args>), 1,
    \     <bang>0 ? fzf#vim#with_preview('up:60%')
    \             : fzf#vim#with_preview('right:50%:hidden', '?'),
    \     <bang>0)

" Autocmds
augroup misc
    au!
    au BufWritePre,FileWritePre * :call s:AutoMkDir()
    au GUIEnter :call s:ApplyGUISettings()
    au FileType vim setlocal keywordprg=:help
augroup END

augroup exec
    au!
    au FileType c      nn <buffer> <leader>x :!clear; gcc -o %:p:r %:p && %:p:r<CR>
    au FileType cpp    nn <buffer> <leader>x :!clear; g++ -o %:p:r %:p && %:p:r<CR>
    au FileType python nn <buffer> <leader>x :!clear; python3 %:p<CR>
    au FileType ruby   nn <buffer> <leader>x :!clear; ruby %:p<CR>
    au FileType rust   nn <buffer> <leader>x :!clear; rustc -o %:p:r %:p && %:p:r<CR>
    au FileType sh     nn <buffer> <leader>x :!clear; %:p<CR>
augroup END

" Functions
func! s:AutoMkDir()
    let dir = expand('<afile>:p:h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endf

func! s:StripTrailingWhitespace()
    %s/\s\+$//e
endf

func! s:MatchNonASCII()
    let ptrn = '[^\x00-\x7F]'
    for m in getmatches()
        if m.pattern == ptrn
            let matched = 1
            call matchdelete(m.id)
        endif
    endfor
    if !exists('l:matched')
        if search(ptrn)
            call matchadd('Error', ptrn)
        else
            echomsg 'No non-ASCII characters found.'
        endif
    endif
endf

func! s:ApplyGUISettings()
    if has('gui_running')
        set go-=T
        set go-=r
        set go-=L
        set vb
        set t_vb=
        set guifont=Source\ Code\ Pro:h14
    endif
endf
