return {
    -- Navigation
    {
        'andymass/vim-matchup',
        commit = 'ea2ff43e09e68b63fc6d9268fc5d82d82d433cb3',
        event = { 'BufNewFile', 'BufReadPost' },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
    },

    {
        'ggandor/leap.nvim',
        commit = '2b68ddc0802bd295e64c9e2e75f18f755e50dbcc',
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
            _map({ 'n', 'x' }, 's', '<Plug>(leap)')
        end,
    },

    {
        'junegunn/fzf',
        version = '*',
        lazy = true,
        build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc',
    },

    {
        'ibhagwan/fzf-lua',
        commit = '480e29c20cb324bb9bf3d6f7d8e5505bcb49d555',
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
                        treesitter = { enabled = true },
                        extensions = {
                            ['gif'] = { 'chafa' },
                            ['png'] = { 'chafa' },
                            ['jpg'] = { 'chafa' },
                            ['jpeg'] = { 'chafa' },
                            ['svg'] = { 'chafa' },
                        },
                        title_fnamemodify = function(s) return vim.fn.fnamemodify(s, ':p:.') end,
                        syntax_limit_b = 100 * 1024,
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
            _map('n', '<Leader>_', fzf_lua.grep_curbuf, { desc = 'Find text in current file' })
            _map('n', '<Leader>\'', fzf_lua.resume, { desc = 'Resume most recent fzf-lua search' })
            _map('n', '<Leader>*', function() fzf_lua.files({ cwd = '~' }) end, { desc = 'Find files in $HOME' })
            _map('n', '<Leader>fd', fzf_lua.diagnostics_document, { desc = 'Find document diagnostics' })
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
        tag = 'v3.1.1',
        event = 'VeryLazy',
        opts = {},
    },

    -- Colorschemes
    {
        'jnnl/tonight.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tonight')
        end,
    },

    -- Language
    {
        'stevearc/conform.nvim',
        tag = 'v9.0.0',
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
        end,
    },

    {
        'neovim/nvim-lspconfig',
        tag = 'v2.1.0',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            { 'mason-org/mason.nvim', tag = 'v2.0.0' },
            { 'ray-x/lsp_signature.nvim', commit = 'a793d02b6a5e639fa9d3f2a89a839fa688ab2d0a' },
            { 'hrsh7th/cmp-nvim-lsp', commit = '99290b3ec1322070bcfb9e846450a46f6efa50f0' },
        },
        config = function()
            local servers = {
                angularls = { filetypes = { 'html', 'htmlangular' } },
                ansiblels = { settings = { ansible = { validation = { lint = { enabled = true } } } } },
                bashls = {},
                cssls = {},
                gopls = {},
                html = { filetypes = { 'html', 'htmlangular' } },
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
                terraformls = {},
                ts_ls = {},
            }
            require('mason').setup()
            for server, config in pairs(servers) do
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',
        commit = '28d480e0624b259095e56f353ec911f9f2a0f404',
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', commit = '0e3be38005e9673d044e994b1e4b123adb040179' },
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
        'hrsh7th/nvim-cmp',
        commit = 'b5311ab3ed9c846b585c0c15b7559be131ec4be9',
        event = 'InsertEnter',
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
        tag = 'v1.0.2',
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
        commit = '4a745ea72fa93bb15dd077109afbb3d1809383f2',
        event = 'VeryLazy',
        config = function()
            _map('n', '<Leader>gb', '<cmd>Git blame<CR>', { desc = 'Open git blame split' })
            _map('n', '<Leader>gl', '<cmd>Git log %<CR>', { desc = 'Open file commit history' })
            _map('n', '<Leader>gL', '<cmd>0Gclog<CR>', { desc = 'Open file commit history in quickfix' })
        end,
    },

    -- Miscellaneous
    {
        'echasnovski/mini.clue',
        tag = 'v0.15.0',
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
                    { mode = 'n', keys = 'z' },
                    { mode = 'x', keys = 'z' },
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
                    miniclue.gen_clues.z(),
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
        tag = 'v0.15.0',
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
        commit = 'b951b87b46c34356d44aa71886aecf9dd7f5788a',
        keys = { { '<Leader>tu', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' } },
        cmd = { 'UndotreeToggle', 'UndotreeShow', 'UndotreeHide' },
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_WindowLayout = 2
        end,
    },

    {
        'michaeljsmith/vim-indent-object',
        commit = '8ab36d5ec2a3a60468437a95e142ce994df598c6',
        event = 'VeryLazy',
    },

    {
        'stevearc/quicker.nvim',
        tag = 'v1.4.0',
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
