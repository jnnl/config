return {
    -- Navigation
    {
        'andymass/vim-matchup',
        commit = 'f89858a5ab87feb752c860d396022ae7b13070c2',
        event = { 'BufNewFile', 'BufReadPost' },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
    },

    {
        'ggandor/leap.nvim',
        commit = 'c6bfb191f1161fbabace1f36f578a20ac6c7642c',
        event = 'VeryLazy',
        config = function()
            local leap = require('leap')
            leap.opts.safe_labels = {}
            leap.opts.preview_filter = function(ch0, ch1, ch2)
                return not (
                    (ch1:match('%s') or ch2:match('%s')) or -- skip whitespace boundaries
                    (ch0:match('%w') and ch1:match('%w') and ch2:match('%w')) -- skip middle of alphanumerics
                )
            end
            _map({ 'n', 'x' }, 's', '<Plug>(leap-forward-to)')
            _map({ 'n', 'x' }, 'S', '<Plug>(leap-backward-to)')
        end,
    },

    {
        'junegunn/fzf',
        lazy = true,
        build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc',
    },

    {
        'ibhagwan/fzf-lua',
        commit = 'f39de2d77755e90a7a80989b007f0bf2ca13b0dd',
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
                    backdrop = 100,
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
                        -- Change search cwd to directory containing current file
                        ['ctrl-x'] = function()
                            local resume_data = fzf_lua.config.__resume_data
                            local opts = { query = resume_data.last_query }
                            local file_dir = vim.fn.expand('%:h')
                            if #file_dir > 0 then
                                opts.cwd = file_dir
                            end
                            fzf_lua[resume_data.opts.__INFO.cmd](opts)
                        end,
                        -- Change search cwd to parent directory
                        ['ctrl-h'] = function()
                            local resume_data = fzf_lua.config.__resume_data
                            local opts = { query = resume_data.last_query, cwd = resume_data.opts.cwd }
                            if #(opts.cwd or '') > 1 and vim.endswith(opts.cwd, '/') then
                                opts.cwd = string.sub(opts.cwd, 1, -2)
                            end
                            if opts.cwd ~= '/' then
                                opts.cwd = vim.fn.fnamemodify(opts.cwd, ':p:h:h')
                            end
                            fzf_lua[resume_data.opts.__INFO.cmd](opts)
                        end,
                        -- Change search cwd to git root
                        ['ctrl-r'] = function()
                            local resume_data = fzf_lua.config.__resume_data
                            local opts = { query = resume_data.last_query }
                            local git_root_dir = vim.fs.root(0, '.git') or ''
                            if #git_root_dir > 0 then
                                opts.cwd = git_root_dir
                            end
                            fzf_lua[resume_data.opts.__INFO.cmd](opts)
                        end,
                        -- Open selected item(s) using system default handler
                        ['ctrl-o'] = function(selected)
                            for _, item in ipairs(selected) do
                                local selected_item = item:match('^%s*(.-)%s*$')
                                vim.notify('fzf-lua: opening file ' .. selected_item)
                                vim.ui.open(selected_item)
                            end
                        end,
                        -- Populate a new vertical split with selected items
                        ['ctrl-p'] = function(selected)
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
                    fzf_opts = { ['--scheme'] = 'path' },
                },
                oldfiles = {
                    fzf_opts = { ['--scheme'] = 'path' },
                    include_current_session = true,
                    winopts = { preview = { hidden = 'hidden' } },
                },
                grep = {
                    fzf_opts = { ['--nth'] = '3..', ['--delimiter'] = ':' },
                    rg_opts = '--column --line-number --no-heading --hidden --smart-case --max-columns=4096 ' ..
                    '--glob="!.git/" --color=always --colors "path:fg:green" --colors "line:fg:yellow"',
                    rg_glob = true,
                },
            })
            _map('n', '<Leader>ff', fzf_lua.builtin, { desc = 'Find fzf-lua builtins' })
            _map('n', '<Leader>fc', fzf_lua.commands, { desc = 'Find commands' })
            _map('n', '<Leader>f*', fzf_lua.grep_cWORD, { desc = 'Find text matching word under cursor' })
            _map('x', '<Leader>f*', fzf_lua.grep_visual, { desc = 'Find text matching visual selection' })
            _map('n', '<Leader>,', fzf_lua.files, { desc = 'Find files' })
            _map('n', '<Leader>.', fzf_lua.buffers, { desc = 'Find buffers' })
            _map('n', '<Leader>-', fzf_lua.grep_project, { desc = 'Find text' })
            _map('n', '<Leader>;', fzf_lua.oldfiles, { desc = 'Find recently opened files' })
            _map('n', '<Leader>:', function()
                fzf_lua.oldfiles({ prompt = 'CwdHistory> ', cwd_only = true })
            end, { desc = 'Find recently opened files under cwd' })
            _map('n', '<Leader>_', fzf_lua.blines, { desc = 'Find text in current file' })
            _map('n', '<Leader>\'', fzf_lua.resume, { desc = 'Resume most recent fzf-lua search' })
            _map('n', '<Leader>*', function() fzf_lua.files({ cwd = '~' }) end, { desc = 'Find files in $HOME' })
            _map('n', '<Leader>fgs', fzf_lua.git_status, { desc = 'Find git status' })
            _map('n', '<Leader>fgx', function()
                fzf_lua.fzf_exec('git diff --name-only --diff-filter=U', {
                    prompt = 'Conflicts> ',
                    cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h'),
                    preview = [[awk '/^<<<<<<</,/^>>>>>>>/ { printf("%4d %s\n", NR, $0) }' {1}]],
                    actions = { ['default'] = actions.file_edit_or_qf },
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
        tag = 'v2.3.0',
        event = 'VeryLazy',
        opts = {},
    },

    {
        'tpope/vim-abolish',
        commit = 'dcbfe065297d31823561ba787f51056c147aa682',
        event = 'VeryLazy',
    },

    -- Colorschemes
    {
        'jnnl/tonight.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tonight')
        end,
    },

    {
        'verf/deepwhite.nvim',
        commit = 'eca39dec3d504412ab5efce0046b77f67ffe4640',
        lazy = true,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('deepwhite')
        end,
    },

    -- Language
    {
        'stevearc/conform.nvim',
        tag = 'v8.0.0',
        event = 'BufWritePre',
        cmd = { 'Format' },
        keys = { { '<Leader>xf', desc = 'Format buffer' } },
        config = function()
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
                    yaml = { 'yamlfmt' },
                },
            })
            vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
            vim.api.nvim_create_user_command('Format', function(args)
                local range = nil
                if args.count > -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = { start = { args.line1, 0 }, ['end'] = { args.line2, end_line:len() } }
                end
                conform.format({ async = true, lsp_format = 'fallback', range = range })
            end, { range = true, desc = 'Format buffer' })
            _map('n', '<Leader>xf', function() vim.cmd('Format') end, { desc = 'Format buffer' })
        end
    },

    {
        'neovim/nvim-lspconfig',
        tag = 'v0.1.8',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            { 'williamboman/mason.nvim', tag = 'v1.10.0' },
            { 'williamboman/mason-lspconfig.nvim', tag = 'v1.30.0' },
            { 'ray-x/lsp_signature.nvim', commit = 'a38da0a61c172bb59e34befc12efe48359884793' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            local lsp = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            local servers = {
                angularls = { filetypes = { 'html' } },
                ansiblels = { settings = { ansible = { validation = { lint = { enabled = true } } } } },
                bashls = {},
                cssls = {},
                denols = { root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc') },
                gopls = {},
                html = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            diagnostics = { globals = { 'vim' } },
                            workspace = {
                                library = { vim.env.VIMRUNTIME },
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                pylsp = {},
                rust_analyzer = {},
                svelte = {},
                terraformls = {},
                tsserver = {},
            }
            require('mason').setup()
            require('mason-lspconfig').setup({
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
                        lsp.util.on_setup = lsp.util.add_hook_before(lsp.util.on_setup, function(cfg)
                            if cfg.name == 'tsserver' and lsp.util.root_pattern('deno.json') then
                                cfg.single_file_support = false
                            end
                        end)
                        lsp[server_name].setup(config)
                    end
                }
            })
            _autocmd('LspAttach', {
                group = _augroup('lsp_attach_config'),
                callback = function(ev)
                    local fzf_lua = require('fzf-lua')
                    local opts = _make_opts_fn({ buffer = ev.buf })
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    _map('n', 'gd', vim.lsp.buf.definition, opts({ desc = 'Go to definition' }))
                    _map('n', 'gD', fzf_lua.lsp_definitions, opts({ desc = 'Find definitions' }))
                    _map('n', 'gi', fzf_lua.lsp_implementations, opts({ desc = 'Find implementations' }))
                    _map('n', 'gt', vim.lsp.buf.type_definition, opts({ desc = 'Go to type definition' }))
                    _map('n', 'gT', fzf_lua.lsp_typedefs, opts({ desc = 'Find type definitions' }))
                    _map('n', '<Space>', vim.lsp.buf.hover, opts())
                    _map({ 'n', 'x' }, '<Leader><Space>', fzf_lua.lsp_code_actions, opts({ desc = 'Find code actions' }))
                    require('lsp_signature').on_attach({ hint_enable = false }, ev.buf)
                end,
            })
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',
        commit = '9ac3931bf6891cecd59c432d343d6490afd401e5',
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', commit = '3a3c6244553f13fdd92d312c82722b57ce6c4bec' },
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = { enable = true },
                matchup = { enable = true },
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
                            ['aA'] = '@assignment.outer',
                            ['iA'] = '@assignment.inner',
                            ['ac'] = '@comment.outer',
                            ['ic'] = '@comment.inner',
                            ['aC'] = '@conditional.outer',
                            ['iC'] = '@conditional.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['aF'] = '@call.outer',
                            ['iF'] = '@call.inner',
                            ['al'] = '@loop.outer',
                            ['il'] = '@loop.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_previous_start = {
                            ['öa'] = '@parameter.inner',
                            ['öA'] = '@assignment.outer',
                            ['öc'] = '@comment.outer',
                            ['öC'] = '@conditional.outer',
                            ['öf'] = '@function.outer',
                            ['öF'] = '@call.outer',
                            ['öl'] = '@loop.outer',
                        },
                        goto_next_start = {
                            ['äa'] = '@parameter.inner',
                            ['äA'] = '@assignment.outer',
                            ['äc'] = '@comment.outer',
                            ['äC'] = '@conditional.outer',
                            ['äf'] = '@function.outer',
                            ['äF'] = '@call.outer',
                            ['äl'] = '@loop.outer',
                        },
                    },
                },
            })
            _cmd('TSInstallPredefined', function(args)
                local parsers = {
                    'angular', 'bash', 'c', 'cpp', 'css', 'diff', 'dockerfile', 'go', 'html', 'javascript', 'json',
                    'lua', 'make', 'markdown', 'markdown_inline', 'python', 'rust', 'scss', 'terraform',
                    'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
                }
                vim.cmd({ cmd = 'TSInstall', args = parsers, bang = args.bang })
            end, { bang = true, desc = 'Install predefined treesitter parsers' })
        end,
    },

    -- Completion
    {
        'hrsh7th/cmp-nvim-lsp',
        commit = '39e2eda76828d88b773cc27a3f61d2ad782c922d',
        lazy = true,
    },

    {
        'hrsh7th/nvim-cmp',
        commit = 'ae644feb7b67bf1ce4260c231d1d4300b19c6f30',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        init = function()
            vim.g.cmp_enabled = true
            _map('n', '<Leader>tc', function()
                vim.g.cmp_enabled = vim.g.cmp_enabled ~= true
                vim.notify('completion ' .. (vim.g.cmp_enabled and 'enabled' or 'disabled'))
            end, { desc = 'Toggle completion' })
        end,
        config = function()
            vim.opt.completeopt = 'menu,menuone,noselect'
            local cmp = require('cmp')
            cmp.setup({
                enabled = function() return vim.g.cmp_enabled end,
                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
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
                snippet = { expand = function(args) vim.snippet.expand(args.body) end },
                sources = cmp.config.sources({ { name = 'nvim_lsp' } }),
            })
        end,
    },

    -- Git
    {
        'lewis6991/gitsigns.nvim',
        tag = 'v0.9.0',
        event = 'VeryLazy',
        opts = {
            on_attach = function(bufnr)
                local gs = require('gitsigns')
                local opts = _make_opts_fn({ buffer = bufnr })
                _map('n', 'öh', function() gs.nav_hunk('prev') end, opts({ desc = 'Go to previous hunk' }))
                _map('n', 'äh', function() gs.nav_hunk('next') end, opts({ desc = 'Go to next hunk' }))
                _map('n', '<Leader>gd', gs.diffthis, opts({ desc = 'Diff file against index' }))
                _map('n', '<Leader>gD', function() gs.diffthis('~') end, opts({ desc = 'Diff file against last commit' }))
                _map('n', '<Leader>gp', gs.preview_hunk, opts({ desc = 'Preview hunk under cursor' }))
                _map('n', '<Leader>gs', gs.stage_hunk, opts({ desc = 'Stage hunk under cursor' }))
                _map('n', '<Leader>gr', gs.reset_hunk, opts({ desc = 'Unstage hunk under cursor' }))
                _map('v', '<Leader>gs', function()
                    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts({ desc = 'Stage hunk(s) in visual range' }))
                _map('v', '<Leader>gr', function()
                    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts({ desc = 'Unstage hunk(s) in visual range' }))
            end,
        }
    },

    {
        'tpope/vim-fugitive',
        commit = '0444df68cd1cdabc7453d6bd84099458327e5513',
        event = 'VeryLazy',
    },

    -- Miscellaneous
    {
        'echasnovski/mini.clue',
        tag = 'v0.13.0',
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
        'echasnovski/mini.files',
        tag = 'v0.13.0',
        config = function()
            local minifiles = require('mini.files')
            minifiles.setup({
                mappings = { go_out_plus = 'h' },
                options = { use_as_default_explorer = true },
            })
            _map('n', '<Leader>tf', function()
                if not minifiles.close() then minifiles.open() end
            end, { desc = 'Toggle mini.files' })
        end,
    },

    {
        'mbbill/undotree',
        commit = '56c684a805fe948936cda0d1b19505b84ad7e065',
        event = 'VeryLazy',
        config = function()
            _map('n', '<Leader>tu', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle undotree' })
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
        event = 'FileType qf',
        config = function()
            _map('n', 'öl', '<Plug>(qf_loc_previous)', { desc = 'Go to previous location list item' })
            _map('n', 'äl', '<Plug>(qf_loc_next)', { desc = 'Go to next location list item' })
            _map('n', 'öq', '<Plug>(qf_qf_previous)', { desc = 'Go to previous quickfix item' })
            _map('n', 'äq', '<Plug>(qf_qf_next)', { desc = 'Go to next quickfix item' })
        end,
    },

    {
        'stevearc/quicker.nvim',
        tag = 'v1.1.1',
        event = 'FileType qf',
        opts = {
            keys = {
                { '>', function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end },
                { '<', function() require('quicker').collapse() end },
            },
        },
    },

    {
        'whiteinge/diffconflicts',
        tag = '2.3.0',
        cmd = { 'DiffConflicts', 'DiffConflictsShowHistory', 'DiffConflictsWithHistory' },
    },
}
