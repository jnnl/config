return {
    -- Navigation
    {
        'andymass/vim-matchup',
        commit = '2d660e4aa7c566014c667af2cda0458043527902',
        event = { 'BufNewFile', 'BufReadPost' },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            keymap({ 'n', 'x' }, 'ö%', '<Plug>(matchup-[%)', { desc = 'Go to previous outer open word' })
            keymap({ 'n', 'x' }, 'ä%', '<Plug>(matchup-]%)', { desc = 'Go to next outer close word' })
        end,
    },
    {
        'ggandor/leap.nvim',
        commit = '89d878f8399d00fb348ad65b6077b996808234d8',
        event = 'VeryLazy',
        config = function()
            local leap = require('leap')
            leap.opts.safe_labels = {}
            keymap({ 'n', 'x' }, 's', '<Plug>(leap-forward-to)')
            keymap({ 'n', 'x' }, 'S', '<Plug>(leap-backward-to)')
        end,
    },
    {
        'justinmk/vim-dirvish',
        commit = 'b660af1fa07fe1d44d4eb3ea5242334f6c2766ca',
    },
    {
        'junegunn/fzf',
        lazy = true,
        build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc',
    },
    {
        'ibhagwan/fzf-lua',
        commit = '14228229b8138e4a306bd0f633e3e55a77a58d6e',
        event = 'VeryLazy',
        config = function()
            local fzf_lua = require('fzf-lua')
            local defaults = require('fzf-lua.defaults').defaults
            local actions = require('fzf-lua.actions')
            fzf_lua.setup({
                'default',
                winopts = {
                    height = 0.75,
                    width = 0.6,
                    preview = {
                        layout = 'vertical',
                        vertical = 'down:50%',
                    },
                },
                fzf_opts = {
                    ['--cycle'] = ''
                },
                actions = {
                    files = vim.tbl_deep_extend('force', defaults.actions.files, {
                        ['ctrl-o'] = function(selected)
                            -- Opens selected file(s) using system default handler
                            for _, item in ipairs(selected) do
                                local selected_item = item:match('^%s*(.-)%s*$')
                                vim.notify('fzf-lua: opening file ' .. selected_item)
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
                oldfiles = {
                    winopts = { preview = { hidden = 'hidden' } },
                    include_current_session = true,
                },
                grep = {
                    rg_opts = '--column --line-number --no-heading --hidden --smart-case --max-columns=4096 ' ..
                    '--glob="!.git/" --color=always --colors "path:fg:green" --colors "line:fg:yellow"',
                    rg_glob = true,
                },
                lsp = {
                    code_actions = {
                        previewer = 'codeaction_native',
                        preview_pager = 'delta -s -w=$FZF_PREVIEW_COLUMNS ' ..
                        '--syntax-theme ansi --file-style=omit --hunk-header-style=omit',
                    },
                },
            })
            keymap('n', '<Leader>ff', fzf_lua.builtin, { desc = 'Find fzf-lua builtins' })
            keymap('n', '<Leader>fc', fzf_lua.commands, { desc = 'Find commands' })
            keymap('n', '<Leader>fr', fzf_lua.registers, { desc = 'Find registers' })
            keymap('n', '<Leader>f*', fzf_lua.grep_cWORD, { desc = 'Find text matching word under cursor' })
            keymap('x', '<Leader>f*', fzf_lua.grep_visual, { desc = 'Find text matching visual selection' })
            keymap('n', '<Leader>,', function()
                fzf_lua.files({ fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files' })
            keymap('n', '<Leader>.', fzf_lua.buffers, { desc = 'Find open buffers' })
            keymap('n', '<Leader>-', function()
                fzf_lua.grep_project({ fzf_opts = { ['--nth'] = '3..', ['--delimiter'] = ':' } })
            end, { desc = 'Find text' })
            keymap('n', '<Leader>;', function()
                fzf_lua.oldfiles({ fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find recently opened files' })
            keymap('n', '<Leader>:', function()
                fzf_lua.oldfiles({ prompt = 'CwdHistory> ', cwd_only = true, fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find recently opened files under current dir' })
            keymap('n', '<Leader>_', fzf_lua.blines, { desc = 'Find text in current file' })
            keymap('n', '<Leader>\'', fzf_lua.resume, { desc = 'Resume most recent fzf-lua search' })
            keymap('n', '<Leader>*', function()
                fzf_lua.files({ cwd = vim.fn.expand('$HOME'), fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files in $HOME' })
            keymap('n', '<Leader>fgb', fzf_lua.git_branches, { desc = 'Find git branches' })
            keymap('n', '<Leader>fgc', fzf_lua.git_commits, { desc = 'Find git commits' })
            keymap('n', '<Leader>fgf', fzf_lua.git_files, { desc = 'Find git files' })
            keymap('n', '<Leader>fgx', function()
                fzf_lua.fzf_exec('git diff --name-only --diff-filter=U', {
                    prompt = 'Conflicts> ',
                    cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h'),
                    preview = [[awk '/^<<<<<<</,/^>>>>>>>/ { printf("%4d %s\n", NR, $0) }' {1}]],
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
        event = 'VeryLazy',
        config = function()
            vim.g.lion_squeeze_spaces = 1
        end,
    },
    {
        'tommcdo/vim-exchange',
        commit = 'd6c1e9790bcb8df27c483a37167459bbebe0112e',
        event = 'VeryLazy',
    },
    {
        'tpope/vim-commentary',
        commit = 'e87cd90dc09c2a203e13af9704bd0ef79303d755',
        event = 'VeryLazy',
    },
    {
        'tpope/vim-surround',
        commit = '3d188ed2113431cf8dac77be61b842acb64433d9',
        event = 'VeryLazy',
    },

    -- Colorschemes
    {
        'jnnl/tonight.nvim',
        priority = 1000,
        init = function()
            vim.cmd.colorscheme('tonight')
        end,
    },

    -- Language
    {
        'nvchad/nvim-colorizer.lua',
        commit = 'dde3084106a70b9a79d48f426f6d6fec6fd203f7',
        ft = { 'css', 'scss' },
        cmd = { 'ColorizerToggle' },
        opts = {
            user_default_options = {
                mode = 'virtualtext',
                virtualtext = '█',
                css = true,
            },
        },
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
        'pmizio/typescript-tools.nvim',
        commit = 'c43d9580c3ff5999a1eabca849f807ab33787ea7',
        ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {},
    },
    {
        'stevearc/conform.nvim',
        commit = '5a15cc46e75cad804fd51ec5af9227aeb1d1bdaa',
        event = 'VeryLazy',
        config = function()
            vim.g.disable_autoformat = true
            local conform = require('conform')
            conform.setup({
                formatters_by_ft = {
                    go = { 'gofmt' },
                    rust = { 'rustfmt' },
                    sh = { 'shellharden' },
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
            command('Format', function()
                conform.format()
            end, { bang = true })
            command('FormatDisable', function(args)
                if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
            end, { bang = true })
            command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { bang = true })
            keymap('n', '<leader>xf', function() vim.cmd('Format') end, { desc = 'Format buffer' })
        end
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            { 'williamboman/mason.nvim', commit = '3b5068f0fc565f337d67a2d315d935f574848ee7' },
            { 'williamboman/mason-lspconfig.nvim', commit = '21d33d69a81f6351e5a5f49078b2e4f0075c8e73' },
            { 'ray-x/lsp_signature.nvim', commit = 'e92b4e7073345b2a30a56b20db3d541a9aa2771e', opts = { hint_enable = false } },
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local lsp = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local servers = {
                ansiblels = {
                    settings = { ansible = { validation = { lint = { enabled = false } } } },
                },
                bashls = {},
                cssls = {},
                gopls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT', },
                            diagnostics = { globals = { 'vim' }, },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file('', true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                pylsp = {},
                terraformls = {},
            }
            require('mason').setup()
            require('mason-lspconfig').setup({
                -- ensure_installed = vim.tbl_keys(servers or {}),
                handlers = {
                    function(server_name)
                        local config = servers[server_name] or {}
                        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
                        config.on_attach = function(client, bufnr)
                            local filename = vim.api.nvim_buf_get_name(bufnr)
                            if #filename > 0 and vim.fn.getfsize(filename) > 1024 * 100 then
                                vim.notify('lsp: file is too large, stopping ' .. client.name, vim.log.levels.WARN)
                                vim.lsp.stop_client(client.id)
                            end
                        end
                        lsp[server_name].setup(config)
                    end
                }
            })
            autocmd('LspAttach', {
                group = augroup('lsp_attach_config', { clear = true }),
                callback = function(ev)
                    local fzf_lua = require('fzf-lua')
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    keymap('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Go to definition' })
                    keymap('n', 'gD', fzf_lua.lsp_definitions, { buffer = ev.buf, desc = 'Find definitions' })
                    keymap('n', 'gi', fzf_lua.lsp_implementations, { desc = 'Find implementations' })
                    keymap('n', 'gr', fzf_lua.lsp_references, { buffer = ev.buf, desc = 'Find references' })
                    keymap('n', 'gt', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Go to type definition' })
                    keymap('n', 'gT', fzf_lua.lsp_typedefs, { buffer = ev.buf, desc = 'Find type definitions' })
                    keymap('n', '<Space>', vim.lsp.buf.hover, { buffer = ev.buf })
                    keymap({ 'n', 'x' }, '<leader><Space>', fzf_lua.lsp_code_actions, { buffer = ev.buf, desc = 'Find code actions' })
                    keymap('n', '<leader>r', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Rename symbol under cursor' })
                    keymap('n', '<leader>fld', fzf_lua.lsp_document_diagnostics, { buffer = ev.buf, desc = 'Find document diagnostics' })
                    keymap('n', '<leader>flD', fzf_lua.lsp_workspace_diagnostics, { buffer = ev.buf, desc = 'Find workspace diagnostics' })
                    keymap('n', '<leader>fls', fzf_lua.lsp_document_symbols, { buffer = ev.buf, desc = 'Find document symbols' })
                    keymap('n', '<leader>flS', fzf_lua.lsp_workspace_symbols, { buffer = ev.buf, desc = 'Find workspace symbols' })
                end,
            })
        end,
    },

    -- Completion
    {
        'hrsh7th/cmp-nvim-lsp',
        commit = '5af77f54de1b16c34b23cba810150689a3a90312',
        lazy = true,
    },
    {
        'hrsh7th/nvim-cmp',
        commit = '04e0ca376d6abdbfc8b52180f8ea236cbfddf782',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            vim.opt.completeopt = 'menu,menuone,noselect'
            local cmp = require('cmp')
            local cmp_config = {
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
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }),
            }
            cmp.setup(cmp_config)
            command('CmpEnable', function() cmp.setup.buffer(cmp_config) end, {})
            command('CmpDisable', function() cmp.setup.buffer({ enabled = false }) end, {})
        end,
    },

    -- Git
    {
        'lewis6991/gitsigns.nvim',
        commit = '2c2463dbd82eddd7dbab881c3a62cfbfbe3c67ae',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '-' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    {
        'tpope/vim-fugitive',
        commit = '41beedabc7e948c787ea5696e04c3544c3674e23',
        event = 'VeryLazy',
    },

    -- Miscellaneous
    {
        'echasnovski/mini.clue',
        commit = '4937bbfb4d461dd9408e004e929716f1fc0296c8',
        event = 'VeryLazy',
        config = function()
            local miniclue = require('mini.clue')
            miniclue.setup({
                triggers = {
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },
                    { mode = 'n', keys = 'ö' },
                    { mode = 'n', keys = 'ä' },
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },
                    { mode = 'n', keys = "'" },
                    { mode = 'x', keys = "'" },
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-x>' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },
                    { mode = 'n', keys = '<C-w>' },
                },
                clues = {
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers({ show_contents = true }),
                    miniclue.gen_clues.windows(),
                },
                window = {
                    delay = 500,
                    config = { width = 'auto', border = 'rounded' },
                }
            })
        end,
    },
    {
        'mbbill/undotree',
        commit = '0e11ba7325efbbb3f3bebe06213afa3e7ec75131',
        event = 'VeryLazy',
        config = function()
            keymap('n', '<Leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle undotree' })
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_WindowLayout = 2
        end,
    },
    {
        'michaeljsmith/vim-indent-object',
        commit = '5c5b24c959478929b54a9e831a8e2e651a465965',
        event = 'VeryLazy',
    },
    {
        'romainl/vim-qf',
        commit = '7e65325651ff5a0b06af8df3980d2ee54cf10e14',
        event = 'VeryLazy',
        config = function()
            keymap('n', 'öq', '<Plug>(qf_qf_previous)', { desc = 'Go to previous quickfix item' })
            keymap('n', 'äq', '<Plug>(qf_qf_next)', { desc = 'Go to next quickfix item' })
        end,
    },
    {
        'tpope/vim-repeat',
        commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a',
        event = 'VeryLazy',
    },
    {
        'whiteinge/diffconflicts',
        commit = '05e8d2e935a235b8f8e6d308a46a5f028ea5bf97',
        cmd = { 'DiffConflicts', 'DiffConflictsShowHistory', 'DiffConflictsWithHistory' },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'VeryLazy',
        branch = 'main',
        commit = 'e73c775aa9d540f0c33585ed1b5ea572a64bdac1',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                    disable = function(_, bufnr)
                        local filename = vim.api.nvim_buf_get_name(bufnr)
                        return #filename > 0 and vim.fn.getfsize(filename) > 1024 * 100
                    end,
                },
                matchup = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        node_incremental = 'v',
                        node_decremental = 'V',
                    },
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
                            ['aC'] = '@comment.outer',
                            ['iC'] = '@comment.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_previous_start = {
                            ['öa'] = '@parameter.inner',
                            ['öc'] = '@class.outer',
                            ['öC'] = '@comment.outer',
                            ['öf'] = '@function.outer',
                        },
                        goto_next_start = {
                            ['äa'] = '@parameter.inner',
                            ['äc'] = '@class.outer',
                            ['äC'] = '@comment.outer',
                            ['äf'] = '@function.outer',
                        },
                    },
                },
            })
        end,
    },
}
