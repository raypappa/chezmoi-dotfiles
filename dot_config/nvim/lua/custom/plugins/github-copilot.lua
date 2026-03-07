return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
  {
    'giuxtaposition/blink-cmp-copilot',
    init = function()
      require('blink.cmp').add_source_provider('copilot', {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        score_offset = 100,
        async = true,
      })
      local config = require 'blink.cmp.config'
      table.insert(config.sources.default, 'copilot')
    end,
  },
}
