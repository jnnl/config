" .vimrc

" Plugins
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
    \   <bang>0)
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --smart-case '
    \   . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
    \   . shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
    \   <bang>0)
func! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endf
let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit'
\}

Plug 'jnnl/tomorrow-night-flight.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'sgur/vim-editorconfig'
Plug 'michaeljsmith/vim-indent-object'
Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.default = {
    \ 'omni': { t -> t =~# '\m\k\%(\k\|\.\|::\)$' }
\}
set shortmess+=c
set completeopt-=preview
set completeopt+=longest,menuone,noselect

call plug#end()

runtime macros/matchit.vim

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

" Vim/neovim specific
if has('vim')
    set ttyfast
    set ttyscroll=3
endif
if has('nvim')
    set inccommand=nosplit
endif

" Performance tweaks
set synmaxcol=500
set lazyredraw

" Statusline
set laststatus=2
set statusline=%f\ %y%m%=%l/%L

" Indentation
set autoindent
set breakindent
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
try | colorscheme seoul256 | catch | colorscheme default | endtry

" Mappings
map , <leader>

nnoremap ö <C-o>
nnoremap ä <C-i>

nnoremap <expr> j (v:count ? 'j' : 'gj')
nnoremap <expr> k (v:count ? 'k' : 'gk')

nnoremap <C-j> }
nnoremap <C-k> {
xnoremap <C-j> }
xnoremap <C-k> {

nnoremap Q @q
xnoremap Q :normal @q<CR>

nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/

nnoremap <leader>, :Files<CR>
nnoremap <leader>. :Buffers<CR>
nnoremap <leader>- :call Search()<CR>
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
    au BufWritePre,FileWritePre * :call s:auto_mkdir()
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
    au QuickFixCmdPost [^l]* cwindow
augroup END

" Functions
func! Search()
    try | Rg
    catch | Ag
    endtry
endf

func! s:auto_mkdir()
    let dir = expand('<afile>:p:h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endf
