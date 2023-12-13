-- init.lua

-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Plugins

local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
    vim.notify('lazy.nvim not found, installing...', vim.log.levels.INFO)
    vim.fn.system({ 'git', 'clone', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazy_path })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_ok, lazy = pcall(require, 'lazy')
if lazy_ok then
    lazy.setup('plugins', {
        defaults = {
            lazy = false,
        },
        change_detection = {
            enabled = false,
        },
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

-- General

vim.opt.backspace = 'indent,eol,start'
vim.opt.hidden = true
vim.opt.joinspaces = false
vim.opt.modeline = false
vim.opt.mouse = ''
vim.opt.shortmess:append('c')
vim.opt.showcmd = true
vim.opt.timeoutlen = 500
vim.opt.fillchars:append('eob: ')
vim.opt.shada:prepend('r/tmp/,r/private/,rfugitive:,rterm:,rzipfile:')

-- Statusline

vim.opt.laststatus = 2
vim.opt.statusline = [[%f %y%m %l/%L]]

-- Indentation

vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1

-- Search

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Splits

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Styles

vim.opt.number = true
if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end

local colorscheme_ok, _ = pcall(vim.cmd.colorscheme, 'tonight')
if not colorscheme_ok then
    vim.notify('failed to load default colorscheme, using fallback...')
    vim.cmd.colorscheme('default')
end

-- Undo

vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
vim.opt.undofile = true

-- Keymaps

vim.keymap.set('n', '<BS>', '<C-^>')
vim.keymap.set('n', '\'', '`')
vim.keymap.set('n', '_', ',')
vim.keymap.set('n', 'öö', '<C-o>', { desc = 'Go to previous jump list position' })
vim.keymap.set('n', 'ää', '<C-i>', { desc = 'Go to next jump list position' })
vim.keymap.set('n', 'öb', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', 'äb', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', 'öt', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', 'ät', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })

vim.keymap.set('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
vim.keymap.set('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
vim.keymap.set({ 'n', 'x' }, '<C-j>', '}')
vim.keymap.set({ 'n', 'x' }, '<C-k>', '{')
vim.keymap.set('c', '<C-j>', '<Down>')
vim.keymap.set('c', '<C-k>', '<Up>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-w>.', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local longest_line_length = math.max(unpack(vim.tbl_map(function(line) return #line end, lines))) + 5
    vim.cmd('vertical resize ' .. longest_line_length)
end, { desc = 'Fit window width to content' })

vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('x', 'Q', ':normal @q<CR>')
vim.keymap.set('x', '@', ':normal @')
vim.keymap.set('x', '.', ':normal .<CR>')

vim.keymap.set({'n', 'x'}, '<Leader>y', '"+y', { desc = 'Copy text to system clipboard' })
vim.keymap.set({'n', 'x'}, '<Leader>Y', '"+Y', { desc = 'Copy text from cursor to end of line to system clipboard' })
vim.keymap.set({'n', 'x'}, '<Leader>p', function()
    vim.cmd('normal "+p')
    vim.cmd([['[,']s/\r//e]])
end, { desc = 'Paste text from system clipboard after the cursor' })
vim.keymap.set({'n', 'x'}, '<Leader>P', function()
    vim.cmd('normal "+P')
    vim.cmd([['[,']s/\r//e]])
end, { desc = 'Paste text from system clipboard before the cursor' })

vim.keymap.set('n', '<Leader>q', '<cmd>CloseFloatingWindows<CR>', { desc = 'Close floating windows' })
vim.keymap.set('n', '<Leader>s', function()
    return ':%s/' .. vim.fn.expand('<cword>') .. '/'
end, { expr = true, desc = 'Substitute word under cursor' })

-- Commands

vim.api.nvim_create_user_command('NonAscii', '/[^\\x00-\\x7F]', { bang = true, desc = 'Search for non-ASCII characters' })
vim.api.nvim_create_user_command('Unansify', ':%s/\\%x1b\\[[0-9;]*[a-zA-Z]//ge', { bang = true, desc = 'Remove ANSI escape codes' })
vim.api.nvim_create_user_command('Unblankify', ':g/^\\s*$/d', { bang = true, desc = 'Remove blank lines' })
vim.api.nvim_create_user_command('Rstrip', function()
    vim.cmd(':%s/\\s\\+$//e')
    vim.cmd(':%s/\r//ge')
end, { bang = true, desc = 'Strip trailing whitespace' })
vim.api.nvim_create_user_command('CloseFloatingWindows', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { bang = true, desc = 'Close floating windows' })
vim.api.nvim_create_user_command('Redir', function(context)
  local lines = vim.split(vim.api.nvim_exec2(context.args, { output = true }).output, '\n', { plain = true })
  vim.cmd('vnew')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command', desc = 'Redirect command output to a new vertical split' })
vim.api.nvim_create_user_command('DiffChanges', function(context)
    local cmd = ':w !git diff --no-index % -'
    if context.bang then
        vim.cmd(':Redir ' .. cmd)
        vim.bo.filetype = 'diff'
    else
        vim.cmd(cmd)
    end
end, { bang = true, desc = 'Show unsaved changes diff. Opens diff in a vertical split when invoked with a bang.' })

-- Autocommands

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('make_ft_options', { clear = true }),
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('help_keywordprg', { clear = true }),
    pattern = { 'vim', 'help' },
    callback = function()
        vim.opt_local.keywordprg = ':help'
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('angular_commands', { clear = true }),
    pattern = { 'html', 'scss', 'typescript' },
    callback = function()
        local create_cmd = function(name, command)
            vim.api.nvim_create_user_command(name, command, { bang = true })
        end
        local is_angular = vim.fn.findfile('angular.json', '.;') ~= ''
        if is_angular then
            create_cmd('ETemplate', ':e %:p:r.html')
            create_cmd('EComponent', ':e %:p:r.ts')
            create_cmd('EStyle', ':e %:p:r.scss')
            create_cmd('STemplate', ':sp %:p:r.html')
            create_cmd('SComponent', ':sp %:p:r.ts')
            create_cmd('SStyle', ':sp %:p:r.scss')
            create_cmd('VTemplate', ':vs %:p:r.html')
            create_cmd('VComponent', ':vs %:p:r.ts')
            create_cmd('VStyle', ':vs %:p:r.scss')
        end
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('go_commands', { clear = true }),
    pattern = 'go',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
        local create_cmd = function(name, command)
            vim.api.nvim_create_user_command(name, command, { bang = true })
        end
        create_cmd('ECode', ':e %:p:s?_test.go?.go?')
        create_cmd('SCode', ':vs %:p:s?_test.go?.go?')
        create_cmd('VCode', ':sp %:p:s?_test.go?.go?')
        create_cmd('ETest', ':e %:p:r_test.go')
        create_cmd('STest', ':sp %:p:r_test.go')
        create_cmd('VTest', ':vs %:p:r_test.go')
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('yank_highlight', { clear = true }),
    callback = function()
        require('vim.highlight').on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = false })
    end
})

vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    group = vim.api.nvim_create_augroup('auto_mkdir', { clear = true }),
    callback = function()
        local filename = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(filename, ':p:h')
        if vim.fn.isdirectory(dir) == 0 and not string.find(dir, '^oil:/') then
            vim.fn.system({ 'mkdir', '-vp', dir })
        end
    end
})

vim.on_key(function(key)
    if vim.fn.mode() == 'n' then
        local hls_keys = { '<CR>', '*', '#', '/', '?', 'n', 'N', }
        local is_hls_key = vim.tbl_contains(hls_keys, vim.fn.keytrans(key))
        if is_hls_key ~= vim.opt.hlsearch then
            vim.opt.hlsearch = is_hls_key
        end
    end
end, vim.api.nvim_create_namespace 'hlsearch_autoclear')
