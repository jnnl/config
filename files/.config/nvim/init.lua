-- init.lua

-- Globals

vim.g.mapleader = ','
vim.g.maplocalleader = ','


-- Plugins

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.notify('lazy.nvim not found, installing...', vim.log.levels.INFO)
    vim.fn.system({ 'git', 'clone', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
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

local ok, _ = pcall(vim.cmd.colorscheme, 'tonight')
if not ok then
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
vim.keymap.set('n', 'ö', '<C-o>')
vim.keymap.set('n', 'ä', '<C-i>')

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

vim.keymap.set('n', '<Leader>s', function()
    return ':%s/' .. vim.call('expand', '<cword>') .. '/'
end, { expr = true })


-- Commands

vim.api.nvim_create_user_command('Rstrip', ':%s/\\s\\+$//e', { bang = true })
vim.api.nvim_create_user_command('Unansify', ':%s/\\%x1b\\[[0-9;]*[a-zA-Z]//ge', { bang = true })
vim.api.nvim_create_user_command('NonAscii', '/[^\\x00-\\x7F]', { bang = true })

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
    pattern = { 'css', 'scss', 'html', 'typescript' },
    callback = function()
        local create_cmd = function(name, command)
            vim.api.nvim_create_user_command(name, command, { bang = true })
        end
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
        require('vim.highlight').on_yank({ higroup = 'IncSearch', timeout = 1000, on_visual = false })
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
