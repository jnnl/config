return {
    -- Navigation
    { 'andymass/vim-matchup',
      event = 'BufReadPost',
      config = function()
          vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      end
    },
    { 'ggandor/leap.nvim',
      config = function()
          require('leap').add_default_mappings()
      end
    },
    { 'romainl/vim-cool', event = 'BufReadPost' },
    { 'junegunn/fzf', build = './install --xdg --key-bindings --completion --no-fish --no-zsh --no-update-rc' },
    { 'ibhagwan/fzf-lua',
      config = function()
          local fzf = require('fzf-lua')
          local actions = require('fzf-lua.actions')
          fzf.setup({
            'default',
            actions = {
                files = {
                    ['default'] = actions.file_edit_or_qf,
                    ['alt-q'] = actions.file_sel_to_qf,
                    ['alt-l'] = actions.file_sel_to_ll,
                    ['ctrl-s'] = actions.file_split,
                    ['ctrl-t'] = actions.file_tabedit,
                    ['ctrl-v'] = actions.file_vsplit,
                    ['ctrl-o'] = function(selected)
                        local is_mac = vim.fn.has('mac')
                        local is_unix = vim.fn.has('unix')

                        if is_mac ~= 1 and is_unix ~= 1 then
                            vim.notify('file open not supported on this platform', vim.log.levels.ERROR)
                            return
                        end

                        for _, item in ipairs(selected) do
                            local selected_item = string.gsub(item, '\t+', '')
                            if is_mac == 1 then
                                vim.fn.jobstart({ 'open', selected_item }, { detach = true })
                            elseif is_unix == 1 then
                                vim.fn.jobstart({ 'xdg-open', selected_item }, { detach = true })
                            end
                        end
                    end,
                },
                buffers = {
                    ['default'] = actions.buf_edit,
                    ['ctrl-s'] = actions.buf_split,
                    ['ctrl-v'] = actions.buf_vsplit,
                    ['ctrl-t'] = actions.buf_tabedit,
                },
            },
            keymap = {
                builtin = {
                    ['§'] = 'toggle-preview',
                    ['½'] = 'toggle-help',
                },
                fzf = {
                    ['§'] = 'toggle-preview',
                    ['ctrl-z'] = 'abort',
                    ['ctrl-u'] = 'unix-line-discard',
                    ['ctrl-f'] = 'half-page-down',
                    ['ctrl-b'] = 'half-page-up',
                    ['ctrl-a'] = 'beginning-of-line',
                    ['ctrl-e'] = 'end-of-line',
                    ['alt-a'] = 'toggle-all',
                    ['f3'] = 'toggle-preview-wrap',
                    ['f4'] = 'toggle-preview',
                },
            },
            previewers = {
                bat = {
                    args = '--style=numbers,changes,header-filename,rule --color always --line-range=:1000',
                },
                builtin = {
                    extensions = {
                        ['gif'] = { 'chafa' },
                        ['png'] = { 'chafa' },
                        ['jpg'] = { 'chafa' },
                        ['jpeg'] = { 'chafa' },
                        ['svg'] = { 'chafa' },
                    },
                },
            },
            grep = {
                rg_opts = '--column --line-number --no-heading --hidden --smart-case --max-columns=4096 ' ..
                          '--color=always --colors "path:fg:green" --colors "line:fg:yellow"',
                rg_glob = true,
            },
          })
          vim.keymap.set('n', '<Leader>ff', fzf.builtin, { desc = 'Show fzf-lua builtins' })
          vim.keymap.set('n', '<Leader>fr', fzf.resume, { desc = 'Resume most recent fzf-lua search' })
          vim.keymap.set('n', '<C-f>', fzf.grep_cWORD, { desc = 'Find text matching word under cursor' })
          vim.keymap.set('x', '<C-f>', fzf.grep_visual, { desc = 'Find text matching visual selection' })
          vim.keymap.set('n', '<Leader>,', fzf.files, { desc = 'Find files' })
          vim.keymap.set('n', '<Leader>.', fzf.buffers, { desc = 'Find open buffers' })
          vim.keymap.set('n', '<Leader>-', function()
              fzf.grep_project({ fzf_opts = { ['--nth'] = '2..', ['--delimiter'] = ':' } })
          end, { desc = 'Find text' })
          vim.keymap.set('n', '<Leader>;', fzf.git_files, { desc = 'Find files in git repo' })
          vim.keymap.set('n', '<Leader>:', fzf.git_bcommits, { desc = 'Find commits affecting current file' })
          vim.keymap.set('n', '<Leader>_', function()
              fzf.grep_project({ cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h') })
          end, { desc = 'Find text in git repo' })
          vim.keymap.set('n', '<Leader>\'', fzf.oldfiles, { desc = 'Find recently opened files' })
          vim.keymap.set('n', '<Leader>*', function()
              fzf.files({ cwd = vim.fn.expand('$HOME') })
          end, { desc = 'Find files in ~' })
          vim.keymap.set('n', '<Leader>fgc', function()
              fzf.fzf_exec('git dmc', {
                  prompt = 'GitConflicts> ',
                  cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h'),
                  preview = "git dt",
                  actions = {
                      ["default"] = actions.file_edit_or_qf,
                  },
              })
          end, { desc = 'Find git merge conflicts' })
      end
    },

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
          local lsp = require('lspconfig')

          vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('LspConfig', {}),
              callback = function(ev)
                vim.diagnostic.config({ virtual_text = false })
                vim.cmd('command! Format execute "lua vim.lsp.buf.format({ async = true })"')
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                local opts = { noremap = true, silent = true, buffer = ev.buf }

                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                vim.keymap.set('n', 'ög',
                    '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.WARN}})<CR>',
                    vim.tbl_extend('force', opts, { desc = 'Go to previous WARN+ diagnostic' })
                )
                vim.keymap.set('n', 'äg',
                    '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.WARN}})<CR>',
                    vim.tbl_extend('force', opts, { desc = 'Go to next WARN+ diagnostic' })
                )
                vim.keymap.set('n', 'öG',
                    '<cmd>lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.HINT}})<CR>',
                    vim.tbl_extend('force', opts, { desc = 'Go to next HINT+ diagnostic' })
                )
                vim.keymap.set('n', 'äG',
                    '<cmd>lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.HINT}})<CR>',
                    vim.tbl_extend('force', opts, { desc = 'Go to next HINT+ diagnostic' })
                )
                vim.keymap.set('n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                vim.keymap.set('n', '<C-Space>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                vim.keymap.set('n', '<leader><Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                vim.keymap.set('x', '<leader><Space>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
                vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                vim.keymap.set('n', '<leader>fo', '<cmd>Format<CR>', opts)
                vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle workspace_diagnostics<CR>', opts)
                vim.keymap.set('n', '<leader>tr', '<cmd>TroubleToggle lsp_references<CR>', opts)
            end,
          })

          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          local servers = {
              'angularls',
              'bashls',
              'cssls',
              'gopls',
              'html',
              'lua_ls',
              'pyright',
              'rust_analyzer',
              'tsserver'
          }

          for _, server in ipairs(servers) do
              if server == 'tsserver' then
                  require('typescript').setup({
                      server = {
                          capabilities = capabilities,
                      }
                  })
              elseif server == 'angularls' then
                  local lsPath = vim.fn.expand('$HOME/.local/lib/node_modules')
                  local cmd = { 'ngserver', '--stdio', '--tsProbeLocations', lsPath, '--ngProbeLocations', lsPath }
                  lsp.angularls.setup({
                      capabilities = capabilities,
                      cmd = cmd,
                      filetypes = { 'html' },
                      on_new_config = function(new_config, new_root_dir)
                          new_config.cmd = cmd
                      end,
                  })
              elseif server == 'lua_ls' then
                  lsp.lua_ls.setup({
                      settings = {
                          Lua = {
                              runtime = {
                                  version = 'LuaJIT',
                              },
                              diagnostics = {
                                  globals = {'vim'},
                              },
                              workspace = {
                                  library = vim.api.nvim_get_runtime_file('', true),
                              },
                              telemetry = {
                                  enable = false,
                              },
                          },
                      },
                  })
              else
                  lsp[server].setup({
                      capabilities = capabilities,
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
    { 'editorconfig/editorconfig-vim',
      cond = function()
          return vim.fn.has('nvim-0.9') == 0
      end
    },
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
        vim.keymap.set('n', 'öq', '<Plug>(qf_qf_previous)')
        vim.keymap.set('n', 'äq', '<Plug>(qf_qf_next)')
      end
    },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-fugitive' },
    { 'whiteinge/diffconflicts' },
}
