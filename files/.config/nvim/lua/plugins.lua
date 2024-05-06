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
        commit = '626be4c4ec040aeaf6466c9aae17ee0ab09f1a5b',
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
        commit = '3851bedb7f191b9a4a5531000b6fc0a8795cc9bb',
    },
    {
        'junegunn/fzf',
        lazy = true,
        build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc',
    },
    {
        'ibhagwan/fzf-lua',
        commit = '6865ff44f975c21d84a0206edae82e5cbb0fd80e',
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
                            -- Open selected file(s) using system default handler
                            for _, item in ipairs(selected) do
                                local selected_item = item:match('^%s*(.-)%s*$')
                                vim.notify('fzf-lua: opening file ' .. selected_item)
                                vim.ui.open(selected_item)
                            end
                        end,
                        ['ctrl-p'] = function(selected)
                            -- Open a new vertical split and populate it with selected search results
                            vim.cmd('vsplit')
                            local win = vim.api.nvim_get_current_win()
                            local buf = vim.api.nvim_create_buf(true, true)
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, selected)
                            vim.api.nvim_win_set_buf(win, buf)
                        end,
                        ['ctrl-h'] = function()
                            -- Change search cwd to parent directory
                            local opts = vim.tbl_deep_extend('force', fzf_lua.config.__resume_data.opts or {}, {
                                query = fzf_lua.config.__resume_data.last_query,
                            })
                            if #(opts.cwd or '') > 1 and vim.endswith(opts.cwd, '/') then
                                opts.cwd = string.sub(opts.cwd, 1, -2)
                            end
                            if opts.cwd ~= '/' then
                                opts.cwd = vim.fn.fnamemodify(opts.cwd, ':p:h:h')
                            end
                            fzf_lua.files(opts)
                        end,
                    }),
                },
                previewers = {
                    bat = {
                        args = '--style=numbers,changes,header-filename,rule --color always --line-range=:1000',
                    },
                    builtin = {
                        treesitter = { enable = true },
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
                files = {
                    formatter = 'path.filename_first',
                },
                oldfiles = {
                    formatter = 'path.filename_first',
                    include_current_session = true,
                    winopts = { preview = { hidden = 'hidden' } },
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
            keymap('n', '<Leader>f,', function()
                fzf_lua.files({ cwd = vim.fn.expand('%:h'), fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find files in current file\'s directory' })
            keymap('n', '<Leader>f;', function()
                fzf_lua.oldfiles({ cwd = vim.fn.expand('%:h'), fzf_opts = { ['--scheme'] = 'path' } })
            end, { desc = 'Find recently opened files in current file\'s directory' })
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
        'kylechui/nvim-surround',
        commit = '6d0dc3dbb557bcc6a024969da461df4ba803fc48',
        event = 'VeryLazy',
        opts = {},
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
        commit = '21f756b933cd11ac5990a6046fdc7c4e2a6c0aee',
    },
    {
        'leafgarland/typescript-vim',
        commit = 'e83ccab88c7a045ce795583adb66956afd464a31',
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
        commit = '12b3995537f52ba2810a9857e8ca256881febbda',
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
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            local servers = {
                angularls = {},
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
        commit = '8f3c541407e691af6163e2447f3af1bd6e17f9a3',
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
                        elseif vim.snippet.active({ direction = 1 }) then
                            vim.snippet.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.snippet.active({ direction = -1 }) then
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
        commit = '9cafac31a091267838e1e90fd6e083d37611f516',
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
        commit = 'dac8e5c2d85926df92672bf2afb4fc48656d96c7',
        event = 'VeryLazy',
    },

    -- Miscellaneous
    {
        'echasnovski/mini.clue',
        commit = '76850c33411ab544725d1a66c9ed528eb6202a64',
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
                    config = {
                        anchor = 'SW',
                        row = 'auto',
                        col = 'auto',
                        width = 'auto',
                        border = 'rounded',
                    },
                }
            })
        end,
    },
    {
        'mbbill/undotree',
        commit = '56c684a805fe948936cda0d1b19505b84ad7e065',
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
            keymap('n', 'öl', '<Plug>(qf_loc_previous)', { desc = 'Go to previous location list item' })
            keymap('n', 'äl', '<Plug>(qf_loc_next)', { desc = 'Go to next location list item' })
            keymap('n', 'öq', '<Plug>(qf_qf_previous)', { desc = 'Go to previous quickfix item' })
            keymap('n', 'äq', '<Plug>(qf_qf_next)', { desc = 'Go to next quickfix item' })
        end,
    },
    {
        'whiteinge/diffconflicts',
        commit = '4972d1401e008c5e9afeb703eddd1b2c2a1d1199',
        cmd = { 'DiffConflicts', 'DiffConflictsShowHistory', 'DiffConflictsWithHistory' },
    },
    {
        'andrewferrier/debugprint.nvim',
        commit = 'c7d04c3bf0a83e37434a4319040c2384a7f97acc',
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {},
    },
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'VeryLazy',
        branch = 'master',
        commit = '4e21361e15b1d4147830c5fe571556eb1b14e6f9',
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', commit = '23b820146956b3b681c19e10d3a8bc0cbd9a1d4c'},
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
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
