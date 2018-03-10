" vimrc
" jnnl.net

" Plugins
call plug#begin()
Plug 'jnnl/tantalum.vim'
Plug 'jnnl/tomorrow-night-flight.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
let g:fzf_tags_command = 'ctags -R .tags'
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

if executable('ctags')
    Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_ctags_tagfile = '.tags'
    let g:gutentags_ctags_exclude = ['node_modules', 'vendor', 'venv',
                                   \ '*.css', '*.html', '*.js', '*.ts']
endif

Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

Plug 'ajh17/vimcompletesme'
Plug 'romainl/vim-cool'
Plug 'michaeljsmith/vim-indent-object'
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

nnoremap § :w<CR>
nnoremap ö <C-o>
nnoremap ä <C-i>
nnoremap Ö g;
nnoremap Ä g,
nnoremap <expr> j (v:count ? 'j' : 'gj')
nnoremap <expr> k (v:count ? 'k' : 'gk')
nnoremap Q @q
xnoremap Q :normal @q<CR>

nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <leader>t <C-]>

nnoremap <leader>, :Files<CR>
nnoremap <leader>. :Buffers<CR>
nnoremap <leader>- :Ag<CR>
nnoremap <leader>; :History<CR>
nnoremap <leader>: :BCommits<CR>
nnoremap <leader>_ :Tags<CR>

" Commands
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null '
            \ . fnameescape(expand('%:p')) | :e!
command! StripTrail :%s/\s\+$//e
command! StripANSI :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! MatchNonASCII /[^\x00-\x7f]

" Autocmds
augroup Miscellaneous
    au!
    au BufWritePre,FileWritePre * :call s:AutoMkDir()
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
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
