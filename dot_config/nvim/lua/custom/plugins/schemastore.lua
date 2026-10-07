return {
  'b0o/schemastore.nvim',
  config = function()
    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })
    -- yamlls schema config is handled in kickstart/plugins/lspconfig.lua
  end,
}
