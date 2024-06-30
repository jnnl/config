local pack_path = vim.fn.stdpath('data') .. '/site/'
local mini_path = pack_path .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim" | redraw')
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = pack_path } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    add('jnnl/tonight.nvim')
    vim.cmd.colorscheme('tonight')
end)

later(function() require('mini.clue').setup() end)
