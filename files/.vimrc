" Plugins
call plug#begin()

" Navigation
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

" Manipulation
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Language
if has('nvim-0.5')
    Plug 'neovim/nvim-lsp'
else
    Plug 'davidhalter/jedi-vim'
    let g:jedi#force_py_version = 3
    let g:jedi#popup_on_dot = 0
    let g:jedi#goto_stubs_command = ''
    let g:jedi#smart_auto_mappings = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#auto_vim_configuration = 0

    Plug 'leafgarland/typescript-vim'
    Plug 'quramy/tsuquyomi'
    let g:tsuquyomi_disable_quickfix = 1
endif

" Completion
Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.default = { 'omni': { t -> t =~# '\m\k\%(\k\|\.\|::\)$' } }
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['ulti', 'path', 'omni', 'keyn', 'dict', 'uspl']

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<nop>'
let g:UltiSnipsSnippetsDir = '~/.vim/snips'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/snips']

" Colorschemes
Plug 'jnnl/vim-tonight'

" Miscellaneous
Plug 'romainl/vim-qf'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'sgur/vim-editorconfig'
Plug 'machakann/vim-highlightedyank'
Plug 'michaeljsmith/vim-indent-object'

Plug 'mbbill/undotree'
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_HelpLine = 0

call plug#end()

runtime macros/matchit.vim

" General
set backspace=indent,eol,start
set clipboard=unnamed
set display+=lastline
set hidden
set nojoinspaces
set nomodeline
set noshowcmd
set noswapfile
set shortmess+=c
set synmaxcol=500
set timeoutlen=500
set wildmenu

" Neovim specific
if has('nvim')
    set inccommand=nosplit

    " Open fzf in a floating window
    let $FZF_DEFAULT_OPTS .= ' --border --margin=0,1'

    function! FloatingFZF()
        let width = float2nr(&columns * 0.8)
        let height = float2nr(&lines * 0.6)
        let opts = { 'relative': 'editor',
                    \ 'row': (&lines - height) / 2,
                    \ 'col': (&columns - width) / 2,
                    \ 'width': width,
                    \ 'height': height }

        let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
        call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
    endfunction

    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

if has('nvim-0.5')
:lua << EOF
    local nvim_lsp = require('nvim_lsp')
    vim.lsp.callbacks['textDocument/publishDiagnostics'] = nil

    local on_attach = function(_, bufnr)
        local buf_set_keymap = vim.api.nvim_buf_set_keymap
        local opts = { noremap=true, silent=true }

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap(bufnr, 'n', ',R', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    end

    for _, server in ipairs{'bashls', 'gopls', 'pyls', 'rls', 'tsserver'} do
        nvim_lsp[server].setup { on_attach = on_attach }
    end
EOF
endif

" Undo
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p', 0700)
endif
set undodir=~/.vim/undo
set undofile

" Completion
set completeopt=menu,menuone,longest

" Statusline
set laststatus=2
set statusline=%f\ %y%m%=%l/%L

" Indentation
set autoindent
set breakindent
set expandtab
set smarttab
set shiftround

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

nnoremap <BS> <C-^>
nnoremap ' `
nnoremap <silent> S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

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

inoremap <expr> <CR> mucomplete#ultisnips#expand_snippet('<CR>')
nnoremap <leader>r :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nmap Ö <Plug>(qf_qf_previous)
nmap Ä <Plug>(qf_qf_next)

nnoremap <silent> <leader>, :Files<CR>
nnoremap <silent> <leader>. :Buffers<CR>
nnoremap <silent> <leader>- :Rg<CR>
nnoremap <silent> <leader>; :History<CR>
nnoremap <silent> <leader>: :BCommits<CR>
nnoremap <silent> <leader>_ :BLines<CR>

" Commands
command! Rstrip :%s/\s\+$//e
command! Unansify :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! W :exec ':silent w !sudo /usr/bin/tee > /dev/null ' . expand('%:p') | :e!
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
    au BufWritePre,FileWritePre * :call s:auto_mkdir()
augroup END

if !has('nvim-0.5')
    augroup Legacy
        au FileType typescript nnoremap <silent> <buffer> <leader>d :TsuDefinition<CR>
        au BufWritePost *.ts call tsuquyomi#asyncGeterr()
    augroup END
endif

" Functions
func! s:auto_mkdir()
    let l:dir = expand('<afile>:p:h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
endf
