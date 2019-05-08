" Plugins
call plug#begin()

" Git plugins
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'

" Navigation plugins
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'

command! -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --smart-case '
    \ . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
    \ . shellescape(<q-args>), 1,
    \ fzf#vim#with_preview({ 'options': '--delimiter : --nth 4..' }, 'right:50%:hidden', '?'))

func! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }')) | copen | cc
endf

let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
\}

Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

" Manipulation plugins
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Writing plugins
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
let g:limelight_default_coefficient = 0.3

" Language plugins
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

if has('nvim')
    let g:python3_host_prog = '/usr/bin/python'
endif
Plug 'davidhalter/jedi-vim', {'for': 'python'}
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0

Plug 'quramy/tsuquyomi', { 'for': 'typescript' }
let g:tsuquyomi_disable_quickfix = 1

Plug 'rip-rip/clang_complete', { 'for': ['c', 'cpp'] }
let g:clang_library_path='/usr/lib/llvm-3.8/lib'

" Completion plugins
Plug 'lifepillar/vim-mucomplete'

" Colorschemes
Plug 'jnnl/vim-tonight'
Plug 'junegunn/seoul256.vim'

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
set clipboard=unnamed

set timeoutlen=500

" Vim/neovim specific
if has('vim')
    set ttyfast
    set ttyscroll=3
elseif has('nvim')
    set inccommand=nosplit
endif

" Performance tweaks
set synmaxcol=500
set lazyredraw

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

nnoremap å [
nnoremap åå [[
nnoremap å¨ []
nnoremap ¨ ]
nnoremap ¨¨ ]]
nnoremap ¨å ][
xnoremap å [
xnoremap åå [[
xnoremap å¨ []
xnoremap ¨ ]
xnoremap ¨¨ ]]
xnoremap ¨å ][
inoremap å [
inoremap ¨ ]
inoremap Å {
inoremap ^ }

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

nmap Ö <Plug>(qf_qf_previous)
nmap Ä <Plug>(qf_qf_next)

nnoremap <silent> <leader>m :make<CR>
nnoremap <leader>M :make<Space>
nnoremap <silent> <leader>q mQgggqG`Q
nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <silent> <leader>t <C-]>
xnoremap <silent> <leader>t <C-]>
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nnoremap <silent> <leader>w :Goyo \| Limelight!!<CR>

nnoremap <silent> <leader>, :Files<CR>
nnoremap <silent> <leader>. :Buffers<CR>
nnoremap <silent> <leader>- :call <SID>search()<CR>
nnoremap <silent> <leader>; :History<CR>
nnoremap <silent> <leader>: :BCommits<CR>
nnoremap <silent> <leader>_ :BLines<CR>

" Commands
command! Chomp :%s/\s\+$//e
command! Unansify :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! NonASCII /[^\x00-\x7f]
command! Groot :exec 'lcd' system('git rev-parse --show-toplevel')
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null '
            \ . fnameescape(expand('%:p')) | :e!

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
    au BufWritePre,FileWritePre * :call s:auto_mkdir()
augroup END

augroup FileSpecific
    au!
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
    au FileType c,cpp setlocal formatprg=clang-format
    au FileType python setlocal formatprg=yapf
    au FileType typescript nnoremap <silent> <buffer> <leader>d :TsuDefinition<CR>
    au BufWritePost *.ts call tsuquyomi#asyncGeterr()
augroup END

" Functions
func! s:search()
    try | Rg
    catch | Ag
    endtry
endf

func! s:auto_mkdir()
    let l:dir = expand('<afile>:p:h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
endf
