-- init.lua

-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','


-- Plugins

local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
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
        lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "matchit",
                    "matchparen",
                    "netrwPlugin",
                    "rplugin",
                    "tohtml",
                    "tutor",
                },
            },
        },
    })
else
    vim.notify('failed to load lazy.nvim, plugins are disabled...', vim.log.levels.WARN)
end


-- General

vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamed'
vim.opt.hidden = true
vim.opt.joinspaces = false
vim.opt.modeline = false
vim.opt.mouse = ''
vim.opt.shortmess:append('c')
vim.opt.showcmd = true
vim.opt.timeoutlen = 500


-- Statusline

vim.opt.laststatus = 2
vim.opt.statusline = [[%f %y%m%=%l/%L]]


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
    vim.cmd.colorscheme('desert')
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
vim.keymap.set('n', 'öj', '<C-o>', { desc = 'Go to previous jump list position' })
vim.keymap.set('n', 'äj', '<C-i>', { desc = 'Go to next jump list position' })
vim.keymap.set('n', 'öb', '<cmd>bprevious<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', 'äb', '<cmd>bnext<CR>', { desc = 'Go to next buffer' })

vim.keymap.set('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
vim.keymap.set('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
vim.keymap.set({ 'n', 'x' }, '<C-j>', '}')
vim.keymap.set({ 'n', 'x' }, '<C-k>', '{')
vim.keymap.set('c', '<C-j>', '<Down>')
vim.keymap.set('c', '<C-k>', '<Up>')

vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('x', 'Q', '<cmd>normal @q<CR>')
vim.keymap.set('x', '@', '<cmd>normal @')
vim.keymap.set('x', '.', '<cmd>normal .<CR>')

vim.keymap.set('n', '<Up>', function() move_split('up', '1') end)
vim.keymap.set('n', '<Down>', function() move_split('down', '1') end)
vim.keymap.set('n', '<Left>', function() move_split('left', '1') end)
vim.keymap.set('n', '<Right>', function() move_split('right', '1') end)
vim.keymap.set('n', '<C-Up>', function() move_split('up', '10') end)
vim.keymap.set('n', '<C-Down>', function() move_split('down', '10') end)
vim.keymap.set('n', '<C-Left>', function() move_split('left', '10') end)
vim.keymap.set('n', '<C-Right>', function() move_split('right', '10') end)

vim.keymap.set('n', '<Leader>q', '<cmd>CloseFloatingWindows<CR>', { desc = 'Close floating windows' })
vim.keymap.set('n', '<Leader>s', function()
    return ':%s/' .. vim.call('expand', '<cword>') .. '/'
end, { expr = true, desc = 'Substitute word under cursor' })


-- Commands

vim.api.nvim_create_user_command('NonAscii', '/[^\\x00-\\x7F]', { bang = true })
vim.api.nvim_create_user_command('Unansify', ':%s/\\%x1b\\[[0-9;]*[a-zA-Z]//ge', { bang = true })
vim.api.nvim_create_user_command('Rstrip', function()
    vim.cmd(':%s/\\s\\+$//e')
    vim.cmd(':%s/\r//ge')
end, { bang = true })
vim.api.nvim_create_user_command('CloseFloatingWindows', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { bang = true })

-- Autocommands

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'vim', 'help' },
    callback = function()
        vim.opt_local.keywordprg = ':help'
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'scss', 'typescript' },
    callback = function()
        local create_cmd = function(name, command)
            vim.api.nvim_create_user_command(name, command, { bang = true })
        end
        local is_angular = vim.fn.findfile('angular.json', '.;') ~= ''
        if is_angular then
            create_cmd('ET', ':e %:p:r.html')
            create_cmd('EC', ':e %:p:r.ts')
            create_cmd('ES', ':e %:p:r.scss')
            create_cmd('ST', ':sp %:p:r.html')
            create_cmd('SC', ':sp %:p:r.ts')
            create_cmd('SS', ':sp %:p:r.scss')
            create_cmd('VT', ':vs %:p:r.html')
            create_cmd('VC', ':vs %:p:r.ts')
            create_cmd('VS', ':vs %:p:r.scss')
        end
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
        local create_cmd = function(name, command)
            vim.api.nvim_create_user_command(name, command, { bang = true })
        end
        create_cmd('EC', ':e %:p:s?_test.go?.go?')
        create_cmd('SC', ':vs %:p:s?_test.go?.go?')
        create_cmd('VC', ':sp %:p:s?_test.go?.go?')
        create_cmd('ET', ':e %:p:r_test.go')
        create_cmd('ST', ':sp %:p:r_test.go')
        create_cmd('VT', ':vs %:p:r_test.go')
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        require('vim.highlight').on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = false })
    end
})

vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.system({ 'mkdir', '-vp', dir })
        end
    end
})


-- Functions

function move_split(direction, amount)
    local op = '+'
    local curr_win = vim.fn.winnr()
    if direction == 'left' or direction == 'right' then
        local left_win = vim.fn.winnr('h')
        local right_win = vim.fn.winnr('l')
        if left_win == right_win then
            return
        end
        if curr_win == right_win then
            if direction == 'right' then op = '-' end
        else
            if direction == 'left' then op = '-' end
        end
        vim.cmd('vertical resize ' .. op .. amount)
    elseif direction == 'up' or direction == 'down' then
        local up_win = vim.fn.winnr('k')
        local down_win = vim.fn.winnr('j')
        if up_win == down_win then
	    return
        end
        if curr_win == up_win then
            if direction == 'up' then op = '-' end
        else
            if direction == 'down' then op = '-' end
        end
        vim.cmd('resize ' .. op .. amount)
    end
end
