" Plugins
call plug#begin()

" Navigation
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS .= ' --border --margin=0,1'

Plug 'romainl/vim-cool'

" Manipulation
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces = 1

" Language
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'ziglang/zig.vim'
Plug 'ap/vim-css-color'
Plug 'leafgarland/typescript-vim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'prettier/vim-prettier'
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'l3mon4d3/LuaSnip'
Plug 'ray-x/lsp_signature.nvim'

" Colorschemes
Plug 'jnnl/vim-tonight'
Plug 'fnune/base16-vim'

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

" Lua setup
:lua << EOF
    local cmp = require('cmp')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local luasnip = require('luasnip')
    local lsp = require('lspconfig')
    local lsp_signature = require('lsp_signature')

    lsp_signature.setup({
        bind = true,
        handler_opts = {
            border = 'single',
        },
    })

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
        }
    })

    local local_on_attach = function(_, bufnr)
        lsp_signature.on_attach()

        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = true,
                update_in_insert = false,
            }
        )

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local mapkey = vim.api.nvim_buf_set_keymap
        local opts = { noremap = true, silent = true }

        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

        mapkey(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        mapkey(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        mapkey(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        mapkey(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        mapkey(bufnr, 'n', 'gö', '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.WARN}})<CR>', opts)
        mapkey(bufnr, 'n', 'gä', '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.WARN}})<CR>', opts)
        mapkey(bufnr, 'n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        mapkey(bufnr, 'n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        mapkey(bufnr, 'n', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        mapkey(bufnr, 'x', '<leader><Space>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
        mapkey(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        mapkey(bufnr, 'n', '<leader>d', '<cmd>:LspDiagnosticsAll<CR>', opts)
        mapkey(bufnr, 'n', '<leader>f', '<cmd>:Format<CR>', opts)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

    local servers = { 'bashls', 'cssls', 'pyright', 'rust_analyzer' }

    for _, server in ipairs(servers) do
        lsp[server].setup {
            capabilities = capabilities,
            on_attach = local_on_attach,
        }
    end

    lsp.tsserver.setup {
        init_options = require('nvim-lsp-ts-utils').init_options,
        on_attach = function(client, bufnr)
            local_on_attach(client, bufnr)
            local ts_utils = require("nvim-lsp-ts-utils")
            ts_utils.setup({})
            ts_utils.setup_client(client)
        end
    }
EOF


" General
set backspace=indent,eol,start
set clipboard=unnamed
set display+=lastline
set hidden
set inccommand=nosplit
set nojoinspaces
set nomodeline
set noswapfile
set showcmd
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
set completeopt=menu,menuone,noselect


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

if has('termguicolors')
  set termguicolors
endif

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

nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>/
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
augroup END


" Functions
func! s:auto_mkdir()
    let l:dir = expand('<afile>:p:h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
endf
