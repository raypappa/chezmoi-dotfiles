return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',

    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- Keybinding config
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Cursor highlight references
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints toggle
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Capabilities setup for cmp integration
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Native Nvim 0.12 LSP configuration
      -- Configure each server with vim.lsp.config() then enable with vim.lsp.enable()

      vim.lsp.config('terraformls', {
        capabilities = capabilities,
        -- Workaround: semantic tokens on this repo/file combination can freeze UI.
        -- Keep diagnostics/hover/goto, disable only semantic token stream.
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        -- Prefer module-level roots so terraform-ls doesn't index the whole monorepo.
        root_markers = {
          '.terraform',
          'terragrunt.hcl',
          'main.tf',
          'versions.tf',
          'variables.tf',
          'outputs.tf',
        },
      })

      vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            procMacro = {
              enable = true,
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      })

      vim.lsp.config('gopls', {
        capabilities = capabilities,
      })

      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })

      vim.lsp.config('yamlls', {
        capabilities = capabilities,
      })

      vim.lsp.config('jsonls', {
        capabilities = capabilities,
      })

      vim.lsp.config('bashls', {
        capabilities = capabilities,
      })

      vim.lsp.config('ansiblels', {
        capabilities = capabilities,
      })

      vim.lsp.config('dockerls', {
        capabilities = capabilities,
      })

      vim.lsp.config('marksman', {
        capabilities = capabilities,
      })

      vim.lsp.config('awk_ls', {
        capabilities = capabilities,
      })

      vim.lsp.config('ruby_lsp', {
        capabilities = capabilities,
      })

      vim.lsp.config('sqls', {
        capabilities = capabilities,
      })

      vim.lsp.config('taplo', {
        capabilities = capabilities,
      })

      vim.lsp.config('biome', {
        capabilities = capabilities,
      })

      vim.lsp.config('jinja_lsp', {
        capabilities = capabilities,
      })

      vim.lsp.config('ruff', {
        capabilities = capabilities,
      })

      -- Enable all configured servers
      -- Tools are managed by mise globally. See ~/.config/mise/conf.d/local.toml
      vim.lsp.enable 'terraformls' -- mise use -g terraform-ls
      vim.lsp.enable 'rust_analyzer' -- mise use -g rust-analyzer
      vim.lsp.enable 'lua_ls' -- mise use -g lua-language-server
      vim.lsp.enable 'gopls' -- mise use -g go:golang.org/x/tools/gopls@latest
      vim.lsp.enable 'pyright' -- mise use -g npm:pyright
      vim.lsp.enable 'yamlls' -- mise use -g npm:yaml-language-server
      vim.lsp.enable 'jsonls' -- mise use -g npm:vscode-langservers-extracted
      vim.lsp.enable 'bashls' -- mise use -g npm:bash-language-server
      vim.lsp.enable 'ansiblels' -- mise use -g npm:@ansible/ansible-language-server
      vim.lsp.enable 'dockerls' -- mise use -g npm:dockerfile-language-server-nodejs
      vim.lsp.enable 'marksman' -- mise use -g marksman
      vim.lsp.enable 'awk_ls' -- mise use -g npm:awk-language-server
      vim.lsp.enable 'ruby_lsp' -- mise use -g gem:ruby-lsp
      vim.lsp.enable 'sqls' -- mise use -g go:github.com/sqls-server/sqls@latest
      vim.lsp.enable 'taplo' -- mise use -g taplo
      vim.lsp.enable 'biome' -- mise use -g biome
      vim.lsp.enable 'jinja_lsp' -- mise use -g cargo:jinja-lsp
      vim.lsp.enable 'ruff' -- mise use -g ruff

      -- Fold options
      vim.opt.foldcolumn = '0'
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.lsp.buf.foldexpr()'
      vim.opt.foldtext = ''
      vim.opt.foldnestmax = 3
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
