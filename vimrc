" Plugins
call plug#begin()

" Navigation plugins
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

" Manipulation plugins
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Language plugins
if has('nvim')
    let g:python3_host_prog = '/usr/bin/python'
endif
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'quramy/tsuquyomi', { 'for': 'typescript' }
let g:tsuquyomi_disable_quickfix = 1

" Completion plugins
Plug 'lifepillar/vim-mucomplete'

" Colorschemes
Plug 'jnnl/vim-tonight'

" Miscellaneous plugins
Plug 'tpope/vim-repeat'
Plug 'sgur/vim-editorconfig'
Plug 'machakann/vim-highlightedyank'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mbbill/undotree'
Plug 'romainl/vim-qf'

call plug#end()

runtime macros/matchit.vim

" General
set backspace=indent,eol,start
set hidden
set noshowcmd
set wildmenu
set display+=lastline
set shortmess+=c
set noswapfile
set nojoinspaces
set nomodeline
set clipboard=unnamed
set timeoutlen=500
set synmaxcol=500
set lazyredraw

" Vim/neovim specific
if has('vim')
    set ttyfast
    set ttyscroll=3
elseif has('nvim')
    set inccommand=nosplit
endif

" Undo
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p', 0700)
endif
set undodir=~/.vim/undo
set undofile

" Completion
set completeopt-=preview
set completeopt+=longest,menuone

" Statusline
set laststatus=2
set statusline=%f\ %y%m%=%l/%L

" Indentation
set autoindent
set breakindent
set expandtab
set smarttab

set shiftwidth=4
set softtabstop=-1

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
try | colorscheme tonight | catch | colorscheme default | endtry

" Mappings
let mapleader = ','

nnoremap <Space> /
nnoremap <BS> <C-^>

nnoremap ö <C-o>
nnoremap ä <C-i>

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <C-j> }
nnoremap <C-k> {
xnoremap <C-j> }
xnoremap <C-k> {
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

nnoremap Q @q
xnoremap Q :normal @q<CR>

nnoremap <silent> <leader>q mQgggqG`Q
nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <silent> <leader>t <C-]>
xnoremap <silent> <leader>t <C-]>
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nmap Ö <Plug>(qf_qf_previous)
nmap Ä <Plug>(qf_qf_next)

nnoremap <silent> <leader>, :Files<CR>
nnoremap <silent> <leader>. :Buffers<CR>
nnoremap <silent> <leader>- :Rg<CR>
nnoremap <silent> <leader>; :History<CR>
nnoremap <silent> <leader>: :Lines<CR>
nnoremap <silent> <leader>_ :BLines<CR>

" Commands
command! Rstrip :%s/\s\+$//e
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null '
    \ . fnameescape(expand('%:p')) | :e!
command! -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --smart-case '
    \ . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
    \ . shellescape(<q-args>), 1,
    \ fzf#vim#with_preview({ 'options': '--delimiter : --nth 4..' }, 'right:50%:hidden', '?'))

" Angular navigation commands
command! ET :e %:p:r.html
command! EC :e %:p:r.ts
command! ES :e %:p:r.scss
command! VT :vs %:p:r.html
command! VC :vs %:p:r.ts
command! VS :vs %:p:r.scss

" Autocmds
augroup Autocmds
    au!
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
    au FileType typescript nnoremap <silent> <buffer> <leader>d :TsuDefinition<CR>
    au BufWritePost *.ts call tsuquyomi#asyncGeterr()
    au BufWritePre,FileWritePre * :call s:auto_mkdir()
augroup END

" Functions
func! s:auto_mkdir()
    let l:dir = expand('<afile>:p:h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
endf
