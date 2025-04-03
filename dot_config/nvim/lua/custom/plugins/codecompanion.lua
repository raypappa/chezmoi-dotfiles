vim.env['CODECOMPANION_TOKEN_PATH'] = vim.fn.expand '~/.config'

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-lua/plenary.nvim' },
    -- Test with blink.cmp
    { 'saghen/blink.cmp' },
    -- Test with nvim-cmp
    -- { "hrsh7th/nvim-cmp" },
  },
  opts = {
    --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    strategies = {

      --NOTE: Change the adapter as required
      chat = { adapter = 'copilot' },
      inline = { adapter = 'copilot' },
    },
    opts = {
      log_level = 'DEBUG',
    },
  },
}
