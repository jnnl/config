" .vimrc

" Plugins
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

Plug 'michaeljsmith/vim-indent-object'
Plug 'jnnl/tomorrow-night-flight.vim'

Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

Plug 'sheerun/vim-polyglot'
let g:python_highlight_space_errors = 0

Plug 'mbbill/undotree'
if has('persistent_undo')
    set undodir=~/.vim/undo/
    set undofile
endif

Plug 'w0rp/ale'
let g:ale_enabled = 0

Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.default = { 'omni': { t -> t =~# '\m\k\%(\k\|\.\|::\)$' } }
set shortmess+=c
set completeopt-=preview
set completeopt+=longest,menuone,noselect

call plug#end()

" General
set encoding=utf-8
set backspace=indent,eol,start
set hidden
set noshowcmd
set wildmenu
set display+=lastline
set noswapfile

set ttimeout
set ttimeoutlen=10

" Performance tweaks
set synmaxcol=500
set lazyredraw

if has('vim')
    set ttyfast
    set ttyscroll=3
endif

" Statusline
set laststatus=2
set statusline=%f\ %y%m%=%l/%L

" Indentation
set autoindent
set expandtab
set smarttab

set shiftwidth=4
set softtabstop=4

" Splits
set splitright
set splitbelow

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Styles
set number
try | colorscheme tomorrow-night-flight | catch | colorscheme default | endtry

" Mappings
map , <leader>

nnoremap ö <C-o>
nnoremap ä <C-i>
nnoremap Ö g;
nnoremap Ä g,

nnoremap <expr> j (v:count ? 'j' : 'gj')
nnoremap <expr> k (v:count ? 'k' : 'gk')

nnoremap <C-j> }
nnoremap <C-k> {
xnoremap <C-j> }
xnoremap <C-k> {

nnoremap Q @q
xnoremap Q :normal @q<CR>

nnoremap <leader>a :ALEToggle<CR>
nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <leader>d :UndotreeToggle<CR>

nnoremap <leader>, :Files<CR>
nnoremap <leader>. :Buffers<CR>
nnoremap <leader>- :Ag<CR>
nnoremap <leader>; :History<CR>
nnoremap <leader>: :BCommits<CR>
nnoremap <leader>_ :BLines<CR>

" Commands
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null '
            \ . fnameescape(expand('%:p')) | :e!
command! StripTrail :%s/\s\+$//e
command! StripANSI :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! MatchNonASCII /[^\x00-\x7f]

" Angular navigation commands
command! ET :e %:p:r.html
command! EC :e %:p:r.ts
command! ES :e %:p:r.scss
command! VT :vs %:p:r.html
command! VC :vs %:p:r.ts
command! VS :vs %:p:r.scss

" Autocmds
augroup Miscellaneous
    au!
    au BufWritePre,FileWritePre * :call s:AutoMkDir()
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
    au FileType html runtime macros/matchit.vim
augroup END

augroup Execute
    au!
    au FileType c      nn <buffer> <leader>x :!clear; gcc -o "%:p:r" "%:p" && "%:p:r"<CR>
    au FileType cpp    nn <buffer> <leader>x :!clear; g++ -o "%:p:r" "%:p" && "%:p:r"<CR>
    au FileType python nn <buffer> <leader>x :!clear; python3 "%:p"<CR>
    au FileType rust   nn <buffer> <leader>x :!clear; rustc -o "%:p:r" "%:p" && "%:p:r"<CR>
    au FileType sh     nn <buffer> <leader>x :!clear; "%:p"<CR>
augroup END

" Functions
func! s:AutoMkDir()
    let dir = expand('<afile>:p:h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endf
