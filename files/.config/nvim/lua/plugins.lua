return {
    -- Navigation
    {
        'andymass/vim-matchup',
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
    { 'junegunn/fzf', build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc' },
    {
        'ibhagwan/fzf-lua',
        config = function()
            local fzf = require('fzf-lua')
            local defaults = require('fzf-lua.defaults').defaults
            local actions = require('fzf-lua.actions')
            fzf.setup({
                'default',
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
                    },
                },
                grep = {
                    rg_opts = '--column --line-number --no-heading --hidden --smart-case --max-columns=4096 ' ..
                        '--glob="!.git/" ' ..
                        '--color=always --colors "path:fg:green" --colors "line:fg:yellow"',
                    rg_glob = true,
                },
            })
            vim.keymap.set('n', '<Leader>ff', fzf.builtin, { desc = 'Find fzf-lua builtins' })
            vim.keymap.set('n', '<Leader>fc', fzf.commands, { desc = 'Find commands' })
            vim.keymap.set('n', '<Leader>fh', fzf.help_tags, { desc = 'Find help tags' })
            vim.keymap.set('n', '<Leader>fk', fzf.keymaps, { desc = 'Find keymaps' })
            vim.keymap.set('n', '<Leader>fl', fzf.lines, { desc = 'Find open buffers\' lines' })
            vim.keymap.set('n', '<Leader>fr', fzf.registers, { desc = 'Find registers' })
            vim.keymap.set('n', '<Leader>fw', fzf.grep_cWORD, { desc = 'Find text matching word under cursor' })
            vim.keymap.set('x', '<Leader>fw', fzf.grep_visual, { desc = 'Find text matching visual selection' })
            vim.keymap.set('n', '<Leader>,', function()
                fzf.files({ fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files' })
            vim.keymap.set('n', '<Leader>.', fzf.buffers, { desc = 'Find open buffers' })
            vim.keymap.set('n', '<Leader>-', function()
                fzf.grep_project({ fzf_opts = { ['--nth'] = '3..', ['--delimiter'] = ':' } })
            end, { desc = 'Find text' })
            vim.keymap.set('n', '<Leader>;', fzf.oldfiles, { desc = 'Find recently opened files' })
            vim.keymap.set('n', '<Leader>:', fzf.git_bcommits, { desc = 'Find git commits affecting current file' })
            vim.keymap.set('n', '<Leader>_', fzf.blines, { desc = 'Find text in current file' })
            vim.keymap.set('n', '<Leader>\'', fzf.resume, { desc = 'Resume most recent fzf-lua search' })
            vim.keymap.set('n', '<Leader>*', function()
                fzf.files({ cwd = vim.fn.expand('$HOME') })
            end, { desc = 'Find files in ~' })
            vim.keymap.set('n', '<Leader>fgb', fzf.git_branches, { desc = 'Find git branches' })
            vim.keymap.set('n', '<Leader>fgc', fzf.git_commits, { desc = 'Find git commits' })
            vim.keymap.set('n', '<Leader>fgx', function()
                fzf.fzf_exec('git dmc', {
                    prompt = 'Conflicts> ',
                    cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h'),
                    preview = "awk '/<<<<<<</, />>>>>>>/ { print NR\"\\t\"$0 }' {1}",
                    actions = {
                        ["default"] = actions.file_edit_or_qf,
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
    {
        'tpope/vim-abolish',
        commit = 'cb3dcb220262777082f63972298d57ef9e9455ec',
    },
    {
        'tpope/vim-commentary',
        commit = 'e87cd90dc09c2a203e13af9704bd0ef79303d755',
        event = { 'BufNewFile', 'BufReadPre' },
    },
    {
        'tpope/vim-surround',
        commit = '3d188ed2113431cf8dac77be61b842acb64433d9',
        event = { 'BufNewFile', 'BufReadPre' },
    },

    -- Colorschemes
    { 'jnnl/vim-tonight' },

    -- Language
    {
        'ap/vim-css-color',
        commit = '2840cd5252db9decc4422844945b3460868ee691',
        ft = { 'css', 'scss' },
    },
    {
        'hashivim/vim-terraform',
        commit = '2bbc5f65a80c79a5110494a2ba1b869075fcf7a0',
    },
    {
        'leafgarland/typescript-vim',
        commit = '31ede5ad905ce4159a5e285073a391daa3bf83fa',
    },
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            require('conform').setup({
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
            vim.api.nvim_create_user_command('FormatDisable', function(args)
                if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
            end, { bang = true })
            vim.api.nvim_create_user_command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { bang = true })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'bash', 'c', 'go', 'html', 'lua', 'markdown', 'python', 'rust', 'tsx', 'typescript', },
                auto_install = false,
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        return (lang ~= 'markdown' and lang ~= 'typescriptreact') or
                            vim.api.nvim_buf_line_count(buf) > 5000
                    end
                },
                matchup = {
                    enable = true,
                    disable = function(lang, _)
                        return lang == 'typescript'
                    end
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ['äa'] = '@parameter.outer',
                            ['äf'] = '@function.outer',
                            ['äc'] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['öa'] = '@parameter.outer',
                            ['öf'] = '@function.outer',
                            ['öc'] = '@class.outer',
                        },
                    },
                },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            'ray-x/lsp_signature.nvim',
        },
        config = function()
            local lsp = require('lspconfig')

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('LspConfig', {}),
                callback = function(ev)
                    vim.diagnostic.config({ virtual_text = false })
                    vim.cmd('command! Format execute "lua require(\'conform\').format()"')
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local opts = { noremap = true, silent = true, buffer = ev.buf }
                    local extend_opts = function(extends) return vim.tbl_extend('force', opts, extends) end

                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
                        extend_opts({ desc = 'Go to definition' }))
                    vim.keymap.set('n', 'gD', '<cmd>FzfLua lsp_definitions<CR>',
                        extend_opts({ desc = 'Find definition(s)' }))
                    vim.keymap.set('n', 'gi', '<cmd>FzfLua lsp_implementations<CR>',
                        extend_opts({ desc = 'Find implementation(s)' }))
                    vim.keymap.set('n', 'gr', '<cmd>FzfLua lsp_references<CR>',
                        extend_opts({ desc = 'Find reference(s)' }))
                    vim.keymap.set('n', 'gt', '<cmd>FzfLua lsp_typedefs<CR>',
                        extend_opts({ desc = 'Find type definitions(s)' }))
                    vim.keymap.set('n', 'ög',
                        '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.WARN}})<CR>',
                        extend_opts({ desc = 'Go to previous WARN+ diagnostic' })
                    )
                    vim.keymap.set('n', 'äg',
                        '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.WARN}})<CR>',
                        extend_opts({ desc = 'Go to next WARN+ diagnostic' })
                    )
                    vim.keymap.set('n', 'öG',
                        '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.HINT}})<CR>',
                        extend_opts({ desc = 'Go to next HINT+ diagnostic' })
                    )
                    vim.keymap.set('n', 'äG',
                        '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.HINT}})<CR>',
                        extend_opts({ desc = 'Go to next HINT+ diagnostic' })
                    )
                    vim.keymap.set('n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                    vim.keymap.set('n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                    vim.keymap.set('n', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                    vim.keymap.set('x', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                    vim.keymap.set('n', '<leader>xf', '<cmd>Format<CR>', opts)
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
                { name = 'emmet_ls', opts = extend_server_opts({ filetypes = { 'html', 'css', 'scss' } }) },
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
                { name = 'pyright', opts = server_opts },
                { name = 'rust_analyzer', opts = server_opts },
            }

            for _, server in ipairs(lspconfig_servers) do
                lsp[server.name].setup(server.opts or {})
            end
        end,
    },
    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {},
    },

    -- Completion
    { 'hrsh7th/cmp-nvim-lsp', lazy = true },
    { 'hrsh7th/cmp-nvim-lua', lazy = true },
    { 'hrsh7th/cmp-path', lazy = true },
    { 'hrsh7th/cmp-vsnip', lazy = true },
    {
        'hrsh7th/vim-vsnip',
        lazy = true,
        config = function()
            vim.g.vsnip_filetypes = {}
            vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets'
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'BufReadPost',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        config = function()
            vim.opt.completeopt = 'menu,menuone,noselect'
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end
                },
                mapping = {
                    ['<Up>'] = cmp.mapping.select_prev_item(),
                    ['<Down>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn['vsnip#available'](1) == 1 then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true),
                                '', true
                            )
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true),
                                '', true
                            )
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'vsnip' },
                    { name = 'path' },
                },
            })
        end,
    },
    {
        'ray-x/lsp_signature.nvim',
        lazy = true,
        config = function()
            require('lsp_signature').setup({
                bind = true,
                hint_enable = false,
                handler_opts = {
                    border = 'single',
                },
            })
        end,
    },

    -- Miscellaneous
    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({})
        end,
    },
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
    {
        'michaeljsmith/vim-indent-object',
        commit = '5c5b24c959478929b54a9e831a8e2e651a465965',
    },
    { 'nvim-lua/plenary.nvim' },
    {
        'romainl/vim-qf',
        commit = '7e65325651ff5a0b06af8df3980d2ee54cf10e14',
        config = function()
            vim.keymap.set('n', 'öq', '<Plug>(qf_qf_previous)')
            vim.keymap.set('n', 'äq', '<Plug>(qf_qf_next)')
        end,
    },
    {
        'tpope/vim-repeat',
        commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a',
    },
    { 'tpope/vim-fugitive' },
    {
        'whiteinge/diffconflicts',
        commit = '05e8d2e935a235b8f8e6d308a46a5f028ea5bf97',
    },
}
