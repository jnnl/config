return {
    -- Navigation
    {
        'andymass/vim-matchup',
        commit = 'ff3bea611696f5cfdfe61a939149daadff41f2af',
        event = { 'BufNewFile', 'BufReadPost' },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            _keymap({ 'n', 'x' }, 'ö%', '<Plug>(matchup-[%)', { desc = 'Go to previous outer open word' })
            _keymap({ 'n', 'x' }, 'ä%', '<Plug>(matchup-]%)', { desc = 'Go to next outer close word' })
        end,
    },

    {
        'ggandor/leap.nvim',
        commit = '75c246f562ab34a92c359c3c4d2eb138768b92ec',
        event = 'VeryLazy',
        config = function()
            local leap = require('leap')
            leap.opts.safe_labels = {}
            leap.opts.preview_filter = function(ch0, ch1, ch2)
                return not (
                    (ch1:match('%s') or ch2:match('%s')) or
                    (ch0:match('%w') and ch1:match('%w') and ch2:match('%w'))
                )
            end
            _keymap({ 'n', 'x' }, 's', '<Plug>(leap-forward-to)')
            _keymap({ 'n', 'x' }, 'S', '<Plug>(leap-backward-to)')
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
        commit = '2e88254c2045e14c712ee09f1e461c6056a2b18c',
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
                            local git_root_dir = vim.fs.dirname(vim.fn.finddir('.git', '.;'))
                            if #git_root_dir > 0 then
                                opts.cwd = git_root_dir
                            end
                            fzf_lua[resume_data.opts.__INFO.cmd](opts)
                        end,
                        -- Open selected file(s) using system default handler
                        ['ctrl-o'] = function(selected)
                            for _, item in ipairs(selected) do
                                local selected_item = item:match('^%s*(.-)%s*$')
                                vim.notify('fzf-lua: opening file ' .. selected_item)
                                vim.ui.open(selected_item)
                            end
                        end,
                        -- Open a new vertical split and populate it with selected search results
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
                lsp = {
                    code_actions = {
                        previewer = 'codeaction_native',
                        preview_pager = 'delta -s -w=$FZF_PREVIEW_COLUMNS ' ..
                        '--syntax-theme ansi --file-style=omit --hunk-header-style=omit',
                    },
                },
            })

            _keymap('n', '<Leader>ff', fzf_lua.builtin, { desc = 'Find fzf-lua builtins' })
            _keymap('n', '<Leader>fc', fzf_lua.commands, { desc = 'Find commands' })
            _keymap('n', '<Leader>fr', fzf_lua.registers, { desc = 'Find registers' })
            _keymap('n', '<Leader>f*', fzf_lua.grep_cWORD, { desc = 'Find text matching word under cursor' })
            _keymap('x', '<Leader>f*', fzf_lua.grep_visual, { desc = 'Find text matching visual selection' })

            _keymap('n', '<Leader>,', fzf_lua.files, { desc = 'Find files' })
            _keymap('n', '<Leader>.', fzf_lua.buffers, { desc = 'Find buffers' })
            _keymap('n', '<Leader>-', fzf_lua.grep_project, { desc = 'Find text' })
            _keymap('n', '<Leader>;', fzf_lua.oldfiles, { desc = 'Find recently opened files' })
            _keymap('n', '<Leader>:', function()
                fzf_lua.oldfiles({ prompt = 'CwdHistory> ', cwd_only = true })
            end, { desc = 'Find recently opened files under cwd' })
            _keymap('n', '<Leader>_', fzf_lua.blines, { desc = 'Find text in current file' })
            _keymap('n', '<Leader>\'', fzf_lua.resume, { desc = 'Resume most recent fzf-lua search' })
            _keymap('n', '<Leader>*', function() fzf_lua.files({ cwd = '~' }) end, { desc = 'Find files in $HOME' })

            _keymap('n', '<Leader>fgb', fzf_lua.git_branches, { desc = 'Find git branches' })
            _keymap('n', '<Leader>fgc', fzf_lua.git_commits, { desc = 'Find git commits' })
            _keymap('n', '<Leader>fgf', fzf_lua.git_files, { desc = 'Find git files' })
            _keymap('n', '<Leader>fgx', function()
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
        init = function()
            vim.cmd.colorscheme('tonight')
        end,
    },

    -- Language
    {
        'stevearc/conform.nvim',
        tag = 'v5.9.0',
        event = 'BufWritePre',
        cmd = { 'Format', 'FormatDisable', 'FormatEnable' },
        keys = { { '<Leader>xf', desc = 'Format buffer' } },
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
            vim.api.nvim_create_user_command('Format', function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ['end'] = { args.line2, end_line:len() },
                    }
                end
                conform.format({ async = true, lsp_fallback = true, range = range })
            end, { range = true, desc = 'Format buffer' })
            _command('FormatDisable', function(args)
                if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
            end, { bang = true, desc = 'Disable autoformatting' })
            _command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { bang = true, desc = 'Enable autoformatting' })
            _keymap('n', '<Leader>xf', function() vim.cmd('Format') end, { desc = 'Format buffer' })
        end
    },

    {
        'ray-x/lsp_signature.nvim',
        commit = 'a38da0a61c172bb59e34befc12efe48359884793',
        lazy = true,
    },

    {
        'neovim/nvim-lspconfig',
        tag = 'v0.1.8',
        event = { 'BufNewFile', 'BufReadPre' },
        dependencies = {
            { 'williamboman/mason.nvim', commit = '0950b15060067f752fde13a779a994f59516ce3d' },
            { 'williamboman/mason-lspconfig.nvim', commit = '37a336b653f8594df75c827ed589f1c91d91ff6c' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            local lsp = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            local servers = {
                angularls = {
                    filetypes = { 'html' },
                },
                ansiblels = {
                    settings = { ansible = { validation = { lint = { enabled = true } } } },
                },
                bashls = {},
                cssls = {},
                denols = {
                    root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc')
                },
                gopls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT', },
                            diagnostics = { globals = { 'vim' }, },
                            workspace = {
                                library = { vim.env.VIMRUNTIME },
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                pylsp = {},
                terraformls = {},
                tsserver = {},
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
                group = _augroup('lsp_attach_config', { clear = true }),
                callback = function(ev)
                    local fzf_lua = require('fzf-lua')
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    _keymap('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Go to definition' })
                    _keymap('n', 'gD', fzf_lua.lsp_definitions, { buffer = ev.buf, desc = 'Find definitions' })
                    _keymap('n', 'gi', fzf_lua.lsp_implementations, { desc = 'Find implementations' })
                    _keymap('n', 'gr', fzf_lua.lsp_references, { buffer = ev.buf, desc = 'Find references' })
                    _keymap('n', 'gt', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Go to type definition' })
                    _keymap('n', 'gT', fzf_lua.lsp_typedefs, { buffer = ev.buf, desc = 'Find type definitions' })
                    _keymap('n', '<Space>', vim.lsp.buf.hover, { buffer = ev.buf })
                    _keymap({ 'n', 'x' }, '<Leader><Space>', fzf_lua.lsp_code_actions, { buffer = ev.buf, desc = 'Find code actions' })
                    _keymap('n', '<Leader>r', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Rename symbol under cursor' })
                    _keymap('n', '<Leader>fld', fzf_lua.lsp_document_diagnostics, { buffer = ev.buf, desc = 'Find document diagnostics' })
                    _keymap('n', '<Leader>flD', fzf_lua.lsp_workspace_diagnostics, { buffer = ev.buf, desc = 'Find workspace diagnostics' })
                    _keymap('n', '<Leader>fls', fzf_lua.lsp_document_symbols, { buffer = ev.buf, desc = 'Find document symbols' })
                    _keymap('n', '<Leader>flS', fzf_lua.lsp_workspace_symbols, { buffer = ev.buf, desc = 'Find workspace symbols' })
                    require('lsp_signature').on_attach({ hint_enable = false }, ev.buf)
                end,
            })
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',
        commit = '73fb37ed77b18ac357ca8e6e35835a8db6602332',
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', commit = '5f9bf4b1ead7707e4e74e5319ee56bdc81fb73db' },
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
                            ['ac'] = '@comment.outer',
                            ['ic'] = '@comment.inner',
                            ['aC'] = '@class.outer',
                            ['iC'] = '@class.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_previous_start = {
                            ['öa'] = '@parameter.inner',
                            ['öc'] = '@comment.outer',
                            ['öC'] = '@class.outer',
                            ['öf'] = '@function.outer',
                        },
                        goto_next_start = {
                            ['äa'] = '@parameter.inner',
                            ['äc'] = '@comment.outer',
                            ['äC'] = '@class.outer',
                            ['äf'] = '@function.outer',
                        },
                    },
                },
            })
            _command('TSInstallPredefined', function(args)
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
        commit = '5260e5e8ecadaf13e6b82cf867a909f54e15fd07',
        event = 'InsertEnter',
        cmd = { 'CmpEnable', 'CmpDisable' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' }
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
            _command('CmpEnable', function() cmp.setup.buffer(cmp_config) end, {})
            _command('CmpDisable', function() cmp.setup.buffer({ enabled = false }) end, {})
        end,
    },

    -- Git
    {
        'lewis6991/gitsigns.nvim',
        tag = 'v0.9.0',
        event = 'VeryLazy',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '-' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = require('gitsigns')
                    local map = function(mode, lhs, rhs, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        _keymap(mode, lhs, rhs, opts)
                    end
                    map('n', 'öh', function() gs.nav_hunk('prev') end, { desc = 'Go to previous hunk' })
                    map('n', 'äh', function() gs.nav_hunk('next') end, { desc = 'Go to next hunk' })
                    map('n', '<Leader>gd', gs.diffthis, { desc = 'Diff file against index' })
                    map('n', '<Leader>gD', function() gs.diffthis('~') end, { desc = 'Diff file against last commit' })
                    map('n', '<Leader>gp', gs.preview_hunk, { desc = 'Preview hunk under cursor' })
                    map('n', '<Leader>gs', gs.stage_hunk, { desc = 'Stage hunk under cursor' })
                    map('n', '<Leader>gr', gs.reset_hunk, { desc = 'Unstage hunk under cursor' })
                    map('v', '<Leader>gs', function()
                        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, { desc = 'Stage hunk(s) in visual range' })
                    map('v', '<Leader>gr', function()
                        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, { desc = 'Unstage hunk(s) in visual range' })
                end,
            })
        end,
    },

    {
        'tpope/vim-fugitive',
        commit = '4f59455d2388e113bd510e85b310d15b9228ca0d',
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
        'mbbill/undotree',
        commit = '56c684a805fe948936cda0d1b19505b84ad7e065',
        event = 'VeryLazy',
        config = function()
            _keymap('n', '<Leader>ou', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle undotree' })
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
            _keymap('n', 'öl', '<Plug>(qf_loc_previous)', { desc = 'Go to previous location list item' })
            _keymap('n', 'äl', '<Plug>(qf_loc_next)', { desc = 'Go to next location list item' })
            _keymap('n', 'öq', '<Plug>(qf_qf_previous)', { desc = 'Go to previous quickfix item' })
            _keymap('n', 'äq', '<Plug>(qf_qf_next)', { desc = 'Go to next quickfix item' })
        end,
    },

    {
        'whiteinge/diffconflicts',
        tag = '2.3.0',
        cmd = { 'DiffConflicts', 'DiffConflictsShowHistory', 'DiffConflictsWithHistory' },
    },

    {
        'junegunn/goyo.vim',
        commit = 'fa0263d456dd43f5926484d1c4c7022dfcb21ba9',
        cmd = 'Goyo',
    },
}
