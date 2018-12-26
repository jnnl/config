" Plugins
call plug#begin()

" Git plugins
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

" Navigation plugins
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'

command! -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --smart-case '
    \ . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
    \ . shellescape(<q-args>), 1,
    \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'))

func! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }')) | copen | cc
endf

let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-x': 'split'
\}

Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

" Manipulation plugins
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Language plugins
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'

" Completion plugins
Plug 'lifepillar/vim-mucomplete'
set shortmess+=c
set completeopt-=preview
set completeopt+=longest,menuone,noselect

if v:version >= 800
  let g:mucomplete#can_complete = {}
  let g:mucomplete#can_complete.default = {
      \ 'omni': { t -> t =~# '\m\k\%(\k\|\.\|::\)$' }
  \}
endif

" Colorschemes
Plug 'jnnl/vim-tonight'
Plug 'junegunn/seoul256.vim'

" Miscellaneous plugins
Plug 'tpope/vim-repeat'
Plug 'sgur/vim-editorconfig'
Plug 'machakann/vim-highlightedyank'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

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
map , <leader>

nmap å [
nmap åå [[
nmap å¨ []
nmap ¨ ]
nmap ¨¨ ]]
nmap ¨å ][
xmap å [
xmap åå [[
xmap å¨ []
xmap ¨ ]
xmap ¨¨ ]]
xmap ¨å ][

nnoremap ö <C-o>
nnoremap ä <C-i>

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <C-j> }
nnoremap <C-k> {
xnoremap <C-j> }
xnoremap <C-k> {

nnoremap Q @q
xnoremap Q :normal @q<CR>

nnoremap <silent> <leader>r :source $MYVIMRC<CR>
nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <silent> <leader>t <C-]>
nnoremap <silent> <leader>u :UndotreeToggle<CR>

nnoremap <silent> <leader>, :Files<CR>
nnoremap <silent> <leader>. :Buffers<CR>
nnoremap <silent> <leader>- :call Search()<CR>
nnoremap <silent> <leader>; :History<CR>
nnoremap <silent> <leader>: :BCommits<CR>
nnoremap <silent> <leader>_ :BLines<CR>

" Commands
command! Chomp :%s/\s\+$//e
command! Unansify :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! NonASCII /[^\x00-\x7f]

command! -bang CD :call s:ch_dir(<bang>0)
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

func! s:ch_dir(bang)
    let a:cmd = a:bang ? 'lcd' : 'cd'
    exec a:cmd . ' %:p:h'
endf

func! s:auto_mkdir()
    let dir = expand('<afile>:p:h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endf
