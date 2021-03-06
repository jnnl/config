" Plugins
call plug#begin()

" Navigation
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS .= ' --border --margin=0,1'
Plug 'ojroques/nvim-lspfuzzy', {'branch': 'main'}

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

Plug 'romainl/vim-cool'
let g:CoolTotalMatches = 1

" Manipulation
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Language
Plug 'neovim/nvim-lspconfig'
Plug 'ziglang/zig.vim'
Plug 'ap/vim-css-color'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier'
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0

" Completion
Plug 'nvim-lua/completion-nvim'
let g:completion_enable_auto_popup = 0
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = [
    \ { 'complete_items': ['lsp', 'snippet'] },
    \ { 'mode': '<c-p>' },
    \ { 'mode': '<c-n>' }
\]

" Colorschemes
Plug 'jnnl/vim-tonight'
Plug 'lifepillar/vim-gruvbox8'

" Miscellaneous
Plug 'romainl/vim-qf'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'whiteinge/diffconflicts'
Plug 'editorconfig/editorconfig-vim'
Plug 'michaeljsmith/vim-indent-object'

Plug 'mbbill/undotree'
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_HelpLine = 0

call plug#end()

runtime macros/matchit.vim
let g:loaded_rrhelper = 1

:lua << EOF
    require('lspfuzzy').setup {}
    local lsp = require('lspconfig')
    local on_attach = function(_, bufnr)
        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = true,
                update_in_insert = false,
            }
        )

        local mapkey = vim.api.nvim_buf_set_keymap
        local opts = { noremap = true, silent = true }

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        mapkey(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        mapkey(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        mapkey(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        mapkey(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        mapkey(bufnr, 'n', 'gö', '<cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit = "Warning"})<CR>', opts)
        mapkey(bufnr, 'n', 'gä', '<cmd>lua vim.lsp.diagnostic.goto_next({severity_limit = "Warning"})<CR>', opts)
        mapkey(bufnr, 'n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        mapkey(bufnr, 'n', '<C-Space>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        mapkey(bufnr, 'n', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        mapkey(bufnr, 'x', '<leader><Space>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
        mapkey(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        mapkey(bufnr, 'n', '<leader>d', '<cmd>:LspDiagnosticsAll<CR>', opts)
    end

    for _, server in ipairs{'cssls', 'pyright', 'rls', 'tsserver', 'vimls', 'zls'} do
        lsp[server].setup { on_attach = on_attach }
    end
EOF


" General
set backspace=indent,eol,start
set clipboard=unnamed
set display+=lastline
set hidden
set inccommand=nosplit
set nojoinspaces
set nomodeline
set noshowcmd
set noswapfile
set shortmess+=c
set synmaxcol=500
set timeoutlen=500
set wildmenu


" Undo
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p', 0700)
endif
set undodir=~/.vim/undo
set undofile


" Completion
set completeopt=menuone,noinsert,noselect


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
nnoremap _ ,

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
xnoremap @ :normal @
xnoremap . :normal .<CR>

nnoremap <leader>r :%s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nnoremap <silent> <leader>p :Prettier<CR>
nmap Ö <Plug>(qf_qf_previous)
nmap Ä <Plug>(qf_qf_next)

nnoremap <silent> <leader>, :Files<CR>
nnoremap <silent> <leader>. :Buffers<CR>
nnoremap <silent> <leader>- :Rg<CR>
nnoremap <silent> <leader>; :History<CR>
nnoremap <silent> <leader>: :BCommits<CR>
nnoremap <silent> <leader>_ :BLines<CR>

inoremap <silent><expr> <Tab>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_space_before() ? "\<Tab>" :
    \ completion#trigger_completion()
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Commands
command! Rstrip :%s/\s\+$//e
command! Unansify :%s/\%x1b\[[0-9;]*[a-zA-Z]//ge
command! NonAscii /[^\x00-\x7F]
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
command! ST :sp %:p:r.html
command! SC :sp %:p:r.ts
command! SS :sp %:p:r.scss


" Autocmds
augroup Autocmds
    au!
    au FileType vim,help setlocal keywordprg=:help
    au FileType make setlocal noexpandtab shiftwidth=8
    au BufWritePre,FileWritePre * :call s:auto_mkdir()
    au TextYankPost * lua require'vim.highlight'.on_yank({ higroup="IncSearch", timeout=1000, on_visual=false })
    au BufEnter * lua require'completion'.on_attach()
augroup END


" Functions
func! s:auto_mkdir()
    let l:dir = expand('<afile>:p:h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
endf

func! s:check_space_before() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endf
