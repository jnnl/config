---@diagnostic disable: lowercase-global
-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','

---@param mode string|string[]
---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
---@see vim.keymap.set
_map = function(mode, lhs, rhs, opts)
    ---@type string[]
    local lhs_tbl = type(lhs) == 'table' and lhs or { lhs }
    for _, lhs_val in ipairs(lhs_tbl) do
        vim.keymap.set(mode, lhs_val, rhs, opts)
    end
end
---@param name string
---@param command string|function
---@param opts? vim.api.keyset.user_command
_cmd = function(name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts or {})
end
---@param name string
---@param opts? vim.api.keyset.create_augroup
_augroup = function(name, opts)
    return vim.api.nvim_create_augroup(name, opts or {})
end
_autocmd = vim.api.nvim_create_autocmd
_dx = vim.diagnostic
_make_opts_fn = function(defaults)
    return function(opts)
        return vim.tbl_deep_extend('force', defaults or {}, opts or {})
    end
end

-- Plugins

local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
    vim.notify('installing lazy.nvim...')
    vim.fn.system({
        'git', 'clone', 'https://github.com/folke/lazy.nvim.git',
        '--filter=blob:none', '--branch=stable',
        lazy_path
    })
end

vim.opt.rtp:prepend(lazy_path)
require('lazy').setup('plugins', {
    change_detection = { enabled = false },
    checker = { check_pinned = true },
    defaults = { lazy = false },
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
    performance = {
        rtp = {
            disabled_plugins = { 'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'rplugin', 'tohtml', 'tutor' },
        },
    },
    pkg = { enabled = false },
    rocks = { enabled = false },
})

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

_statusline = function()
    local separator = ' %#StatuslineNC#::%* '
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
        if _dx.is_enabled() then
            local dx_counts = _dx.count(0)
            if #dx_counts > 0 then
                local dx_start_pos = #attrs + 1
                for severity, count in pairs(dx_counts) do
                    local symbol = _dx.severity[severity]:sub(1, 1)
                    table.insert(attrs, dx_start_pos, string.format('%s:%s ', symbol, count))
                end
            end
        end
        if #attrs > 0 then
            table.insert(attrs, 1, separator)
            buf_attrs = table.concat(attrs)
        end
    end
    return table.concat({ line_count, file_path, buf_attrs })
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

_map('n', '<BS>', '<C-^>')
_map('n', '\'', '`')
_map('n', '<Esc>', '<cmd>nohlsearch<CR>')
_map('n', { 'Ö', 'öö' }, '<C-o>', { desc = 'Go to previous jump list position' })
_map('n', { 'Ä', 'ää' }, '<C-i>', { desc = 'Go to next jump list position' })
_map('n', 'öb', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
_map('n', 'äb', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
_map('n', 'öt', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
_map('n', 'ät', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
_map('n', '<C-Space>', _dx.open_float)
_map('n', 'öd', function()
    _dx.jump({ count = -1, severity = { min = _dx.severity.WARN } })
end, { desc = 'Go to previous WARN+ diagnostic' })
_map('n', 'äd', function()
    _dx.jump({ count = 1, severity = { min = _dx.severity.WARN } })
end, { desc = 'Go to next WARN+ diagnostic' })
_map('n', 'öD', function()
    _dx.jump({ count = -1, severity = { min = _dx.severity.HINT } })
end, { desc = 'Go to previous HINT+ diagnostic' })
_map('n', 'äD', function()
    _dx.jump({ count = 1, severity = { min = _dx.severity.HINT } })
end, { desc = 'Go to next HINT+ diagnostic' })

_map('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
_map('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
_map({ 'n', 'x' }, '<C-j>', '}')
_map({ 'n', 'x' }, '<C-k>', '{')
_map('c', '<C-j>', '<Down>')
_map('c', '<C-k>', '<Up>')
_map('ca', 'W', 'w')

_map('n', '<C-w>.', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local longest_line_length = math.max(unpack(vim.tbl_map(function(line) return #line end, lines)))
    vim.cmd('vertical resize ' .. longest_line_length + 8)
end, { desc = 'Fit window width to content' })
_map('n', '<C-w>:', function()
    vim.cmd('resize' .. vim.fn.line('$'))
end, { desc = 'Fit window height to content' })

_map('n', '§', '@')
_map('n', '§§', '@@')
_map('n', 'Q', '@q')
_map('x', 'Q', ':normal @q<CR>')
_map('x', { '§', '@' }, ':normal @')
_map('x', '.', ':normal .<CR>')

_map({ 'n', 'x' }, '<Leader>y', '"+y', { desc = 'Copy text to system clipboard' })
_map({ 'n', 'x' }, '<Leader>Y', '"+Y', { desc = 'Copy text from cursor to end of line to system clipboard' })
_map({ 'n', 'x' }, '<Leader>p', function()
    vim.cmd('normal "+p')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard after the cursor' })
_map({ 'n', 'x' }, '<Leader>P', function()
    vim.cmd('normal "+P')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard before the cursor' })

_map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
_map('n', '<Leader>q', '<cmd>CloseFloatingWindows<CR>', { desc = 'Close floating windows' })
_map('n', '<Leader>s', function()
    return ':%s/' .. vim.fn.expand('<cword>') .. '/'
end, { expr = true, desc = 'Substitute word under cursor' })

_map('n', '<Leader>td', function()
    _dx.enable(not _dx.is_enabled())
    vim.notify('diagnostics ' .. (_dx.is_enabled() and 'enabled' or 'disabled'))
end, { desc = 'Toggle diagnostics' })

-- Commands

_cmd('NonAscii', '/[^\\x00-\\x7F]', { desc = 'Search for non-ASCII characters' })
_cmd('Unansify', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/\%x1b\[[0-9;]*[a-zA-Z]//ge]])
end, { range = true, desc = 'Remove ANSI escape codes' })

_cmd('Unblankify', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd(range .. [[g/^\s*$/d]])
end, { range = true, desc = 'Remove blank lines' })

_cmd('Lstrip', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/^\s\+//e]])
end, { range = true, desc = 'Strip leading whitespace' })

_cmd('Rstrip', function(opts)
    local range = string.format('%s,%s', opts.line1, opts.line2)
    vim.cmd('keeppatterns ' .. range .. [[s/\s\+$//e]])
    vim.cmd('keeppatterns ' .. range .. [[s/\r//ge]])
end, { range = true, desc = 'Strip trailing whitespace' })

_cmd('CloseFloatingWindows', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { desc = 'Close floating windows' })

_cmd('Redir', function(opts)
    local lines = vim.split(vim.api.nvim_exec2(opts.args, { output = true }).output, '\n', { plain = true })
    vim.cmd(opts.bang and 'new' or 'vnew')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { bang = true, nargs = '+', complete = 'command', desc = 'Redirect command output to a vertical split (!: horizontal split)' })

_cmd('DiffChanges', function(opts)
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
    group = _augroup('make_ft_opts'),
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end
})

_autocmd('FileType', {
    group = _augroup('terraform_ft_opts'),
    pattern = { 'terraform' },
    callback = function()
        vim.opt_local.commentstring = '# %s'
    end
})

_autocmd('FileType', {
    group = _augroup('treesitter'),
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
    group = _augroup('help_keywordprg'),
    pattern = { 'vim', 'help' },
    callback = function()
        vim.opt_local.keywordprg = ':help'
    end
})

_autocmd('FileType', {
    group = _augroup('angular_cmds'),
    pattern = { 'html', 'scss', 'typescript' },
    callback = function()
        local is_angular = vim.fn.findfile('angular.json', '.;') ~= ''
        if is_angular then
            _cmd('ETemplate', ':e %:p:r.html')
            _cmd('EComponent', ':e %:p:r.ts')
            _cmd('EStyle', ':e %:p:r.scss')
            _cmd('STemplate', ':sp %:p:r.html')
            _cmd('SComponent', ':sp %:p:r.ts')
            _cmd('SStyle', ':sp %:p:r.scss')
            _cmd('VTemplate', ':vs %:p:r.html')
            _cmd('VComponent', ':vs %:p:r.ts')
            _cmd('VStyle', ':vs %:p:r.scss')
        end
    end
})

_autocmd('FileType', {
    group = _augroup('go_cmds'),
    pattern = 'go',
    callback = function()
        _cmd('ECode', ':e %:p:s?_test.go?.go?')
        _cmd('SCode', ':vs %:p:s?_test.go?.go?')
        _cmd('VCode', ':sp %:p:s?_test.go?.go?')
        _cmd('ETest', ':e %:p:r_test.go')
        _cmd('STest', ':sp %:p:r_test.go')
        _cmd('VTest', ':vs %:p:r_test."go"')
    end
})

_autocmd('TextYankPost', {
    group = _augroup('yank_highlight'),
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = false })
    end
})

_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    group = _augroup('auto_mkdir'),
    callback = function()
        local filename = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(filename, ':p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.system({ 'mkdir', '-vp', dir })
        end
    end
})

_autocmd('DiagnosticChanged', {
    group = _augroup('statusline_refresh'),
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
