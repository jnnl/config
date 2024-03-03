-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Plugins

local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
    vim.notify('lazy.nvim not found, installing...', vim.log.levels.INFO)
    vim.fn.system({
        'git', 'clone', 'https://github.com/folke/lazy.nvim.git',
        '--filter=blob:none', '--branch=stable',
        lazy_path
    })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_ok, lazy = pcall(require, 'lazy')
if lazy_ok then
    lazy.setup('plugins', {
        defaults = { lazy = false },
        change_detection = { enabled = false },
        lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
        performance = {
            rtp = {
                disabled_plugins = { 'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'rplugin', 'tohtml', 'tutor', },
            },
        },
    })
else
    vim.notify('failed to load lazy.nvim, plugins are disabled...', vim.log.levels.WARN)
end

-- Miscellaneous

vim.opt.fillchars:append('eob: ')
vim.opt.modeline = false
vim.opt.mouse = ''
vim.opt.number = true
vim.opt.shada = [[r/tmp/,r/private/,rfugitive:,rterm:,rzipfile:,!,'200,<50,s10,h]]
vim.opt.shortmess:append('cI')
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500

-- Statusline

function _G.statusline()
    local separator = '%#StatuslineNC# | %*'
    local line_count = '%3l/%L'
    local file_path = separator .. '%f'
    local buf_attrs = (function()
        local attrs = {}
        if #vim.api.nvim_buf_get_name(0) > 0 then
            table.insert(attrs, '%y%r%m ')
        end
        if vim.g['loaded_fugitive'] ~= nil and #vim.fn.FugitiveHead() > 0 then
            table.insert(attrs, string.format('(%s) ', vim.fn.FugitiveHead()))
        end
        if #vim.diagnostic.get(0) > 0 then
            local diagnostic_levels = {
                { symbol = 'H', severity = vim.diagnostic.severity.HINT },
                { symbol = 'I', severity = vim.diagnostic.severity.INFO },
                { symbol = 'W', severity = vim.diagnostic.severity.WARN },
                { symbol = 'E', severity = vim.diagnostic.severity.ERROR },
            }
            for _, level in ipairs(diagnostic_levels) do
                local diagnostic_count = #vim.diagnostic.get(0, { severity = level.severity })
                if diagnostic_count > 0 then
                    table.insert(attrs, string.format('%s:%s ', level.symbol, diagnostic_count))
                end
            end
        end
        if #attrs > 0 then
            table.insert(attrs, 1, separator)
        end
        return table.concat(attrs)
    end)()

    return table.concat({
        line_count,
        file_path,
        buf_attrs,
    })
end

vim.opt.statusline = '%{%v:lua.statusline()%}'

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

_G.keymap = vim.keymap.set

keymap('n', '<BS>', '<C-^>')
keymap('n', '\'', '`')
keymap('n', '_', ',')
keymap('n', 'öö', '<C-o>', { desc = 'Go to previous jump list position' })
keymap('n', 'ää', '<C-i>', { desc = 'Go to next jump list position' })
keymap('n', 'öb', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
keymap('n', 'äb', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
keymap('n', 'öt', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
keymap('n', 'ät', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
keymap('n', 'ög', function()
    vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = 'Go to previous WARN+ diagnostic' })
keymap('n', 'äg', function()
    vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = 'Go to next WARN+ diagnostic' })
keymap('n', 'öG', function()
    vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.HINT } })
end, { desc = 'Go to next HINT+ diagnostic' })
keymap('n', 'äG', function()
    vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.HINT } })
end, { desc = 'Go to next HINT+ diagnostic' })
keymap('n', '<C-Space>', vim.diagnostic.open_float)

