return {
    -- Navigation
    {
        'andymass/vim-matchup',
        commit = 'd30b72d20f01478a8486f15a57c89fe3177373db',
        event = 'BufReadPost',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
    },
    {
        'ggandor/leap.nvim',
        commit = '5efe985cf68fac3b6a6dfe7a75fbfaca8db2af9c',
        config = function()
            local leap = require('leap')
            leap.add_default_mappings()
            leap.opts.safe_labels = {}
        end,
    },
    { 'justinmk/vim-dirvish' },
    { 'junegunn/fzf', build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc' },
    {
        'ibhagwan/fzf-lua',
        config = function()
            local fzf_lua = require('fzf-lua')
            local defaults = require('fzf-lua.defaults').defaults
            local actions = require('fzf-lua.actions')
            fzf_lua.setup({
                'default',
                winopts = {
                    height = 0.9,
                    width = 0.9,
                },
                fzf_opts = {
                    ['--cycle'] = ''
                },
                actions = {
                    files = vim.tbl_deep_extend('force', defaults.actions.files, {
                        ['ctrl-o'] = function(selected)
                            -- Opens selected file(s) with system default handler
                            for _, item in ipairs(selected) do
                                local selected_item = string.gsub(item, '\t+', '')
                                vim.notify('opening file ' .. selected_item)
                                vim.ui.open(selected_item)
                            end
                        end,
                        ['ctrl-p'] = function(selected)
                            -- Opens a new vertical split and populates it with selected search results
                            vim.cmd('vsplit')
                            local win = vim.api.nvim_get_current_win()
                            local buf = vim.api.nvim_create_buf(true, true)
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, selected)
                            vim.api.nvim_win_set_buf(win, buf)
                        end,
                    }),
                },
                previewers = {
                    bat = {
                        args = '--style=numbers,changes,header-filename,rule --color always --line-range=:1000',
                    },
                    builtin = {
                        treesitter = { enable = false },
                        extensions = {
                            ['gif'] = { 'chafa' },
                            ['png'] = { 'chafa' },
                            ['jpg'] = { 'chafa' },
                            ['jpeg'] = { 'chafa' },
                            ['svg'] = { 'chafa' },
                        },
                        title_fnamemodify = function(s) return vim.fn.fnamemodify(s, ':p:.') end,
                    },
                },
                grep = {
                    rg_opts = '--column --line-number --no-heading --hidden --smart-case --max-columns=4096 ' ..
                    '--glob="!.git/" ' ..
                    '--color=always --colors "path:fg:green" --colors "line:fg:yellow"',
                    rg_glob = true,
                },
            })
            vim.keymap.set('n', '<Leader>ff', fzf_lua.builtin, { desc = 'Find fzf-lua builtins' })
            vim.keymap.set('n', '<Leader>f*', fzf_lua.grep_cWORD, { desc = 'Find text matching word under cursor' })
            vim.keymap.set('x', '<Leader>f*', fzf_lua.grep_visual, { desc = 'Find text matching visual selection' })
            vim.keymap.set('n', '<Leader>,', function()
                fzf_lua.files({ fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files' })
            vim.keymap.set('n', '<Leader>.', fzf_lua.buffers, { desc = 'Find open buffers' })
            vim.keymap.set('n', '<Leader>-', function()
                fzf_lua.grep_project({ fzf_opts = { ['--nth'] = '3..', ['--delimiter'] = ':' } })
            end, { desc = 'Find text' })
            vim.keymap.set('n', '<Leader>;', function()
                fzf_lua.oldfiles({ fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find recently opened files' })
            vim.keymap.set('n', '<Leader>:', function()
                fzf_lua.oldfiles({ prompt = 'CwdHistory> ', cwd_only = true, fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find recently opened files under current dir' })
            vim.keymap.set('n', '<Leader>_', fzf_lua.blines, { desc = 'Find text in current file' })
            vim.keymap.set('n', '<Leader>\'', fzf_lua.resume, { desc = 'Resume most recent fzf-lua search' })
            vim.keymap.set('n', '<Leader>*', function()
                fzf_lua.files({ cwd = vim.fn.expand('$HOME'), fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files in ~' })
            vim.keymap.set('n', '<Leader>fgb', fzf_lua.git_branches, { desc = 'Find git branches' })
            vim.keymap.set('n', '<Leader>fgc', fzf_lua.git_commits, { desc = 'Find git commits' })
            vim.keymap.set('n', '<Leader>fgx', function()
                fzf_lua.fzf_exec('git dmc', {
                    prompt = 'Conflicts> ',
                    cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h'),
                    preview = 'awk "/<<<<<<</, />>>>>>>/ { print NR\"\\t\"$0 }" {1}',
                    actions = {
                        ['default'] = actions.file_edit_or_qf,
                    },
                })
            end, { desc = 'Find git merge conflicts' })
        end,
    },

    -- Manipulation
    {
        'tommcdo/vim-lion',
        commit = 'ce46593ecd60e6051fb6e4d3986d2fc9f5a618b1',
        event = 'BufReadPost',
        config = function()
            vim.g.lion_squeeze_spaces = 1
        end,
    },
    { 'tpope/vim-abolish', commit = 'cb3dcb220262777082f63972298d57ef9e9455ec' },
    { 'tpope/vim-commentary', commit = 'e87cd90dc09c2a203e13af9704bd0ef79303d755' },
    { 'tpope/vim-surround', commit = '3d188ed2113431cf8dac77be61b842acb64433d9' },

    -- Colorschemes
    { 'jnnl/vim-tonight' },
    { 'ellisonleao/gruvbox.nvim', config = true, commit = '517b012757fbe7a4d6e507baf5cc75837e62734f' },

    -- Language
    {
        'nvchad/nvim-colorizer.lua',
        commit = 'dde3084106a70b9a79d48f426f6d6fec6fd203f7',
        ft = { 'css', 'scss' },
        opts = {
            user_default_options = {
                mode = 'virtualtext',
                css = true,
            },
        },
    },
    { 'hashivim/vim-terraform', commit = '2bbc5f65a80c79a5110494a2ba1b869075fcf7a0' },
    { 'leafgarland/typescript-vim', commit = '31ede5ad905ce4159a5e285073a391daa3bf83fa' },
    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {},
    },
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            local conform = require('conform')
            conform.setup({
                formatters_by_ft = {
                    -- json = { 'jq' },
                    go = { 'gofmt' },
                    rust = { 'rustfmt' },
                    html = { 'prettier' },
                    scss = { 'prettier' },
                    javascript = { 'prettier' },
                    javascriptreact = { 'prettier' },
                    typescript = { 'prettier' },
                    typescriptreact = { 'prettier' },
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                    return {
                        timeout_ms = 500,
                        lsp_fallback = false,
                    }
                end
            })
            vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
            vim.api.nvim_create_user_command('Format', function()
                conform.format()
            end, { bang = true })
            vim.api.nvim_create_user_command('FormatDisable', function(args)
                if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
            end, { bang = true })
            vim.api.nvim_create_user_command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { bang = true })
            vim.keymap.set('n', '<leader>xf', function() vim.cmd('Format') end, { desc = 'Format' })
        end
    },
    {
        'ray-x/lsp_signature.nvim',
        lazy = true,
        opts = {
            bind = true,
            hint_enable = false,
            handler_opts = {
                border = 'single',
            },
        },
    },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
    { 'williamboman/mason-lspconfig.nvim', lazy = true, opts = {} },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            'ray-x/lsp_signature.nvim',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            local lsp = require('lspconfig')

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_attach_config', { clear = true }),
                callback = function(ev)
                    vim.diagnostic.config({ virtual_text = false })
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local opts = { noremap = true, silent = true, buffer = ev.buf }
                    local extend_opts = function(extends) return vim.tbl_extend('force', opts, extends) end
                    local fzf_lua = require('fzf-lua')

                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, extend_opts({ desc = 'Go to definition' }))
                    vim.keymap.set('n', 'gD', fzf_lua.lsp_definitions, extend_opts({ desc = 'Find definition(s)' }))
                    vim.keymap.set('n', 'gi', fzf_lua.lsp_implementations, extend_opts({ desc = 'Find implementation(s)' }))
                    vim.keymap.set('n', 'gr', fzf_lua.lsp_references, extend_opts({ desc = 'Find reference(s)' }))
                    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, extend_opts({ desc = 'Go to type definition' }))
                    vim.keymap.set('n', 'gT', fzf_lua.lsp_typedefs, extend_opts({ desc = 'Find type definitions(s)' }))
                    vim.keymap.set('n', 'ög', function()
                        vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
                    end, extend_opts({ desc = 'Go to previous WARN+ diagnostic' }))
                    vim.keymap.set('n', 'äg', function()
                        vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
                    end, extend_opts({ desc = 'Go to next WARN+ diagnostic' }))
                    vim.keymap.set('n', 'öG', function()
                        vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.HINT } })
                    end, extend_opts({ desc = 'Go to next HINT+ diagnostic' }))
                    vim.keymap.set('n', 'äG', function()
                        vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.HINT } })
                    end, extend_opts({ desc = 'Go to next HINT+ diagnostic' }))
                    vim.keymap.set('n', '<Space>', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<C-Space>', vim.diagnostic.open_float, opts)
                    vim.keymap.set({ 'n', 'x' }, '<leader><Space>', fzf_lua.lsp_code_actions, opts)
                    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                end,
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local server_opts = { capabilities = capabilities }
            local extend_server_opts = function(extends) return vim.tbl_extend('force', server_opts, extends) end

            local local_npm_ls_path = vim.fn.expand('$HOME/.local/lib/node_modules')
            local angularls_cmd = {
                'ngserver',
                '--stdio',
                '--tsProbeLocations', local_npm_ls_path,
                '--ngProbeLocations', local_npm_ls_path
            }

            local lspconfig_servers = {
                {
                    name = 'angularls',
                    opts = extend_server_opts({
                        cmd = angularls_cmd,
                        filetypes = { 'ts', 'html' },
                        on_new_config = function(new_config, _)
                            new_config.cmd = angularls_cmd
                        end,
                    })
                },
                { name = 'bashls', opts = server_opts },
                { name = 'cssls', opts = server_opts },
                {
                    name = 'emmet_ls',
                    opts = extend_server_opts({
                        filetypes = { 'html', 'css', 'scss', 'typescriptreact' }
                    })
                },
                { name = 'gopls', opts = server_opts },
                {
                    name = 'lua_ls',
                    opts = extend_server_opts({
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT', },
                                diagnostics = { globals = { 'vim' }, },
                                workspace = { library = vim.api.nvim_get_runtime_file('', true), },
                                telemetry = { enable = false, },
                            },
                        },
                    })
                },
                {
                    name = 'pyright',
                    opts = extend_server_opts({
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = false,
                                    diagnosticMode = 'openFilesOnly',
                                    useLibraryCodeForTypes = false,
                                    typeCheckingMode = 'basic',
                                }
                            }
                        }
                    })
                },
                { name = 'rust_analyzer', opts = server_opts },
            }

            for _, server in ipairs(lspconfig_servers) do
                lsp[server.name].setup(server.opts or {})
            end
        end,
    },

    -- Completion
    { 'hrsh7th/cmp-nvim-lsp', lazy = true },
    { 'hrsh7th/cmp-nvim-lua', lazy = true },
    { 'hrsh7th/cmp-path', lazy = true },
    {
        'hrsh7th/nvim-cmp',
        event = 'BufReadPost',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
        },
        config = function()
            vim.opt.completeopt = 'menu,menuone,noselect'
            local cmp = require('cmp')
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<Up>'] = cmp.mapping.select_prev_item(),
                    ['<Down>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.snippet.jumpable(1) then
                            vim.snippet.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.snippet.jumpable(-1) then
                            vim.snippet.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                },
            })
        end,
    },

    -- Miscellaneous
    { 'folke/which-key.nvim', opts = {} },
    {
        'mbbill/undotree',
        commit = '0e11ba7325efbbb3f3bebe06213afa3e7ec75131',
        config = function()
            vim.keymap.set('n', '<Leader>u', '<cmd>UndotreeToggle<CR>', { silent = true })
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_HelpLine = 0
        end,
    },
    { 'michaeljsmith/vim-indent-object', commit = '5c5b24c959478929b54a9e831a8e2e651a465965' },
    {
        'romainl/vim-qf',
        commit = '7e65325651ff5a0b06af8df3980d2ee54cf10e14',
        config = function()
            vim.keymap.set('n', 'öq', '<Plug>(qf_qf_previous)')
            vim.keymap.set('n', 'äq', '<Plug>(qf_qf_next)')
        end,
    },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-repeat', commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a' },
    { 'whiteinge/diffconflicts', commit = '05e8d2e935a235b8f8e6d308a46a5f028ea5bf97' },
}
