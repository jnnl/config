return {
    -- Navigation
    { 'andymass/vim-matchup',
      event = 'BufReadPost',
      config = function()
          vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      end
    },
    { 'ggandor/leap.nvim',
      event = 'BufReadPost',
      config = function()
          require('leap').add_default_mappings()
      end
    },
    { 'junegunn/fzf', build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc' },
    { 'junegunn/fzf.vim',
      config = function()
          vim.keymap.set('n', '<Leader>,', '<cmd>Files<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>.', '<cmd>Buffers<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>-', '<cmd>Ripgrep<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>;', '<cmd>GitFiles<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>:', '<cmd>BCommits<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>_', '<cmd>GitRipgrep<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>\'', '<cmd>History<CR>', { silent = true })
          vim.keymap.set('n', '<Leader>*', '<cmd>Files ~<CR>', { silent = true })
          vim.cmd([[ command! -nargs=* Ripgrep
              \ call fzf#vim#grep(
              \ 'rg --column --line-number --no-heading --smart-case '
              \ . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
              \ . shellescape(<q-args>), 1,
              \ fzf#vim#with_preview({ 'options': '--delimiter : --nth 4..' }, 'right:50%:hidden', 'ctrl-/'))
          ]])
          vim.cmd([[ command! -bang -nargs=* GitRipgrep
              \ call fzf#vim#grep(
              \ 'rg --column --line-number --no-heading  --smart-case '
              \ . '--color=always --colors "path:fg:green" --colors "line:fg:yellow" '
              \ . shellescape(<q-args>), 1,
              \ fzf#vim#with_preview(
              \ { 'options': '--prompt="GitRg> " --delimiter : --nth 4..',
              \   'dir': system('git -C ' . expand('%:p:h') . ' rev-parse --show-toplevel 2>/dev/null')[:-2]
              \ }, 'right:50%:hidden', 'ctrl-/'),
              \ <bang>0)
          ]])
      end
    },
    { 'romainl/vim-cool', event = 'BufReadPost' },

    -- Manipulation
    { 'tommcdo/vim-lion',
      event = 'BufReadPost',
      config = function()
        vim.g.lion_squeeze_spaces = 1
      end
    },
    { 'tpope/vim-abolish' },
    { 'tpope/vim-commentary', event = 'BufReadPre' },
    { 'tpope/vim-surround', event = 'BufReadPre' },

    -- Colorschemes
    { 'jnnl/vim-tonight' },

    -- Language
    { 'ap/vim-css-color', ft = { 'css', 'scss' } },
    { 'hashivim/vim-terraform' },
    { 'leafgarland/typescript-vim' },
    { 'prettier/vim-prettier',
      ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'css', 'scss', 'html' },
      config = function()
          vim.keymap.set('n', '<Leader>p', '<cmd>Prettier<CR>', { silent = true })
          vim.g['prettier#autoformat_config_present'] = 1
          vim.g['prettier#autoformat_require_pragma'] = 0
      end
    },
    { 'ziglang/zig.vim', ft = { 'zig' } },

    -- LSP
    { 'neovim/nvim-lspconfig',
      event = 'BufReadPre',
      dependencies = {
          'folke/trouble.nvim'
      },
      config = function()
          local cmp_nvim_lsp = require('cmp_nvim_lsp')
          local lsp = require('lspconfig')

          local local_on_attach = function(_, bufnr)
              vim.diagnostic.config({ virtual_text = false })
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
              vim.cmd('command! Format execute "lua vim.lsp.buf.format({ async = true })"')

              local opts = { noremap = true, silent = true, buffer = bufnr }

              vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
              vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
              vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
              vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
              vim.keymap.set('n', 'gö', '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.WARN}})<CR>', opts)
              vim.keymap.set('n', 'gä', '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.WARN}})<CR>', opts)
              vim.keymap.set('n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
              vim.keymap.set('n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
              vim.keymap.set('n', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
              vim.keymap.set('x', '<leader><Space>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
              vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
              vim.keymap.set('n', '<leader>f', '<cmd>Format<CR>', opts)
              vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle workspace_diagnostics<CR>', opts)
              vim.keymap.set('n', '<leader>tr', '<cmd>TroubleToggle lsp_references<CR>', opts)
          end

          local capabilities = cmp_nvim_lsp.default_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          local servers = {
              'angularls',
              'bashls',
              'cssls',
              'gopls',
              'html',
              'pyright',
              'rust_analyzer',
              'tsserver'
          }

          for _, server in ipairs(servers) do
              if server == 'tsserver' then
                  require('typescript').setup({
                      server = {
                          capabilities = capabilities,
                          on_attach = function(client, bufnr)
                              local_on_attach(client, bufnr)
                          end
                      }
                  })
              elseif server == 'angularls' then
                  local lsPath = vim.fn.expand('$HOME/.local/lib/node_modules')
                  local cmd = { 'ngserver', '--stdio', '--tsProbeLocations', lsPath, '--ngProbeLocations', lsPath }
                  lsp.angularls.setup({
                      on_attach = on_attach,
                      capabilities = capabilities,
                      cmd = cmd,
                      filetypes = { 'html' },
                      on_new_config = function(new_config, new_root_dir)
                          new_config.cmd = cmd
                      end,
                  })
              else
                  lsp[server].setup({
                      capabilities = capabilities,
                      on_attach = local_on_attach,
                  })
              end
          end

      end
    },
    { 'folke/trouble.nvim',
      lazy = true,
      config = function()
          require('trouble').setup({
              icons = false,
              fold_open = 'v',
              fold_closed = '>',
              indent_lines = false,
              signs = {
                  error = '[error]',
                  warn = '[warn]',
                  hint = '[hint]',
                  information = '[info]',
                  other = '[other]',
              },
              use_diagnostic_signs = false
          })
      end
    },
    { 'jose-elias-alvarez/typescript.nvim' },

    -- Completion
    { 'hrsh7th/cmp-nvim-lsp', lazy = true },
    { 'hrsh7th/cmp-nvim-lua', lazy = true },
    { 'hrsh7th/cmp-path', lazy = true },
    { 'hrsh7th/cmp-vsnip', lazy = true },
    { 'hrsh7th/vim-vsnip',
      lazy = true,
      config = function()
          -- vim.g.vsnip_filetypes = { 'html' }
          vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets'
      end
    },
    { 'hrsh7th/vim-vsnip-integ',
      lazy = true,
      dependencies = { 'hrsh7th/vim-vsnip' },
    },
    { 'hrsh7th/nvim-cmp',
      event = 'BufReadPost',
      dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-vsnip',
          'hrsh7th/vim-vsnip',
          'hrsh7th/vim-vsnip-integ',
      },
      config = function()
          vim.opt.completeopt = 'menu,menuone,noselect'
	  local cmp = require('cmp')
          cmp.setup({
              snippet = {
                  expand = function(args)
                      vim.fn['vsnip#anonymous'](args.body)
                  end
              },
              mapping = {
                  ['<Up>'] = cmp.mapping.select_prev_item(),
                  ['<Down>'] = cmp.mapping.select_next_item(),
                  ['<C-k>'] = cmp.mapping.select_prev_item(),
                  ['<C-j>'] = cmp.mapping.select_next_item(),
                  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-u>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.close(),
                  ['<CR>'] = cmp.mapping.confirm {
                      behavior = cmp.ConfirmBehavior.Replace,
                      select = true,
                  },
                  ['<Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                          cmp.select_next_item()
                      elseif vim.fn['vsnip#available'](1) == 1 then
                          vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true),
                            '', true
                          )
                      else
                          fallback()
                      end
                  end, { 'i', 's' }),
                  ['<S-Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                          cmp.select_prev_item()
                      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                          vim.api.nvim_feedkeys(
                             vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true),
                             '', true
                          )
                      else
                          fallback()
                      end
                  end, { 'i', 's' }),
              },
              sources = {
                  { name = 'nvim_lsp' },
                  { name = 'nvim_lua' },
                  { name = 'vsnip' },
                  { name = 'path' },
              }
          })

      end
    },
    { 'ray-x/lsp_signature.nvim',
      config = function()
          require('lsp_signature').setup({
              bind = true,
              hint_enable = false,
              handler_opts = {
                  border = 'single',
              },
          })
      end
    },

    -- Miscellaneous
    { 'editorconfig/editorconfig-vim' },
    { 'folke/which-key.nvim',
      config = function()
          require('which-key').setup({})
      end
    },
    { 'mbbill/undotree',
      config = function()
        vim.keymap.set('n', '<Leader>u', '<cmd>UndotreeToggle<CR>', { silent = true })
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_HelpLine = 0
      end
    },
    { 'michaeljsmith/vim-indent-object' },
    { 'nvim-lua/plenary.nvim' },
    { 'romainl/vim-qf',
      config = function()
        vim.keymap.set('n', 'Ö', '<Plug>(qf_qf_previous)')
        vim.keymap.set('n', 'Ä', '<Plug>(qf_qf_next)')
      end
    },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-fugitive' },
    { 'whiteinge/diffconflicts' },
}