keymap('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
keymap('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
keymap({ 'n', 'x' }, '<C-j>', '}')
keymap({ 'n', 'x' }, '<C-k>', '{')
keymap('c', '<C-j>', '<Down>')
keymap('c', '<C-k>', '<Up>')
keymap('n', '<C-w>.', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local longest_line_length = math.max(unpack(vim.tbl_map(function(line) return #line end, lines))) + 5
    vim.cmd('vertical resize ' .. longest_line_length)
end, { desc = 'Fit window width to content' })

keymap('n', 'Q', '@q')
keymap('x', 'Q', ':normal @q<CR>')
keymap('x', '@', ':normal @')
keymap('x', '.', ':normal .<CR>')

keymap({'n', 'x'}, '<Leader>y', '"+y', { desc = 'Copy text to system clipboard' })
keymap({'n', 'x'}, '<Leader>Y', '"+Y', { desc = 'Copy text from cursor to end of line to system clipboard' })
keymap({'n', 'x'}, '<Leader>p', function()
    vim.cmd('normal "+p')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard after the cursor' })
keymap({'n', 'x'}, '<Leader>P', function()
    vim.cmd('normal "+P')
    vim.cmd([['[,']Rstrip]])
end, { desc = 'Paste text from system clipboard before the cursor' })

keymap('n', '<Leader>q', '<cmd>CloseFloatingWindows<CR>', { desc = 'Close floating windows' })
keymap('n', '<Leader>s', function()
    return ':%s/' .. vim.fn.expand('<cword>') .. '/'
end, { expr = true, desc = 'Substitute word under cursor' })

-- Commands

_G.command = vim.api.nvim_create_user_command

command('NonAscii', '/[^\\x00-\\x7F]', { desc = 'Search for non-ASCII characters' })
command('Unansify', function(opts)
    local range = '%'
    if opts.range ~= 0 then range = opts.line1 .. ',' .. opts.line2 end
    vim.cmd('keeppatterns ' .. range .. 's/\\%x1b\\[[0-9;]*[a-zA-Z]//ge')
end, { range = true, desc = 'Remove ANSI escape codes' })

command('Unblankify', function(opts)
    local range = '%'
    if opts.range ~= 0 then range = opts.line1 .. ',' .. opts.line2 end
    vim.cmd(range .. 'g/^\\s*$/d')
end, { range = true, desc = 'Remove blank lines' })

command('Lstrip', function(opts)
    local range = '%'
    if opts.range ~= 0 then range = opts.line1 .. ',' .. opts.line2 end
    vim.cmd('keeppatterns ' .. range .. 's/^\\s\\+//e')
end, { range = true, desc = 'Strip leading whitespace' })

command('Rstrip', function(opts)
    local range = '%'
    if opts.range ~= 0 then range = opts.line1 .. ',' .. opts.line2 end
    vim.cmd('keeppatterns ' .. range .. 's/\\s\\+$//e')
    vim.cmd('keeppatterns ' .. range .. 's/\r//ge')
end, { range = true, desc = 'Strip trailing whitespace' })

command('CloseFloatingWindows', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { desc = 'Close floating windows' })

command('Redir', function(context)
    local lines = vim.split(vim.api.nvim_exec2(context.args, { output = true }).output, '\n', { plain = true })
    vim.cmd('vnew')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { nargs = '+', complete = 'command', desc = 'Redirect command output to a new vertical split' })

command('DiffChanges', function(context)
    local cmd = 'w !git diff --no-index % -'
    if context.bang then
        vim.cmd('Redir ' .. cmd)
        vim.bo.filetype = 'diff'
    else
        vim.cmd(cmd)
    end
end, { bang = true, desc = 'Show unsaved changes diff. Opens diff in a vertical split when invoked with a bang.' })

-- Autocommands

_G.autocmd = vim.api.nvim_create_autocmd
_G.augroup = vim.api.nvim_create_augroup

autocmd('FileType', {
    group = augroup('make_ft_options', { clear = true }),
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end
})

autocmd('FileType', {
    group = augroup('treesitter', { clear = true }),
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

autocmd('FileType', {
    group = augroup('help_keywordprg', { clear = true }),
    pattern = { 'vim', 'help' },
    callback = function()
        vim.opt_local.keywordprg = ':help'
    end
})

autocmd('FileType', {
    group = augroup('angular_commands', { clear = true }),
    pattern = { 'html', 'scss', 'typescript' },
    callback = function()
        local is_angular = vim.fn.findfile('angular.json', '.;') ~= ''
        if is_angular then
            command('ETemplate', ':e %:p:r.html', {})
            command('EComponent', ':e %:p:r.ts', {})
            command('EStyle', ':e %:p:r.scss', {})
            command('STemplate', ':sp %:p:r.html', {})
            command('SComponent', ':sp %:p:r.ts', {})
            command('SStyle', ':sp %:p:r.scss', {})
            command('VTemplate', ':vs %:p:r.html', {})
            command('VComponent', ':vs %:p:r.ts', {})
            command('VStyle', ':vs %:p:r.scss', {})
        end
    end
})

autocmd('FileType', {
    group = augroup('go_commands', { clear = true }),
    pattern = 'go',
    callback = function()
        command('ECode', ':e %:p:s?_test.go?.go?', {})
        command('SCode', ':vs %:p:s?_test.go?.go?', {})
        command('VCode', ':sp %:p:s?_test.go?.go?', {})
        command('ETest', ':e %:p:r_test.go', {})
        command('STest', ':sp %:p:r_test.go', {})
        command('VTest', ':vs %:p:r_test.go', {})
    end
})

autocmd('TextYankPost', {
    group = augroup('yank_highlight', { clear = true }),
    callback = function()
        require('vim.highlight').on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = false })
    end
})

autocmd({ 'BufWritePre', 'FileWritePre' }, {
    group = augroup('auto_mkdir', { clear = true }),
    callback = function()
        local filename = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(filename, ':p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.system({ 'mkdir', '-vp', dir })
        end
    end
})

autocmd('DiagnosticChanged', {
    group = augroup('statusline_refresh', { clear = true }),
    callback = function()
        vim.o.statusline = vim.o.statusline
    end,
})

vim.on_key(function(key)
    if vim.fn.mode() == 'n' then
        local hls_keys = { '<CR>', '*', '#', '/', '?', 'n', 'N', }
        local is_hls_key = vim.tbl_contains(hls_keys, vim.fn.keytrans(key))
        if is_hls_key ~= vim.opt.hlsearch then
            vim.opt.hlsearch = is_hls_key
        end
    end
end, vim.api.nvim_create_namespace('hlsearch_autoclear'))
