-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','

_G._keymap = vim.keymap.set
_G._command = vim.api.nvim_create_user_command
_G._autocmd = vim.api.nvim_create_autocmd
_G._augroup = vim.api.nvim_create_augroup
_G._dx = vim.diagnostic

-- Plugins

local load_plugins = true
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazy_path) then
    vim.ui.select({ 'yes', 'no' }, { prompt = 'lazy.nvim not found, install now?' }, function(choice)
        if choice == 'yes' then
            vim.notify('\ninstalling lazy.nvim...')
            vim.fn.system({
                'git', 'clone', 'https://github.com/folke/lazy.nvim.git',
                '--filter=blob:none', '--branch=stable',
                lazy_path
            })
        else
            vim.notify('\nlazy.nvim not installed, plugins are disabled...', vim.log.levels.WARN)
            load_plugins = false
        end
    end)
end

if load_plugins then
    vim.opt.rtp:prepend(lazy_path)
    local lazy_ok, lazy = pcall(require, 'lazy')
    if lazy_ok then
        lazy.setup('plugins', {
            defaults = { lazy = false },
            change_detection = { enabled = false },
            lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
            checker = { check_pinned = true },
            install = { missing = false },
            performance = {
                rtp = {
                    disabled_plugins = { 'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'rplugin', 'tohtml', 'tutor', },
                },
            },
        })
    else
        vim.notify('failed to load lazy.nvim, plugins are disabled...', vim.log.levels.WARN)
    end
end

-- Miscellaneous

vim.opt.fillchars:append('eob: ')
vim.opt.modeline = false
vim.opt.mouse = ''
vim.opt.number = true
vim.opt.shada = [[r/tmp/,r/private/,rfugitive:,rterm:,rzipfile:,!,'200,<50,s10,h]]
vim.opt.shortmess:append('cI')
vim.opt.timeoutlen = 500
vim.opt.inccommand = 'split'
vim.opt.signcolumn = 'yes'

_dx.config({ virtual_text = false })

-- Statusline

_G._statusline = function()
    local separator = '%#StatuslineNC# | %*'
    local line_count = '%3l/%L'
    local file_path = separator .. '%<%f'
    local buf_attrs = ''
    do
        local attrs = {}
        if #vim.api.nvim_buf_get_name(0) > 0 then
            table.insert(attrs, '%y%r%m ')
        end
        if vim.g['loaded_fugitive'] == 1 then
            local branch_name = vim.fn.FugitiveHead(7)
            if #branch_name > 0 then
                table.insert(attrs, string.format('(%s) ', branch_name))
            end
        end
        local diagnostic_counts = _dx.count(0)
        if #diagnostic_counts > 0 then
            local diagnostic_start_pos = #attrs + 1
            for severity, count in pairs(diagnostic_counts) do
                local symbol = _dx.severity[severity]:sub(1, 1)
                table.insert(attrs, diagnostic_start_pos, string.format('%s:%s ', symbol, count))
            end
        end
        if #attrs > 0 then
            table.insert(attrs, 1, separator)
        end
        buf_attrs = table.concat(attrs)
    end

    return table.concat({
        line_count,
        file_path,
        buf_attrs,
    })
end

vim.opt.statusline = '%{%v:lua._statusline()%}'

-- Indentation

vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1

-- Search

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Splits

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Undo

vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
vim.opt.undofile = true

-- Keymaps

_keymap('n', '<BS>', '<C-^>')
_keymap('n', '\'', '`')
_keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
_keymap('n', 'Ö', '<C-o>', { desc = 'Go to previous jump list position' })
_keymap('n', 'Ä', '<C-i>', { desc = 'Go to next jump list position' })
_keymap('n', 'öb', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
_keymap('n', 'äb', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
_keymap('n', 'öt', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
_keymap('n', 'ät', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
_keymap('n', 'ög', function()
    _dx.jump({ count = -1, severity = { min = _dx.severity.WARN } })
end, { desc = 'Go to previous WARN+ diagnostic' })
_keymap('n', 'äg', function()
    _dx.jump({ count = 1, severity = { min = _dx.severity.WARN } })
end, { desc = 'Go to next WARN+ diagnostic' })
_keymap('n', 'öG', function()
    _dx.jump({ count = -1, severity = { min = _dx.severity.HINT } })
end, { desc = 'Go to previous HINT+ diagnostic' })
_keymap('n', 'äG', function()
    _dx.jump({ count = 1, severity = { min = _dx.severity.HINT } })
end, { desc = 'Go to next HINT+ diagnostic' })
_keymap('n', '<C-Space>', _dx.open_float)

_keymap('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
_keymap('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
_keymap({ 'n', 'x' }, '<C-j>', '}')
_keymap({ 'n', 'x' }, '<C-k>', '{')
_keymap('c', '<C-j>', '<Down>')
_keymap('c', '<C-k>', '<Up>')

_keymap('n', '<C-w>.', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local longest_line_length = math.max(unpack(vim.tbl_map(function(line) return #line end, lines)))
    vim.cmd('vertical resize ' .. longest_line_length + 8)
end, { desc = 'Fit window width to content' })
_keymap('n', '<C-w>:', function()
    vim.cmd('resize' .. vim.fn.line('$'))
end, { desc = 'Fit window height to content' })

_keymap('n', '§', '@')
_keymap('n', '§§', '@@')
_keymap('n', 'Q', '@q')
_keymap('x', 'Q', ':normal @q<CR>')
_keymap('x', '§', ':normal @')
_keymap('x', '@', ':normal @')
_keymap('x', '.', ':normal .<CR>')

_keymap({'n', 'x'}, '<Leader>y', '"+y', { desc = 'Copy text to system clipboard' })
_keymap({'n', 'x'}, '<Leader>Y', '"+Y', { desc = 'Copy text from cursor to end of line to system clipboard' })
_keymap({'n', 'x'}, '<Leader>p', function()
    vim.cmd('normal "+p')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard after the cursor' })
_keymap({'n', 'x'}, '<Leader>P', function()
    vim.cmd('normal "+P')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard before the cursor' })

_keymap('n', '<Leader>q', '<cmd>CloseFloatingWindows<CR>', { desc = 'Close floating windows' })
_keymap('n', '<Leader>s', function()
    return ':%s/' .. vim.fn.expand('<cword>') .. '/'
end, { expr = true, desc = 'Substitute word under cursor' })

-- Commands

_command('NonAscii', '/[^\\x00-\\x7F]', { desc = 'Search for non-ASCII characters' })
_command('Unansify', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/\%x1b\[[0-9;]*[a-zA-Z]//ge]])
end, { range = true, desc = 'Remove ANSI escape codes' })

_command('Unblankify', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd(range .. [[g/^\s*$/d]])
end, { range = true, desc = 'Remove blank lines' })

_command('Lstrip', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/^\s\+//e]])
end, { range = true, desc = 'Strip leading whitespace' })

_command('Rstrip', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/\s\+$//e]])
    vim.cmd('keeppatterns ' .. range .. [[s/\r//ge]])
end, { range = true, desc = 'Strip trailing whitespace' })

_command('CloseFloatingWindows', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { desc = 'Close floating windows' })

_command('Redir', function(opts)
    local lines = vim.split(vim.api.nvim_exec2(opts.args, { output = true }).output, '\n', { plain = true })
    vim.cmd(opts.bang and 'new' or 'vnew')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { bang = true, nargs = '+', complete = 'command', desc = 'Redirect command output to a vertical split (!: horizontal split)' })

_command('DiffChanges', function(opts)
    local cmd = 'w !git diff --no-index % -'
    if opts.bang then
        vim.cmd('Redir ' .. cmd)
        vim.bo.filetype = 'diff'
    else
        vim.cmd(cmd)
    end
end, { bang = true, desc = 'Show unsaved changes diff (!: vertical split)' })

-- Autocommands

_autocmd('FileType', {
    group = _augroup('make_ft_options', { clear = true }),
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end
})

_autocmd('FileType', {
    group = _augroup('terraform_ft_options', { clear = true }),
    pattern = { 'terraform' },
    callback = function()
        vim.opt_local.commentstring = '# %s'
    end
})

_autocmd('FileType', {
    group = _augroup('treesitter', { clear = true }),
    callback = function(args)
        local filename = vim.api.nvim_buf_get_name(args.buf)
        if #filename > 0 and vim.fn.getfsize(filename) > 1024 * 200 then
            vim.notify('treesitter: file is too large, treesitter highlighting is disabled', vim.log.levels.WARN)
            return
        end
        pcall(vim.treesitter.start)
    end,
})

_autocmd('FileType', {
    group = _augroup('help_keywordprg', { clear = true }),
    pattern = { 'vim', 'help' },
    callback = function()
        vim.opt_local.keywordprg = ':help'
    end
})

_autocmd('FileType', {
    group = _augroup('angular_commands', { clear = true }),
    pattern = { 'html', 'scss', 'typescript' },
    callback = function()
        local is_angular = vim.fn.findfile('angular.json', '.;') ~= ''
        if is_angular then
            _command('ETemplate', ':e %:p:r.html', {})
            _command('EComponent', ':e %:p:r.ts', {})
            _command('EStyle', ':e %:p:r.scss', {})
            _command('STemplate', ':sp %:p:r.html', {})
            _command('SComponent', ':sp %:p:r.ts', {})
            _command('SStyle', ':sp %:p:r.scss', {})
            _command('VTemplate', ':vs %:p:r.html', {})
            _command('VComponent', ':vs %:p:r.ts', {})
            _command('VStyle', ':vs %:p:r.scss', {})
        end
    end
})

_autocmd('FileType', {
    group = _augroup('go_commands', { clear = true }),
    pattern = 'go',
    callback = function()
        _command('ECode', ':e %:p:s?_test.go?.go?', {})
        _command('SCode', ':vs %:p:s?_test.go?.go?', {})
        _command('VCode', ':sp %:p:s?_test.go?.go?', {})
        _command('ETest', ':e %:p:r_test.go', {})
        _command('STest', ':sp %:p:r_test.go', {})
        _command('VTest', ':vs %:p:r_test."go"', {})
    end
})

_autocmd('TextYankPost', {
    group = _augroup('yank_highlight', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = false })
    end
})

_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    group = _augroup('auto_mkdir', { clear = true }),
    callback = function()
        local filename = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(filename, ':p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.system({ 'mkdir', '-vp', dir })
        end
    end
})

_autocmd('DiagnosticChanged', {
    group = _augroup('statusline_refresh', { clear = true }),
    callback = function()
        vim.o.statusline = vim.o.statusline
    end,
})

-- Filetypes

vim.filetype.add({
  pattern = {
    ['.*/ansible/.*.ya?ml'] = 'yaml.ansible'
  },
})
