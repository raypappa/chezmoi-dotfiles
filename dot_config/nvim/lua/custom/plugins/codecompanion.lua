vim.env['CODECOMPANION_TOKEN_PATH'] = vim.fn.expand '~/.config'

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-lua/plenary.nvim' },
    { 'zbirenbaum/copilot.lua' },
    { 'saghen/blink.cmp' },
  },
  opts = {
    --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    interactions = {
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
      background = {
        adapter = 'copilot',
      },
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = 'Prompt ', -- Prompt used for interactive LLM calls
        provider = 'default', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_preset_actions = true, -- Show the preset actions in the action palette?
          show_preset_prompts = true, -- Show the preset prompts in the action palette?
          title = 'CodeCompanion actions', -- The title of the action palette
        },
      },
    },
    -- opts = {
    --   log_level = 'DEBUG',
    -- },
  },
  init = function()
    local config = require 'blink.cmp.config'
    table.insert(config.sources.default, 'codecompanion')
  end,
}
